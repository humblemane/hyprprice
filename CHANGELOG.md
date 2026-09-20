# Changelog

All notable changes to HyprPrice. This project follows [Semantic Versioning](https://semver.org).

## 1.3.0

- Polished the project: rewritten README with screenshots, `CONTRIBUTING.md`, this changelog, issue templates, and an
  offline consistency check (`tools/check.py`).

## 1.2.0

- Logos now come only from open-licensed sources (CC0 / MIT); every file is attributed in `assets/logos/SOURCES.md`.
  Assets without a logo show their ticker instead.
- Removed unused glyph data and state.

## 1.1.1

- Switching assets clears the previous asset's price, change and chart, so an old price never shows under a new logo
  (for example while offline).

## 1.1.0

- 52 stocks via Yahoo Finance alongside the 33 coins, with a fuzzy, scrollable search across both.
- Real logos in the bar and panel header.
- "Set as default" button; the default is saved in the plugin's data directory.
- USD / EUR toggle works for stocks (converted with Kraken's EUR/USD rate).
- Green/red ▲/▼ percentage change on the bar.
- "Updated Ns ago" line in the panel, red when a poll fails.
- 24h / 7d / 30d chart timeframe toggle.
- Manifest: `plugin_api` raised to 24 (required for `require` and argument-array `runAsync`); `xdg-open` declared as
  a dependency.

## 1.0.0

- First release: bar widget and chart panel for Monero and other coins, priced from Kraken's public API.
