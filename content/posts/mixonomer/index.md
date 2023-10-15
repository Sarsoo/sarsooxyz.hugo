---
title: "Mixonomer: Smart Spotify Playlists"
date: 2021-01-19T14:23:40+00:00
draft: false
aliases:
    - /mixonomer
---

![ci badge](https://github.com/sarsoo/mixonomer/workflows/test%20and%20deploy/badge.svg)

Mixonomer is a web app to augment your __Spotify__ listening experience with _smart playlists_. A _smart playlist_ watches several child playlists and filters the tracks to create new mixes. Updates are run multiple times a day or on-demand.

[Try It Out](https://mixonomer.sarsoo.xyz/)

[Read the Docs](https://docs.mixonomer.sarsoo.xyz/)

{{< figure src="Playlists.png" alt="playlist list" >}}

Include recommendations for additional __Spotify__ suggestions based on a playlist’s tracklist. Reference your playlists and those you follow by name or add references to other _smart playlists_ to additionaly include their watchlist.

Select library tracks for the playlists to include your __Spotify__ saved tracks in the mix.

{{< figure src="PlaylistExample.png" alt="playlist example" >}}

You can shuffle playlists for output or sort by reverse release date for a thumbnail that stays fresh with new music artwork.

# Tags

Tags are a listening statistics visualiser for exploring your [__Last.fm__](https://last.fm) habits. __Last.fm__ is great for exploring your listening history but sometimes I’ve wanted to be able to group some artists or albums to see their data in one place.

{{< figure src="TagExample.png" alt="tag example" >}}

Mixonomer’s tags lets you do this, I use it for stuff like grouping a label’s artists together to see how many times I’ve listened to _Dreamville_ artists, for example. Tick time to estimate the amount of time you’ve spent listening to each.

# Development

I started this project as an exercise in recreating the functionality of [__Paul Lamere‘s__](https://twitter.com/plamere) [__Smarter Playlists__](http://playlistmachinery.com/) app. The tool had become a really important part of my daily listening habits as a way of combining my smaller sub-genre playlists into larger mixes.

I wanted to see what an app like this looks like, what it involves to build it. At this point, I had neither built a web server nor written a significant front-end with a proper framework.

In the process of working on this project, I learnt how to create web servers with __Python’s__ [__Flask__](https://flask.palletsprojects.com/en/1.1.x/) module, how to deploy them to a cloud environment and how to interact with other cloud-based services. The architecture is now completely serverless using __Google‘s App Engine__, __Cloud Functions__ and __Firestore__ services.

{{< figure src="cloud-structure-3.png" caption="Cloud architecture of services in Google’s Cloud Platform" alt="cloud structure" >}}

The front-end was written in __React__, which I also learnt in the process. It was, in fact, my first significant modern __Javascript__ project utilising a __Node__ + __Webpack__ stack, it was interesting getting to grips with the __Js__ ecosystem by making them work together and getting the result to deliver correctly from the backend.

The app sits in the background now, it has replaced [__Smarter Playlists__](http://playlistmachinery.com/) for my _smart playlists_ and its been a good testbed to play with more cloud services.

# [Try It Out](https://mixonomer.sarsoo.xyz/)

[Github](https://github.com/Sarsoo/Mixonomer)

[iOS Github](https://github.com/Sarsoo/Mixonomer-iOS)

[C# Github](https://github.com/Sarsoo/Mixonomer.NET)