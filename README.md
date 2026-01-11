# dotfiles-chezmoi




## Commands

### dump Brewfile

at home directory
```
brew bundle dump --force


### check diff

```
chezmoi diff
```

```
### file -> chezmoi
```
chezmoi re-add <filename>
```

or 

```
chezmoi add <filename>
```

### apply chezmoi -> file
```
chezmoi apply
```

## WezTerm ショートカットチートシート

### タブ操作

| 操作 | ショートカット |
|------|----------------|
| 新しいタブを作成 | `CMD + T` |
| タブを閉じる | `CMD + W` (パネルが1つの場合) |
| 次のタブに移動 | `CMD + Shift + ]` または `CTRL + TAB` |
| 前のタブに移動 | `CMD + Shift + [` または `CTRL + Shift + TAB` |
| タブ番号で移動 (1-9) | `CMD + 1~9` |

### パネル操作（カスタム設定）

#### パネル分割

| 操作 | ショートカット | 設定箇所 |
|------|----------------|----------|
| **横分割**（上下に分割） | `CMD + D` | [wezterm.lua](dot_config/wezterm/wezterm.lua#L34) |
| **縦分割**（左右に分割） | `CMD + Shift + D` | [wezterm.lua](dot_config/wezterm/wezterm.lua#L33) |

#### パネル移動

| 操作 | ショートカット | 設定箇所 |
|------|----------------|----------|
| 左のパネルに移動 | `CMD + H` | [wezterm.lua](dot_config/wezterm/wezterm.lua#L37) |
| 下のパネルに移動 | `CMD + J` | [wezterm.lua](dot_config/wezterm/wezterm.lua#L38) |
| 上のパネルに移動 | `CMD + K` | [wezterm.lua](dot_config/wezterm/wezterm.lua#L39) |
| 右のパネルに移動 | `CMD + L` | [wezterm.lua](dot_config/wezterm/wezterm.lua#L40) |

#### パネルを閉じる

| 操作 | ショートカット | 設定箇所 |
|------|----------------|----------|
| 現在のパネルを閉じる | `CMD + W` | [wezterm.lua](dot_config/wezterm/wezterm.lua#L43) |

### その他の便利な操作

| 操作 | ショートカット |
|------|----------------|
| フォントサイズを大きく | `CMD + +` |
| フォントサイズを小さく | `CMD + -` |
| フォントサイズをリセット | `CMD + 0` |
| コピー | `CMD + C` |
| ペースト | `CMD + V` |
| 検索 | `CMD + F` |
| ウィンドウを閉じる | `CMD + Q` |

### 現在の設定情報

- **フォント**: Ricty Diminished (14pt)
- **カラースキーム**: iceberg-dark
- **初期サイズ**: 120列 × 28行
- **自動リロード**: 無効

ショートカットを変更したい場合は、[wezterm.lua](dot_config/wezterm/wezterm.lua) の `config.keys` セクションを編集してください。

設定の詳細については [WezTerm 公式ドキュメント](https://wezfurlong.org/wezterm/config/files.html) を参照してください。

## Lazygit カスタムコマンド

| 操作 | ショートカット | コンテキスト | 設定箇所 |
|------|----------------|--------------|----------|
| Worktreeを新しいWezTermタブで開く | `Ctrl + T` | worktrees | [config.yml](dot_config/lazygit/config.yml#L7) |

## Neovim (claudecode.nvim)

| 操作 | ショートカット | 設定箇所 |
|------|----------------|----------|
| Claude Codeをトグル | `<leader>ac` | [claudecode.lua](dot_config/nvim/lua/plugins/claudecode.lua#L7) |
| Claude Codeにフォーカス | `<leader>af` | [claudecode.lua](dot_config/nvim/lua/plugins/claudecode.lua#L8) |
| Claude Codeを再開 | `<leader>ar` | [claudecode.lua](dot_config/nvim/lua/plugins/claudecode.lua#L9) |
| Claude Codeを継続 | `<leader>aC` | [claudecode.lua](dot_config/nvim/lua/plugins/claudecode.lua#L10) |
| モデル選択 | `<leader>am` | [claudecode.lua](dot_config/nvim/lua/plugins/claudecode.lua#L11) |
| 現在のバッファを追加 | `<leader>ab` | [claudecode.lua](dot_config/nvim/lua/plugins/claudecode.lua#L12) |
| 選択範囲をClaudeに送信 | `<leader>as` (visual) | [claudecode.lua](dot_config/nvim/lua/plugins/claudecode.lua#L13) |
| ファイルを追加 (ファイラー) | `<leader>as` | [claudecode.lua](dot_config/nvim/lua/plugins/claudecode.lua#L15) |
| Diffを承認 | `<leader>aa` | [claudecode.lua](dot_config/nvim/lua/plugins/claudecode.lua#L21) |
| Diffを拒否 | `<leader>ad` | [claudecode.lua](dot_config/nvim/lua/plugins/claudecode.lua#L22) |

## Neovim (Telescope)

| 操作 | ショートカット |
|------|----------------|
| ファイル検索 (find files) | `ff` |
| ファイル検索 (directory) | `fd` |