---
title: "Linear Predictive Speech Synthesiser"
date: 2020-11-10T14:48:40+00:00
draft: false
---

During my speech & audio processing & recognition post-grad module, I completed two pieces of coursework. The first of which involved writing and analysing a speech synthesiser utilising linear predictive coding. The report achieved 95%.

{{< figure src="hood_m_gram.png" caption="Spectrogram analysing one of the original vowel segments; the red circles highlight areas of interest, the lower are the formant frequencies" alt="spectrogram" >}}

The report analysed two vowel segments in order to identify their fundamental frequencies and the first handful of formant frequencies. After this, linear predictive coefficients of varying orders were calculated and used in conjunction with the fundamental frequency to re-synthesise the vowel.

[![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Sarsoo/linear-predictive-speech-synth)

[Read the report here.](final-report.pdf)

![lpc](hood_m_lpc_tile.png)