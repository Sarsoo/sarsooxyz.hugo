---
title: "Going all in on Tailscale"
date: 2024-07-02T08:26:40+00:00
---

I've been fiddling with Tailscale for a while. It has always seemed like a really cool piece of tech but there have been a few things that have held me back from going all in.

For context, Tailscale is a VPN platform built on top of Wireguard that builds a flat, programmable network. It has some helpful features to help keep clients connected in ways Wireguard won't, by default. This helps with clients that are behind complex NATs.

I've been running my own Wireguard tunnels for home access since before Tailscale came out and was always pretty impressed with what Wireguard represents over the alternatives. I ran an OpenVPN tunnel a long time ago and, to be honest, it was comparatively crap. Wireguard being just a key pair is so simple and the performance is basically native.

This meant that my remote access solution was heavily centred on my Pfsense router for both Wireguard tunnel hosting and all of the routing rules. These routing rules allowed me to build my reverse VPN solution and include any forward VPN connections.

_Here, I am using reverse and forward in the way that it is used when talking about Proxies, which isn't a way I have heard VPNs described before but should make describing it easier. Here, a **reverse** VPN is for accessing protected resources, in the way that an enterprise VPN functions. A **forward** VPN is for protecting outgoing traffic using a commercial service like Nord/Proton VPN._

# Sharing

The ability to share resources is a powerful addition to the overlay network that allows exporting and importing components from other people. Previously, if I have wanted to share resources and services with friends and family they would either need to be publically accessible or people would need to be onboarded to the self-hosted Wireguard which is a bit onerrous. With Tailscale, it's super simple just invite them to access a specific node with a link or an email.

You can then control what they can access further with ACL rules.

# Containers

While this is all very powerful, one of the things which finally got me to take another look was the ability to combine Tailscale and its Serve + Funnel features with individual Docker Containers. [Alex Kretzschmar did a video for Tailscale](https://tailscale.com/kb/1282/docker) where he lays out how this works. Essentially, instead of just adding a machine to Tailscale, you can add a single container.

This works by standing up a Tailscale container alongside the target and making the target use it as its network using `network_mode`. Under the hood, this makes the two containers share a network namespace and effectively share a `localhost`.

Combining this with the sharing capabilities, you no longer need to share a whole machine with someone else, instead you can share just one container.

## Serve + Funnel

I use a lot of NGINX, it's great. My Ansible setup templates my NGINX configs for me and it integrates with it really well. I'm also a big fan of Caddy, I tend to use this on my internet-facing services because the auto-provisioning and renewal of LetsEncrypt certificates really make life easy. What I'm saying is I like reverse proxies, they make me happy and they make life livable with a heavily containerised homelab.

Tailscale Serve and Tailscale Funnel are ways to reverse proxy natively in Tailscale and really supercharge Tailscale-connected containers. In short, Tailscale Serve reverse proxies ports to your tailnet while Funnel extends that to make that port publically accessible, *with a LetsEncrypt certificate by default*. This is super cool.

To be fair, directly connecting a container to the public internet without some sort of reverse proxy would probably be more pain than it's worth, few containers expose port 80 let alone 80 and 443 - *and this is a good thing, that's what reverse proxies are for*. but Serve + Funnel makes the whole thing work.


# CI/CD

This is a bit of a rabbit hole, it's something I've done fairly recently and I'm not sure if I like it. It still sort of gives me weird vibes but it is undeniably powerful. You can create OAuth clients for Tailscale, allowing you to programmatically manage the network. You can use this to allow Github Actions runners to authenticate and gain access to your Tailnet.

Combine this with Tailscale SSH which allows you to replace the SSH keys auth layer with the ACLs of Tailscale and you have a way to let your CI/CD pipelines SSH into your Tailnet machines and deploy code that isn't cloud-hosted.

I really like how this closes the loop and helps implement full-throated CD. It also sort of scares me that Github can SSH into my infrastructure. Let's call it an experiment, we'll see if I stick with it. Don't get me wrong, it's ACL-ed to the eyeballs, but it still feels odd.

# Dopamine

A few things that I have managed to do with Tailscale that made me happy to wrap up.

## Itty bitty containers of DNS

You can set the DNS servers used by nodes on your Tailnet, you can also do split DNS where requests for specific domains are routed to specific servers. This was a bit of an itch for me, I use my own domain on my homelab and I wanted to be able to keep doing split DNS for my domain when on Tailscale.

To achieve this I deployed containers for Bind DNS server that are only available on my Tailnet. Ansible renders the Zone files so that when you are requesting from a Tailscale IP it returns the Tailscale IP for the machine instead of the `192.168.x.x` IP. The config looks a bit like this:

```
acl "ts-subnet" { 100.64.0.0/10; };

view "tailscale" {
    match-clients { "ts-subnet"; };

    <ZONE FILES>
};

view "native" {
    match-clients { any; };

    <ZONE FILES>
};
```

I also run three Bind containers, one at home, one in Linode and one in Oracle cloud. This not only adds redundancy but should also help with resolution speed when I'm not at home.

## Shhh, what SSH

There have been a few SSH scares recently, first the whole social engineering System D thing, [then the RCE](https://www.wiz.io/blog/cve-2024-6387-critical-rce-openssh). SSH is very secure and it's _proooobably_ fine to have it open on the internet, but with Tailscale you don't have to so I don't. That just makes me a bit happy.