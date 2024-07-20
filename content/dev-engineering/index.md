---
title: "Dev & Engineering"
date: 2021-01-17T22:59:40+00:00
draft: false
aliases:
    - /dev
---

{{% image-box-link src="/posts/mixonomer/PlaylistExample.png" href="/posts/mixonomer" title="Mixonomer" caption="Python + React" %}}

{{% image-box-link src="/posts/selector/dashboard.png" href="/posts/selector/" title="Selector" caption="C# + TypeScript + Vue.js" %}}

# [Infrastructure]({{< relref "infra" >}})

I manage my local and cloud infrastructure with __Terraform__ + __Ansible__ + __Docker__. I've found this stack incredibly powerful so I've written a post about my patterns and what I love about it.

{{< figure src="/posts/infra/grafana.png" alt="grafana dashboard" >}}

Basically, Terraform creates and destroys infrastructure, Ansible manages the OS-level stuff and then the services I run use docker compose. I use a _bootstrap_ Ansible role instead of golden images.

[Read More]({{< relref "infra" >}})

{{% image-box-link src="/posts/visual-search/mapSurfaceWithMax2.png" href="/posts/visual-search" title="Visual Search" caption="MATLAB" %}}

{{% image-box-link src="/posts/lpss/hood_m_gram.png" href="/posts/lpss" title="Speech Synthesiser" caption="MATLAB" %}}

{{% image-box-link src="/posts/markov/StateTopology.png" href="/posts/markov" title="Hidden Markov Models" caption="Python + Numpy" %}}

# [Holoportation](/holo)

`C++ [Kinect SDK, OpenCV]`
`C# [Winforms, Unity 3D]`

Holoportation is an area of research exploring the ability to livestream 3D environments over the internet. The technology has many applications for __AR/VR__ experiences like 3D sports and music events or smaller-scale applications like a 3D __Twitch__.

The holograms are captured in the form of a __point cloud__, a cluster of coloured dots that, when presented correctly, can appear like the original object.

{{< figure src="/images/holo-avatar.jpg" >}}

My undergraduate dissertation documented extending the [__LiveScan3D__](https://github.com/MarekKowalski/LiveScan3D) holoportation platform to allow multi-source streaming. The existing capabilities allowed a single scene to be captured in real-time and streamed elsewhere for viewing, multi-source allows multiple independent scenes to be received and composited at the same time (a many-to-one system).

{{< youtube NP0aVjuk5fU >}}

[Read More](/holo)

{{% image-box-link src="/posts/draught/checkers-board.png" href="/posts/draught" title="Draught" caption="Rust + Js" %}}

{{% image-box-link src="/posts/game-of-life/gameoflife1.png" href="/posts/game-of-life" title="Game of Life" caption="Rust + Js" %}}

# [Mixonomer](/mixonomer)

`Python [Flask]`
`JavaScript [React]`

Mixonomer is a web app for creating smart playlists for __Spotify__. These playlists watch other playlists to use them as sources of tracks. These tracks are filtered and sorted before updating a __Spotify__ playlist.

Updates are run multiple times a day or on-demand. Additionally, __Last.fm__ integration provides listening statistics for your playlists.

{{< figure src="/posts/mixonomer/cloud-structure-3.png" alt="cloud structure" >}}

The project began as an exercise in recreating the functionality of [__Paul Lamere‘s__](https://twitter.com/plamere) [__Smarter Playlists__](http://playlistmachinery.com/) app. This tool had become a really important part of my daily listening habits as a way of combining my smaller sub-genre playlists into larger mixes.

The app has a __Python__ back-end written in __Flask__. The front-end was built using a __Node + Webpack + React__ stack.

The system is now deployed with a fully serverless architecture.

[Read More](/mixonomer)

[Try It Out](https://mixonomer.sarsoo.xyz/)

[Source Code](https://github.com/Sarsoo/Mixonomer)

---

# [Selector](/selector)

`.NET [ASP.NET, Redis, Docker]`
`TypeScript [Vue]`

A __Spotify__ listening agent which watches what you listen to and presents related data and information in a live dashboard. __Spotify__ presents some interesting track data that isn’t visible in the official clients such as its beats-per-minute, key signature and a musical descriptor.

{{< figure src="/posts/selector/dashboard.png" alt="dashboard" >}}

[Read More](/selector)

[Try It Out](https://selector.sarsoo.xyz/)

[Source Code](https://github.com/Sarsoo/Selector)

---

# [Listening Engineering](/posts/listening-analysis)

`Python [scikit-learn, Jupyter]`

__Spotify__ and __Last.fm__ are two powerful platforms for music data and consumption.

I wanted to explore what insights could be found in my 3 years of __Last.fm__ scrobbles when augmented with __Spotify__ data. Ideally, I also wanted to be able to apply the intelligence to the __Mixonomer__ playlist pipeline.

__Spotify__ provides audio features for the tracks on its platform. These features describe a number of qualities for the tracks including how much energy it has and how vocal it is. I investigated whether the set of audio features for my larger genre playlists could be used to classify tracks by genre. 

[Read More](/posts/listening-analysis)

---

# Signal Processing

Throughout my studies I found myself particularly interested in the signal processing and AI modules, these have included:

- Computer Vision and Pattern Recognition
    - Visual Search Report
- Robotics
    - ROS Labs
- Speech & Audio Processing & Recognition
    - Linear Predictive Speech Synthesiser
    - Hidden Markov Model Training
- Image Processing & Deep Learning
    - CNN Training Coursework
- AI & AI Programming
    - Shallow MLP Coursework

[Posts](/posts)

[Coursework Code](https://github.com/Sarsoo?tab=repositories&q=coursework)

---

<!--- 2016 for coding, 2018 for Linux --->

I've been coding for 8 years and I now work as a software engineer in fintech. Day-to-day this is in [__C#__](/holo/) and [__TypeScript__](/mixonomer) but I also like working with [__Python__](/mixonomer) and [__Rust__](https://github.com/Sarsoo?tab=repositories&q=&type=&language=rust&sort=). I keep all of my projects on [__GitHub__](http://github.com/sarsoo).

Alongside development I also enjoy working on infrastructure, I have 5 years experience using __Linux__ and managing networks. I have experience working with cloud technologies – from [__virtual machines__](/holo), [__web server PaaS__](/mixonomer) and [__serverless functions__](/mixonomer) to [__NoSQL__](/mixonomer), Big Data SQL and [__pub/sub messaging__](/mixonomer). Much of this experience was gained during my [__Mixonomer__](/mixonomer) project and during my __Disney__ internship. As part of my [dissertation](/holo#research), I used a global cluster of virtual machines as an environment to measure and experiment with holographic video QoS over long distances.

At university, I was particularly interested in the software side of the field including modules in __programming__, __signal processing__ and __AI__. I also took a set of modules in __semiconductors__ and __nanoscience__.

[Posts](/posts)

---

# Awards

Throughout my time at university, I earned multiple awards for academic achievement

- ___Dean’s List for Academic Achievement___ (2018)
    - Awarded for overall academic performance as part of my international exchange program with the [__California State University, Los Angeles__](https://www.calstatela.edu/)
- ___Lumentum Award___ (2020)
    - Awarded for achieving the __highest mark__ in my third year __Semiconductors & Optoelectronics__ module
- ___Atkins Best Oral Presentation – 2nd Prize___ (2021)
    - Awarded for giving second best oral presentation for ___multi-disciplinary design project___. Project involved designing a fully renewable ship and depot to repair sub-sea fibre optic cables. 