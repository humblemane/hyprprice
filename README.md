# HyprPrice

A live price widget for the [Noctalia](https://noctalia.dev) shell (Hyprland/Quickshell). Shows the price and change of
a cryptocurrency or stock right in the bar, defaulting to Monero (XMR), with a dropdown chart panel and a search bar to
switch to any of 33 coins or 52 stocks (most have logos; the rest show their ticker).

## Features

- **Bar widget**: the asset's logo (or ticker), its price, and a green/red ▲/▼ percentage change.
- **Click for a dropdown chart panel**:
  - Chart with a 24h / 7d / 30d timeframe toggle; hover it to see the price at that point
  - "Updated Ns ago" line that turns red if a poll fails
  - USD / EUR toggle (stock prices are converted using Kraken's EUR/USD rate)
  - Refresh button to poll immediately
  - Search bar (fuzzy match, scrollable results) to switch to any coin or stock; the bar widget follows
  - **Set as default** star button to choose which asset the widget starts on
  - Button to open the asset on Kraken (coins) or Yahoo Finance (stocks)
- Timeframe, currency and asset switches are runtime-only and reset on restart. Only the saved default persists.

## Install

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

Requires Noctalia with plugin API level 24 or newer (v5.0.0-beta.9+) and `xdg-open` on your `PATH`.

## Plugin

| Field | Value |
| --- | --- |
| ID | `humblemane/hyprprice` |
| Entries | Bar widget: `price`; service: `service`; panel: `chart` |
| Dependencies | `xdg-open` (opens the exchange link in your browser) |

## Settings

Configure under **Settings → Plugins → HyprPrice**:

| Setting | Type | Default | Description |
| --- | --- | --- | --- |
| `coin` | `string` | `monero` | Fallback asset id (see `lib/coins.luau`, e.g. `bitcoin`, `stock-aapl`) used when no default has been saved from the panel. |
| `currency` | `select` | `usd` | Quote currency (`usd`, `eur`). Not every coin has a EUR pair on Kraken. |
| `interval` | `int` | `30` | Refresh cadence in seconds (15-600). |
| `show_change` | `bool` | `true` | Show the percentage change next to the price. |

## IPC

```sh
# Force an immediate refresh
noctalia msg plugin humblemane/hyprprice:service all refresh

# Switch the tracked asset at runtime (id from lib/coins.luau)
noctalia msg plugin humblemane/hyprprice:service all set_coin bitcoin
noctalia msg plugin humblemane/hyprprice:service all set_coin stock-nvda

# Save an asset as the default
noctalia msg plugin humblemane/hyprprice:service all set_default stock-aapl

# Change the timeframe (24h, 7d, 30d) or currency (usd, eur)
noctalia msg plugin humblemane/hyprprice:service all set_range 7d
noctalia msg plugin humblemane/hyprprice:service all set_currency eur

# Toggle the chart panel
noctalia msg panel-toggle humblemane/hyprprice:chart
```

## What it touches

- **Network** (read-only, no accounts or keys):
  - `api.kraken.com`: coin ticker and OHLC candles, plus the EUR/USD rate for stocks in EUR
  - `query1.finance.yahoo.com`: stock prices and history (an unofficial endpoint that may rate-limit or change)
- **Filesystem**: writes one small file, `default.json`, in the plugin's own data directory (the saved default).
- **Processes**: `xdg-open` to open the exchange page, and `noctalia msg …` so the panel can send commands to the
  background service.

## Adding assets

`lib/coins.luau` is a flat, hand-verified list. For a coin, confirm Kraken resolves the pair first:

```sh
curl -s "https://api.kraken.com/0/public/Ticker?pair=<BASE>USD"
```

For a stock, confirm the Yahoo ticker returns data:

```sh
curl -s -A "Mozilla/5.0" "https://query1.finance.yahoo.com/v8/finance/chart/<TICKER>?range=1d&interval=5m"
```

Then add an entry (`id`, `symbol`, `name`, `base`, `color`, plus `kind = "stock"` for stocks). Optionally drop an
open-licensed `<symbol lowercase>.png` logo into `assets/logos/` and record its source in `assets/logos/SOURCES.md`.

## Credits

Logos in `assets/logos/` come from open-licensed sets: [cryptocurrency-icons](https://github.com/spothq/cryptocurrency-icons)
(CC0), [Simple Icons](https://github.com/simple-icons/simple-icons) (CC0) and
[Trust Wallet assets](https://github.com/trustwallet/assets) (MIT). See [assets/logos/SOURCES.md](assets/logos/SOURCES.md)
for the source of every file. Logos are trademarks of their owners and are used only to identify the asset. Assets
without a logo file show their ticker instead.

## License

The code is MIT-licensed (see [LICENSE](LICENSE)). Logos keep their own licenses, listed in `assets/logos/SOURCES.md`.
