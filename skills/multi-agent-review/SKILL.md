---
name: multi-agent-review
description: Use this skill when the user asks for a multi-perspective / multi-agent code review — "多観点レビュー", "観点レビュー", "観点を洗い出してレビュー", "観点ごとにレビュー", "multi-agent review", "レビュー観点を出して並列でレビュー". Discovers review perspectives with one subagent, adds a fixed best-practices perspective, then runs one reviewer subagent per perspective in parallel and summarizes the findings.
version: 1.0.0
---

# Multi-Agent Review（多観点レビュー）

レビュー観点を洗い出すサブエージェントと、観点ごとにレビューするサブエージェントを使い、変更を多観点で並列レビューしてサマリーを返すスキル。オーケストレーション（観点の集約・固定観点の付与・並列起動・結果集約）は **main（このスキルを実行しているあなた）** が行う。

このスキルは **report-only**。指摘の自動修正は行わない。

## 手順

### 1. レビュー対象の特定

- 引数や会話で対象（ファイル/作業内容）が**明示されていればそれを使う**。
- 明示が無ければ既定で**ブランチ差分**を取得する。base ブランチは upstream → develop → main の順でフォールバック検出する:

  ```bash
  BASE=$(git rev-parse --abbrev-ref @{upstream} 2>/dev/null | sed 's|origin/||' \
    || (git rev-parse --verify origin/develop >/dev/null 2>&1 && echo develop) \
    || echo main)
  git diff origin/$BASE...HEAD --name-only
  ```

- ブランチ差分が空なら、未コミット差分にフォールバック（`git diff --name-only` / `git diff --cached --name-only`）。
- それも空なら、**中断**してユーザーに「レビュー対象が見つからない。対象を指定してほしい」と伝える。
- 確定した**差分範囲**（例 `origin/develop-vn...HEAD`）と**変更ファイル一覧**を要約してユーザーに提示する。

### 2. レビュー観点の洗い出し（finder を1つ起動）

`review-perspective-finder` サブエージェントを **1つ** 起動する。プロンプトに以下を渡す:

- 差分範囲（または対象ファイル一覧）
- 変更ファイル一覧
- （あれば）作業内容・タスクの説明

finder は自分でコードを読み、観点リスト（各観点 = `title` / `rationale` / `focus`）を返す。
※ finder には「スタイル/規約準拠の観点は含めない」ことが指示済み（手順3で main が付与するため）。

### 3. 固定観点の追加（main が必ず付与）

finder が返した観点リストに、main が**必ず次の1観点を追加**する:

> **既存コードの書き方・パターン・命名・スタイルに従っているか、および一般的なベストプラクティスに従っているか**
> - rationale: 周囲の既存実装と一貫し、保守性を損なわないことを担保する。
> - focus: 変更ファイル全体と、近接する既存の同種実装・`CLAUDE.md` の規約。

これで「finder 由来の観点」＋「固定観点1つ」が最終的な観点リストになる。
finder が観点ゼロを返した場合は、この固定観点1つだけでレビューを行う。

### 4. 観点ごとに並列レビュー（perspective-reviewer を観点数だけ起動）

最終観点リストの**数だけ** `perspective-reviewer` サブエージェントを起動する。観点数の**上限は設けない**。

- **1つのメッセージ内で複数の Agent 呼び出しをまとめて発行**し、並列実行させる。
- 各エージェントのプロンプトには、その**担当観点1つ**（title / rationale / focus）と、**レビュー対象**（差分範囲・対象ファイル一覧）を渡す。
- 各エージェントは担当観点だけに集中して findings（severity 付き）を返す。

### 5. main による取捨判断（対応要否の仕分け）

サブエージェントは差分しか見ていないが、**main は実装の背景・意図・会話の文脈を知っている**。その知識を使い、集約した各指摘を「対応すべきか」で仕分けする:

- **要対応**: 実害があり、修正・確認が必要な指摘。
- **対応不要**: 背景を踏まえると問題にならない指摘（例: 意図的な設計、既存仕様、別箇所で担保済み、スコープ外、誤検知）。

判断は背景知識に基づいて行い、**指摘を黙って捨てない**。対応不要にしたものは必ず理由を残す（後でユーザーが妥当性を判断できるように）。

### 6. サマリー報告（main）

仕分け結果を、**要対応**と**対応不要**を分けてユーザーへ報告する:

- **要対応サマリー**（メイン）: 観点ごとにセクションを分け、severity（🔴critical / 🟠high / 🟡medium / 🟢low）付きで並べる。冒頭にレビュー対象・観点数・重大度別の件数を置く。
- **対応不要（別枠）**: 上記とは**別のセクション**に、対応不要と判断した指摘を「指摘 → 対応不要の理由（背景）」の形で簡潔にまとめる。
- いずれかの reviewer が失敗・未完了なら「**N/M 観点完了**」と明示する（取りこぼしを黙って隠さない）。
- report-only。修正は行わない（ユーザーが望めば別途対応する）。

## 原則

- オーケストレーション（観点集約・固定観点付与・並列起動・結果集約）は main が担う。サブエージェントは「観点を出す」「1観点でレビューする」に専念させる。
- finder・reviewer はいずれも read-only。このスキルの実行中にファイルを編集しない。
- 観点数に上限はないが、`perspective-reviewer` は必ず**1メッセージで並列起動**してレイテンシを抑える。
