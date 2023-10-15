---
title: "More Sustainable Terraform: Breaking Down the Beast"
date: 2023-09-10T08:34:40+00:00
draft: false
---

I [wrote earlier this year]({{< relref "infra" >}}) about jumping into Terraform to manage my infrastructure. I love the [idemptotent](https://en.wikipedia.org/wiki/Idempotence) behaviour and the way that the declarative format leads to a self-documenting, centralised repository of my resources across a variety of platforms.

There were issues with my implementation, though, issues that I sought to tackle recently. I'm going to describe some of these problems that I encountered and what I did to solve them for [Mixonomer]({{< relref "mixonomer" >}}) and [Selector]({{< relref "selector" >}}).

# Big ol' Blob

I have a private git repo where I keep my infrastructure-related resources including Terraform manifests, Ansible playbooks, nginx configs and Docker images. This included a single Terraform folder with a single state file and a few modules. This is a common pattern when starting out, but it is just as common to start feeling the limitations as you scale. 

In particular, in my case, I was managing the infrastructure for all of my projects together. This meant that in order to make a change to, say, [Selector]({{< relref "selector" >}}), the [Mixonomer]({{< relref "mixonomer" >}})-related resources would need to be checked and possibly fixed when doing so.

I had a situation recently when I updated the Linode Terraform provider and it is now enforcing minimum root password lengths on virtual machines. A VPS I'm using originally had a root password that didn't meet this and, in order to bring the Terraform state in line, it wanted to delete and recreate the machine. This VPS isn't related to [Mixonomer]({{< relref "mixonomer" >}}), but if I wanted to make any changes to [Mixonomer]({{< relref "mixonomer" >}}), I would need to either fix the VPS or remove it from the state. The latter may sound easier but in fact, the issue cascades as some of my DNS records rely on this machine by pointing at its IP address (a feature of Terraform that I love, don't get me wrong).

It's clear that I needed to do some decomposition - break down the Terraform blob into smaller repos (and state files) that represent well-defined areas of concern.

# Testing in Prod? 😬

In order to split this behemoth, I broke out all of the Mixonomer resources into a separate git repo, `terraform rm`-ing the state from the original monolith and re-importing into a new state file in this new repo.

Now that I had this Mixonomer.infra repo, I wanted to explore how to properly utilise Terraform best practices, *while I'm here why don't I do it properly?* To do this I needed to confront something that I had been avoiding, it wasn't just my Terraform that was a blob, the Mixonomer platform itself was a bit of a blob.

As I wrote about when I documented [Mixonomer]({{< relref "mixonomer" >}}), the project had originally been a way to learn both web development and cloud computing. Unsurprisingly, this led to some bad practices.

First off, there was only one environment, production. No testing, no pre-prod, throw it straight into production, what's the worst that could happen? Also, the security practices weren't as tight as they could be, all of the Cloud Functions used a single service account with permissions that it didn't need.

Now, the project is just a personal one, I didn't have intentions for it to be a big public platform or anything, so it's not like this is negligent. But knowing what I know now, this isn't how you do things and again, *while I'm here why don't I do it properly?*

# Phew!

There are multiple ways to lay out a Terraform repo for handling multiple environments. I went for a global module collection which is imported by multiple environment folders, each with their own state file. The result looks like the below:

```
├── modules
│   ├── acm
│   │   ├── api.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   ├── run_all_playlists
│   │   ├── ...
│   ├── run_user_playlist
│   │   ├── ...
│   ├── secrets
│   │   ├── ...
│   ├── static_resources
│   │   ├── ...
│   ├── task_queues
│   │   ├── ...
│   ├── web_app
│   │   ├── ...
├── prod
│   ├── api.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
├── test
│   ├── api.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
```

This design has its ups and downs. One advantage, as mentioned before is the different state files; each environment can be checked and updated individually, broken environments don't block changing other environments.
One disadvantage is that module changes really need to be done from lower environments up to prod or in a separate branch so that changes don't get prematurely applied to higher environments. This isn't that big of an issue, it's what should be happening anyway but it is worth keeping in mind.
Another advantage is that the heavy modulation means that changes to modules are applied to each environment in the same way every time, no manual effort is required to make sure changes are applied the same way.

Finally, the exercise in itself had a huge upside. When I originally started managing the system with Terraform, I imported the resources instead of creating them. This meant that the environment couldn't necessarily be deployed from scratch with those resources, they were just the current state. For example, I like Google Cloud Functions and have a few to support the system. Previously, I had Terraform resources for the functions themselves as they were imported. However, when trying to deploy a new environment, deploying functions with Terraform directly proved tricky. I deploy the functions with GitHub Actions, but Terraform couldn't deploy an empty function ready to be filled by CD. The solution was that Terraform is responsible for the associated resources - the service account, its privileges and Pub/Sub topics, while GitHub Actions maintains responsibility for actually standing up the function.
Writing the resources again from scratch made sure that the actual resources being created were suitable to create an environment from scratch.