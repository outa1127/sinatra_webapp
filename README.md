# sinatra メモアプリ

## 導入手順(ローカルで動かすことを想定しています)

### STEP1 クローンする

```
git clone https://github.com/outa1127/sinatra_webapp.git
```

### STEP2 ディレクトリの移動

```
cd sinatra_webapp
```

### STEP3 必要な gem をインストールする

```
bundle install
```

### STEP4 データベースを作成

```
createdb sinatra_memo_app
```

### STEP5 テーブルを作成

```
CREATE TABLE memos (id serial not null, title text, content text, PRIMARY KEY(id));
```

### STEP6 ENV ファイルを作成

```
touch .env
```

### STEP6 `.env`ファイルに環境変数を追加

```
DB_NAME = 'sinatra_memo_app'
DB_USER = 'postgres'
DB_HOST= 'localhost'
DB_PORT = '5432'
```

### STEP7 アプリケーションを起動する

```
bundle exec ruby myapp.rb
```
