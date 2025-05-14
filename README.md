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

### STEP6 アプリケーションを起動する

```
bundle exec ruby myapp.rb
```
