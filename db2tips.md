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