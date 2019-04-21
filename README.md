# db2_developer_cの取得手順

## Dockerにログイン
~~~
docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID,
head over to https://hub.docker.com to create one.
Username: xxxx
Password: パスワードを入力（表示はされません）
Login Succeeded
~~~

## コンテナをダウンロード
~~~
docker pull store/ibmcorp/db2_developer_c:11.1.2.2b-x86_64
11.1.2.2: Pulling from store/ibmcorp/db2_developer_c
18b8eb7e7f01: Pull complete
bd79b882979f: Pull complete
7062daba2413: Pull complete
5309e003a4bb: Pull complete
a4a9ce1100fe: Pull complete
48b47247495c: Pull complete
Digest: sha256:f9a4ccfc37ecd845443750ef54583f2968a3aed8de8780db04882b0ffc522d99 Status:
Downloaded newer image for store/ibmcorp/db2_developer_c:11.1.2.2
21
~~~

## 設定ファイルを編集（お好みにあわせて設定を変えて下さい）
~~~
vi db2.env
# set License to accept to use the Db2 software contained in this image
LICENSE=accept
# specify the Db2 Instance name
DB2INSTANCE=db2inst1
# specify the Db2 Instance password
DB2INST1_PASSWORD=password
# create an initial database with the name provided or leave empty
DBNAME=qdb
# set to true to enable BLU on instance
BLU=false
# set to true to enable Oracle Compatibility on instance
ENABLE_ORACLE_COMPATIBILITY=true
# set to yes if we have an existing instance and running a new container with an higher Db2 level. Will be deprecated on next release
UPDATEAVAIL=NO
# set to true to create sample database
TO_CREATE_SAMPLEDB=false
# set to true to create DSM repository database
REPODB=true
~~~


## コンテナを実行（run）
~~~
docker run -h db2server_qiitaTry --name db2server --restart=always --detach --privileged=true -p 50000 --env-file ./db2.env -v
/data:/database 83e8b59d8007
~~~

## Docker-Composeを使う場合
~~~
docker-compose up -d
docker-compose.ymlと同一ディレクトリで実行
~~~

## runの状況をdocker logsコマンドで確認。最後に「(*) All databases are now active.」が出るまで待つ。

~~~
docker logs -f db2server
(*) Previous setup has not been detected. Creating the users...
(*) Creating users ...
(*) Previous setup has not been detected. Creating the instance...
(*) Creating instance ... DB2 installation is being initialized.
Total number of tasks to be performed: 4
~~~

## 起動が完了したら、稼働確認。コンテナにログイン
~~~
docker exec -ti db2server bash -c "su - db2inst1"
Last login: Fri Oct 20 14:34:37 UTC 2017
[db2inst1@db2server_q ~]$
~~~

## DBに接続し、テーブル一覧を表示してみる
~~~
[db2inst1@db2server ~]$ db2 connect to sample
Database Connection Information
Database server = DB2/LINUXX8664 11.1.2.2
SQL authorization ID = DB2INST1
Local database alias = SAMPLE
[db2inst1@db2server ~]$ db2 list tables
Table/View Schema Type Creation time
------------ ------------------- --------------- -------------------------------
ACT DB2INST1 T 2017-10-20-14.30.49.511231
ADEFUSR DB2INST1 S 2017-10-20-14.30.52.539125
CATALOG DB2INST1 T 2017-10-20-14.30.56.467247
~~~

## centosのスタートアップに登録
sudo vi /etc/rc.local
~~~
docker start db2server
~~~

## コマンド集
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

・リモートのDB2インスタンスをノードとして登録  
`db2 CATALOG TCPIP NODE ノード名(任意) REMOTE ホスト名 SERVER ポート番号`

・ノードの確認  
`db2 LIST NODE DIRECTORY`  
※NODE及びDATABASEとも任意の名前を付けますが、いずれも8文字以内でないと登録できないので注意！

・インスタンスにあるデータベースをクライアント側にカタログ  
`db2 CATALOG DATABASE DB名 AS 別名 AT NODE ノード名`