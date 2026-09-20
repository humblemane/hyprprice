# HyprPrice

A live cryptocurrency price widget for the [Noctalia](https://noctalia.dev) shell (Hyprland/Quickshell). Shows a
coin's price and 24h change right in the bar, defaulting to Monero (XMR), with a dropdown chart panel for a 24h
sparkline and switching coins.

## Why Kraken, not CoinGecko

This started out calling CoinGecko's public API, but `api.coingecko.com`'s HTTPS endpoint turned out to be silently
blackholed for Noctalia's HTTP client specifically — every request timed out at exactly 30s with 0 bytes received,
while plain HTTP to the same host, and HTTPS to other hosts (GitHub, Kraken, Coinbase, Binance), all worked fine. That
pattern (TLS connects but nothing ever comes back) is consistent with a Cloudflare-level block on the client's TLS
fingerprint rather than anything fixable with headers or retries. [Kraken's public API](https://docs.kraken.com/api/)
turned out to be fully reachable and has real ticker + OHLC candle data, so that's what this plugin uses.

## Features

- **Bar widget**: current price and % change with the coin's logo.
- **Click for a dropdown chart panel**:
  - Sparkline built from Kraken OHLC candles, with a 24h / 7d / 30d timeframe toggle (resets to 24h on restart)
  - Hover the chart to see the price at that point
  - "Updated Ns ago" line that turns red if a poll fails
  - USD / EUR toggle button
  - Refresh button to poll immediately
  - Search bar (fuzzy match) to switch to any coin in the curated list — updates the bar widget too
  - "Open on Kraken" button for the active coin's trade page
- Coin switches from the search bar are runtime-only; the widget always starts back on the configured default coin
  (Monero) on restart.

## Install

Clone this repo as a plugin source, or drop it straight into Noctalia's local plugins directory for development:

```sh
# As a git source (stays in sync with `noctalia msg plugins update`)
noctalia msg plugins source add hyprprice git https://github.com/humblemane/hyprprice
noctalia msg plugins enable humblemane/hyprprice

# Or, for local development: clone straight into the local plugins directory
git clone https://github.com/humblemane/hyprprice ~/.local/share/noctalia/plugins/hyprprice
noctalia msg plugins enable humblemane/hyprprice
```

Then add the bar widget to a bar, e.g. in `~/.config/noctalia/config.toml`:

```toml
[bar.default]
end = [ "…", "humblemane/hyprprice:price", "…" ]
```

## Plugin

| Field | Value |
| --- | --- |
| ID | `humblemane/hyprprice` |
| Entries | Bar widget: `price`; service: `service`; panel: `chart` |

## Settings

Configure under **Settings → Plugins → HyprPrice** (or `~/.config/noctalia/config.toml` under `[plugin_settings."humblemane/hyprprice"]`):

| Setting | Type | Default | Description |
| --- | --- | --- | --- |
| `coin` | `string` | `monero` | Coin id (from `lib/coins.luau`) tracked on startup. |
| `currency` | `select` | `usd` | Quote currency to price the coin against (`usd`, `eur`). Not every coin has an EUR pair on Kraken. |
| `interval` | `int` | `30` | Refresh cadence in seconds (15-600). |
| `show_change` | `bool` | `true` | Show the 24h percent change next to the price. |

## IPC

```sh
# Force an immediate refresh
noctalia msg plugin humblemane/hyprprice:service all refresh

# Switch the tracked coin at runtime (id must exist in lib/coins.luau)
noctalia msg plugin humblemane/hyprprice:service all set_coin bitcoin

# Change the chart timeframe (24h, 7d, 30d)
noctalia msg plugin humblemane/hyprprice:service all set_range 7d

# Toggle the chart panel
noctalia msg panel-toggle humblemane/hyprprice:chart
```

## Adding coins

Kraken doesn't trade every coin, and its pair symbols don't always match the common ticker (Bitcoin is `XBT`, for
example). `lib/coins.luau` is a flat, hand-verified list — to add a coin, confirm it resolves first:

```sh
curl -s "https://api.kraken.com/0/public/Ticker?pair=<BASE>USD"
```

then add an entry with `id` (any stable internal slug), `symbol`, `name`, a Tabler `glyph`, and the verified `base`.

## Credits

Coin logos in `assets/logos/` come from the CC0 [cryptocurrency-icons](https://github.com/spothq/cryptocurrency-icons)
set and CoinCap's icon CDN; the Solana logo is redrawn in purple. All logos are trademarks of their respective projects.

## License

MIT
