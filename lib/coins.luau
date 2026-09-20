--!nonstrict
-- Curated list of coins searchable from the chart panel's switcher, all
-- verified tradable against USD/EUR on Kraken's public API. `base` is
-- Kraken's ticker symbol (not always the same as the common one, e.g.
-- Bitcoin is XBT); `glyph` is the Tabler icon shown on the bar widget (empty when Tabler has no icon for the coin, in which case the bar shows the ticker text instead); `color` is the coin's brand color used for the chart.

return {
  { id = "monero", symbol = "XMR", name = "Monero", glyph = "coin-monero-filled", base = "XMR", color = "#FF6600" },
  { id = "bitcoin", symbol = "BTC", name = "Bitcoin", glyph = "coin-bitcoin-filled", base = "XBT", color = "#F7931A" },
  { id = "ethereum", symbol = "ETH", name = "Ethereum", glyph = "currency-ethereum", base = "ETH", color = "#627EEA" },
  { id = "litecoin", symbol = "LTC", name = "Litecoin", glyph = "currency-litecoin", base = "LTC", color = "#345D9D" },
  { id = "dogecoin", symbol = "DOGE", name = "Dogecoin", glyph = "currency-dogecoin", base = "DOGE", color = "#C2A633" },
  { id = "solana", symbol = "SOL", name = "Solana", glyph = "currency-solana", base = "SOL", color = "#9945FF" },
  { id = "ripple", symbol = "XRP", name = "XRP", glyph = "currency-xrp", base = "XRP", color = "#346AA9" },
  { id = "binancecoin", symbol = "BNB", name = "BNB", glyph = "", base = "BNB", color = "#F3BA2F" },
  { id = "cardano", symbol = "ADA", name = "Cardano", glyph = "", base = "ADA", color = "#3468D1" },
  { id = "polkadot", symbol = "DOT", name = "Polkadot", glyph = "", base = "DOT", color = "#E6007A" },
  { id = "tron", symbol = "TRX", name = "TRON", glyph = "", base = "TRX", color = "#EB0029" },
  { id = "avalanche-2", symbol = "AVAX", name = "Avalanche", glyph = "", base = "AVAX", color = "#E84142" },
  { id = "chainlink", symbol = "LINK", name = "Chainlink", glyph = "", base = "LINK", color = "#2A5ADA" },
  { id = "polygon-ecosystem-token", symbol = "POL", name = "Polygon", glyph = "", base = "POL", color = "#8247E5" },
  { id = "shiba-inu", symbol = "SHIB", name = "Shiba Inu", glyph = "", base = "SHIB", color = "#FFA409" },
  { id = "uniswap", symbol = "UNI", name = "Uniswap", glyph = "", base = "UNI", color = "#FF007A" },
  { id = "cosmos", symbol = "ATOM", name = "Cosmos", glyph = "", base = "ATOM", color = "#5064FB" },
  { id = "bitcoin-cash", symbol = "BCH", name = "Bitcoin Cash", glyph = "currency-bitcoin", base = "BCH", color = "#8DC351" },
  { id = "stellar", symbol = "XLM", name = "Stellar", glyph = "", base = "XLM", color = "#14B6E7" },
  { id = "near", symbol = "NEAR", name = "NEAR Protocol", glyph = "", base = "NEAR", color = "#00C1DE" },
  { id = "internet-computer", symbol = "ICP", name = "Internet Computer", glyph = "", base = "ICP", color = "#29ABE2" },
  { id = "filecoin", symbol = "FIL", name = "Filecoin", glyph = "", base = "FIL", color = "#0090FF" },
  { id = "aptos", symbol = "APT", name = "Aptos", glyph = "", base = "APT", color = "#2DD8A7" },
  { id = "arbitrum", symbol = "ARB", name = "Arbitrum", glyph = "", base = "ARB", color = "#28A0F0" },
  { id = "optimism", symbol = "OP", name = "Optimism", glyph = "", base = "OP", color = "#FF0420" },
  { id = "hedera-hashgraph", symbol = "HBAR", name = "Hedera", glyph = "", base = "HBAR", color = "#8259EF" },
  { id = "algorand", symbol = "ALGO", name = "Algorand", glyph = "", base = "ALGO", color = "#00B4B4" },
  { id = "aave", symbol = "AAVE", name = "Aave", glyph = "", base = "AAVE", color = "#B6509E" },
  { id = "sui", symbol = "SUI", name = "Sui", glyph = "", base = "SUI", color = "#4DA2FF" },
  { id = "pepe", symbol = "PEPE", name = "Pepe", glyph = "", base = "PEPE", color = "#4C9A2A" },
  { id = "zcash", symbol = "ZEC", name = "Zcash", glyph = "", base = "ZEC", color = "#F4B728" },
  { id = "dash", symbol = "DASH", name = "Dash", glyph = "", base = "DASH", color = "#008DE4" },
  { id = "tezos", symbol = "XTZ", name = "Tezos", glyph = "", base = "XTZ", color = "#2C7DF7" },
}
