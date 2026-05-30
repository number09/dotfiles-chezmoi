# dotfiles-chezmoi




## Commands

### dump Brewfile

at home directory

```
brew bundle dump --force
```

### check diff

```
chezmoi diff
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

## 個人設定ファイル

一部のプラグインでは、個人情報（パス、メールアドレスなど）を含む設定ファイルを別ファイルとして管理しています。
これらのファイルは`.chezmoiignore`に追加されており、gitで管理されません。

### Obsidian.nvim

obsidian.nvimのワークスペース設定は、個人固有の情報を含むため別ファイルで管理します。

**設定ファイル**: `~/.config/nvim/obsidian_local.lua` (gitで管理されない)

**作成方法**:
```bash
cat > ~/.config/nvim/obsidian_local.lua << 'EOF'
-- このファイルはgitで管理しないでください（個人設定用）
return {
  workspaces = {
    {
      name = "work",
      path = "~/path/to/your/obsidian-vault",
    },
  },
}
EOF
```

**設定例**:
```lua
return {
  workspaces = {
    {
      name = "personal",
      path = "~/Documents/obsidian-vault",
    },
    {
      name = "work",
      path = "~/Google Drive/My Vault",
    },
  },
}
```

このファイルが存在しない場合は、デフォルト設定 (`~/Documents/obsidian-vault`) が使用されます。

### AWS (XDG + スイッチロール)

AWS CLI の `config` を XDG Base Directory 配下 (`~/.config/aws/config`) で管理します。
パスは `dot_zshenv` の `AWS_CONFIG_FILE` で指定。**長期キーはディスクにもリポジトリにも
保存しません**（`credentials` ファイルは作らない）。

構成:

- **`~/.config/aws/config`** (`dot_config/private_aws/private_config.tmpl`): chezmoi 管理。
  `[profile test]` の `role_arn` / `mfa_serial`（アカウント ID を含むため機密）は git に
  残さず、`chezmoi init` 時にプロンプト手入力 → `~/.config/chezmoi/chezmoi.toml` に保持。
- **`[default]` の認証**: `credential_process` で 1Password から実行時取得。長期キーは
  どこにも書かない。
- **`~/.config/aws/op-credential-process.sh`** (`dot_config/private_aws/executable_op-credential-process.sh.tmpl`):
  1Password (`op`) からアクセスキーを取得し credential_process 形式 JSON を出力する
  ラッパー。1Password の item 名 / account も機密のため `chezmoi init` 時に手入力
  (`.aws.opItem` / `.aws.opAccount`)。

**前提**: 1Password CLI が対象アカウントにサインイン済み（デスクトップ連携で `op`
実行時に Touch ID 等で解錠される状態）。`assume` は対話実行なのでこれで足ります。

**プロンプト値の入力／変更** （`chezmoi apply` ではなく `chezmoi init` 時に評価される点に注意）:

```bash
chezmoi init        # role_arn / mfa_serial / 1Password item・account を入力
                    #   （既入力なら再質問なし: promptStringOnce）
chezmoi diff        # 差分プレビュー
chezmoi apply       # ~/.config/aws/config と op-credential-process.sh を生成
# 値を変えたいとき: chezmoi init を再実行、または ~/.config/chezmoi/chezmoi.toml を直接編集
```

スイッチロールは zshrc の `assume` 関数を使う（例: `assume test`）。
`assume test` は `[default]` の credential_process で得た IAM ユーザー認証を使って
`sts assume-role` し、得た一時クレデンシャルを環境変数に export する（ディスク非保存）。
詳細は [dot_zshrc.tmpl の assume()](dot_config/zsh/dot_zshrc.tmpl#L198)。

## LSP / 開発ツールの管理方針

LSP やランタイム/ツールチェーンといった **開発ツールは「プロジェクトの依存物」ではなく
「開発者個人のツール」** と捉え、どのプロジェクトにいても使え、かつ **特定プロジェクトの
ランタイムに縛られない** レイヤに置く。具体的には **mise のグローバル設定
(`~/.config/mise/config.toml`) に一本化** し、Homebrew は GUI / システム物に限定する。

```
OS (macOS)
├─ Homebrew ……………………… GUI / システム物のみ（開発ツール・LSPは置かない）
│
└─ mise
    ├─ グローバル (~/.config/mise/config.toml) ◀── 開発ツールは全部ここ
    │   │
    │   ├─[ランタイム/ツールチェーン: baseline、プロジェクトで上書き可]
    │   │   ├─ node = "lts" ……………… JSランタイム 兼 npm系LSPの土台
    │   │   ├─ pnpm = "latest" ……… JS パッケージマネージャ
    │   │   ├─ go   = "latest" ……… Go ツールチェーン
    │   │   ├─ rust = "stable" ……… Rust（rustup ベース）
    │   │   └─ aqua:astral-sh/uv … Python パッケージ/プロジェクト管理
    │   │
    │   └─[LSP: neovim 用]
    │       ├─ npm:@vtsls/language-server … TypeScript（bin: vtsls）
    │       ├─ npm:basedpyright ……………… Python 型/補完（bin: basedpyright-langserver）
    │       ├─ aqua:astral-sh/ruff ………… Python lint/format（ruff server）
    │       ├─ aqua:hashicorp/terraform-ls … Terraform
    │       └─ aqua:LuaLS/lua-language-server … Lua
    │
    │        └─▶ PATH / shims ─▶ neovim (vim.lsp.config)
    │
    └─ プロジェクト (repo/mise.toml) … ランタイムのバージョン上書きのみ
        ├─ node = "20"
        ├─ python = "3.12"
        └─ terraform = "1.9"
```

**原則:**

- LSP・ランタイム・ツールチェーンはすべて `mise グローバル` の1ファイルに集約する。
- `Homebrew` には開発ツール・LSP を置かない（GUI / システム物のみ。役割を混ぜない）。
- グローバルには安定版を baseline として常備し、`プロジェクト mise` は **バージョン上書き**に使う。
  プロジェクトで `node = "20"` 等に切り替えても、グローバルの baseline は無傷なので LSP は壊れない。
- グローバル mise（L2）とプロジェクト mise（L3）は別ファイル・別レイヤであり競合しない。

**バックエンドの使い分け / なぜ brew・Mason でないか:**

- node / pnpm / go / rust は mise コアプラグイン、uv / ruff / terraform-ls / lua-ls は aqua、
  vtsls / basedpyright は npm。いずれも mise が **lockfile で固定**でき一元管理できる。
- rust は brew の `rust` formula（toolchain 切替や clippy/target が扱いづらい）ではなく
  **rustup ベースの mise `rust`** を使う。
- Mason（nvim 内蔵）はバージョンが nvim 内に閉じ、再現性・一元管理が効かないため使わない。

**バージョン / サプライチェーン方針:**

- config は `latest` 表記のまま。実バージョンは隣の **`mise.lock`（chezmoi 管理）で固定**するので、
  `mise install` は lock に従い、勝手に最新へ飛ばない。
- 更新は手動 `mise upgrade` のときだけ。**リリースから数日寝かせてから上げる**運用で、
  mise に無い「最低リリース経過日数（cooldown）」を人間側で担保する。
- aqua 系（uv / ruff / terraform-ls / lua）と pnpm は **cosign / slsa / minisign /
  github_attestations 検証がデフォルト ON**（pnpm / uv / ruff は実際に attestation 検証が走る）。
  npm 系（vtsls / basedpyright）が相対的に高リスクなので、upgrade 時は特に慎重に。

**運用コマンド:**

```bash
mise install            # lock に従ってインストール（再現性あり）
mise upgrade            # 意図的にバージョンを上げる → mise.lock 更新
chezmoi re-add ~/.config/mise/mise.lock   # 更新後、lock を chezmoi ソースへ反映
mise which vtsls        # neovim 起動コマンドのパス確認
```

neovim 側の起動コマンド: `vtsls` / `basedpyright-langserver --stdio` / `ruff server` /
`terraform-ls serve` / `lua-language-server`。

> Markdown の LSP は今回は対象外（追って検討）。

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
| Worktreeを新しいWezTermタブで開く | `Ctrl + T` | localBranches | [config.yml](dot_config/lazygit/config.yml#L11) |
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
