## 参考URL
Unofficial DB2 BLOG
http://db2.jugem.cc/

http://gihyo.jp/book/2011/978-4-7741-4597-6/support

## コマンド集

DB2 コマンド・ウィンドウを開く  
`db2cmd`


・リモートのDB2インスタンスをノードとして登録  
`db2 CATALOG TCPIP NODE ノード名(任意) REMOTE ホスト名 SERVER ポート番号`

・ノードの確認  
`db2 LIST NODE DIRECTORY`  
※NODE及びDATABASEとも任意の名前を付けますが、いずれも8文字以内でないと登録できないので注意！

・インスタンスにあるデータベースをクライアント側にカタログ  
`db2 CATALOG DATABASE DB名 AS 別名 AT NODE ノード名`

・カタログの削除
`db2 uncatalog node ノード名`

「DB2 ファースト・ステップ」  
`db2fs`

このコマンドは、インストールされた DB2 製品、fix pack のレベル、およびそ
の他の詳細情報を表示します。
`db2level`


このコマンドは、インストールされた DB2 製品に固有のライセンス情報をす
べてリストアップします。  
`db2licm -l`

これは DB2 9.7 で使用可能な新しいコマンドで、DB2 コピーのコア機能を検証す
ることによって、インストールの検証を行います。ご使用のインスタンスに矛盾がないか、
またデータベース作成およびデータベース接続が機能するかどうかを確認します。  
`db2val`

現行のアクティブ・インスタンスの一覧を表示する
`db2 get instance`

DB一覧  
`db2 list db directory`




DB一覧（アクティブなもの）  
`db2 list active database`

テーブルスペース情報  
`db2 list tablespaces show detail`

インスタンスレベルのレジストリ確認  
`db2set -all`

DB2インスタンス起動  
`db2start`

DB2インスタンス停止  
`db2stop force`

データベース接続  
`db2 connect to {DB名} user {username} using {password}`

データベース活性化  
`db2 "activate database {DB名} user {username} using {password}`

データベース非活性化  
`db2 "deactivate database {DB名} user {username} using {password}`

データベースマネージャ情報(インスタンスレベルのパラメータ)取得  
`db2 get dbm cfg`

データベースマネージャ情報(インスタンスレベルのパラメータ)更新  
`db2 update dbm cfg using {パラメータ名} {更新値}`

データベース情報(各データベースレベルのパラメータ)取得  
`db2 get db cfg for [DB名]`  
または  
`db2 get database configuration for [DB名]`

データベース情報(各データベースレベルのパラメータ)更新  
`db2 update db cfg for [DB名] using {パラメータ名} {値}`

スキーマ一覧  
`SELECT SCHEMANAME,OWNER FROM SYSCAT.SCHEMATA`

定義情報のエクスポート
~~~
db2look -d データベース名 -e [ 対象指定 ] [-m] [-l] [-x] [-f] 　 [-i 接続ユーザー名 -w パスワード ] [-o 出力ファイル名 ] 


　-m ： 統計情報を複製するためのUPDATE文を出力に含める。
　-a ： データベースに含まれるすべてのオブジェクトを対象とする。
　-l ： 表スペースおよびバッファプールを定義するためのDDLを出力に含める。
　-x ： 権限を付与するためのDDLを出力に含める。
　-f ： 照会オプティマイザーに影響を与える構成パラーメーターおよびプロファイルレジストリ変数の設定コマンドを出力に含める。
　-i ユーザー名 -w パスワード ： データベースの接続にユーザー名とパスワードが必要であれば指定する。
　-o 出力ファイル名 ： 生成したDDLを出力するファイルを指定します。指定しない場合、生成されたDDLは標準出力に出力する。
　-e: データベースの複製に必要な DDL ファイルを抽出


例）データベースの複製に必要なDDLを作成
>db2look -d DB名 -e -i ユーザ名 -w パスワード -o 出力ファイル名
~~~

ファイルを実行して結果をファイルに出力
`db2 –tvf script1.db2 –z script1.log`


DB作成  
`DB2 CREATE DATABASE TESTDB AUTOMATIC STORAGE YES ON C:\ USING CODESET IBM-943 TERRITORY JP COLLATE USING IDENTITY PAGESIZE 4096`


`db2 "CREATE SCHEMA APLDBUSR"`

`db2 SET CURRENT SCHEMA = 'APLDBUSR'`


表スペースの削除
https://www.ibm.com/support/knowledgecenter/ja/SSEPGG_9.7.0/com.ibm.db2.luw.admin.dbobj.doc/doc/t0005213.html

CREATE SCHEMA APLDBUSR AUTHORIZATION DB2ADMIN;
GRANT ALTERIN ON SCHEMA APLDBUSR TO USER DB2ADMIN WITH GRANT OPTION;
GRANT CREATEIN ON SCHEMA APLDBUSR TO USER DB2ADMIN WITH GRANT OPTION;
GRANT DROPIN ON SCHEMA APLDBUSR TO USER DB2ADMIN WITH GRANT OPTION;