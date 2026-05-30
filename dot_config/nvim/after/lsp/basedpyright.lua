---@brief
--- basedpyright — Python の型チェック/補完/ナビゲーション LSP
--- cmd 等は nvim-lspconfig の lsp/basedpyright.lua プリセットを継承。
--- バイナリは mise グローバル (npm:basedpyright, bin: basedpyright-langserver)。
---
--- lint/format は ruff に任せる分業構成のため、ここでは型チェックと
--- inlay hints / semantic 表示にフォーカスする。
--- デフォルトの typeCheckingMode は厳しめなので "standard" に緩める。

---@type vim.lsp.Config
return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'standard',
        diagnosticMode = 'openFilesOnly',
        autoImportCompletions = true,
        inlayHints = {
          callArgumentNames = true,
          functionReturnTypes = true,
          variableTypes = true,
          genericTypes = false,
        },
      },
    },
  },
}
