-- 行番号の表示
vim.opt.number = true

-- タブの大きさ
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- クリップボードに追加（OSC 52 経由でマルチプレクサ内でも動作）
-- paste 側は OSC 52 問い合わせを避け、copy 時のキャッシュを返す
vim.opt.clipboard = "unnamedplus"
local osc52 = require("vim.ui.clipboard.osc52")
local osc52_cache = { "" }
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = function(lines, regtype)
      osc52_cache = lines
      osc52.copy("+")(lines, regtype)
    end,
    ["*"] = function(lines, regtype)
      osc52_cache = lines
      osc52.copy("*")(lines, regtype)
    end,
  },
  paste = {
    ["+"] = function() return osc52_cache end,
    ["*"] = function() return osc52_cache end,
  },
}


require("config.lazy")
require("config.lsp")
