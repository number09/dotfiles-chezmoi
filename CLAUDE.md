# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## このリポジトリについて

macOS 向け dotfiles を [chezmoi](https://www.chezmoi.io/) で管理するリポジトリ。
ここは chezmoi の **ソースディレクトリ**（`~/.local/share/chezmoi`）であり、
ここでファイルを編集しても `chezmoi apply` するまで実環境（`$HOME`）には反映されない。

## 主要コマンド

```bash
chezmoi diff              # ソース → 実環境 の差分プレビュー（変更前に必ず確認）
chezmoi apply             # ソースの内容を実環境に反映
chezmoi re-add <file>     # 実環境で編集した既存ファイルをソースへ取り込む
chezmoi add <file>        # 新規ファイルをソース管理下に追加
brew bundle dump --force  # Brewfile を再生成（ホームディレクトリで実行）
```

実環境側で設定を直接いじった場合は `chezmoi re-add` でソースに戻すこと。
ソース側を編集したら `chezmoi diff` → `chezmoi apply` の順で反映する。

## chezmoi の命名規約（重要）

ソースファイル名そのものが配置先とパーミッションを表す。ファイルを追加・改名する際は規約に従う。

- `dot_xxx` → `~/.xxx`（例: `dot_config/` → `~/.config/`）
- `private_xxx` → 配置時にパーミッション `600`/`700`
- `xxx.tmpl` → Go テンプレートとして展開。データは `.chezmoi.toml.tmpl` で定義
  （`chezmoi init` 時に Work email / Personal email をプロンプト入力し
  `.workEmail` / `.personalEmail` として参照される。例: `dot_config/zsh/dot_zshrc.tmpl` のエイリアス）
- `.chezmoiscripts/run_onchange_*` → 内容変更時に一度だけ実行されるスクリプト
  （例: `run_onchange_darwin-trackpad.sh.tmpl` は darwin 限定でトラックパッド設定を投入）
- `.chezmoiignore` → chezmoi の管理対象から除外するパス。
  リポジトリ専用ドキュメント（`README.md`, `CLAUDE.md`）や、
  実行時に生成される個人設定・キャッシュ（`obsidian_local.lua`、claude のキャッシュ類、`lazygit/state.yml` 等）を列挙。
  **ルート直下の非 `dot_` ファイルは `.chezmoiignore` に入れないと `$HOME` 直下へ配置されてしまう**点に注意。

`.tmpl` ファイルを編集するときは Go テンプレート構文（`{{ .workEmail }}` 等）を壊さないこと。
メールアドレス等の個人情報はハードコードせず、必ずテンプレート変数経由にする。

## 注意点

- `dot_config/claude/CLAUDE.md` は**ユーザーの全プロジェクト共通の Claude 指示ファイル**で、
  `chezmoi apply` で `~/.config/claude/CLAUDE.md` に配置される。本ファイル（リポジトリ用ガイド）とは別物。
- zsh では `npm` / `npx` がエラーになるようエイリアスされている（pnpm を使う方針）。
- `ZDOTDIR` は `~/.config/zsh`（XDG 準拠）。`dot_zshenv` で設定され、zsh 設定はすべてその配下。
- README.md に各ツール（WezTerm / lazygit / Neovim+claudecode / Telescope）のキーバインド早見表があり、
  設定箇所へのリンクが張られている。キーバインドを変更したら README の表も更新する。
