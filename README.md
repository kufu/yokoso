# Yokoso

Slack と https://srd-gate.com/03/login.cgi を連携させるツール。

# セットアップ

## サーバサイド

### 前提

- 以下を使っています
  - Heroku
  - Redis
- 以下の環境変数は後で設定するので空で大丈夫です
  - `SLACK_TOKEN`
  - `MAIL_ADDRESS_WEBHOOK`

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

```
heroku local -e .env
```

## Slack App 作成

- Slack App を新規作成して各種設定をする
- https://api.slack.com/apps

### Interactive Components

### Slash Commands

### OAuth & Permissions

- 権限を追加する
    - channels:history
    - chat:write:bot
    - users:read
- スラッシュコマンドを設定していれば以下は自動で追加されているはず
    - commands
- Token は後でサーバサイド環境変数へセットする

### App Install

- ワークスペースへのインストールを忘れずに実施

## Email Webhook

- メール受信 -> Webhook を作成
- 受信したメールの body を json で post すれば OK
- サービスは何でも良い
    - zapier なら [コチラ](https://zapier.com/app/editor/template/9205?selected_apis=ZapierMailAPI%2CWebHookAPI)
- Webhook 用メールアドレスは後でサーバサイド環境変数へセットする

## サーバーサイド環境変数の再設定

- 以下の環境変数を設定する
  - `SLACK_TOKEN`
  - `MAIL_ADDRESS_WEBHOOK`
