return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    local GtdDecorator = require("gtd.decorator")

    require("nvim-tree").setup({
      view = {
        width = {
          min = 30,
          max = 120,
        },
      },
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
      renderer = {
        decorators = {
          "Git",
          "Open",
          "Hidden",
          "Modified",
          "Bookmark",
          "Diagnostics",
          "Copied",
          GtdDecorator,
          "Cut",
        },
      },
    })
  end,
}
