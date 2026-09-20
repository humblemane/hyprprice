# HyprPrice

**Live crypto and stock prices in your [Noctalia](https://noctalia.dev) bar, with a chart on click.**
Monero by default, 33 coins and 52 stocks to switch between. Built for Hyprland.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Noctalia plugin API](https://img.shields.io/badge/noctalia%20plugin%20API-24%2B-8A7CFF.svg)](https://docs.noctalia.dev)
[![Made for Hyprland](https://img.shields.io/badge/made%20for-Hyprland-58E1FF.svg)](https://hyprland.org)

![HyprPrice in the Noctalia bar](docs/bar.png)

<p align="center"><img src="docs/panel.png" alt="The HyprPrice chart panel" width="360"></p>

## Features

- **In the bar**: the asset's logo (or ticker), its price, and a green/red ▲/▼ percentage change.
- **Click for a dropdown panel**:
  - Price chart with a **24h / 7d / 30d** toggle; hover it to read the price at any point
  - **Search** across every coin and stock (fuzzy match, scrollable results); the bar follows your pick
  - **USD / EUR** toggle (stocks are converted with Kraken's EUR/USD rate)
  - **Set as default**: choose what the widget starts on
  - "Updated Ns ago" line that turns red if a poll fails, plus a refresh button
  - One-click link to the asset on Kraken or Yahoo Finance
- **No accounts, no API keys.** Crypto comes from Kraken's public API, stocks from Yahoo Finance.
- Lightweight: one background service polls once per interval (30s by default), shared by every bar and monitor.

## Requirements

- [Noctalia](https://noctalia.dev) v5.0.0-beta.9 or newer (plugin API level 24+)
- Hyprland (or any compositor Noctalia supports)
- `xdg-open` on your `PATH` (opens the exchange link)

## Install

```sh
# As a git source: stays up to date with `noctalia msg plugins update`
noctalia msg plugins source add hyprprice git https://github.com/humblemane/hyprprice
noctalia msg plugins enable humblemane/hyprprice
```

Or clone it into your local plugins directory:

```sh
git clone https://github.com/humblemane/hyprprice ~/.local/share/noctalia/plugins/hyprprice
noctalia msg plugins enable humblemane/hyprprice
```

### Add it to your bar

In **Settings → Bar**, add the **HyprPrice** widget, or edit `~/.config/noctalia/config.toml`:

```toml
[bar.default]
end = [ "…", "humblemane/hyprprice:price", "…" ]
```

### Optional: a Hyprland keybind for the panel

`hyprland.conf`:

```ini
bind = SUPER, P, exec, noctalia msg panel-toggle humblemane/hyprprice:chart
```

Lua config (`hyprland.lua`):

```lua
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("noctalia msg panel-toggle humblemane/hyprprice:chart"))
```

Pick any free key. Clicking the bar widget also toggles the panel.

## Usage

Click the widget to open the panel, then:

| Want to… | Do this |
| --- | --- |
| Switch asset | Type in the search box (`monero`, `nvda`, `apple`…) and click a result |
| Change the timeframe | Click **24h**, **7d** or **30d** under the chart |
| Change currency | Click the **USD/EUR** button in the header |
| Start on a different asset | Switch to it, then click **Set as default** (the star) |
| Refresh now | Click the refresh button |

Timeframe, currency and asset switches last until Noctalia restarts. The saved default persists.

## Configuration

**Settings → Plugins → HyprPrice**:

| Setting | Type | Default | Description |
| --- | --- | --- | --- |
| `coin` | string | `monero` | Fallback asset id (see `lib/coins.luau`, e.g. `bitcoin`, `stock-aapl`) used until you save a default from the panel |
| `currency` | select | `usd` | Quote currency: `usd` or `eur`. Not every coin has a EUR pair on Kraken |
| `interval` | int | `30` | Refresh cadence in seconds (15–600) |
| `show_change` | bool | `true` | Show the percentage change next to the price |

## IPC

Everything the panel does can be scripted:

```sh
noctalia msg plugin humblemane/hyprprice:service all refresh
noctalia msg plugin humblemane/hyprprice:service all set_coin bitcoin        # or stock-nvda, …
noctalia msg plugin humblemane/hyprprice:service all set_default stock-aapl  # save as default
noctalia msg plugin humblemane/hyprprice:service all set_range 7d            # 24h | 7d | 30d
noctalia msg plugin humblemane/hyprprice:service all set_currency eur        # usd | eur
noctalia msg panel-toggle humblemane/hyprprice:chart
```

## What it touches

The plugin is trusted, unsandboxed code, so here is everything it does:

- **Network** (read-only, no credentials sent):
  - `api.kraken.com`: coin ticker and candles, and the EUR/USD rate for stocks in EUR
  - `query1.finance.yahoo.com`: stock prices and history (an unofficial endpoint that may rate-limit or change)
- **Files**: writes one small file, `default.json`, in the plugin's own data directory (your saved default).
- **Processes**: `xdg-open` to open the exchange page, and `noctalia msg …` so the panel can command the background
  service.

## Troubleshooting

| Symptom | What to check |
| --- | --- |
| Bar shows `…` or `--` | Check your connection. The panel's "Updated" line turns red on failed polls. Details are in `grep hyprprice ~/.cache/noctalia/noctalia.log` |
| `--` only in EUR | That coin may have no EUR pair on Kraken; switch back to USD |
| Stock price looks stale | Markets close: the price is the last trade, and the "Updated" line shows its time |
| No logo | Not every asset has an open-licensed logo; those show their ticker |
| Plugin won't enable | Needs Noctalia beta.9+ (plugin API 24) and `xdg-open` |

## Contributing

Bug reports, new assets and fixes are welcome; see [CONTRIBUTING.md](CONTRIBUTING.md). Release notes are in
[CHANGELOG.md](CHANGELOG.md).

## Credits

Prices from [Kraken](https://docs.kraken.com/api/) and Yahoo Finance. Logos in `assets/logos/` come from
open-licensed sets: [cryptocurrency-icons](https://github.com/spothq/cryptocurrency-icons) (CC0),
[Simple Icons](https://github.com/simple-icons/simple-icons) (CC0) and
[Trust Wallet assets](https://github.com/trustwallet/assets) (MIT). See
[assets/logos/SOURCES.md](assets/logos/SOURCES.md) for every file's source. Logos are trademarks of their owners and are
used only to identify the asset.

## License

The code is MIT-licensed (see [LICENSE](LICENSE)). Logos keep their own licenses, listed in `assets/logos/SOURCES.md`.

HyprPrice is not affiliated with Kraken, Yahoo, or any listed company. Prices are informational, not financial advice.
