--!nonstrict
-- Headless service: polls Kraken's public API for the selected coin's price
-- and a 24h price history, computes the 24h change from that history, and
-- publishes it all to the plugin's shared state. bar.luau and chart.luau
-- watch it. The active coin defaults to Monero but can be switched at
-- runtime from the chart panel's search bar (onIpc "set_coin"), independent
-- of the persisted `coin` setting.
--
-- Kraken, not CoinGecko: api.coingecko.com's HTTPS endpoint is silently
-- blackholed (TLS-level, no response) from this host's HTTP client, while
-- plain HTTP to it and HTTPS to Kraken both work, so Kraken is the data
-- source here.

local COINS = require("./lib/coins.luau")

local function findCoin(id)
  for _, c in ipairs(COINS) do
    if c.id == id then
      return c
    end
  end
  return nil
end

local currency = noctalia.getConfig("currency") or "usd"
local intervalSeconds = noctalia.getConfig("interval") or 30
local coinId = noctalia.getConfig("coin") or "monero"

local REQUEST_HEADERS = { "Accept: application/json", "User-Agent: noctalia-monero-widget/1.0" }
local MAX_HISTORY_POINTS = 60

local lastPrice = nil

local function publishCoinMeta()
  local coin = findCoin(coinId) or { id = coinId, symbol = string.upper(coinId), name = coinId, glyph = "coin-filled" }
  noctalia.state.set("coinId", coin.id)
  noctalia.state.set("coinSymbol", coin.symbol)
  noctalia.state.set("coinName", coin.name)
  noctalia.state.set("coinGlyph", coin.glyph)
end

-- Kraken's ticker keys don't match the requested pair string (legacy X/Z
-- prefixes for some assets, e.g. XMRUSD -> XXMRZUSD), so grab whichever
-- single entry the result table holds rather than guessing the key.
local function firstValue(t)
  for _, v in pairs(t) do
    return v
  end
  return nil
end

local function krakenPair(coin)
  return coin.base .. string.upper(currency)
end

local function fetchPrice()
  local coin = findCoin(coinId)
  if not coin then
    noctalia.state.set("error", true)
    return
  end

  local requestCoin = coinId
  local pair = krakenPair(coin)
  local url = "https://api.kraken.com/0/public/Ticker?pair=" .. noctalia.string.urlEncode(pair)

  noctalia.http({ url = url, headers = REQUEST_HEADERS }, function(res)
    if requestCoin ~= coinId then
      return -- superseded by a newer coin switch
    end

    if not res.ok then
      noctalia.log(`humblemane/hyprprice: price request failed status={res.status}`)
      noctalia.state.set("error", true)
      return
    end

    local decoded = noctalia.json.decode(res.body)
    if not decoded or (decoded.error and #decoded.error > 0) then
      noctalia.log(`humblemane/hyprprice: price error for {pair}: {res.body}`)
      noctalia.state.set("error", true)
      return
    end

    local ticker = decoded.result and firstValue(decoded.result)
    local price = ticker and ticker.c and tonumber(ticker.c[1])

    if not price then
      noctalia.log(`humblemane/hyprprice: unexpected ticker payload: {res.body}`)
      noctalia.state.set("error", true)
      return
    end

    lastPrice = price
    noctalia.state.set("error", false)
    noctalia.state.set("currency", currency)
    noctalia.state.set("price", price)
  end)
end

local function fetchHistory()
  local coin = findCoin(coinId)
  if not coin then
    return
  end

  local requestCoin = coinId
  local pair = krakenPair(coin)
  local since = os.time() - 86400
  local url = "https://api.kraken.com/0/public/OHLC?pair="
    .. noctalia.string.urlEncode(pair)
    .. "&interval=30&since="
    .. tostring(since)

  noctalia.http({ url = url, headers = REQUEST_HEADERS }, function(res)
    if requestCoin ~= coinId then
      return -- superseded by a newer coin switch
    end

    if not res.ok then
      noctalia.log(`humblemane/hyprprice: history request failed status={res.status}`)
      return
    end

    local decoded = noctalia.json.decode(res.body)
    if not decoded or (decoded.error and #decoded.error > 0) then
      noctalia.log(`humblemane/hyprprice: history error for {pair}: {res.body}`)
      return
    end

    local candles = nil
    if decoded.result then
      for key, value in pairs(decoded.result) do
        if key ~= "last" then
          candles = value
          break
        end
      end
    end

    if not candles or #candles == 0 then
      noctalia.log(`humblemane/hyprprice: unexpected OHLC payload: {res.body}`)
      return
    end

    local start = math.max(1, #candles - MAX_HISTORY_POINTS + 1)
    local raw = {}
    for i = start, #candles do
      raw[#raw + 1] = tonumber(candles[i][5]) -- close price
    end

    local lo, hi = raw[1], raw[1]
    for _, v in ipairs(raw) do
      if v < lo then
        lo = v
      end
      if v > hi then
        hi = v
      end
    end

    local span = hi - lo
    local normalized = {}
    for i, v in ipairs(raw) do
      normalized[i] = span > 0 and (v - lo) / span or 0.5
    end

    noctalia.state.set("history", normalized)
    noctalia.state.set("historyPrices", raw)

    if lastPrice and raw[1] and raw[1] > 0 then
      noctalia.state.set("change", (lastPrice - raw[1]) / raw[1] * 100)
    end
  end)
end

local function fetchAll()
  publishCoinMeta()
  fetchPrice()
  fetchHistory()
end

noctalia.setUpdateInterval(intervalSeconds * 1000)
fetchAll()

function update()
  fetchAll()
end

function onConfigChanged()
  currency = noctalia.getConfig("currency") or "usd"
  intervalSeconds = noctalia.getConfig("interval") or 30
  coinId = noctalia.getConfig("coin") or "monero"
  noctalia.setUpdateInterval(intervalSeconds * 1000)
  fetchAll()
end

function onIpc(event, payload)
  if event == "refresh" then
    fetchAll()
  elseif event == "set_coin" and payload and payload ~= "" then
    coinId = payload
    fetchAll()
  end
end
