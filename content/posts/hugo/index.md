---
title: "Wordpress → Hugo"
date: 2022-09-20T07:43:40+00:00
draft: false
tags:
    - Cloud
---

![ci](https://github.com/sarsoo/sarsooxyz.hugo/actions/workflows/pages.yml/badge.svg)

My personal website (this one) has been a Wordpress instance for several years. This was a great exercise in running a public facing, static-ish site as well as managing Wordpress itself but it did demonstrate it's drawbacks. Wordpress has some real strengths; it doesn't have a crazy learning curve, it has a nice WYSIWYG editor and it's flexible.

But it does have weaknesses, it is a frequent target of security attacks - partly due to it's broad plugin eco-system and partly as a victim of it's own success drawing more attention. I was also paying for managed Wordpress hosting, I had tried multiple times to migrate my site away from this platform and onto my own infrastructure but had failed for different reasons each time.

A flaw that was presenting itself more and more over time was it's statefulness. I have been leaning into infrastructure-as-code (IAC) and GitOps throughout my personal infrastructure, it is incredibly powerful to have the equivalent of manifests that both document and manage resources. Were there to be an issue with my [Selector](/selector) environment, I could burn the docker environment or the whole VM and stand it all back up extremely quickly and painlessly. This was not so for my Wordpress instance which felt big and lumbering in comparison.

Static site generators sounded far more flexible - ditch the database, ditch the app server, build static HTML files which can be hosted from just about anywhere. I went with [Hugo](https://gohugo.io/), I like how the project structure mapped to the site layout and I really like the markdown input. Hugo has a flexible way of including raw HTML templates which is all under source control, this was a bit of a pain with Wordpress which doesn't have such an easy way; shared blocks felt like a workaround and getting too far into custom theming felt like trouble waiting to happen.

When it comes to deployment, my first instinct was to use GitHub Pages. The static site → GitHub Pages workflow is a popular one which is getting more and more support from GitHub using their Actions CI/CD platform. This would mean that my site would be delivered from the GitHub CDN, it would make my hosting free and it would be extremely easy with a full CD/GitOps workflow. I did encounter a problem when I went to flip to a production deployment, however, and that is that GitHub Pages doesn't support SSL certificates for root domains (like sarsoo.xyz as opposed to mysite.sarsoo.xyz). Now, in theory, I don't really need a SSL certificate for my personal site anymore; no database or app server means that it's all just static files without any security considerations. But, in reality, it is something I want for my site regardless - as well as the fact that going to a non-SSL-protected site in 2022 results in a complete torrent of warnings and red flags from the browsers.

So, for now, I am hosting the site on my public VPS. This means it's not coming from a crazy large CDN but a single server which could make it a bit slower. I hope that the increased speed from serving only static files should help there. As I said, though, there are so many options to host static sites from GitHub Pages to public facing S3 buckets it could be fun to revisit this. I have left the GitHub Pages workflow in place as a [beta](https://new.sarsoo.xyz) of the site, I push new changes to production with Ansible at the moment.

[![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Sarsoo/sarsooxyz-hugo)