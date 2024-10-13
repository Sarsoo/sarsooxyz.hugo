---
title: "Holoportation with LiveScan3D"
date: 2021-01-19T21:49:40+00:00
draft: false
aliases:
    - /holo
tags:
    - Uni
    - C#
    - C++
    - Cloud
categories:
    - Dev
---

[LiveScan3D](https://github.com/MarekKowalski/LiveScan3D) is a holographic teleportation or _holoportation_ platform. The app has a client-server model for streaming 3D or _volumetric_ video over the internet. It was written in 2015 by a pair of academics at the Warsaw University of Technology, [Marek Kowalski](http://home.elka.pw.edu.pl/~mkowals6/) and [Jacek Naruniec](http://home.elka.pw.edu.pl/~jnarunie/).

`Kowalski, M.; Naruniec, J.; Daniluk, M.:`

`
"LiveScan3D: A Fast and Inexpensive 3D Data Acquisition System for Multiple Kinect v2 Sensors". in 3D Vision (3DV), 2015 International Conference on, Lyon, France, 2015
`

{{% giphy l2JJmXRcFoEJNXyEM %}}

The app works by capturing what is called a [_point cloud_](https://en.wikipedia.org/wiki/Point_cloud), a cluster of coloured points. These points act as the pixels of the image with an extra third coordinate for depth. The coordinates of these points are sent with their RGB values; a good enough resolution allows rendering these points to create a decent real-time image for AR/VR streaming. The original version of the software used the Xbox Kinect camera for the Xbox One but it also supports the new Azure Kinect. 

## On This Page

    1 Multi-Source
    2 Mobile AR
    3 Research
    4 Photoshoot

{{< figure src="Structure.png" caption="Client-server structure of the environment" alt="client-server structure" >}}

# Multi-Source

{{< figure src="pair.png" alt="pair of subjects facing each other" >}}

My undergraduate dissertation was tasked with extending the original software to allow _multi-source_ streaming. The current system could stream one scene to one server for viewing. This scene being captured, whether by one camera or from multiple angles, is called a _source_. Multi-source operation allows more than one scene to be composited and displayed at the server or a connected AR client.

The development works by including an ID to indicate what source a frame of footage represents.

{{< youtube id=NP0aVjuk5fU autoplay=true controls=false loop=true class=youtube-embed >}}

###### A couple of recorded sources operating in the virtual space. A third live one is connected part way through

# Mobile AR

The main use for a platform like LiveScan3D is augmented reality using a mobile phone or Microsoft Hololens. Although the point clouds are suitable for rendering in both an AR and VR environment, the resolution and nature of the captured perspective is suited well to recreation in AR.

A client AR app was written in Unity 3D by the original authors; initially design for Microsoft’s Hololens headset, it was modified to target Android devices using Google’s ARCore library. From here, I upgraded it to use the Unity-native ARFoundation library. The ARFoundation library abstracts AR functionality away from the device-specific libraries including Apple’s ARKit and Google’s ARCore. Instead, an AR environment can be constructed in wholly Unity components which are replaced by these libraries at compile-time. This was partly a result of the pandemic stopping access to the lab, without the ability to debug on Android devices I hoped to deploy the app on my own phone.

Despite successfully migrating the app to use the ARFoundation library, the app is still not yet working on iOS. This is because the existing graphics pipeline isn’t playing well with the iOS Metal graphics API. The app renders a point cloud by spawning objects to act as the points of the frame. Each pixel is rendered using a geometry shader that creates a small coloured square billboard facing the camera. This was a pretty good way to efficiently render the hologram on a mobile device. The problem is that the Metal graphics API used on iOS doesn’t support geometry shaders.

As a result, the app works fine from a network perspective, but there is a purple rendering error instead of a hologram.

{{< figure src="mobile-holo.png" caption="AR app working on iOS, a purple rendering error where the hologram should be" alt="mobile screenshot" >}}

# Research

{{< figure src="ServerWindow.png" caption="Server window with additional statistics including bandwidth and latency as exponential moving average" alt="server window" >}}

As part of my ongoing work with the holoportation research group, I have also conducted experiments into the suite’s network behaviour. The original software was suited well to the lab environment that it was written for but there are a number of limitations that affects its performance over the open internet. For one, it uses TCP for its data transmission; streaming protocols usually don’t use this because of the overhead it incurs among other reasons.

The work that I did used a collection of virtual machines hosted in various global locations as an environment to measure quality-of-service stats. Streams were set up over varying distances to see how it affected values like latency and throughput. This led to a channel management system being written that would manually control the throughput of frames in order to prioritise certain operating parameters. The system proved effective and further expansions are being looked into.

# Photoshoot

{{< figure src="ballcap.jpg" alt="ballcap" >}}

The system uses a [_point cloud_](https://en.wikipedia.org/wiki/Point_cloud) to capture and transmit 3D video. When zoomed in with a small point size, the medium looked really cool with the black virtual background, see here for more.