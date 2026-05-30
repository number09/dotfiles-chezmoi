---@brief
--- ruff — Python の lint / format（flake8 + isort + black 相当）
--- cmd 等は nvim-lspconfig の lsp/ruff.lua プリセット（`ruff server`）を継承。
--- バイナリは mise グローバル (aqua:astral-sh/ruff)。
---
--- basedpyright と併用するため、hover は basedpyright に任せて ruff 側は無効化する
--- （二重 hover を防ぐ）。format は lsp.lua の BufWritePre オートフォーマットが
--- ruff の textDocument/formatting を使う。

---@type vim.lsp.Config
return {
  on_attach = function(client, _)
    -- 型情報の hover は basedpyright が担当
    client.server_capabilities.hoverProvider = false
  end,
}
