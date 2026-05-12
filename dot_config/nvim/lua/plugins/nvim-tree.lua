return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require("nvim-tree").setup({
      -- ディレクトリを開いたときに自動表示
      hijack_directories = {
        enable = true,
        auto_open = true,
      },
      -- 現在のファイルをツリー内でハイライト
      update_focused_file = {
        enable = true,
        update_cwd = false, -- プロジェクトルートを維持
      },
    })
  end,
}
