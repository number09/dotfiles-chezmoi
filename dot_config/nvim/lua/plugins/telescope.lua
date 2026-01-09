---@type LazyPluginSpec
return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = "Telescope",  -- Telescopeコマンドが実行されたときに遅延ロード
  keys = {
    { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "定義へジャンプ" },
    { "gr", "<cmd>Telescope lsp_references<cr>", desc = "参照を検索" },
    { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "実装を検索" },
    { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "型定義へジャンプ" },
    { "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>", desc = "ドキュメントシンボルを検索" },
    { "<leader>ws", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "ワークスペースシンボルを検索" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "ファイル検索" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "テキスト検索" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "バッファ一覧" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "ヘルプ検索" },
  },
  config = function()
    require('telescope').setup({
      defaults = {
        -- UIの設定
        layout_strategy = 'vertical',  -- 縦分割でプレビューを大きく表示
        layout_config = {
          height = 0.95,
          width = 0.9,
          preview_cutoff = 1,
          prompt_position = "bottom",
        },
        -- プレビューの設定
        preview = {
          treesitter = true,  -- Treesitterを使用してシンタックスハイライト
        },
        -- 検索の設定
        file_ignore_patterns = {
          "node_modules",
          ".git/",
        },
      },
      pickers = {
        -- LSP用のピッカー設定
        lsp_references = {
          show_line = false,  -- 行全体を表示しない
          include_declaration = false,  -- 宣言を含めない
        },
      },
    })
  end,
}
