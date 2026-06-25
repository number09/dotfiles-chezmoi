-- vault ナビ用のキーマップを既存の telescope spec にマージする。
-- lua/vault/init.lua の M.notes() を <leader>nn で呼ぶ。
---@type LazyPluginSpec
return {
  'nvim-telescope/telescope.nvim',
  keys = {
    { "<leader>nn", function() require("vault").notes() end, desc = "ノート(Daily/案件)を開く・作成" },
  },
}
