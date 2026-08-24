# Dotfiles
this is my dotfiles!!

# install

## macOS

```
git clone https://github.com/rnnno/dotfiles && cd dotfiles
./link.sh
```

`link.sh` は設定ファイル・Claude Code 設定・エージェントスキルの symlink をまとめて張る。
`$(pwd)` を基準にするため、dotfiles ディレクトリ内で実行すること。

## Arch Linux

```
git clone https://github.com/rnnno/dotfiles && cd dotfiles
chmod +x install.sh
./install.sh
./link.sh
```

`install.sh` はパッケージのインストールと基本の symlink までを行う。
Claude Code 設定とエージェントスキルは `link.sh` が張る。
