--!nonstrict
-- Dropdown panel opened by clicking the bar widget: current price, 24h
-- change, a 24h sparkline, a manual refresh button, and a search bar to
-- switch the tracked coin at runtime (service.luau defaults it to Monero).

local COINS = require("./lib/coins.luau")

local CURRENCY_SYMBOLS = {
  usd = "$",
  eur = "€",
}

local coinId = noctalia.state.get("coinId") or "monero"
local coinSymbol = noctalia.state.get("coinSymbol") or "XMR"
local coinName = noctalia.state.get("coinName") or "Monero"
local coinGlyph = noctalia.state.get("coinGlyph") or "coin-monero-filled"
local currency = noctalia.state.get("currency") or "usd"
local price = noctalia.state.get("price")
local change = noctalia.state.get("change")
local history = noctalia.state.get("history") or {}
local historyPrices = noctalia.state.get("historyPrices") or {}
local hoverText = nil

local searchQuery = ""
local searchResults = {}
local searchInputGen = 0
local resultsGen = 0

local function formatPrice(value: number, cur: string): string
  local symbol = CURRENCY_SYMBOLS[cur] or (string.upper(cur) .. " ")
  if value >= 1 then
    return string.format("%s%.2f", symbol, value)
  elseif value >= 0.01 then
    return string.format("%s%.4f", symbol, value)
  end
  return string.format("%s%.8f", symbol, value)
end

local function findCoin(id: string)
  for _, c in ipairs(COINS) do
    if c.id == id then
      return c
    end
  end
  return nil
end

local function searchCoins(query: string)
  if query == "" then
    return {}
  end
  local scored = {}
  for _, c in ipairs(COINS) do
    local score = noctalia.fuzzyScore(query, c.symbol .. " " .. c.name)
    if score ~= nil then
      scored[#scored + 1] = { coin = c, score = score }
    end
  end
  table.sort(scored, function(a, b)
    return a.score > b.score
  end)
  local results = {}
  for i = 1, math.min(6, #scored) do
    results[i] = scored[i].coin
  end
  return results
end

local function selectCoin(id: string)
  coinId = id
  searchQuery = ""
  searchResults = {}
  searchInputGen += 1
  resultsGen += 1
  noctalia.runAsync({ "noctalia", "msg", "plugin", "humblemane/hyprprice:service", "all", "set_coin", id })
end

local function render()
  local changeColor = "on_surface_variant"
  local changeText = "—"
  if change ~= nil then
    changeColor = change >= 0 and "success" or "error"
    changeText = string.format("%s%.2f%% · 24h", change >= 0 and "▲ " or "▼ ", math.abs(change))
  end

  local resultRows = {}
  for _, c in ipairs(searchResults) do
    resultRows[#resultRows + 1] = ui.button({
      key = c.id,
      text = `{c.symbol} · {c.name}`,
      variant = "ghost",
      contentAlign = "start",
      selected = c.id == coinId,
      onClick = function()
        selectCoin(c.id)
        render()
      end,
    })
  end

  panel.render(ui.column({ flexGrow = 1, gap = 12 }, {
    ui.row({ align = "center", justify = "space_between", gap = 8 }, {
      ui.row({ align = "center", gap = 8 }, {
        ui.glyph({ name = coinGlyph, size = 20 }),
        ui.label({ text = coinName, fontSize = 16, fontWeight = "bold", color = "on_surface" }),
      }),
      ui.row({ gap = 4 }, {
        ui.button({ glyph = "refresh", tooltip = "Refresh now", variant = "ghost", onClick = "onRefreshClicked" }),
        ui.button({ glyph = "close", onClick = "onCloseClicked" }),
      }),
    }),

    ui.column({ gap = 2 }, {
      ui.label({
        text = price and formatPrice(price, currency) or "…",
        fontSize = 28,
        fontWeight = "bold",
        color = "on_surface",
      }),
      ui.label({ text = changeText, color = changeColor }),
    }),

    ui.graph({
      values = history,
      color = "primary",
      lineWidth = 2,
      fillOpacity = 0.15,
      height = 90,
      onPointerMove = "onGraphMove",
      onPointerLeave = "onGraphLeave",
    }),

    ui.label({
      text = hoverText or "Last 24h · hover the chart to inspect",
      color = "on_surface_variant",
      fontSize = 12,
    }),

    ui.separator({}),

    ui.column({ gap = 8, align = "stretch" }, {
      ui.input({
        key = `search-{searchInputGen}`,
        placeholder = "Search coin (e.g. bitcoin, eth)…",
        onChange = "onSearchChanged",
      }),
      ui.scroll({ key = `results-{resultsGen}`, gap = 2, height = 140, align = "stretch" }, resultRows),
    }),

    ui.button({ text = "Open on Kraken", variant = "outline", onClick = "onOpenExchange" }),
  }))
end

noctalia.state.watch("coinId", function(value)
  coinId = value
  render()
end)

noctalia.state.watch("coinSymbol", function(value)
  coinSymbol = value
  render()
end)

noctalia.state.watch("coinName", function(value)
  coinName = value
  render()
end)

noctalia.state.watch("coinGlyph", function(value)
  coinGlyph = value
  render()
end)

noctalia.state.watch("price", function(value)
  price = value
  render()
end)

noctalia.state.watch("change", function(value)
  change = value
  render()
end)

noctalia.state.watch("currency", function(value)
  currency = value
  render()
end)

noctalia.state.watch("history", function(value)
  history = value
  render()
end)

noctalia.state.watch("historyPrices", function(value)
  historyPrices = value
end)

function onOpen(_context)
  render()
end

function onSearchChanged(value)
  searchQuery = value
  searchResults = searchCoins(value)
  resultsGen += 1
  render()
end

function onGraphMove(normX)
  local n = #historyPrices
  if n == 0 then
    return
  end
  local x = tonumber(normX) or 0
  local index = math.clamp(math.floor(x * (n - 1) + 0.5) + 1, 1, n)
  hoverText = formatPrice(historyPrices[index], currency)
  render()
end

function onGraphLeave()
  hoverText = nil
  render()
end

function onRefreshClicked()
  noctalia.runAsync({ "noctalia", "msg", "plugin", "humblemane/hyprprice:service", "all", "refresh" })
end

function onOpenExchange()
  local coin = findCoin(coinId)
  local base = coin and coin.base or string.upper(coinId)
  local url = "https://pro.kraken.com/app/trade/" .. string.lower(base) .. "-" .. currency
  noctalia.runAsync({ "xdg-open", url })
end

function onCloseClicked()
  panel.close()
end
