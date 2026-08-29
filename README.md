# RoastCalc

RoastCalc is a cross-platform calculator app built with Flutter. It keeps the core calculator experience clean and familiar, then adds a retro-inspired interface and a light AI personality that reacts to your recent math activity.

The roast panel refreshes every 30 seconds and uses recent calculation history to generate short, playful commentary. If the history is empty or the network is unavailable, the app falls back to built-in responses instead of failing silently.

## Features
* Calculator input that supports familiar math notation, including symbol-friendly formatting and parsing edge cases for things like multiplication, square roots, and cube roots.
* A sliding history panel that keeps recent calculations saved locally so they persist between app sessions.
* Offline-aware behavior with graceful fallbacks when there is no internet connection or the API is unavailable.
* A Math Hacks page that suggests tips and learning moments based on your recent calculation history, even when the history is empty, with a 2-minute cooldown between generations.
* A small serverless API layer used to protect credentials while keeping client-side code simple.

## Architecture
The project keeps responsibilities separated into clear layers: presentation, domain, data, and core platform code. That structure helps keep the UI, business logic, storage, and API access independent and easier to maintain over time.