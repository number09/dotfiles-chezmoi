---@brief
--- vtsls (@vtsls/language-server) — TypeScript/JavaScript LSP
--- cmd 等は nvim-lspconfig の lsp/vtsls.lua プリセットを継承し、ここでは
--- inlay hints など VS Code 同等の表示を有効化する。
--- バイナリは mise グローバル (npm:@vtsls/language-server, bin: vtsls)。

local inlay = {
  enumMemberValues = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  parameterNames = { enabled = 'literals' },
  parameterTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  variableTypes = { enabled = false },
}

---@type vim.lsp.Config
return {
  settings = {
    typescript = { inlayHints = inlay },
    javascript = { inlayHints = inlay },
    vtsls = {
      -- workspace のローカル TS を優先しつつ、未導入なら同梱版にフォールバック
      autoUseWorkspaceTsdk = true,
    },
  },
}
