--liquibase formatted sql

--changeset author:sitmun dbms:h2

CREATE TABLE STM_GTER_TYP (
    GTT_ID          NUMBER(11)      NOT NULL,
    GTT_NAME        VARCHAR2(250)   NOT NULL
);
ALTER TABLE STM_GTER_TYP ADD CONSTRAINT STM_GTT_PK PRIMARY KEY (GTT_ID);
ALTER TABLE STM_GTER_TYP ADD CONSTRAINT STM_GTT_NAME_UK UNIQUE (GTT_NAME);

CREATE TABLE STM_TER_TYP (
    TET_ID          NUMBER(11)      NOT NULL,
    TET_NAME        VARCHAR2(250)   NOT NULL
);
ALTER TABLE STM_TER_TYP ADD CONSTRAINT STM_TET_PK PRIMARY KEY (TET_ID);
ALTER TABLE STM_TER_TYP ADD CONSTRAINT STM_TET_NAME_UK UNIQUE (TET_NAME);

CREATE TABLE STM_TERRITORY (
    TER_ID          NUMBER(11)      NOT NULL,
    TER_CODMUN      VARCHAR2(10)    NOT NULL,
    TER_NAME        VARCHAR2(250)   NOT NULL,
    TER_ADMNAME     VARCHAR2(250),
    TER_ADDRESS     VARCHAR2(250),
    TER_EMAIL       VARCHAR2(250),
    TER_SCOPE       VARCHAR2(250),
    TER_LOGO        VARCHAR2(250),
    TER_EXTENT      VARCHAR2(250),
    TER_BLOCKED     BOOLEAN          NOT NULL,
    TER_TYPID       NUMBER(11),
    TER_NOTE        VARCHAR2(250),
    TER_CREATED     TIMESTAMP(6),
    TER_GTYPID      NUMBER(11)
);
ALTER TABLE STM_TERRITORY ADD CONSTRAINT STM_TER_PK PRIMARY KEY (TER_ID);
ALTER TABLE STM_TERRITORY ADD CONSTRAINT STM_TER_NAME_UK UNIQUE (TER_NAME);

CREATE TABLE STM_GRP_TER (
    GTE_TERID       NUMBER(11)      NOT NULL,
    GTE_TERMID      NUMBER(11)      NOT NULL
);
ALTER TABLE STM_GRP_TER ADD CONSTRAINT STM_GTE_PK PRIMARY KEY (GTE_TERID,GTE_TERMID);

CREATE TABLE STM_ROLE (
    ROL_ID          NUMBER(11)       NOT NULL,
    ROL_NAME        VARCHAR2(250)    NOT NULL,
    ROL_NOTE        VARCHAR2(500)
);
ALTER TABLE STM_ROLE ADD CONSTRAINT STM_ROL_PK PRIMARY KEY (ROL_ID);
ALTER TABLE STM_ROLE ADD CONSTRAINT STM_ROL_NAME_UK UNIQUE (ROL_NAME);

CREATE TABLE STM_USER (
    USE_ID          NUMBER(11)      NOT NULL,
    USE_USER        VARCHAR2(30),
    USE_PWD         VARCHAR2(128),
    USE_NAME        VARCHAR2(30),
    USE_SURNAME     VARCHAR2(40),
    USE_IDENT       VARCHAR2(20),
    USE_IDENTTYPE   VARCHAR2(3),
    USE_ADM         BOOLEAN         NOT NULL,
    USE_BLOCKED     BOOLEAN         NOT NULL,
    USE_GENERIC     BOOLEAN
);
ALTER TABLE STM_USER ADD CONSTRAINT STM_USE_PK PRIMARY KEY (USE_ID);
ALTER TABLE STM_USER ADD CONSTRAINT STM_USE_NAME_UK UNIQUE (USE_USER);

CREATE TABLE STM_USR_CONF (
    UCO_ID          NUMBER(11)      NOT NULL,
    UCO_USERID      NUMBER(11)      NOT NULL,
    UCO_TERID       NUMBER(11)      NOT NULL,
    UCO_ROLEID      NUMBER(11)      NOT NULL,
    UCO_ROLEMID     NUMBER(11)
);
ALTER TABLE STM_USR_CONF ADD CONSTRAINT STM_UCO_PK PRIMARY KEY (UCO_ID);
ALTER TABLE STM_USR_CONF ADD CONSTRAINT STM_UCO_UK UNIQUE (UCO_USERID,UCO_TERID,UCO_ROLEID,UCO_ROLEMID);

CREATE TABLE STM_AVAIL_TSK (
    ATS_ID          NUMBER(11)      NOT NULL,
    ATS_CREATED     TIMESTAMP(6),
    ATS_TERID       NUMBER(11)      NOT NULL,
    ATS_TASKID      NUMBER(11)      NOT NULL
);
ALTER TABLE STM_AVAIL_TSK ADD CONSTRAINT STM_ATS_PK PRIMARY KEY (ATS_ID);
ALTER TABLE STM_AVAIL_TSK ADD CONSTRAINT STM_ATS_UK UNIQUE (ATS_TERID,ATS_TASKID);

CREATE TABLE STM_AVAIL_GI (
    AGI_ID          NUMBER(11)      NOT NULL,
    AGI_CREATED     TIMESTAMP(6),
    AGI_PROPRIETA   VARCHAR2(50),
    AGI_TERID       NUMBER(11)      NOT NULL,
    AGI_GIID        NUMBER(11)      NOT NULL
);
ALTER TABLE STM_AVAIL_GI ADD CONSTRAINT STM_AGI_PK PRIMARY KEY (AGI_ID);
ALTER TABLE STM_AVAIL_GI ADD CONSTRAINT STM_AGI_UK UNIQUE (AGI_TERID,AGI_GIID);

CREATE TABLE STM_GEOINFO (
    GEO_ID          NUMBER(11)      NOT NULL,
    GEO_NAME        VARCHAR2(100)   NOT NULL,
    GEO_ABSTRACT    VARCHAR2(250),    
    GEO_LAYERS      VARCHAR2(800)   NOT NULL,
    GEO_MINSCALE    NUMBER(11),
    GEO_MAXSCALE    NUMBER(11),
    GEO_ORDER       NUMBER(6),
    GEO_TRANSP      NUMBER(6),
    GEO_FILTER_GM   BOOLEAN         NOT NULL,
    GEO_QUERYABL    BOOLEAN,
    GEO_QUERYACT    BOOLEAN,
    GEO_QUERYLAY    VARCHAR2(500),    
    GEO_FILTER_GFI  BOOLEAN         NOT NULL,
    GEO_TYPE        VARCHAR2(30),
    GEO_SERID       NUMBER(11)      NOT NULL,
    GEO_SELECTABL   BOOLEAN,
    GEO_SELECTLAY   VARCHAR2(500),
    GEO_FILTER_SE   BOOLEAN         NOT NULL,
    GEO_SERSELID    NUMBER(11),    
    GEO_LEGENDTIP   VARCHAR2(50)    CHECK ("GEO_LEGENDTIP" IN ('LINK','LEGENDGRAPHIC','CAPABILITIES')),
    GEO_LEGENDURL   VARCHAR2(250),
    GEO_CREATED     TIMESTAMP(6),
    GEO_EDITABLE    BOOLEAN,
    GEO_CONNID      NUMBER(11),
    GEO_METAURL     VARCHAR2(250),
    GEO_DATAURL     VARCHAR2(4000),
    GEO_THEMATIC    BOOLEAN,
    GEO_GEOMTYPE    VARCHAR2(50)    CHECK ("GEO_GEOMTYPE" IN ('POINT','LINE','POLYGON')),
    GEO_SOURCE      VARCHAR2(80),
    GEO_STYID       INTEGER
);
ALTER TABLE STM_GEOINFO ADD CONSTRAINT STM_GEO_PK PRIMARY KEY (GEO_ID);

CREATE TABLE STM_FIL_GI (
    FGI_ID          INTEGER         NOT NULL,
    FGI_NAME        VARCHAR2(80)    NOT NULL,
    FGI_REQUIRED    BOOLEAN         NOT NULL,
    FGI_TYPE        VARCHAR2(1)     NOT NULL CHECK ("FGI_TYPE" IN ('D','C')),
    FGI_TYPID       NUMBER(11),
    FGI_COLUMN      VARCHAR2(250),
    FGI_VALUE       VARCHAR2(4000),
    FGI_VALUETYPE   VARCHAR2(30)    CHECK ("FGI_VALUETYPE" IN ('A','D','N')),
    FGI_GIID        NUMBER(11)      NOT NULL
);
ALTER TABLE STM_FIL_GI ADD CONSTRAINT STM_FGI_PK PRIMARY KEY (FGI_ID);

CREATE TABLE STM_STY_GI (
    SGI_ID          INTEGER         NOT NULL,
    SGI_NAME        VARCHAR2(80)    NOT NULL,
    SGI_TITLE       VARCHAR2(250),
    SGI_ABSTRACT    VARCHAR2(250),
    SGI_LURL_WIDTH  INTEGER,
    SGI_LURL_HEIGHT INTEGER,
    SGI_LURL_FORMAT VARCHAR2(80),
    SGI_LURL_URL    VARCHAR2(250),
    SGI_GIID        NUMBER(11)      NOT NULL
);
ALTER TABLE STM_STY_GI ADD CONSTRAINT STM_SGI_PK PRIMARY KEY (SGI_ID);

CREATE TABLE STM_PAR_GI (
    PGI_ID          INTEGER         NOT NULL,
    PGI_NAME        VARCHAR2(250)   NOT NULL,
    PGI_VALUE       VARCHAR2(250)   NOT NULL,
    PGI_FORMAT      VARCHAR2(250),
    PGI_TYPE        VARCHAR2(250)   NOT NULL,
    PGI_GIID        NUMBER(11)      NOT NULL,
    PGI_ORDER       INTEGER
);
ALTER TABLE STM_PAR_GI ADD CONSTRAINT STM_PGI_PK PRIMARY KEY (PGI_ID);

CREATE TABLE STM_ROL_GGI (
    RGG_ROLEID      NUMBER(11)      NOT NULL,
    RGG_GGIID       NUMBER(11)      NOT NULL
);
ALTER TABLE STM_ROL_GGI ADD CONSTRAINT STM_RGG_PK PRIMARY KEY (RGG_ROLEID,RGG_GGIID);

CREATE TABLE STM_GRP_GI (
    GGI_ID          NUMBER(11)      NOT NULL,
    GGI_NAME        VARCHAR2(80)    NOT NULL,
    GGI_TYPE        VARCHAR2(30)
);
ALTER TABLE STM_GRP_GI ADD CONSTRAINT STM_GGI_PK PRIMARY KEY (GGI_ID);

CREATE TABLE STM_GGI_GI (
    GGG_GGIID       NUMBER(11)      NOT NULL,
    GGG_GIID        NUMBER(11)      NOT NULL
);
ALTER TABLE STM_GGI_GI ADD CONSTRAINT STM_GGG_PK PRIMARY KEY (GGG_GGIID,GGG_GIID);

CREATE TABLE STM_APP (
    APP_ID          NUMBER(11)      NOT NULL,
    APP_NAME        VARCHAR2(80)    NOT NULL,
    APP_TYPE        VARCHAR2(250),
    APP_TITLE       VARCHAR2(250),
    APP_THEME       VARCHAR2(30),
    APP_SCALES      VARCHAR2(250),
    APP_PROJECT     VARCHAR2(250),
    APP_TEMPLATE    VARCHAR2(250)   NOT NULL,
    APP_REFRESH     BOOLEAN,
    APP_ENTRYS      BOOLEAN,
    APP_ENTRYM      BOOLEAN,
    APP_GGIID       NUMBER(11),
    APP_CREATED     TIMESTAMP(6)
);
ALTER TABLE STM_APP ADD CONSTRAINT STM_APP_PK PRIMARY KEY (APP_ID);

CREATE TABLE STM_BACKGRD (
    BAC_ID          NUMBER(11)      NOT NULL,
    BAC_NAME        VARCHAR2(30)    NOT NULL,
    BAC_DESC        VARCHAR2(250),
    BAC_ACTIVE      BOOLEAN,
    BAC_GGIID       NUMBER(11),
    BAC_CREATED     TIMESTAMP(6)
);
ALTER TABLE STM_BACKGRD ADD CONSTRAINT STM_BAC_PK PRIMARY KEY (BAC_ID);

CREATE TABLE STM_APP_BCKG (
    ABC_ID          NUMBER(11)      NOT NULL,
    ABC_APPID       NUMBER(11)      NOT NULL,
    ABC_BACKID      NUMBER(11)      NOT NULL,
    ABC_ORDER       NUMBER(6)
);
ALTER TABLE STM_APP_BCKG ADD CONSTRAINT STM_ABC_PK PRIMARY KEY (ABC_ID);
ALTER TABLE STM_APP_BCKG ADD CONSTRAINT STM_ABC_UK UNIQUE (ABC_APPID,ABC_BACKID);

CREATE TABLE STM_APP_TREE (
    ATR_APPID       NUMBER(11)      NOT NULL,
    ATR_TREEID      NUMBER(11)      NOT NULL
);
ALTER TABLE STM_APP_TREE ADD CONSTRAINT STM_ATR_PK PRIMARY KEY (ATR_APPID,ATR_TREEID);

CREATE TABLE STM_APP_ROL (
    ARO_APPID       NUMBER(11)      NOT NULL,
    ARO_ROLEID      NUMBER(11)      NOT NULL
);
ALTER TABLE STM_APP_ROL ADD CONSTRAINT STM_ARO_PK PRIMARY KEY (ARO_APPID,ARO_ROLEID);

CREATE TABLE STM_PAR_APP (
    PAP_ID          NUMBER(11)      NOT NULL,
    PAP_NAME        VARCHAR2(30)    NOT NULL,
    PAP_VALUE       VARCHAR2(250)   NOT NULL,
    PAP_TYPE        VARCHAR2(250)   NOT NULL,
    PAP_APPID       NUMBER(11)      NOT NULL
);
ALTER TABLE STM_PAR_APP ADD CONSTRAINT STM_PAP_PK PRIMARY KEY (PAP_ID);

CREATE TABLE STM_TREE (
    TRE_ID          NUMBER(11)      NOT NULL,
    TRE_NAME        VARCHAR2(100)   NOT NULL,
    TRE_USERID      NUMBER(11)
);
ALTER TABLE STM_TREE ADD CONSTRAINT STM_TRE_PK PRIMARY KEY (TRE_ID);

CREATE TABLE STM_TREE_NOD (
    TNO_ID          NUMBER(11)      NOT NULL,
    TNO_PARENTID    NUMBER(11),
    TNO_NAME        VARCHAR2(80)    NOT NULL,
    TNO_ABSTRACT    VARCHAR2(250),
    TNO_TOOLTIP     VARCHAR2(100),
    TNO_ACTIVE      BOOLEAN,
    TNO_RADIO       BOOLEAN,
    TNO_ORDER       NUMBER(6),
    TNO_METAURL     VARCHAR2(2000),
    TNO_DATAURL     VARCHAR2(2000),
    TNO_FILTER_GM   BOOLEAN,
    TNO_FILTER_GFI  BOOLEAN,
    TNO_QUERYACT    BOOLEAN,
    TNO_FILTER_SE   BOOLEAN,
    TNO_TREEID      NUMBER(11)      NOT NULL,
    TNO_GIID        NUMBER(11)
);
ALTER TABLE STM_TREE_NOD ADD CONSTRAINT STM_TNO_PK PRIMARY KEY (TNO_ID);

CREATE TABLE STM_TREE_ROL (
    TRO_TREEID      NUMBER(11)      NOT NULL,
    TRO_ROLEID      NUMBER(11)      NOT NULL
);
ALTER TABLE STM_TREE_ROL ADD CONSTRAINT STM_TRO_PK PRIMARY KEY (TRO_TREEID,TRO_ROLEID);

CREATE TABLE STM_SERVICE (
    SER_ID          NUMBER(11)      NOT NULL,
    SER_NAME        VARCHAR2(60)    NOT NULL,
    SER_ABSTRACT    VARCHAR2(250),
    SER_URL         VARCHAR2(250)   NOT NULL,
    SER_PROJECTS    VARCHAR2(250),
    SER_LEGEND      VARCHAR2(250),
    SER_INFOURL     VARCHAR2(250),
    SER_CREATED     TIMESTAMP(6),
    SER_PROTOCOL    VARCHAR2(30)    NOT NULL,
    SER_NAT_PROT    VARCHAR2(10),
    SER_CONNID      NUMBER(11)
);
ALTER TABLE STM_SERVICE ADD CONSTRAINT STM_SER_PK PRIMARY KEY (SER_ID);

CREATE TABLE STM_PAR_SER (
    PSE_ID          NUMBER(11)      NOT NULL,
    PSE_SERID       NUMBER(11)      NOT NULL,
    PSE_TYPE        VARCHAR2(250)   NOT NULL,
    PSE_NAME        VARCHAR2(30)    NOT NULL,
    PSE_VALUE       VARCHAR2(250)
);
ALTER TABLE STM_PAR_SER ADD CONSTRAINT STM_PSE_PK PRIMARY KEY (PSE_ID);

CREATE TABLE STM_CONNECT (
    CON_ID          NUMBER(11)      NOT NULL,
    CON_NAME        VARCHAR2(80)    NOT NULL,
    CON_DRIVER      VARCHAR2(50)    NOT NULL,
    CON_USER        VARCHAR2(50),
    CON_PWD         VARCHAR2(50),
    CON_CONNECTION  VARCHAR2(250)
);
ALTER TABLE STM_CONNECT ADD CONSTRAINT STM_CON_PK PRIMARY KEY (CON_ID);

CREATE TABLE STM_TASK (
    TAS_ID          NUMBER(11)      NOT NULL,
    TAS_PARENTID    NUMBER(11),
    TAS_NAME        VARCHAR2(512)   NOT NULL,
    TAS_CREATED     TIMESTAMP(6),
    TAS_ORDER       NUMBER(6),
    TAS_GIID        NUMBER(11),
    TAS_SERID       NUMBER(11),
    TAS_GTASKID     NUMBER(11),
    TAS_TTASKID     NUMBER(11),
    TAS_TUIID       NUMBER(11),
    TAS_CONNID      NUMBER(11)
);
ALTER TABLE STM_TASK ADD CONSTRAINT STM_TAS_PK PRIMARY KEY (TAS_ID);

CREATE TABLE STM_GRP_TSK (
    GTS_ID          NUMBER(11)      NOT NULL,
    GTS_NAME        VARCHAR2(80)    NOT NULL
);
ALTER TABLE STM_GRP_TSK ADD CONSTRAINT STM_GTS_PK PRIMARY KEY (GTS_ID);

CREATE TABLE STM_TSK_TYP (
    TTY_ID          NUMBER(11)      NOT NULL,
    TTY_NAME        VARCHAR2(30)    NOT NULL
);
ALTER TABLE STM_TSK_TYP ADD CONSTRAINT STM_TTY_PK PRIMARY KEY (TTY_ID);

CREATE TABLE STM_PAR_TSK (
    PTT_ID          NUMBER(11)      NOT NULL,
    PTT_NAME        VARCHAR2(50)    NOT NULL,
    PTT_VALUE       VARCHAR2(4000),
    PTT_TYPE        VARCHAR2(30),
    PTT_ORDER       NUMBER(6),
    PTT_FORMAT      VARCHAR2(250),
    PTT_HELP        VARCHAR2(250),
    PTT_SELECT      VARCHAR2(1500),
    PTT_SELECTABL   BOOLEAN,
    PTT_EDITABLE    BOOLEAN,
    PTT_REQUIRED    BOOLEAN,
    PTT_DEFAULT     VARCHAR2(250),
    PTT_MAXLEN      INTEGER,
    PTT_VALUEREL    VARCHAR2(512),
    PTT_FILTERREL   VARCHAR2(512),
    PTT_TASKID      NUMBER(11)      NOT NULL
);
ALTER TABLE STM_PAR_TSK ADD CONSTRAINT STM_PTT_PK PRIMARY KEY (PTT_ID);

CREATE TABLE STM_TSK_UI (
    TUI_ID          NUMBER(11)      NOT NULL,
    TUI_NAME        VARCHAR2(30)    NOT NULL,
    TUI_TOOLTIP     VARCHAR2(100),
    TUI_ORDER       NUMBER(6),
    TUI_TYPE        VARCHAR2(30)
);
ALTER TABLE STM_TSK_UI ADD CONSTRAINT STM_TUI_PK PRIMARY KEY (TUI_ID);

CREATE TABLE STM_ROL_TSK (
    RTS_ROLEID      NUMBER(11)      NOT NULL,
    RTS_TASKID      NUMBER(11)      NOT NULL
);
ALTER TABLE STM_ROL_TSK ADD CONSTRAINT STM_RTS_PK PRIMARY KEY (RTS_ROLEID,RTS_TASKID);

CREATE TABLE STM_COMMENT (
    COM_ID          INTEGER         NOT NULL,
    COM_COORD_X     DOUBLE          NOT NULL,
    COM_COORD_Y     DOUBLE          NOT NULL,
    COM_NAME        VARCHAR2(250),
    COM_EMAIL       VARCHAR2(250),
    COM_TITLE       VARCHAR2(500),
    COM_DESC        VARCHAR2(1000),
    COM_CREATED     TIMESTAMP(6),
    COM_USERID      NUMBER(11),
    COM_APPID       NUMBER(11)
);
ALTER TABLE STM_COMMENT ADD CONSTRAINT STM_COM_PK PRIMARY KEY (COM_ID);

CREATE TABLE STM_LOG (
    LOG_ID          NUMBER(11)      NOT NULL,
    LOG_DATE        TIMESTAMP(6),
    LOG_TYPE        VARCHAR2(50),
    LOG_USERID      NUMBER(11),
    LOG_APPID       NUMBER(11),
    LOG_TERID       NUMBER(11),
    LOG_TASKID      NUMBER(11),
    LOG_COUNT       NUMBER(11),
    LOG_TER         VARCHAR2(250),
    LOG_TEREXT      VARCHAR2(250),
    LOG_DATA        VARCHAR2(250),
    LOG_SRS         VARCHAR2(250),
    LOG_FORMAT      VARCHAR2(250),
    LOG_BUFFER      BOOLEAN,
    LOG_EMAIL       VARCHAR2(250),
    LOG_OTHER       VARCHAR2(4000),
    LOG_GIID        NUMBER(11)
);
ALTER TABLE STM_LOG ADD CONSTRAINT STM_LOG_PK PRIMARY KEY (LOG_ID);

CREATE TABLE STM_DOWNLOAD (
    DOW_ID          NUMBER(11)      NOT NULL,
    DOW_EXT         VARCHAR2(5)     NOT NULL,
    DOW_TYPE        VARCHAR2(1)     DEFAULT 'U' NOT NULL,
    DOW_PATH        VARCHAR2(300)
);
ALTER TABLE STM_DOWNLOAD ADD CONSTRAINT STM_DOW_PK PRIMARY KEY (DOW_ID);

CREATE TABLE STM_QUERY (
    QUE_ID          NUMBER(11)      NOT NULL,
    QUE_COMMAND     VARCHAR2(4000),
    QUE_TYPE        VARCHAR2(250)   CHECK ("QUE_TYPE" IN ('URL','SQL','WS','INFORME','TAREA')),
    QUE_DESC        VARCHAR2(250),
    QUE_TASKID      NUMBER(11)
);
ALTER TABLE STM_QUERY ADD CONSTRAINT STM_QUE_PK PRIMARY KEY (QUE_ID);

CREATE TABLE STM_POST (
    POS_ID          NUMBER(11)      NOT NULL,
    POS_POST        VARCHAR2(250),
    POS_ORG         VARCHAR2(250),
    POS_EMAIL       VARCHAR2(250),
    POS_CREATED     TIMESTAMP(6),
    POS_EXPIRATION  TIMESTAMP(6),
    POS_TYPE        VARCHAR2(2),
    POS_USERID      NUMBER(11)      NOT NULL,
    POS_TERID       NUMBER(11)      NOT NULL
);
ALTER TABLE STM_POST ADD CONSTRAINT STM_POS_PK PRIMARY KEY (POS_ID);
ALTER TABLE STM_POST ADD CONSTRAINT STM_POS_UK UNIQUE (POS_USERID,POS_TERID);

CREATE TABLE STM_THEMATIC (
    THE_ID          INTEGER         NOT NULL,
    THE_NAME        VARCHAR2(250),
    THE_DESC        VARCHAR2(250),
    THE_RANKTYPE    VARCHAR2(30)    CHECK ("THE_RANKTYPE" IN ('VU','RE','RL')),
    THE_RANKNUM     INTEGER,
    THE_COLORMIN    VARCHAR2(30),
    THE_COLORMAX    VARCHAR2(30),
    THE_SIZEMIN     INTEGER,
    THE_SIZEMAX     INTEGER,
    THE_TRANSPARENCY INTEGER,
    THE_DATAREF     BOOLEAN,
    THE_RANKREC     BOOLEAN,
    THE_USERID      NUMBER(11),
    THE_GIID        NUMBER(11),
    THE_TASKID      NUMBER(11),
    THE_TAGGABLE    BOOLEAN,
    THE_VALUETYPE   VARCHAR2(30)    CHECK ("THE_VALUETYPE" IN ('STR','DOU')),
    THE_URLWS       VARCHAR2(250),
    THE_DESTINATION VARCHAR2(30),
    THE_EXPIRATION  TIMESTAMP(6)
);
ALTER TABLE STM_THEMATIC ADD CONSTRAINT STM_THE_PK PRIMARY KEY (THE_ID);

CREATE TABLE STM_THE_RANK (
    TRK_THEID       INTEGER         NOT NULL,
    TRK_POSITION    INTEGER         NOT NULL,
    TRK_NAME        VARCHAR2(30),
    TRK_VALUENUL    BOOLEAN,
    TRK_VALUE       VARCHAR2(30),
    TRK_VALUEMIN    NUMBER(19,11),
    TRK_VALUEMAX    NUMBER(19,11),
    TRK_STYLEINT    VARCHAR2(30),
    TRK_COLORINT    VARCHAR2(30),
    TRK_STYLE       VARCHAR2(30),
    TRK_COLOR       VARCHAR2(30),
    TRK_SIZE        INTEGER,
    TRK_DESC        VARCHAR2(250)
);
ALTER TABLE STM_THE_RANK ADD CONSTRAINT STM_TRK_PK PRIMARY KEY (TRK_THEID, TRK_POSITION);

CREATE TABLE STM_LANGUAGE (
    LAN_ID          INTEGER         NOT NULL,
    LAN_SHORTNAME   VARCHAR2(3)     NOT NULL,
    LAN_NAME        VARCHAR2(80)    NOT NULL
);
ALTER TABLE STM_LANGUAGE ADD CONSTRAINT STM_LAN_PK PRIMARY KEY (LAN_ID);
ALTER TABLE STM_LANGUAGE ADD CONSTRAINT STM_LAN_UK UNIQUE (LAN_SHORTNAME);

CREATE TABLE STM_TRANSLATION (
    TRA_ID          INTEGER         NOT NULL,
    TRA_ELEID       INTEGER         NOT NULL,
    TRA_COLUMN      VARCHAR2(30)    NOT NULL,
    TRA_LANID       INTEGER         NOT NULL,
    TRA_NAME        VARCHAR2(250)   NOT NULL
);
ALTER TABLE STM_TRANSLATION ADD CONSTRAINT STM_TRA_PK PRIMARY KEY (TRA_ID);
ALTER TABLE STM_TRANSLATION ADD CONSTRAINT STM_TRA_UK UNIQUE (TRA_ELEID,TRA_COLUMN,TRA_LANID);

CREATE TABLE STM_CODELIST(
    COD_ID          INTEGER         NOT NULL,
    COD_LIST        VARCHAR2(250)   NOT NULL,
    COD_VALUE       VARCHAR2(250)   NOT NULL,
    COD_DESCRIPTION VARCHAR2(250)
);
ALTER TABLE STM_CODELIST ADD CONSTRAINT STM_COD_PK PRIMARY KEY (COD_ID);
ALTER TABLE STM_CODELIST ADD CONSTRAINT STM_COD_UK UNIQUE (COD_LIST,COD_VALUE);

CREATE TABLE STM_SEQUENCE(
    SEQ_NAME        VARCHAR(50)     NOT NULL,
    SEQ_COUNT       BIGINT
);
ALTER TABLE STM_SEQUENCE ADD CONSTRAINT STM_SEQ_PK PRIMARY KEY (SEQ_NAME);


ALTER TABLE STM_TREE ADD CONSTRAINT STM_TRE_FK_USE FOREIGN KEY (TRE_USERID) REFERENCES STM_USER (USE_ID);

ALTER TABLE STM_USR_CONF ADD CONSTRAINT STM_UCO_FK_USE FOREIGN KEY (UCO_USERID) REFERENCES STM_USER (USE_ID);
ALTER TABLE STM_USR_CONF ADD CONSTRAINT STM_UCO_FK_TER FOREIGN KEY (UCO_TERID) REFERENCES STM_TERRITORY (TER_ID);
ALTER TABLE STM_USR_CONF ADD CONSTRAINT STM_UCO_FK_ROL FOREIGN KEY (UCO_ROLEID) REFERENCES STM_ROLE (ROL_ID);
ALTER TABLE STM_USR_CONF ADD CONSTRAINT STM_UCO_FK_ROLM FOREIGN KEY (UCO_ROLEMID) REFERENCES STM_ROLE (ROL_ID);

ALTER TABLE STM_AVAIL_TSK ADD CONSTRAINT STM_ATS_FK_TER FOREIGN KEY (ATS_TERID) REFERENCES STM_TERRITORY (TER_ID);
ALTER TABLE STM_AVAIL_TSK ADD CONSTRAINT STM_ATS_FK_TAS FOREIGN KEY (ATS_TASKID) REFERENCES STM_TASK (TAS_ID);

ALTER TABLE STM_AVAIL_GI ADD CONSTRAINT STM_AGI_FK_TER FOREIGN KEY (AGI_TERID) REFERENCES STM_TERRITORY (TER_ID);
ALTER TABLE STM_AVAIL_GI ADD CONSTRAINT STM_AGI_FK_GEO FOREIGN KEY (AGI_GIID) REFERENCES STM_GEOINFO (GEO_ID);

ALTER TABLE STM_TREE_NOD ADD CONSTRAINT STM_TNO_FK_TNO FOREIGN KEY (TNO_PARENTID) REFERENCES STM_TREE_NOD (TNO_ID);
ALTER TABLE STM_TREE_NOD ADD CONSTRAINT STM_TNO_FK_GEO FOREIGN KEY (TNO_GIID) REFERENCES STM_GEOINFO (GEO_ID);
ALTER TABLE STM_TREE_NOD ADD CONSTRAINT STM_TNO_FK_TRE FOREIGN KEY (TNO_TREEID) REFERENCES STM_TREE (TRE_ID);

ALTER TABLE STM_PAR_SER ADD CONSTRAINT STM_PSE_FK_SER FOREIGN KEY (PSE_SERID) REFERENCES STM_SERVICE (SER_ID);

ALTER TABLE STM_TREE_ROL ADD CONSTRAINT STM_TRO_FK_TRE FOREIGN KEY (TRO_TREEID) REFERENCES STM_TREE (TRE_ID);
ALTER TABLE STM_TREE_ROL ADD CONSTRAINT STM_TRO_FK_ROL FOREIGN KEY (TRO_ROLEID) REFERENCES STM_ROLE (ROL_ID);

ALTER TABLE STM_TASK ADD CONSTRAINT STM_TAS_FK_GEO FOREIGN KEY (TAS_GIID) REFERENCES STM_GEOINFO (GEO_ID);
ALTER TABLE STM_TASK ADD CONSTRAINT STM_TAS_FK_SER FOREIGN KEY (TAS_SERID) REFERENCES STM_SERVICE (SER_ID);
ALTER TABLE STM_TASK ADD CONSTRAINT STM_TAS_FK_GTS FOREIGN KEY (TAS_GTASKID) REFERENCES STM_GRP_TSK (GTS_ID);
ALTER TABLE STM_TASK ADD CONSTRAINT STM_TAS_FK_TTY FOREIGN KEY (TAS_TTASKID) REFERENCES STM_TSK_TYP (TTY_ID);
ALTER TABLE STM_TASK ADD CONSTRAINT STM_TAS_FK_TUI FOREIGN KEY (TAS_TUIID) REFERENCES STM_TSK_UI (TUI_ID);
ALTER TABLE STM_TASK ADD CONSTRAINT STM_TAS_FK_CON FOREIGN KEY (TAS_CONNID) REFERENCES STM_CONNECT (CON_ID);
ALTER TABLE STM_TASK ADD CONSTRAINT STM_TAS_FK_TAS FOREIGN KEY (TAS_PARENTID) REFERENCES STM_TASK (TAS_ID);

ALTER TABLE STM_DOWNLOAD ADD CONSTRAINT STM_DOW_FK_TAS FOREIGN KEY (DOW_ID) REFERENCES STM_TASK (TAS_ID);

ALTER TABLE STM_QUERY ADD CONSTRAINT STM_QUE_FK_TAS FOREIGN KEY (QUE_ID) REFERENCES STM_TASK (TAS_ID);
ALTER TABLE STM_QUERY ADD CONSTRAINT STM_QUE_FK_TASM FOREIGN KEY (QUE_TASKID) REFERENCES STM_TASK (TAS_ID);

ALTER TABLE STM_GEOINFO ADD CONSTRAINT STM_GEO_FK_SER FOREIGN KEY (GEO_SERID) REFERENCES STM_SERVICE (SER_ID);
ALTER TABLE STM_GEOINFO ADD CONSTRAINT STM_GEO_FK_SERSEL FOREIGN KEY (GEO_SERSELID) REFERENCES STM_SERVICE (SER_ID);
ALTER TABLE STM_GEOINFO ADD CONSTRAINT STM_GEO_FK_CON FOREIGN KEY (GEO_CONNID) REFERENCES STM_CONNECT (CON_ID);
ALTER TABLE STM_GEOINFO ADD CONSTRAINT STM_GEO_FK_SGI FOREIGN KEY (GEO_STYID) REFERENCES STM_STY_GI (SGI_ID);

ALTER TABLE STM_PAR_GI ADD CONSTRAINT STM_PGI_FK_GEO FOREIGN KEY (PGI_GIID) REFERENCES STM_GEOINFO (GEO_ID);

ALTER TABLE STM_ROL_GGI ADD CONSTRAINT STM_RGG_FK_ROL FOREIGN KEY (RGG_ROLEID) REFERENCES STM_ROLE (ROL_ID);
ALTER TABLE STM_ROL_GGI ADD CONSTRAINT STM_RGG_FK_GGI FOREIGN KEY (RGG_GGIID) REFERENCES STM_GRP_GI (GGI_ID);

ALTER TABLE STM_APP ADD CONSTRAINT STM_APP_FK_GGI FOREIGN KEY (APP_GGIID) REFERENCES STM_GRP_GI (GGI_ID);

ALTER TABLE STM_PAR_APP ADD CONSTRAINT STM_PAP_FK_APP FOREIGN KEY (PAP_APPID) REFERENCES STM_APP (APP_ID);

ALTER TABLE STM_BACKGRD ADD CONSTRAINT STM_BAC_FK_GGI FOREIGN KEY (BAC_GGIID) REFERENCES STM_GRP_GI (GGI_ID);

ALTER TABLE STM_APP_BCKG ADD CONSTRAINT STM_ABC_FK_APP FOREIGN KEY (ABC_APPID) REFERENCES STM_APP (APP_ID);
ALTER TABLE STM_APP_BCKG ADD CONSTRAINT STM_ABC_FK_FON FOREIGN KEY (ABC_BACKID) REFERENCES STM_BACKGRD (BAC_ID);

ALTER TABLE STM_APP_TREE ADD CONSTRAINT STM_ATR_FK_APP FOREIGN KEY (ATR_APPID) REFERENCES STM_APP (APP_ID);
ALTER TABLE STM_APP_TREE ADD CONSTRAINT STM_ATR_FK_TRE FOREIGN KEY (ATR_TREEID) REFERENCES STM_TREE (TRE_ID);

ALTER TABLE STM_APP_ROL ADD CONSTRAINT STM_ARO_FK_APP FOREIGN KEY (ARO_APPID) REFERENCES STM_APP (APP_ID);
ALTER TABLE STM_APP_ROL ADD CONSTRAINT STM_ARO_FK_ROL FOREIGN KEY (ARO_ROLEID) REFERENCES STM_ROLE (ROL_ID);

ALTER TABLE STM_PAR_TSK ADD CONSTRAINT STM_PTT_FK_TAS FOREIGN KEY (PTT_TASKID) REFERENCES STM_TASK (TAS_ID);

ALTER TABLE STM_ROL_TSK ADD CONSTRAINT STM_RTS_FK_ROL FOREIGN KEY (RTS_ROLEID) REFERENCES STM_ROLE (ROL_ID);
ALTER TABLE STM_ROL_TSK ADD CONSTRAINT STM_RTS_FK_TAS FOREIGN KEY (RTS_TASKID) REFERENCES STM_TASK (TAS_ID);

ALTER TABLE STM_FIL_GI ADD CONSTRAINT STM_FGI_FK_GEO FOREIGN KEY (FGI_GIID) REFERENCES STM_GEOINFO (GEO_ID);
ALTER TABLE STM_FIL_GI ADD CONSTRAINT STM_FGI_FK_TET FOREIGN KEY (FGI_TYPID) REFERENCES STM_TER_TYP (TET_ID);

ALTER TABLE STM_STY_GI ADD CONSTRAINT STM_SGI_FK_GEO FOREIGN KEY (SGI_GIID) REFERENCES STM_GEOINFO (GEO_ID);

ALTER TABLE STM_GGI_GI ADD CONSTRAINT STM_GGG_FK_GGI FOREIGN KEY (GGG_GGIID) REFERENCES STM_GRP_GI (GGI_ID);
ALTER TABLE STM_GGI_GI ADD CONSTRAINT STM_GGG_FK_GEO FOREIGN KEY (GGG_GIID) REFERENCES STM_GEOINFO (GEO_ID);

ALTER TABLE STM_TERRITORY ADD CONSTRAINT STM_TER_FK_GTT FOREIGN KEY (TER_GTYPID) REFERENCES STM_GTER_TYP (GTT_ID);
ALTER TABLE STM_TERRITORY ADD CONSTRAINT STM_TER_FK_TET FOREIGN KEY (TER_TYPID) REFERENCES STM_TER_TYP (TET_ID);

ALTER TABLE STM_GRP_TER ADD CONSTRAINT STM_GTE_FK_TER FOREIGN KEY (GTE_TERID) REFERENCES STM_TERRITORY (TER_ID);
ALTER TABLE STM_GRP_TER ADD CONSTRAINT STM_GTE_FK_TERM FOREIGN KEY (GTE_TERMID) REFERENCES STM_TERRITORY (TER_ID);

ALTER TABLE STM_POST ADD CONSTRAINT STM_POS_FK_USE FOREIGN KEY (POS_USERID) REFERENCES STM_USER (USE_ID);
ALTER TABLE STM_POST ADD CONSTRAINT STM_POS_FK_TER FOREIGN KEY (POS_TERID) REFERENCES STM_TERRITORY (TER_ID);

ALTER TABLE STM_SERVICE ADD CONSTRAINT STM_SER_FK_CON FOREIGN KEY (SER_CONNID) REFERENCES STM_CONNECT (CON_ID);

ALTER TABLE STM_THEMATIC ADD CONSTRAINT STM_THE_FK_USE FOREIGN KEY (THE_USERID) REFERENCES STM_USER (USE_ID);
ALTER TABLE STM_THEMATIC ADD CONSTRAINT STM_THE_FK_GEO FOREIGN KEY (THE_GIID) REFERENCES STM_GEOINFO (GEO_ID);
ALTER TABLE STM_THEMATIC ADD CONSTRAINT STM_THE_FK_TAS FOREIGN KEY (THE_TASKID) REFERENCES STM_TASK (TAS_ID);

ALTER TABLE STM_THE_RANK ADD CONSTRAINT STM_TRK_FK_THE FOREIGN KEY (TRK_THEID) REFERENCES STM_THEMATIC (THE_ID);

ALTER TABLE STM_TRANSLATION ADD CONSTRAINT STM_TRA_FK_LAN FOREIGN KEY (TRA_LANID) REFERENCES STM_LANGUAGE (LAN_ID);