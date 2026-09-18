--!nonstrict
-- Curated list of coins searchable from the chart panel's switcher, all
-- verified tradable against USD/EUR on Kraken's public API. `base` is
-- Kraken's ticker symbol (not always the same as the common one, e.g.
-- Bitcoin is XBT); `glyph` is the Tabler icon shown on the bar widget.

return {
  { id = "monero", symbol = "XMR", name = "Monero", glyph = "coin-monero-filled", base = "XMR" },
  { id = "bitcoin", symbol = "BTC", name = "Bitcoin", glyph = "coin-bitcoin-filled", base = "XBT" },
  { id = "ethereum", symbol = "ETH", name = "Ethereum", glyph = "currency-ethereum", base = "ETH" },
  { id = "litecoin", symbol = "LTC", name = "Litecoin", glyph = "currency-litecoin", base = "LTC" },
  { id = "dogecoin", symbol = "DOGE", name = "Dogecoin", glyph = "currency-dogecoin", base = "DOGE" },
  { id = "solana", symbol = "SOL", name = "Solana", glyph = "currency-solana", base = "SOL" },
  { id = "ripple", symbol = "XRP", name = "XRP", glyph = "currency-xrp", base = "XRP" },
  { id = "binancecoin", symbol = "BNB", name = "BNB", glyph = "coin-filled", base = "BNB" },
  { id = "cardano", symbol = "ADA", name = "Cardano", glyph = "coin-filled", base = "ADA" },
  { id = "polkadot", symbol = "DOT", name = "Polkadot", glyph = "coin-filled", base = "DOT" },
  { id = "tron", symbol = "TRX", name = "TRON", glyph = "coin-filled", base = "TRX" },
  { id = "avalanche-2", symbol = "AVAX", name = "Avalanche", glyph = "coin-filled", base = "AVAX" },
  { id = "chainlink", symbol = "LINK", name = "Chainlink", glyph = "coin-filled", base = "LINK" },
  { id = "polygon-ecosystem-token", symbol = "POL", name = "Polygon", glyph = "coin-filled", base = "POL" },
  { id = "shiba-inu", symbol = "SHIB", name = "Shiba Inu", glyph = "coin-filled", base = "SHIB" },
  { id = "uniswap", symbol = "UNI", name = "Uniswap", glyph = "coin-filled", base = "UNI" },
  { id = "cosmos", symbol = "ATOM", name = "Cosmos", glyph = "coin-filled", base = "ATOM" },
  { id = "bitcoin-cash", symbol = "BCH", name = "Bitcoin Cash", glyph = "currency-bitcoin", base = "BCH" },
  { id = "stellar", symbol = "XLM", name = "Stellar", glyph = "coin-filled", base = "XLM" },
  { id = "near", symbol = "NEAR", name = "NEAR Protocol", glyph = "coin-filled", base = "NEAR" },
  { id = "internet-computer", symbol = "ICP", name = "Internet Computer", glyph = "coin-filled", base = "ICP" },
  { id = "filecoin", symbol = "FIL", name = "Filecoin", glyph = "coin-filled", base = "FIL" },
  { id = "aptos", symbol = "APT", name = "Aptos", glyph = "coin-filled", base = "APT" },
  { id = "arbitrum", symbol = "ARB", name = "Arbitrum", glyph = "coin-filled", base = "ARB" },
  { id = "optimism", symbol = "OP", name = "Optimism", glyph = "coin-filled", base = "OP" },
  { id = "hedera-hashgraph", symbol = "HBAR", name = "Hedera", glyph = "coin-filled", base = "HBAR" },
  { id = "algorand", symbol = "ALGO", name = "Algorand", glyph = "coin-filled", base = "ALGO" },
  { id = "aave", symbol = "AAVE", name = "Aave", glyph = "coin-filled", base = "AAVE" },
  { id = "sui", symbol = "SUI", name = "Sui", glyph = "coin-filled", base = "SUI" },
  { id = "pepe", symbol = "PEPE", name = "Pepe", glyph = "coin-filled", base = "PEPE" },
  { id = "zcash", symbol = "ZEC", name = "Zcash", glyph = "coin-filled", base = "ZEC" },
  { id = "dash", symbol = "DASH", name = "Dash", glyph = "coin-filled", base = "DASH" },
  { id = "tezos", symbol = "XTZ", name = "Tezos", glyph = "coin-filled", base = "XTZ" },
}
