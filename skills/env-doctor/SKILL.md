---
name: env-doctor
description: Use when a feature fails due to the local environment rather than the code — login/auth fails only locally, missing or wrong environment variables (AWS_PROFILE, APP_ENV, table names, endpoints), Cognito/DynamoDB/Docker connection errors, "ローカルで動かない", "環境がおかしい", "環境変数を確認して", "環境診断して", or when expected-vs-actual configuration needs auditing before touching code.
version: 1.0.0
---

# env-doctor

環境起因の不具合を「コードの期待値 vs 実際の状態」の突き合わせで診断するスキル。
推測で結論を出さず、確認できない項目は「未確認」とマークする。

**冒頭で宣言する**: 「env-doctor スキルで環境診断を行います」

## 重要な前提

- 診断は**読み取り専用**。修正は提案のみとし、適用はユーザー承認後。
- `.env` / `*.key` / `id_rsa*` は**開かない**（グローバルルール）。存在確認（`ls`）のみ可。
  キーの有無・値の確認が必要な場合は変数名を提示してユーザーに確認を依頼する。
- 環境変数・設定値は**伏字**で扱う（値そのものを表示しない。存在有無・文字数程度まで）。

## 手順

### 1. 症状の特定

失敗している機能・コマンド・エラーメッセージを特定する（不明ならユーザーに確認）。
再現コマンドがあれば実行し、実際のエラー出力を取得する。

### 2. コードの期待値を洗い出す

設定読み込み箇所（config / env 解決コード）を Grep / Read で特定し、以下を列挙する。
各項目に**根拠の file:line** を必ず付ける。

- 参照される環境変数名・設定キー
- デフォルト値と、未設定時のフォールバック挙動（例: APP_ENV 未設定 → 'local' に解決）
- 環境名・フラグによる分岐条件
- **`.env` の読み込み機構の有無**（dotenv 系依存、`node --env-file`、docker compose の `env_file`、
  フレームワークの自動読込 等）。機構が無ければ `.env` に値があっても反映されない

### 3. 実際の状態を列挙（読み取り専用）

症状に関係するものだけ実行する:

```bash
# シェル環境変数（存在確認。値は伏字。0件判定は grep -c で行う）
printenv | grep -cE '^(APP_ENV|AWS_|NODE_ENV|<関連プレフィックス>)='
printenv | grep -E '^(APP_ENV|AWS_|NODE_ENV|<関連プレフィックス>)' | sed 's/=.*/=***/'

# AWS（read 系のみ）
aws configure list
aws sts get-caller-identity

# 稼働サービス
docker ps
docker compose ps
lsof -nP -iTCP:<期待ポート> -sTCP:LISTEN

# 秘匿ファイルは存在確認のみ
ls -la .env* 2>/dev/null
```

- `.env` 以外の設定ファイル（json / yaml 等）は読んでよいが、秘匿値は伏字で扱う。
- プロセス環境と `.env` は別物である点に注意（アプリが `.env` を読む構成なら、
  シェルの `printenv` に無くても未設定とは限らない → 「未確認」としてユーザーに確認を依頼）。
- `.env` 内のキー有無は自分では確認しない。ユーザーに実行してもらうコマンドを提示する
  （例: `grep -c '^SAMPLE_TABLE_NAME=' .env` — 値を表示せず有無だけ分かる）。
- 診断シェルとユーザーの普段のシェルは環境変数が異なりうる。診断シェルで症状が再現しない場合、
  `printenv` の結果を根拠にせず「ユーザーのシェルでの確認が必要」として扱う。

### 4. 期待 vs 実際の表を作る

| 項目 | 期待値（根拠 file:line） | 実際 | 判定 |
|---|---|---|---|

- 判定は **OK / NG / 未確認** の3値。
- **確認できなかった項目を NG にしない**（未確認は未確認のまま提示する）。

### 5. 根本原因と修正提案

- NG のうち症状を説明できる最有力の根本原因を特定し、因果（この値が X だから Y が起きる）を説明する。
- 修正案（環境変数の設定・AWS profile 切替・サービス起動 等）を提示する。**適用は承認後**。
- 複数 NG がある場合は症状への寄与が大きい順に並べる。

### 6. 完了報告

表 + 根本原因 + 修正提案をまとめて提示する。
未確認項目には確認方法（実行すべきコマンド、またはユーザーに確認してほしい内容）を添える。
