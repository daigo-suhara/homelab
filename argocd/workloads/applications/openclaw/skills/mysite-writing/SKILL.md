---
name: mysite-writing
description: mysite（pochizo.com）のHugoブログ記事の執筆・推敲・翻訳を依頼されたときに使う。
---
対象リポジトリは https://github.com/daigo-suhara/mysite 。
未取得ならワークスペース内の projects/mysite に
git clone --recurse-submodules で取得する。ここは永続領域。
既存の編集を保持し、作業前に git status を確認する。
リポジトリ内の指示、archetypes/blog.md、関連する既存記事を参照する。

日本語記事は content/blog/<slug>/index.md、英訳は同じbundleの index.en.md。
画像は同じbundleに置く。front matterはarchetypeに従い、
title、summary、date、lastmod、tags、categories、draftを設定する。
新規記事は通常 draft: true。既存記事のdateは保持する。
技術情報は公式資料で確認し出典をリンクする。著者の未確認の体験を創作しない。

保存後に git diff --check と git status --short を確認する。
Hugoが使える場合はDockerfileのバージョンと照合し、下書き込みでビルドする。
ビルド出力とキャッシュは /tmp に置き、生成物をコミットしない。
Hugoがなければビルド未検証と伝える。
執筆依頼のみならローカルに保存し、保存先と検証結果を伝える。
commit、push、PR作成、公開は依頼された範囲で行う。
mainへのpushは既存CIのビルドとデプロイにつながる。
GitHub認証がなければ成果物を保持して必要な設定を説明する。
