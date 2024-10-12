---
title: "Listening Engineering: ML + Spotify + Last.fm"
date: 2021-02-20T12:22:40+00:00
draft: false
tags:
    - Python
    - ML
    - Music
categories:
    - Dev
---

[![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Sarsoo/listening-analysis)

As my [Music Tools](https://sarsoo.xyz/music-tools/) project progressed, I found myself with a cloud environment and a growing dataset of my listening habits to explore. __Spotify__ provides audio features for all of the tracks on its service. These features describe qualities about the track such as how instrumental it is, how much energy it has. I wanted to investigate whether the features that describe my larger genre-playlists were coherent enough to use as the classes of a classifier. I compared the performance of SVM’s with shallow multi-layer perceptrons.

All of these investigations are part of my [`listening-analysis`](https://github.com/Sarsoo/listening-analysis) repo, the work is spread out over a couple of different notebooks

## [`analysis`](https://github.com/Sarsoo/listening-analysis/blob/master/analysis.ipynb)

Introducing the dataset, high-level explorations including average Spotify descriptor over time and hours per day of music visualisations

## [`artist`](https://github.com/Sarsoo/listening-analysis/blob/master/artist.ipynb), [`album`](https://github.com/Sarsoo/listening-analysis/blob/master/album.ipynb), [`track`](http://github.com/Sarsoo/listening-analysis/blob/master/track.ipynb), [`playlist`](https://github.com/Sarsoo/listening-analysis/blob/master/playlist.ipynb)

Per-object investigations such as how much have I listened to this over time, it’s average descriptor and comparisons of the most-listened-to items

## `playlist classifier` ([`SVM`](https://github.com/Sarsoo/listening-analysis/blob/master/playlist-svm.ipynb)/[`MLP`](https://github.com/Sarsoo/listening-analysis/blob/master/playlist-nn.ipynb))

Investigations into whether my large genre-playlists can be used as classes for a genre classifier. Comparing and evaluating different types of support-vector machine and neural networks

## [`stats`](https://github.com/Sarsoo/listening-analysis/blob/master/stats.ipynb)

Dataset statistics including the amount of __Last.fm__ scrobbles that have an associated __Spotify__ URI (critical for attaching a __Spotify__ descriptor)

## On This Page

    1 Dataset
    2 Playlist Classifier
        - Class Weighting
        - Data Stratification

{{< figure src="svm-1.png" caption="Confusion matrix for a SVM playlist classifier" alt="svm" >}}

## Dataset

The dataset I wanted to explore was a combination of my __Spotify__ and __Last.fm__ data. __Last.fm__ records the music that you listen to on __Spotify__, I’ve been collating the information since November 2017. __Spotify__ was used primarily for two sources of data,

    1 Playlist tracklists
        - Initially for exploring habits such as which playlists I listen to the most, the data then formed the classes for applied machine learning models
    2 Audio features
        - For each track on the Spotify service, you can query for its audio features. This is a data structure describing information about the track including the key it’s in and the tempo. Additionally, there are 7 fields describing subjective qualities of the track including how instrumental a track is and how much energy it has

These two sides of the dataset were joined using the __Spotify__ URI. As the __Last.fm__ dataset identifies tracks, albums and artists by name alone, these were mapped to __Spotify__ objects using the search API endpoint. With __Spotify__ URIs attached to the majority of my __Last.fm__ scrobbles, these scrobbles could then easily have their __Spotify__ audio features attached. This was completed using Google’s Big Query service to store the data with a SQL interface.

{{< figure src="hrsperday.png" caption="Average time spent listening to music each day. Per-year polynomial line of best fit also visualised" alt="hours listening per day graph" >}}

## Playlist Classifier

My large genre playlists describe my tastes in genres across Rap, Rock, Metal and EDM. They’re some of my go-to playlists and they can be quite long. With these, I wanted to see how useful they could be from a classification perspective.

The premise was this: could arbitrary tracks be correctly classified as one of these genres as I would describe them through my playlist tracklists.

{{< figure src="playlist-descriptor.png" caption="Average Spotify descriptor for each genre playlist being investigated and modelled" alt="average descriptor by playlist graph" >}}

The scikit-learn library makes beginning to explore a dataset using ML models really fast. I began by using a support-vector machine. SVMs of differing kernels were evaluated and compared to see which type of boundaries best discriminated between the genres. The differences can be seen below,

{{< figure src="svm-classes.png" caption="Confusion matrices for the different type of SVM evaluated" alt="playlist classifier svm by class" >}}

| SVM Kernel  | RBF | Linear | Poly | Sigmoid |
|-------------|-----|--------|------|---------|
| Accuracy, % | 71% | 68%    | 70%  | 29%     |

###### `.score()` for each SVM model

From these, it can be seen that the _Radial Basis Function_ (RBF) and _polynomial_ kernels were the best performing with the _Sigmoid_ function being just awful. When implementing one of these models in __Music Tools__ playlist generation, these two kernels will be considered.

### Class Weighting

The playlists that I’m using aren’t all of the same length. My Rap and EDM playlists are around 1,000 tracks long while my Pop playlist is only around 100. This poses an issue when attempting to create models from these playlists. The Rap model, for example, will be a much larger model than the Pop playlist and take up more volume in the descriptor space. This can make it much harder to correctly classify tracks as these under-represented classes when larger ones dominate.

This issue can be seen visualised below, in the left matrix no tracks were correctly classified as Pop. Instead, half were classified as EDM and 20% as Rock.

{{< figure src="svm.png" caption="Difference in classification accuracy when weighting the genres based on proportion" alt="svm classes" >}}

There are many ways to begin mitigating this issue. One way is to penalise misclassifying under-represented classes more than the larger ones. This can be implemented in __scikit__ by initialising the model with the `class_weight` parameter equal to `'balanced'`. This was the method used in the matrix on the right, above. It was highly effective in rebalancing the classes, all of them have comparable accuracy afterwards.

### Data Stratification

Similar to class rebalancing, the dataset also required processing. Before using a model, a dataset is split between a _training_ set and a _test_ set. A default way to do this is to just take a random subset of the data for each set, it is crucial for properly evaluating the model that these datasets are distinct without overlap. However, this doesn’t take into account the relative occurrence of each class in either dataset. For example, a random split could leave more of one class or genre in one dataset than the other. As mentioned, the Pop class is much smaller than the other classes, it is feasible that the whole genre could end up in either the training or test dataset instead of properly splitting.

Instead of allowing this to be determined by a random split, the dataset was _stratified_ when splitting. This applies the given proportion of training to test set to each class during the split such that the same proportion of tracks occur in either dataset.

[![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Sarsoo/listening-analysis)