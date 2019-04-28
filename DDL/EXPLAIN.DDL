-- -*- sql -*-
--
-- Sample DDL to create Explain tables
--
--   -> assumes db2start issued
--   -> assumes connection to a database exists
--   -> assumes called by "db2 -tf EXPLAIN.DDL"
--   -> ALTERNATIVELY, ONE CAN EXECUTE THE FOLLOWING: ;
--   -> db2 "CALL SYSPROC.SYSINSTALLOBJECTS('EXPLAIN','C',NULL,CURRENT SCHEMA)"
--
--   -> uses NOT LOGGED option for LOB columns
--      If database configuration parameter BLOCKNONLOGGED is set to yes, then
--      stored procedure SYSPROC.SYSINSTALLOBJECTS should be used as shown above
--

--
-- To remind users how to use this file!
--
ECHO                              ;
ECHO ******* IMPORTANT ********** ;
ECHO                              ;
ECHO USAGE: db2 -tf EXPLAIN.DDL   ;
ECHO                              ;
ECHO ******* IMPORTANT ********** ;
ECHO                              ;
ECHO                              ;
--
--
-- Set autocommit off
--
UPDATE COMMAND OPTIONS USING C OFF;
--
--  EXPLAIN INSTANCE
--
--  (must be defined first due to referential integrity definitions)
--
CREATE TABLE EXPLAIN_INSTANCE ( EXPLAIN_REQUESTER VARCHAR(128 OCTETS) NOT NULL,
                                EXPLAIN_TIME      TIMESTAMP    NOT NULL,
                                SOURCE_NAME       VARCHAR(128 OCTETS) NOT NULL,
                                SOURCE_SCHEMA     VARCHAR(128 OCTETS) NOT NULL,
                                SOURCE_VERSION    VARCHAR(64 OCTETS)  NOT NULL,
                                EXPLAIN_OPTION    CHAR(1 OCTETS)      NOT NULL,
                                SNAPSHOT_TAKEN    CHAR(1 OCTETS)   NOT NULL,
                                DB2_VERSION       CHAR(7 OCTETS)   NOT NULL,
                                SQL_TYPE          CHAR(1 OCTETS)   NOT NULL,
                                QUERYOPT          INTEGER   NOT NULL,
                                BLOCK             CHAR(1 OCTETS)   NOT NULL,
                                ISOLATION         CHAR(2 OCTETS)   NOT NULL,
                                BUFFPAGE          INTEGER   NOT NULL,
                                AVG_APPLS         INTEGER   NOT NULL,
                                SORTHEAP          INTEGER   NOT NULL,
                                LOCKLIST          INTEGER   NOT NULL,
                                MAXLOCKS          SMALLINT  NOT NULL,
                                LOCKS_AVAIL       INTEGER   NOT NULL,
                                CPU_SPEED         DOUBLE    NOT NULL,
                                REMARKS           VARCHAR(254 OCTETS),
                                DBHEAP            INTEGER   NOT NULL,
                                COMM_SPEED        DOUBLE    NOT NULL,
                                PARALLELISM       CHAR(2 OCTETS)   NOT NULL,
                                DATAJOINER        CHAR(1 OCTETS)   NOT NULL,
                                EXECUTABLE_ID     VARCHAR(32 OCTETS) FOR BIT DATA,
                                EXECUTION_TIME    TIMESTAMP,
                                    PRIMARY KEY (EXPLAIN_REQUESTER,
                                                 EXPLAIN_TIME,
                                                 SOURCE_NAME,
                                                 SOURCE_SCHEMA,
                                                 SOURCE_VERSION))
                              ORGANIZE BY ROW;
--
-- EXPLAIN_STATEMENT
--
CREATE TABLE EXPLAIN_STATEMENT ( EXPLAIN_REQUESTER VARCHAR(128 OCTETS) NOT NULL,
                                 EXPLAIN_TIME      TIMESTAMP    NOT NULL,
                                 SOURCE_NAME       VARCHAR(128 OCTETS) NOT NULL,
                                 SOURCE_SCHEMA     VARCHAR(128 OCTETS) NOT NULL,
                                 SOURCE_VERSION    VARCHAR(64 OCTETS)  NOT NULL,
                                 EXPLAIN_LEVEL     CHAR(1 OCTETS)      NOT NULL,
                                 STMTNO            INTEGER      NOT NULL,
                                 SECTNO            INTEGER      NOT NULL,
                                 QUERYNO           INTEGER      NOT NULL,
                                 QUERYTAG          CHAR(20 OCTETS)     NOT NULL,
                                 STATEMENT_TYPE    CHAR(2 OCTETS)      NOT NULL,
                                 UPDATABLE         CHAR(1 OCTETS)      NOT NULL,
                                 DELETABLE         CHAR(1 OCTETS)      NOT NULL,
                                 TOTAL_COST        DOUBLE       NOT NULL,
                                 STATEMENT_TEXT    CLOB(2M OCTETS)     NOT NULL NOT LOGGED,
                                 SNAPSHOT          BLOB(10M)    NOT LOGGED,
                                 QUERY_DEGREE      INTEGER      NOT NULL,
                                    PRIMARY KEY (EXPLAIN_REQUESTER,
                                                 EXPLAIN_TIME,
                                                 SOURCE_NAME,
                                                 SOURCE_SCHEMA,
                                                 SOURCE_VERSION,
                                                 EXPLAIN_LEVEL,
                                                 STMTNO,
                                                 SECTNO),
                                     FOREIGN KEY (EXPLAIN_REQUESTER,
                                                  EXPLAIN_TIME,
                                                  SOURCE_NAME,
                                                  SOURCE_SCHEMA,
                                                  SOURCE_VERSION)
                                     REFERENCES EXPLAIN_INSTANCE
                                     ON DELETE CASCADE)
                               ORGANIZE BY ROW;
--
-- EXPLAIN_ARGUMENTS
--
CREATE TABLE EXPLAIN_ARGUMENT ( EXPLAIN_REQUESTER   VARCHAR(128 OCTETS)  NOT NULL,
                                EXPLAIN_TIME        TIMESTAMP     NOT NULL,
                                SOURCE_NAME         VARCHAR(128 OCTETS)  NOT NULL,
                                SOURCE_SCHEMA       VARCHAR(128 OCTETS)  NOT NULL,
                                SOURCE_VERSION      VARCHAR(64 OCTETS)   NOT NULL,
                                EXPLAIN_LEVEL       CHAR(1 OCTETS)       NOT NULL,
                                STMTNO              INTEGER       NOT NULL,
                                SECTNO              INTEGER       NOT NULL,
                                OPERATOR_ID         INTEGER       NOT NULL,
                                ARGUMENT_TYPE       CHAR(8 OCTETS)       NOT NULL,
                                ARGUMENT_VALUE      VARCHAR(1024 OCTETS),
                                LONG_ARGUMENT_VALUE CLOB(2M OCTETS)      NOT LOGGED,
                                   FOREIGN KEY (EXPLAIN_REQUESTER,
                                                EXPLAIN_TIME,
                                                SOURCE_NAME,
                                                SOURCE_SCHEMA,
                                                SOURCE_VERSION,
                                                EXPLAIN_LEVEL,
                                                STMTNO,
                                                SECTNO)
                                   REFERENCES EXPLAIN_STATEMENT
                                   ON DELETE CASCADE)
                              ORGANIZE BY ROW;
--
-- EXPLAIN_OBJECT
--
CREATE TABLE EXPLAIN_OBJECT ( EXPLAIN_REQUESTER    VARCHAR(128 OCTETS) NOT NULL,
                              EXPLAIN_TIME         TIMESTAMP    NOT NULL,
                              SOURCE_NAME          VARCHAR(128 OCTETS) NOT NULL,
                              SOURCE_SCHEMA        VARCHAR(128 OCTETS) NOT NULL,
                              SOURCE_VERSION       VARCHAR(64 OCTETS)  NOT NULL,
                              EXPLAIN_LEVEL        CHAR(1 OCTETS)      NOT NULL,
                              STMTNO               INTEGER      NOT NULL,
                              SECTNO               INTEGER      NOT NULL,
                              OBJECT_SCHEMA        VARCHAR(128 OCTETS) NOT NULL,
                              OBJECT_NAME          VARCHAR(128 OCTETS) NOT NULL,
                              OBJECT_TYPE          CHAR(2 OCTETS)      NOT NULL,
                              CREATE_TIME          TIMESTAMP,
                              STATISTICS_TIME      TIMESTAMP,
                              COLUMN_COUNT         SMALLINT     NOT NULL,
                              ROW_COUNT            BIGINT       NOT NULL,
                              WIDTH                INTEGER      NOT NULL,
                              PAGES                BIGINT       NOT NULL,
                              DISTINCT             CHAR(1 OCTETS)      NOT NULL,
                              TABLESPACE_NAME      VARCHAR(128 OCTETS),
                              OVERHEAD             DOUBLE       NOT NULL,
                              TRANSFER_RATE        DOUBLE       NOT NULL,
                              PREFETCHSIZE         INTEGER      NOT NULL,
                              EXTENTSIZE           INTEGER      NOT NULL,
                              CLUSTER              DOUBLE       NOT NULL,
                              NLEAF                BIGINT       NOT NULL,
                              NLEVELS              INTEGER      NOT NULL,
                              FULLKEYCARD          BIGINT       NOT NULL,
                              OVERFLOW             BIGINT       NOT NULL,
                              FIRSTKEYCARD         BIGINT       NOT NULL,
                              FIRST2KEYCARD        BIGINT       NOT NULL,
                              FIRST3KEYCARD        BIGINT       NOT NULL,
                              FIRST4KEYCARD        BIGINT       NOT NULL,
                              SEQUENTIAL_PAGES     BIGINT       NOT NULL,
                              DENSITY              INTEGER      NOT NULL,
                              STATS_SRC            CHAR(1 OCTETS)      NOT NULL,
                              AVERAGE_SEQUENCE_GAP          DOUBLE  NOT NULL,
                              AVERAGE_SEQUENCE_FETCH_GAP    DOUBLE  NOT NULL,
                              AVERAGE_SEQUENCE_PAGES        DOUBLE  NOT NULL,
                              AVERAGE_SEQUENCE_FETCH_PAGES  DOUBLE  NOT NULL,
                              AVERAGE_RANDOM_PAGES          DOUBLE  NOT NULL,
                              AVERAGE_RANDOM_FETCH_PAGES    DOUBLE  NOT NULL,
                              NUMRIDS                       BIGINT  NOT NULL,
                              NUMRIDS_DELETED               BIGINT  NOT NULL,
                              NUM_EMPTY_LEAFS               BIGINT  NOT NULL,
                              ACTIVE_BLOCKS                 BIGINT  NOT NULL,
                              NUM_DATA_PARTS                INTEGER  NOT NULL,
                              NULLKEYS                      CHAR(1 OCTETS),
                                   FOREIGN KEY (EXPLAIN_REQUESTER,
                                                EXPLAIN_TIME,
                                                SOURCE_NAME,
                                                SOURCE_SCHEMA,
                                                SOURCE_VERSION,
                                                EXPLAIN_LEVEL,
                                                STMTNO,
                                                SECTNO)
                                   REFERENCES EXPLAIN_STATEMENT
                                   ON DELETE CASCADE)
                            ORGANIZE BY ROW;
--
-- EXPLAIN_OPERATOR
--
CREATE TABLE EXPLAIN_OPERATOR ( EXPLAIN_REQUESTER VARCHAR(128 OCTETS) NOT NULL,
                                EXPLAIN_TIME      TIMESTAMP    NOT NULL,
                                SOURCE_NAME       VARCHAR(128 OCTETS) NOT NULL,
                                SOURCE_SCHEMA     VARCHAR(128 OCTETS) NOT NULL,
                                SOURCE_VERSION    VARCHAR(64 OCTETS)  NOT NULL,
                                EXPLAIN_LEVEL     CHAR(1 OCTETS)      NOT NULL,
                                STMTNO            INTEGER      NOT NULL,
                                SECTNO            INTEGER      NOT NULL,
                                OPERATOR_ID       INTEGER      NOT NULL,
                                OPERATOR_TYPE     CHAR(6 OCTETS)      NOT NULL,
                                TOTAL_COST        DOUBLE       NOT NULL,
                                IO_COST           DOUBLE       NOT NULL,
                                CPU_COST          DOUBLE       NOT NULL,
                                FIRST_ROW_COST    DOUBLE       NOT NULL,
                                RE_TOTAL_COST     DOUBLE       NOT NULL,
                                RE_IO_COST        DOUBLE       NOT NULL,
                                RE_CPU_COST       DOUBLE       NOT NULL,
                                COMM_COST         DOUBLE       NOT NULL,
                                FIRST_COMM_COST   DOUBLE       NOT NULL,
                                BUFFERS           DOUBLE       NOT NULL,
                                REMOTE_TOTAL_COST DOUBLE       NOT NULL,
                                REMOTE_COMM_COST  DOUBLE       NOT NULL,
                                   PRIMARY KEY (EXPLAIN_REQUESTER,
                                                EXPLAIN_TIME,
                                                SOURCE_NAME,
                                                SOURCE_SCHEMA,
                                                SOURCE_VERSION,
                                                EXPLAIN_LEVEL,
                                                STMTNO,
                                                SECTNO,
                                                OPERATOR_ID),
                                   FOREIGN KEY (EXPLAIN_REQUESTER,
                                                EXPLAIN_TIME,
                                                SOURCE_NAME,
                                                SOURCE_SCHEMA,
                                                SOURCE_VERSION,
                                                EXPLAIN_LEVEL,
                                                STMTNO,
                                                SECTNO)
                                   REFERENCES EXPLAIN_STATEMENT
                                   ON DELETE CASCADE)
                              ORGANIZE BY ROW;
--
-- EXPLAIN_PREDICATE
--
CREATE TABLE EXPLAIN_PREDICATE ( EXPLAIN_REQUESTER VARCHAR(128 OCTETS) NOT NULL,
                                 EXPLAIN_TIME      TIMESTAMP    NOT NULL,
                                 SOURCE_NAME       VARCHAR(128 OCTETS) NOT NULL,
                                 SOURCE_SCHEMA     VARCHAR(128 OCTETS) NOT NULL,
                                 SOURCE_VERSION    VARCHAR(64 OCTETS)  NOT NULL,
                                 EXPLAIN_LEVEL     CHAR(1 OCTETS)      NOT NULL,
                                 STMTNO            INTEGER      NOT NULL,
                                 SECTNO            INTEGER      NOT NULL,
                                 OPERATOR_ID       INTEGER      NOT NULL,
                                 PREDICATE_ID      INTEGER      NOT NULL,
                                 HOW_APPLIED       CHAR(10 OCTETS)     NOT NULL,
                                 WHEN_EVALUATED    CHAR(3 OCTETS)      NOT NULL,
                                 RELOP_TYPE        CHAR(2 OCTETS)      NOT NULL,
                                 SUBQUERY          CHAR(1 OCTETS)      NOT NULL,
                                 FILTER_FACTOR     DOUBLE       NOT NULL,
                                 PREDICATE_TEXT    CLOB(2M OCTETS)     NOT LOGGED,
                                 RANGE_NUM         INTEGER,
                                 INDEX_COLSEQ      INTEGER      NOT NULL,
                                   FOREIGN KEY (EXPLAIN_REQUESTER,
                                                EXPLAIN_TIME,
                                                SOURCE_NAME,
                                                SOURCE_SCHEMA,
                                                SOURCE_VERSION,
                                                EXPLAIN_LEVEL,
                                                STMTNO,
                                                SECTNO)
                                   REFERENCES EXPLAIN_STATEMENT
                                   ON DELETE CASCADE)
                               ORGANIZE BY ROW;
--
-- EXPLAIN_STREAM
--
CREATE TABLE EXPLAIN_STREAM ( EXPLAIN_REQUESTER VARCHAR(128 OCTETS) NOT NULL,
                              EXPLAIN_TIME      TIMESTAMP    NOT NULL,
                              SOURCE_NAME       VARCHAR(128 OCTETS) NOT NULL,
                              SOURCE_SCHEMA     VARCHAR(128 OCTETS) NOT NULL,
                              SOURCE_VERSION    VARCHAR(64 OCTETS)  NOT NULL,
                              EXPLAIN_LEVEL     CHAR(1 OCTETS)      NOT NULL,
                              STMTNO            INTEGER      NOT NULL,
                              SECTNO            INTEGER      NOT NULL,
                              STREAM_ID         INTEGER      NOT NULL,
                              SOURCE_TYPE       CHAR(1 OCTETS)      NOT NULL,
                              SOURCE_ID         INTEGER      NOT NULL,
                              TARGET_TYPE       CHAR(1 OCTETS)      NOT NULL,
                              TARGET_ID         INTEGER      NOT NULL,
                              OBJECT_SCHEMA     VARCHAR(128 OCTETS),
                              OBJECT_NAME       VARCHAR(128 OCTETS),
                              STREAM_COUNT      DOUBLE       NOT NULL,
                              COLUMN_COUNT      SMALLINT     NOT NULL,
                              PREDICATE_ID      INTEGER      NOT NULL,
                              COLUMN_NAMES      CLOB(2M OCTETS)     NOT LOGGED,
                              PMID              SMALLINT     NOT NULL,
                              SINGLE_NODE       CHAR(5 OCTETS),
                              PARTITION_COLUMNS CLOB(2M OCTETS)     NOT LOGGED,
                              SEQUENCE_SIZES    CLOB(2M OCTETS)     NOT LOGGED,
                                   FOREIGN KEY (EXPLAIN_REQUESTER,
                                                EXPLAIN_TIME,
                                                SOURCE_NAME,
                                                SOURCE_SCHEMA,
                                                SOURCE_VERSION,
                                                EXPLAIN_LEVEL,
                                                STMTNO,
                                                SECTNO)
                                   REFERENCES EXPLAIN_STATEMENT
                                   ON DELETE CASCADE)
                            ORGANIZE BY ROW;

--
-- EXPLAIN_DIAGNOSTIC
--
CREATE TABLE EXPLAIN_DIAGNOSTIC ( EXPLAIN_REQUESTER VARCHAR(128 OCTETS) NOT NULL,
                                  EXPLAIN_TIME      TIMESTAMP    NOT NULL,
                                  SOURCE_NAME       VARCHAR(128 OCTETS) NOT NULL,
                                  SOURCE_SCHEMA     VARCHAR(128 OCTETS) NOT NULL,
                                  SOURCE_VERSION    VARCHAR(64 OCTETS)  NOT NULL,
                                  EXPLAIN_LEVEL     CHAR(1 OCTETS)      NOT NULL,
                                  STMTNO            INTEGER      NOT NULL,
                                  SECTNO            INTEGER      NOT NULL,
                                  DIAGNOSTIC_ID     INTEGER      NOT NULL,
                                  CODE              INTEGER      NOT NULL,
                                   PRIMARY KEY (EXPLAIN_REQUESTER,
                                                EXPLAIN_TIME,
                                                SOURCE_NAME,
                                                SOURCE_SCHEMA,
                                                SOURCE_VERSION,
                                                EXPLAIN_LEVEL,
                                                STMTNO,
                                                SECTNO,
                                                DIAGNOSTIC_ID),
                                   FOREIGN KEY (EXPLAIN_REQUESTER,
                                                EXPLAIN_TIME,
                                                SOURCE_NAME,
                                                SOURCE_SCHEMA,
                                                SOURCE_VERSION,
                                                EXPLAIN_LEVEL,
                                                STMTNO,
                                                SECTNO)
                                   REFERENCES EXPLAIN_STATEMENT
                                   ON DELETE CASCADE)
                                ORGANIZE BY ROW;

--
-- EXPLAIN_DIAGNOSTIC_TOKEN
--
CREATE TABLE EXPLAIN_DIAGNOSTIC_DATA ( EXPLAIN_REQUESTER VARCHAR(128 OCTETS) NOT NULL,
                                       EXPLAIN_TIME      TIMESTAMP    NOT NULL,
                                       SOURCE_NAME       VARCHAR(128 OCTETS) NOT NULL,
                                       SOURCE_SCHEMA     VARCHAR(128 OCTETS) NOT NULL,
                                       SOURCE_VERSION    VARCHAR(64 OCTETS)  NOT NULL,
                                       EXPLAIN_LEVEL     CHAR(1 OCTETS)      NOT NULL,
                                       STMTNO            INTEGER      NOT NULL,
                                       SECTNO            INTEGER      NOT NULL,
                                       DIAGNOSTIC_ID     INTEGER      NOT NULL,
                                       ORDINAL           INTEGER      NOT NULL,
                                       TOKEN             VARCHAR(1000 OCTETS),
                                       TOKEN_LONG        BLOB(3M)     NOT LOGGED,
                                          FOREIGN KEY (EXPLAIN_REQUESTER,
                                                       EXPLAIN_TIME,
                                                       SOURCE_NAME,
                                                       SOURCE_SCHEMA,
                                                       SOURCE_VERSION,
                                                       EXPLAIN_LEVEL,
                                                       STMTNO,
                                                       SECTNO,
                                                       DIAGNOSTIC_ID)
                                          REFERENCES EXPLAIN_DIAGNOSTIC
                                          ON DELETE CASCADE)
                                     ORGANIZE BY ROW;

--
-- OBJECT_METRICS
--
CREATE TABLE OBJECT_METRICS ( EXECUTABLE_ID     VARCHAR(32 OCTETS) FOR BIT DATA NOT NULL,
                              EXECUTION_TIME    TIMESTAMP    NOT NULL,
                              OBJECT_SCHEMA     VARCHAR(128 OCTETS) NOT NULL,
                              OBJECT_NAME       VARCHAR(128 OCTETS) NOT NULL,
                              OBJECT_TYPE       CHAR(2 OCTETS)      NOT NULL,
                              MEMBER            SMALLINT     NOT NULL, 
                              DATA_PARTITION_ID INTEGER      NOT NULL,
                              ROWS_INSERTED                             BIGINT, 
                              ROWS_DELETED                              BIGINT, 
                              ROWS_UPDATED                              BIGINT, 
                              ROWS_READ                                 BIGINT, 
                              OVERFLOW_CREATES                          BIGINT, 
                              OVERFLOW_ACCESSES                         BIGINT, 
                              LOCK_WAIT_TIME                            BIGINT, 
                              LOCK_WAIT_TIME_GLOBAL                     BIGINT, 
                              LOCK_WAITS                                BIGINT, 
                              LOCK_WAITS_GLOBAL                         BIGINT, 
                              LOCK_ESCALS                               BIGINT, 
                              LOCK_ESCALS_GLOBAL                        BIGINT, 
                              DIRECT_WRITES                             BIGINT, 
                              DIRECT_WRITE_REQS                         BIGINT, 
                              DIRECT_READS                              BIGINT, 
                              DIRECT_READ_REQS                          BIGINT, 
                              OBJECT_DATA_L_READS                       BIGINT, 
                              OBJECT_DATA_P_READS                       BIGINT, 
                              OBJECT_DATA_GBP_L_READS                   BIGINT, 
                              OBJECT_DATA_GBP_P_READS                   BIGINT, 
                              OBJECT_DATA_GBP_INVALID_PAGES             BIGINT, 
                              OBJECT_DATA_LBP_PAGES_FOUND               BIGINT, 
                              OBJECT_DATA_GBP_INDEP_PAGES_FOUND_IN_LBP  BIGINT,
                              OBJECT_XDA_L_READS                        BIGINT, 
                              OBJECT_XDA_P_READS                        BIGINT, 
                              OBJECT_XDA_GBP_L_READS                    BIGINT, 
                              OBJECT_XDA_GBP_P_READS                    BIGINT, 
                              OBJECT_XDA_GBP_INVALID_PAGES              BIGINT, 
                              OBJECT_XDA_LBP_PAGES_FOUND                BIGINT,
                              OBJECT_XDA_GBP_INDEP_PAGES_FOUND_IN_LBP   BIGINT,
                              OBJECT_INDEX_L_READS                      BIGINT, 
                              OBJECT_INDEX_P_READS                      BIGINT, 
                              OBJECT_INDEX_GBP_L_READS                  BIGINT, 
                              OBJECT_INDEX_GBP_P_READS                  BIGINT, 
                              OBJECT_INDEX_GBP_INVALID_PAGES            BIGINT, 
                              OBJECT_INDEX_LBP_PAGES_FOUND              BIGINT, 
                              OBJECT_INDEX_GBP_INDEP_PAGES_FOUND_IN_LBP BIGINT,
                              OBJECT_COL_L_READS                        BIGINT,
                              OBJECT_COL_P_READS                        BIGINT,
                              OBJECT_COL_GBP_L_READS                    BIGINT,
                              OBJECT_COL_GBP_P_READS                    BIGINT,
                              OBJECT_COL_GBP_INVALID_PAGES              BIGINT,
                              OBJECT_COL_LBP_PAGES_FOUND                BIGINT,
                              OBJECT_COL_GBP_INDEP_PAGES_FOUND_IN_LBP   BIGINT,
                              OBJECT_DATA_CACHING_TIER_L_READS                 BIGINT, 
                              OBJECT_DATA_CACHING_TIER_PAGES_FOUND             BIGINT, 
                              OBJECT_DATA_CACHING_TIER_GBP_INVALID_PAGES       BIGINT,
                              OBJECT_DATA_CACHING_TIER_GBP_INDEP_PAGES_FOUND   BIGINT,
                              OBJECT_XDA_CACHING_TIER_L_READS                  BIGINT, 
                              OBJECT_XDA_CACHING_TIER_PAGES_FOUND              BIGINT, 
                              OBJECT_XDA_CACHING_TIER_GBP_INVALID_PAGES        BIGINT,
                              OBJECT_XDA_CACHING_TIER_GBP_INDEP_PAGES_FOUND    BIGINT,
                              OBJECT_INDEX_CACHING_TIER_L_READS                BIGINT, 
                              OBJECT_INDEX_CACHING_TIER_PAGES_FOUND            BIGINT, 
                              OBJECT_INDEX_CACHING_TIER_GBP_INVALID_PAGES      BIGINT,
                              OBJECT_INDEX_CACHING_TIER_GBP_INDEP_PAGES_FOUND  BIGINT,
                              OBJECT_COL_CACHING_TIER_L_READS                  BIGINT, 
                              OBJECT_COL_CACHING_TIER_PAGES_FOUND              BIGINT, 
                              OBJECT_COL_CACHING_TIER_GBP_INVALID_PAGES        BIGINT,
                              OBJECT_COL_CACHING_TIER_GBP_INDEP_PAGES_FOUND    BIGINT,
                              EXT_TABLE_RECV_WAIT_TIME                         BIGINT,
                              EXT_TABLE_RECVS_TOTAL                            BIGINT,
                              EXT_TABLE_RECV_VOLUME                            BIGINT,
                              EXT_TABLE_READ_VOLUME                            BIGINT,
                              EXT_TABLE_SEND_WAIT_TIME                         BIGINT,
                              EXT_TABLE_SENDS_TOTAL                            BIGINT,
                              EXT_TABLE_SEND_VOLUME                            BIGINT,
                              EXT_TABLE_WRITE_VOLUME                           BIGINT,
                                      PRIMARY KEY (EXECUTABLE_ID,
                                                   EXECUTION_TIME,
                                                   OBJECT_SCHEMA,
                                                   OBJECT_NAME,
                                                   OBJECT_TYPE,
                                                   MEMBER,
                                                   DATA_PARTITION_ID))
                            ORGANIZE BY ROW;


--
-- ADVISE TABLES
--

--
-- ADVISE_INSTANCE
--
--  (must be defined first due to referential integrity definitions)
--
CREATE TABLE ADVISE_INSTANCE (
        START_TIME        TIMESTAMP     NOT NULL WITH DEFAULT CURRENT TIMESTAMP,
        END_TIME          TIMESTAMP     NOT NULL WITH DEFAULT CURRENT TIMESTAMP,
        MODE              VARCHAR(4 OCTETS)    NOT NULL WITH DEFAULT,
        WKLD_COMPRESSION  CHAR(4 OCTETS)       NOT NULL WITH DEFAULT 'NONE',
        STATUS            CHAR(9 OCTETS)       NOT NULL WITH DEFAULT,
                                    PRIMARY KEY (START_TIME))
       ORGANIZE BY ROW;


--
-- ADVISE_INDEX
--
CREATE TABLE ADVISE_INDEX(
        EXPLAIN_REQUESTER VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        EXPLAIN_TIME      TIMESTAMP     NOT NULL WITH DEFAULT CURRENT TIMESTAMP,
        SOURCE_NAME       VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        SOURCE_SCHEMA     VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        SOURCE_VERSION    VARCHAR(64 OCTETS)   NOT NULL WITH DEFAULT,
        EXPLAIN_LEVEL     CHAR(1 OCTETS)       NOT NULL WITH DEFAULT,
        STMTNO            INTEGER       NOT NULL WITH DEFAULT 0,
        SECTNO            INTEGER       NOT NULL WITH DEFAULT 0,
        QUERYNO           INTEGER       NOT NULL WITH DEFAULT 0,
        QUERYTAG          CHAR(20 OCTETS)      NOT NULL WITH DEFAULT,
        NAME              VARCHAR(128 OCTETS)  NOT NULL,
        CREATOR           VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        TBNAME            VARCHAR(128 OCTETS)  NOT NULL,
        TBCREATOR         VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        COLNAMES          CLOB(2M OCTETS)      NOT NULL WITH DEFAULT,
        UNIQUERULE        CHAR(1 OCTETS)       NOT NULL WITH DEFAULT,
        COLCOUNT          SMALLINT      NOT NULL WITH DEFAULT 0,
        IID               SMALLINT      NOT NULL WITH DEFAULT 0,
        NLEAF             BIGINT        NOT NULL WITH DEFAULT 0,
        NLEVELS           SMALLINT      NOT NULL WITH DEFAULT 0,
        FIRSTKEYCARD      BIGINT        NOT NULL WITH DEFAULT 0,
        FULLKEYCARD       BIGINT        NOT NULL WITH DEFAULT 0,
        CLUSTERRATIO      SMALLINT      NOT NULL WITH DEFAULT 0,
        CLUSTERFACTOR     DOUBLE        NOT NULL WITH DEFAULT 0,
        USERDEFINED       SMALLINT      NOT NULL WITH DEFAULT 0,
        SYSTEM_REQUIRED   SMALLINT      NOT NULL WITH DEFAULT 0,
        CREATE_TIME       TIMESTAMP     NOT NULL WITH DEFAULT CURRENT TIMESTAMP,
        STATS_TIME        TIMESTAMP              WITH DEFAULT CURRENT TIMESTAMP,
        PAGE_FETCH_PAIRS  VARCHAR(520 OCTETS)  NOT NULL WITH DEFAULT,
        REMARKS           VARCHAR(254 OCTETS)           WITH DEFAULT,
        DEFINER           VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        CONVERTED         CHAR(1 OCTETS)       NOT NULL WITH DEFAULT,
        SEQUENTIAL_PAGES  BIGINT        NOT NULL WITH DEFAULT 0,
        DENSITY           INTEGER       NOT NULL WITH DEFAULT 0,
        FIRST2KEYCARD     BIGINT        NOT NULL WITH DEFAULT 0,
        FIRST3KEYCARD     BIGINT        NOT NULL WITH DEFAULT 0,
        FIRST4KEYCARD     BIGINT        NOT NULL WITH DEFAULT 0,
        PCTFREE           SMALLINT      NOT NULL WITH DEFAULT -1,
        UNIQUE_COLCOUNT   SMALLINT      NOT NULL WITH DEFAULT -1,
        MINPCTUSED        SMALLINT      NOT NULL WITH DEFAULT 0,
        REVERSE_SCANS     CHAR(1 OCTETS)       NOT NULL WITH DEFAULT 'N',
        USE_INDEX         CHAR(1 OCTETS),
        CREATION_TEXT     CLOB(2M OCTETS)      NOT NULL NOT LOGGED WITH DEFAULT,
        PACKED_DESC       BLOB(1M)               NOT LOGGED,
        RUN_ID            TIMESTAMP,
        INDEXTYPE         VARCHAR(4 OCTETS)    NOT NULL WITH DEFAULT,
        EXISTS            CHAR(1 OCTETS)       NOT NULL WITH DEFAULT 'N',
        RIDTOBLOCK        CHAR(1 OCTETS)       NOT NULL WITH DEFAULT 'N',
        AVGPARTITION_CLUSTERRATIO     SMALLINT     NOT NULL WITH DEFAULT 0,
        AVGPARTITION_CLUSTERFACTOR    DOUBLE       NOT NULL WITH DEFAULT 0,
        AVGPARTITION_PAGE_FETCH_PAIRS VARCHAR(520 OCTETS) NOT NULL WITH DEFAULT,
        DATAPARTITION_CLUSTERFACTOR   DOUBLE       NOT NULL WITH DEFAULT 0,
        NULLKEYS          CHAR(1 OCTETS)       NOT NULL WITH DEFAULT 'Y',
                                    FOREIGN KEY (RUN_ID)
                                    REFERENCES ADVISE_INSTANCE (START_TIME)
                                    ON DELETE CASCADE)
       ORGANIZE BY ROW;
--
-- ADVISE_WORKLOAD
--
CREATE TABLE ADVISE_WORKLOAD (
        WORKLOAD_NAME     CHAR(128 OCTETS)    NOT NULL WITH DEFAULT 'WK0',
        STATEMENT_NO      INTEGER      NOT NULL WITH DEFAULT 1,
        STATEMENT_TEXT    CLOB(2M OCTETS)     NOT NULL NOT LOGGED,
        STATEMENT_TAG     VARCHAR(256 OCTETS) NOT NULL WITH DEFAULT ,
        FREQUENCY         INTEGER      NOT NULL WITH DEFAULT 1,
        IMPORTANCE        DOUBLE       NOT NULL WITH DEFAULT 1,
        WEIGHT            DOUBLE       NOT NULL WITH DEFAULT 1,
        COST_BEFORE       DOUBLE,
        COST_AFTER        DOUBLE,
        COMPILABLE        CHAR(17 OCTETS))
       ORGANIZE BY ROW;

--
-- ADVISE_MQT
--
CREATE TABLE ADVISE_MQT (
        EXPLAIN_REQUESTER VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        EXPLAIN_TIME      TIMESTAMP     NOT NULL WITH DEFAULT CURRENT TIMESTAMP,
        SOURCE_NAME       VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        SOURCE_SCHEMA     VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        SOURCE_VERSION    VARCHAR(64 OCTETS)   NOT NULL WITH DEFAULT,
        EXPLAIN_LEVEL     CHAR(1 OCTETS)       NOT NULL WITH DEFAULT,
        STMTNO            INTEGER       NOT NULL WITH DEFAULT 0,
        SECTNO            INTEGER       NOT NULL WITH DEFAULT 0,
        NAME              VARCHAR(128 OCTETS)  NOT NULL,
        CREATOR           VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        IID               SMALLINT      NOT NULL WITH DEFAULT 0,
        CREATE_TIME       TIMESTAMP     NOT NULL WITH DEFAULT CURRENT TIMESTAMP,
        STATS_TIME        TIMESTAMP              WITH DEFAULT CURRENT TIMESTAMP,
        NUMROWS           DOUBLE        NOT NULL WITH DEFAULT 0,
        NUMCOLS           SMALLINT      NOT NULL WITH DEFAULT 0,
        ROWSIZE           DOUBLE        NOT NULL WITH DEFAULT 0,
        BENEFIT           FLOAT         NOT NULL WITH DEFAULT 0.0,
        USE_MQT           CHAR(1 OCTETS),
        MQT_SOURCE        CHAR(1 OCTETS),
        QUERY_TEXT        CLOB(2M OCTETS)      NOT NULL NOT LOGGED WITH DEFAULT,
        CREATION_TEXT     CLOB(2M OCTETS)      NOT NULL NOT LOGGED WITH DEFAULT,
        SAMPLE_TEXT       CLOB(2M OCTETS)      NOT NULL NOT LOGGED WITH DEFAULT,
        COLSTATS          CLOB(2M OCTETS)      NOT NULL NOT LOGGED WITH DEFAULT,
        EXTRA_INFO        BLOB(2M)      NOT NULL NOT LOGGED WITH DEFAULT,
        TBSPACE           VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        RUN_ID            TIMESTAMP,
        REFRESH_TYPE      CHAR(1 OCTETS)       NOT NULL WITH DEFAULT,
        EXISTS            CHAR(1 OCTETS)       NOT NULL WITH DEFAULT 'N',
                                    FOREIGN KEY (RUN_ID)
                                    REFERENCES ADVISE_INSTANCE (START_TIME)
                                    ON DELETE CASCADE)
       ORGANIZE BY ROW;

--
-- ADVISE_PARTITION
--
CREATE TABLE ADVISE_PARTITION (
        EXPLAIN_REQUESTER VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        EXPLAIN_TIME      TIMESTAMP     NOT NULL WITH DEFAULT CURRENT TIMESTAMP,
        SOURCE_NAME       VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        SOURCE_SCHEMA     VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        SOURCE_VERSION    VARCHAR(64 OCTETS)   NOT NULL WITH DEFAULT,
        EXPLAIN_LEVEL     CHAR(1 OCTETS)       NOT NULL WITH DEFAULT,
        STMTNO            INTEGER       NOT NULL WITH DEFAULT 0,
        SECTNO            INTEGER       NOT NULL WITH DEFAULT 0,
        QUERYNO           INTEGER       NOT NULL WITH DEFAULT 0,
        QUERYTAG          CHAR(20 OCTETS)      NOT NULL WITH DEFAULT,
        TBNAME            VARCHAR(128 OCTETS)  NOT NULL,
        TBCREATOR         VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        PMID              SMALLINT      NOT NULL,
        TBSPACE           VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        COLNAMES          CLOB(2M OCTETS)      NOT NULL NOT LOGGED WITH DEFAULT,
        COLCOUNT          SMALLINT      NOT NULL WITH DEFAULT 0,
        REPLICATE         CHAR(1 OCTETS)       NOT NULL WITH DEFAULT 'N',
        COST              DOUBLE        NOT NULL,
        USEIT             CHAR(1 OCTETS),
        RUN_ID            TIMESTAMP,
                                    FOREIGN KEY(RUN_ID)
                                    REFERENCES ADVISE_INSTANCE (START_TIME)
                                    ON DELETE CASCADE)
       ORGANIZE BY ROW;

--
-- ADVISE_TABLE
--
CREATE TABLE ADVISE_TABLE (
        RUN_ID            TIMESTAMP,
        TABLE_NAME        VARCHAR(128 OCTETS)  NOT NULL,
        TABLE_SCHEMA      VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        TABLESPACE        VARCHAR(128 OCTETS)  NOT NULL WITH DEFAULT,
        SELECTION_FLAG    VARCHAR(8 OCTETS)    NOT NULL WITH DEFAULT,
        TABLE_EXISTS      CHAR(1 OCTETS)       NOT NULL WITH DEFAULT,
        USE_TABLE         CHAR(1 OCTETS)       NOT NULL WITH DEFAULT,
        GEN_COLUMNS       CLOB(2M OCTETS)      NOT NULL NOT LOGGED WITH DEFAULT,
        ORGANIZE_BY       CLOB(2M OCTETS)      NOT NULL NOT LOGGED WITH DEFAULT,
        CREATION_TEXT     CLOB(2M OCTETS)      NOT NULL NOT LOGGED WITH DEFAULT,
        ALTER_COMMAND     CLOB(2M OCTETS)      NOT NULL NOT LOGGED WITH DEFAULT,
        DISKUSE           DOUBLE        NOT NULL WITH DEFAULT 0 ,
                                    FOREIGN KEY (RUN_ID)
                                    REFERENCES ADVISE_INSTANCE (START_TIME)
                                    ON DELETE CASCADE)
       ORGANIZE BY ROW;


--
-- Commit work
--
COMMIT WORK;

--
-- Optional Indexes: The following indexes are recommended for improved performance
-- of explain-related utilities. These create index statements can be deleted, or
-- the indexes dropped if space is a problem.
--
CREATE INDEX STMT_I1 on
   EXPLAIN_STATEMENT(EXPLAIN_TIME, EXPLAIN_LEVEL, STMTNO, SECTNO);
CREATE INDEX ARG_I1 on
   EXPLAIN_ARGUMENT(EXPLAIN_TIME, EXPLAIN_LEVEL, STMTNO, SECTNO, OPERATOR_ID);
CREATE INDEX PRD_I1 on
   EXPLAIN_PREDICATE(EXPLAIN_TIME, EXPLAIN_LEVEL, STMTNO, SECTNO, OPERATOR_ID);
CREATE INDEX STM_I1 on
   EXPLAIN_STREAM(EXPLAIN_TIME, EXPLAIN_LEVEL, STMTNO, SECTNO);
CREATE INDEX OBJ_I1 on
   EXPLAIN_OBJECT(EXPLAIN_TIME, EXPLAIN_LEVEL, STMTNO, SECTNO);
CREATE INDEX EXP_DIAG_DAT_I1 on
   EXPLAIN_DIAGNOSTIC_DATA(EXPLAIN_TIME, EXPLAIN_LEVEL, STMTNO, SECTNO, DIAGNOSTIC_ID, ORDINAL);

CREATE INDEX IDX_I1 on
   ADVISE_INDEX (EXPLAIN_TIME);
CREATE INDEX IDX_I2 on
   ADVISE_INDEX (NAME, EXPLAIN_TIME);
CREATE INDEX MQT_I1 on
   ADVISE_MQT (EXPLAIN_TIME);
CREATE INDEX MQT_I2 on
   ADVISE_MQT (NAME,EXPLAIN_TIME);
CREATE INDEX PRT_I1 on
   ADVISE_PARTITION (EXPLAIN_TIME);

--
-- Commit work
--
COMMIT WORK;

--
-- The following function formats the explain diagnostic table messages
--
CREATE FUNCTION EXPLAIN_GET_MSGS( EXPLAIN_REQUESTER VARCHAR(128 OCTETS),
                                  EXPLAIN_TIME      TIMESTAMP,
                                  SOURCE_NAME       VARCHAR(128 OCTETS),
                                  SOURCE_SCHEMA     VARCHAR(128 OCTETS),
                                  SOURCE_VERSION    VARCHAR(64 OCTETS),
                                  EXPLAIN_LEVEL     CHAR(1 OCTETS),
                                  STMTNO            INTEGER,
                                  SECTNO            INTEGER,
                                  INLOCALE          VARCHAR(33 OCTETS) )
  RETURNS TABLE ( EXPLAIN_REQUESTER VARCHAR(128 OCTETS),
                  EXPLAIN_TIME      TIMESTAMP,
                  SOURCE_NAME       VARCHAR(128 OCTETS),
                  SOURCE_SCHEMA     VARCHAR(128 OCTETS),
                  SOURCE_VERSION    VARCHAR(64 OCTETS),
                  EXPLAIN_LEVEL     CHAR(1 OCTETS),
                  STMTNO            INTEGER,
                  SECTNO            INTEGER,
                  DIAGNOSTIC_ID     INTEGER,
                  LOCALE            VARCHAR(33 OCTETS),
                  MSG               VARCHAR(4096 OCTETS) )
  SPECIFIC EXPLAIN_GET_MSGS
  LANGUAGE SQL
  DETERMINISTIC
  NO EXTERNAL ACTION
  READS SQL DATA
  RETURN SELECT A.A_EXPLAIN_REQUESTER,
                A.A_EXPLAIN_TIME,
                A.A_SOURCE_NAME,
                A.A_SOURCE_SCHEMA,
                A.A_SOURCE_VERSION,
                A.A_EXPLAIN_LEVEL,
                A.A_STMTNO,
                A.A_SECTNO,
                A.A_DIAGNOSTIC_ID,
                F.LOCALE,
                F.MSG
         FROM EXPLAIN_DIAGNOSTIC A( A_EXPLAIN_REQUESTER,
                                    A_EXPLAIN_TIME,
                                    A_SOURCE_NAME,
                                    A_SOURCE_SCHEMA,
                                    A_SOURCE_VERSION,
                                    A_EXPLAIN_LEVEL,
                                    A_STMTNO,
                                    A_SECTNO,
                                    A_DIAGNOSTIC_ID,
                                    A_CODE ),
              TABLE( SYSPROC.EXPLAIN_GET_MSG2(
                       INLOCALE,
                       A.A_CODE,
                       ( SELECT TOKEN FROM EXPLAIN_DIAGNOSTIC_DATA B
                         WHERE A.A_EXPLAIN_REQUESTER = B.EXPLAIN_REQUESTER
                           AND A.A_EXPLAIN_TIME      = B.EXPLAIN_TIME
                           AND A.A_SOURCE_NAME       = B.SOURCE_NAME
                           AND A.A_SOURCE_SCHEMA     = B.SOURCE_SCHEMA
                           AND A.A_SOURCE_VERSION    = B.SOURCE_VERSION
                           AND A.A_EXPLAIN_LEVEL     = B.EXPLAIN_LEVEL
                           AND A.A_STMTNO            = B.STMTNO
                           AND A.A_SECTNO            = B.SECTNO
                           AND A.A_DIAGNOSTIC_ID     = B.DIAGNOSTIC_ID
                           AND B.ORDINAL=1 ),
                       ( SELECT TOKEN FROM EXPLAIN_DIAGNOSTIC_DATA B
                         WHERE A.A_EXPLAIN_REQUESTER = B.EXPLAIN_REQUESTER
                           AND A.A_EXPLAIN_TIME      = B.EXPLAIN_TIME
                           AND A.A_SOURCE_NAME       = B.SOURCE_NAME
                           AND A.A_SOURCE_SCHEMA     = B.SOURCE_SCHEMA

                           AND A.A_SOURCE_VERSION    = B.SOURCE_VERSION
                           AND A.A_EXPLAIN_LEVEL     = B.EXPLAIN_LEVEL
                           AND A.A_STMTNO            = B.STMTNO
                           AND A.A_SECTNO            = B.SECTNO
                           AND A.A_DIAGNOSTIC_ID     = B.DIAGNOSTIC_ID
                           AND B.ORDINAL=2 ),
                       ( SELECT TOKEN FROM EXPLAIN_DIAGNOSTIC_DATA B
                         WHERE A.A_EXPLAIN_REQUESTER = B.EXPLAIN_REQUESTER
                           AND A.A_EXPLAIN_TIME      = B.EXPLAIN_TIME
                           AND A.A_SOURCE_NAME       = B.SOURCE_NAME
                           AND A.A_SOURCE_SCHEMA     = B.SOURCE_SCHEMA
                           AND A.A_SOURCE_VERSION    = B.SOURCE_VERSION
                           AND A.A_EXPLAIN_LEVEL     = B.EXPLAIN_LEVEL
                           AND A.A_STMTNO            = B.STMTNO
                           AND A.A_SECTNO            = B.SECTNO
                           AND A.A_DIAGNOSTIC_ID     = B.DIAGNOSTIC_ID
                           AND B.ORDINAL=3 ) ) ) F
         WHERE ( EXPLAIN_REQUESTER IS NULL OR
                 EXPLAIN_REQUESTER = A.A_EXPLAIN_REQUESTER )
           AND ( EXPLAIN_TIME      IS NULL OR
                 EXPLAIN_TIME      = A.A_EXPLAIN_TIME      )
           AND ( SOURCE_NAME       IS NULL OR
                 SOURCE_NAME       = A.A_SOURCE_NAME       )
           AND ( SOURCE_SCHEMA     IS NULL OR
                 SOURCE_SCHEMA     = A.A_SOURCE_SCHEMA     )
           AND ( SOURCE_VERSION    IS NULL OR
                 SOURCE_VERSION    = A.A_SOURCE_VERSION    )
           AND ( EXPLAIN_LEVEL     IS NULL OR
                 EXPLAIN_LEVEL     = A.A_EXPLAIN_LEVEL     )
           AND ( STMTNO            IS NULL OR
                 STMTNO            = A.A_STMTNO            )
           AND ( SECTNO            IS NULL OR
                 SECTNO            = A.A_SECTNO            );
--
-- Commit work
--
COMMIT WORK;

--
-- EXPLAIN_ACTUALS
--
CREATE TABLE EXPLAIN_ACTUALS ( EXPLAIN_REQUESTER VARCHAR(128 OCTETS) NOT NULL,
                                EXPLAIN_TIME      TIMESTAMP    NOT NULL,
                                SOURCE_NAME       VARCHAR(128 OCTETS) NOT NULL,
                                SOURCE_SCHEMA     VARCHAR(128 OCTETS) NOT NULL,
                                SOURCE_VERSION    VARCHAR(64 OCTETS)  NOT NULL,
                                EXPLAIN_LEVEL     CHAR(1 OCTETS)      NOT NULL,
                                STMTNO            INTEGER      NOT NULL,
                                SECTNO            INTEGER      NOT NULL,
                                OPERATOR_ID       INTEGER      NOT NULL,
                                DBPARTITIONNUM    INTEGER      NOT NULL,
                                PREDICATE_ID      INTEGER,
                                HOW_APPLIED       CHAR(10 OCTETS),
                                ACTUAL_TYPE       VARCHAR(12 OCTETS)  NOT NULL,
                                ACTUAL_VALUE      DOUBLE,
                                   FOREIGN KEY (EXPLAIN_REQUESTER,
                                                EXPLAIN_TIME,
                                                SOURCE_NAME,
                                                SOURCE_SCHEMA,
                                                SOURCE_VERSION,
                                                EXPLAIN_LEVEL,
                                                STMTNO,
                                                SECTNO,
                                                OPERATOR_ID)
                                   REFERENCES EXPLAIN_OPERATOR
                                   ON DELETE CASCADE)
                             ORGANIZE BY ROW;
--
-- Commit work
--
COMMIT WORK;
