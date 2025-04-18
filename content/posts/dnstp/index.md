---
title: "dnstp: Transmitting Arbitrary Data With DNS"
date: 2024-10-13T08:26:40+00:00
tags:
    - Rust
    - Networking
categories:
    - Dev
---

![Build Binaries](https://github.com/Sarsoo/dnstp/actions/workflows/build.yml/badge.svg)
[![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Sarsoo/dnstp)

[![Rust](https://img.shields.io/badge/rust-%23000000.svg?style=for-the-badge&logo=rust&logoColor=white)](https://git.sarsoo.xyz/sarsoo/-/packages/cargo/dnstplib)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://git.sarsoo.xyz/sarsoo/-/packages/container/dnstp)

[I have written previously about my Rust projects](/tags/rust). However, these have always been in WebAssembly so they are consumed from a web browser. I wanted to play with native Rust code and some if its highly regarded multi-threading features.

Something I also enjoy, when working with low-level languages, is bitwise operations. These two led me to the desire to do a native Rust project. I was aware of the concept of [DNS tunneling](https://www.zenarmor.com/docs/network-security-tutorials/what-is-dns-tunneling#what-are-the-dns-tunneling-techniques), I think I heard the idea described on [Security This Week with Carl Franklin](https://securitythisweek.com/). 

So that was the inspiration for a project - build some sort of DNS tunneling apparatus, largely to have a toy project that I could fiddle with.

# spec

There were a few things that would need to be considered when building something like this:

1. How much like normal DNS traffic would this tool appear to be
2. Is there some sort of DNS library for Rust or would I need to write one
3. What would this protocol look like on top of DNS
4. How would the data be secured (given that bog-standard DNS is unencrypted)

# surreptitious

I decided that the traffic should be standard DNS messages, this was so that any DNS proxies in between would be able to understand the messages and forward them on. The idea is that a hypothetical `dnstp` server wouldn't need to be sent to directly, but could be reached regardless of what path the DNS messages would take. 

In the past, I have had NAT rules on my router that redirected all DNS traffic from the LAN to itself so that it could do the requisite adblocking and upstream forwarding. This is handy for IoT devices like Chromecasts. _As an aside, this will likely be less of a solution as DNS-over-HTTP(s) has become a standard_.

Because of this possibility that the DNS messages will not go straight from client to server but could be proxied and processed through routers and DNS servers in between, the messages should conform to DNS standards.

# protocol

## cryptography + handshakes

[Docs for the crypto module of `dnstp`](https://sarsoo.github.io/dnstp/dnstplib/crypto/index.html)

In order to protect the data, it should be encrypted during transmission. The client and server need to be able to agree on a unique, ephemeral key without transmitting it over the insecure channel. This is done using a [key agreement protocol](https://en.wikipedia.org/wiki/Key-agreement_protocol), a specialisation of [key exchange protocols](https://en.wikipedia.org/wiki/Key_exchange). This has the classic advantage of using the more expensive asymmetric cryptography initially to agree on a private but shared symmetric key which is less expensive to use from then on.

For this implementation, the [Elliptic-curve Diffie–Hellman](https://en.wikipedia.org/wiki/Elliptic-curve_Diffie%E2%80%93Hellman) or ECDH algorithm was used, specifically the [p256](https://docs.rs/p256/latest/p256/) crate.

The protocol for performing this key exchange goes a bit like this. The client generates an ECDH asymmetric pair. It formulates a DNS request in the form:

```
Name Request 1: 
    Record type = A, 
    Hostname = static.CONFIGURED_BASENAME (e.g static.sarsoo.xyz)
Name Request 2: 
    Record type = A, 
    Hostname = base_64(CLIENT_PUBLIC_KEY).CONFIGURED_BASENAME
```

When the server identifies that the message is a client handshake request by the hostname of the first request, it generates its own ECDH key pair. The response it sends back to the client is as such:

```
Name Response 1: 
    Record type = A, 
    IP = 127.0.0.1
Name Response 2: 
    Record type = CNAME, 
    Hostname = base_64(SERVER_PUBLIC_KEY).CONFIGURED_BASENAME
```

With this response, each side now has the other's public key. With this and their own private key, the shared secret can be divined independently. The server keeps a map of its known clients using their public key as an identifier. It stores its shared secret alongside this key.

## data transmission

With this security context set, we can now send data over the insecure channel. The general idea is that the components of each data transfer including the client's public key, the encrypted data and the nonce used during encryption are sent as separate DNS questions.

That looks like this for an upload value with a corresponding key:

```
Name Request 1: 
    Record type = A, 
    Hostname = base_64(CLIENT_PUBLIC_KEY).CONFIGURED_BASENAME
Name Request 2: 
    Record type = A, 
    Hostname = base_64(ENCRYPTED_DESCRIPTIVE_KEY)
Name Request 3: 
    Record type = A, 
    Hostname = base_64(ENCRYPTED_VALUE)
Name Request 4: 
    Record type = A, 
    Hostname = base_64(ENCRYPTION_NONCE)
```

Where the `ENCRYPTED_DESCRIPTIVE_KEY` question can be omitted for a description-less value.

{{< figure src="client.png" caption="The client handshakes with the server and then encrypts and transmits the data" alt="client sends the data to the server" >}}

# dns lib 

[Docs for the DNS message module of `dnstp`](https://sarsoo.github.io/dnstp/dnstplib/message/index.html)

The first task when I started the project was to work out how to generate and serialise DNS messages. I had a look for an existing crate that could help with this but wasn't satisfied with what I could find, so I decided to write my own. This was a lot of fun because, as I mentioned previously, I love working with bitwise operations. Working with the bit flags of the DNS header was great.

{{< figure src="server.png" caption="The server receives and completes the handshake before decrypting the follow-up data" alt="server receives data from client" >}}

# mvp

So far, the upload feature is working, clients are able to encrypt and transmit data to the server which logs out the unencrypted data. In a hypothetical red team scenario this would be for exfiltration. 

The next step would be downloading data from a server. Ideally, this could be text or files, `dnstp` could be used to download secondary binaries to run.

Once bi-directional transfers are working, the system could be used for command & control (C2) in a red team context. The client could query the server for commands including downloading and running commands and other binaries.

# limitations

The project is very much an MVP at this point; as a toy project, there hasn't been thorough planning of bigger ideas such as session management or error correction.

There is no retry handling which isn't ideal over the UDP protocol of DNS. There are limits to the lengths of DNS hostnames and of UDP packets in general, how would `dnstp` handle splitting larger data blobs for transmission and do error correction?

# takeaways

Working with low-level native Rust was very rewarding, the memory safety and threading systems are pretty ergonomic and make life easy. I think I'll find myself coming back to the project to work on some of the missing features I described.

[Check out the source code ![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Sarsoo/dnstp)

[Check out the rust crate ![Rust](https://img.shields.io/badge/rust-%23000000.svg?style=for-the-badge&logo=rust&logoColor=white)](https://git.sarsoo.xyz/sarsoo/-/packages/cargo/dnstplib)

[Check out the server container ![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://git.sarsoo.xyz/sarsoo/-/packages/container/dnstp)