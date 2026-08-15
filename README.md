# RoastCalc

A cross-platform calculator application built with Flutter. Version 1.0.0.

RoastCalc functions as a standard calculator with a distinct retro aesthetic. It integrates an AI persona that acts as a chill coworker. This AI silently monitors your calculation history and generates a short, witty text roast every five minutes. 

## Features
* Custom math engine for implicit multiplication and complex formatting.
* Sliding panel for persistent local calculation history.
* Automatic background AI fetching with an animated UI panel.
* Intelligent offline fallbacks and local rate limiting.
* Secure serverless backend via Vercel to protect API credentials.

## Architecture
This project enforces a strict layer-first architecture. The presentation, domain, data, and core platform modules remain completely separated to ensure long-term maintainability.