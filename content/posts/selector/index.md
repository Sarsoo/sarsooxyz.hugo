---
title: "Selector: A Spotify Listening Agent"
date: 2022-04-04T21:26:40+00:00
draft: false
aliases:
    - /selector
tags:
    - Music
    - C#
    - Vue
    - Javascript
categories:
    - Dev
---

![ci](https://github.com/sarsoo/Selector/actions/workflows/ci.yml/badge.svg)

I've been working on my .NET skills recently and, as I tend to, practiced with a tool that would integrate with my music listening habits.

Selector is an agent that watches what you’re listening to on Spotify and reacts to changes by firing pluggable events. These include retrieving the current song’s characteristics and play count on Last.fm. This information is displayed on a dashboard that updates live.

{{< figure src="dashboard.png" caption="The dashboard shows information from Spotify and Last.fm" alt="dashboard example" >}}

The app consists of a ASP.NET web app and a command line service that runs the listening agents. A Redis instance is used for cache and messaging between the nodes.

# Last.fm

[Last.fm](https://last.fm) is a service that records what you listen to to give stats and recommendations, Spotify can be linked to record your listening history. Selector includes an integration to present play count data for the current track along with it’s album and artist on the dashboard. 

Along with this, a background agent can be configured in the web UI’s settings to mirror your listening history to the local database in order to allow quicker, live statistics querying without constant network calls. This really adds to the data that can be presented live, Last.fm has a decent API, but querying a user’s entire history takes a while and seriously reduces the depth of insights that can be presented in real-time, especially as this dataset grows with time. By storing a copy locally, the whole history can be queried quickly.

Get deeper insights into what you listen to, [start here](https://selector.sarsoo.xyz).

# Architecture 🔧

As mentioned, Selector is structured as a distributed system with shared communication via a PostgreSQL database and a Redis cache. This wasn't a necessity and, in fact, the whole system could be composed of the web front end with the back end functionalities being performed by the web app, removing the need for a Redis cache.

It was a conscious decision to break down the system in this way, I was interested in what is required when building a system of this structure particularly in the Redis cache which I was previously unfamiliar with. My previous system, [Mixonomer](/mixonomer), was a cloud-native, serverless application and I wanted to play with a system that I could run myself including managing the required infrastructure.

Although Redis has fantastic caching functionality, I was primarily interested in using the component for its Pub/Sub functionality. Having built-in functionality for messaging is very interesting and adds quite a lot of value to the database. One feature, in particular, that I found very powerful in Selector was the ability to subscribe to channels/topics with patterns or globs. I use a colon/full-stop-separated namespace structure for keys, with this I could subscribe to just my user events with the channel key `USER.CURRENTLY_PLAYING:sarsoo` or get the same type of event for all users with `USER.CURRENTLY_PLAYING:*`.