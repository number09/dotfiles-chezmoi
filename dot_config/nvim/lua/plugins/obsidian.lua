-- ユーザー固有の設定を読み込む
local config_path = vim.fn.stdpath("config") .. "/obsidian_local.lua"
local ok, user_config = pcall(dofile, config_path)

-- デフォルト設定
local default_opts = {
  legacy_commands = false,
  workspaces = {
    {
      name = "default",
      path = "~/Documents/obsidian-vault",
    },
  },
  templates = {
    folder = "Template",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
  },
  daily_notes = {
    folder = "Daily",
    date_format = "%Y-%m-%d",
    template = "daily.md"
  },
}

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = false,
  ft = "markdown",
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = ok and vim.tbl_deep_extend("force", default_opts, user_config) or default_opts,
}
