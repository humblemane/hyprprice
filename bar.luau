--!nonstrict
-- Bar widget: renders the Monero price published by service.luau.
-- Click opens the chart panel (chart.luau).

local CURRENCY_SYMBOLS = {
  usd = "$",
  eur = "€",
}

local showChange = noctalia.getConfig("show_change")
if showChange == nil then
  showChange = true
end

local price = noctalia.state.get("price")
local change = noctalia.state.get("change")
local currency = noctalia.state.get("currency") or "usd"
local hasError = noctalia.state.get("error") or false
local coinSymbol = noctalia.state.get("coinSymbol") or "XMR"
local coinGlyph = noctalia.state.get("coinGlyph") or "coin-monero-filled"

local function formatPrice(value: number, cur: string): string
  local symbol = CURRENCY_SYMBOLS[cur] or (string.upper(cur) .. " ")
  if value >= 1 then
    return string.format("%s%.2f", symbol, value)
  elseif value >= 0.01 then
    return string.format("%s%.4f", symbol, value)
  end
  return string.format("%s%.8f", symbol, value)
end

local function render()
  barWidget.setGlyph(coinGlyph)

  if price == nil then
    barWidget.setText(hasError and `{coinSymbol} --` or `{coinSymbol} …`)
    barWidget.setTooltip(hasError and "Price unavailable" or "Fetching price…")
    return
  end

  local text = formatPrice(price, currency)
  if showChange and change ~= nil then
    local arrow = change >= 0 and "▲" or "▼"
    text = string.format("%s  %s%.1f%%", text, arrow, math.abs(change))
  end

  barWidget.setText(text)
  barWidget.setTooltip(`{coinSymbol} · click for chart`)
end

render()

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

noctalia.state.watch("error", function(value)
  hasError = value
  render()
end)

noctalia.state.watch("coinSymbol", function(value)
  coinSymbol = value
  render()
end)

noctalia.state.watch("coinGlyph", function(value)
  coinGlyph = value
  render()
end)

function onClick()
  noctalia.togglePanel("humblemane/hyprprice:chart")
end
