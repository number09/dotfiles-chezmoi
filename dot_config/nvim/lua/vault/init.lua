-- vault: Daily note と 案件別デイリーメモを 1 キーで横断するための Telescope ピッカー。
-- Obsidian の `## 案件` dataview ナビ（今日の日付と同名の 案件/*/<日付>.md を集める）を
-- Neovim 側で再現する。vault の .md には一切手を加えない（Obsidian と共存）。
local M = {}

-- Obsidian vault のルート（Google Drive 上）
M.vault = "/Users/ogura.koichi/Library/CloudStorage/GoogleDrive-ogura.koichi@classmethod.jp/マイドライブ/obsidian-vault"

local uv = vim.uv or vim.loop

-- いま開いているバッファ名から日付を取る。YYYY-MM-DD.md ならその日付、なければ今日。
-- → 過去の Daily を開いていれば、その日の案件メモ群を辿れる。
local function current_date()
  local base = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  return base:match("(%d%d%d%d%-%d%d%-%d%d)") or os.date("%Y-%m-%d")
end

-- Templater のヘッダブロック（<%* ... %>）を除去し、先頭の空行を整える。
local function strip_templater(text)
  text = text:gsub("<%%.-%%>", "")
  text = text:gsub("^%s*\n", "")
  return text
end

local function read_template(name)
  local fh = io.open(M.vault .. "/Template/" .. name, "r")
  if not fh then return "" end
  local c = fh:read("*a")
  fh:close()
  return c
end

-- 指定ディレクトリ直下のサブディレクトリ名一覧。
local function subdirs(path)
  local dirs = {}
  local fd = uv.fs_scandir(path)
  if not fd then return dirs end
  while true do
    local name, t = uv.fs_scandir_next(fd)
    if not name then break end
    if t == "directory" then table.insert(dirs, name) end
  end
  return dirs
end

-- エントリを開く。ファイルが無ければテンプレートから作成してから開く。
local function open_entry(e)
  if not uv.fs_stat(e.path) then
    vim.fn.mkdir(vim.fn.fnamemodify(e.path, ":h"), "p")
    local body
    if e.kind == "daily" then
      body = read_template("daily.md")
    else
      body = strip_templater(read_template("project template.md"))
    end
    local fh = io.open(e.path, "w")
    if fh then
      fh:write(body)
      fh:close()
    end
  end
  vim.cmd("edit " .. vim.fn.fnameescape(e.path))
end

-- 候補リストを組み立てる。先頭に Daily、続いて「今日メモ有り」(●,更新時刻順)、最後に「無し」(○,名前順)。
local function build_entries(date)
  local entries = {
    { label = "📅 Daily note", path = M.vault .. "/Daily/" .. date .. ".md", kind = "daily", group = 0, key = "" },
  }

  local root = M.vault .. "/案件"
  for _, proj in ipairs(subdirs(root)) do
    local path = root .. "/" .. proj .. "/" .. date .. ".md"
    local st = uv.fs_stat(path)
    if st then
      entries[#entries + 1] = {
        label = string.format("● %s  %s", proj, os.date("%H:%M", st.mtime.sec)),
        path = path, kind = "exists", proj = proj, group = 1, key = st.mtime.sec,
      }
    else
      entries[#entries + 1] = {
        label = "○ " .. proj, path = path, kind = "new", proj = proj, group = 2, key = proj,
      }
    end
  end

  table.sort(entries, function(a, b)
    if a.group ~= b.group then return a.group < b.group end
    if a.group == 1 then return a.key > b.key end -- 更新が新しい順
    return tostring(a.key) < tostring(b.key)      -- 名前順
  end)
  return entries
end

-- メインのピッカー。<leader>nn で呼ぶ。
function M.notes()
  local date = current_date()
  local entries = build_entries(date)

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "ノート (" .. date .. ")",
    finder = finders.new_table({
      results = entries,
      entry_maker = function(e)
        return {
          value = e,
          display = e.label,
          ordinal = (e.proj or "Daily") .. " " .. e.label,
          path = e.path, -- 既存ファイルはプレビュー表示される
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = conf.file_previewer({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local sel = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if sel then open_entry(sel.value) end
      end)
      return true
    end,
  }):find()
end

return M
