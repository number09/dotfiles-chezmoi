-- 行番号の表示
vim.opt.number = true

-- タブの大きさ
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- クリップボードに追加
vim.opt.clipboard = "unnamedplus"


require("config.lazy")
require("config.lsp")
