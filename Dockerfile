FROM oraclelinux:latest

MAINTAINER hshekhar <himanshu.shekhar.in@gmail.com>

ENV ORACLE_SID=RBMDB
ENV ORACLE_PDB=RBMPDB

# Environment variables required for this build (do NOT change)
ENV ORACLE_BASE=/opt/oracle \
    ORACLE_HOME=/opt/oracle/product/12.1.0.2/dbhome_1 \
    INSTALL_FILE="linuxamd64_12102_database_se2.zip" \
    INSTALL_RSP="db_inst.rsp" \
    CONFIG_RSP="dbca.rsp.tmpl" \
    PWD_FILE="setPassword.sh" \
    PERL_INSTALL_FILE="installPerl.sh" \
    RUN_FILE="runOracle.sh" \
    START_FILE="startDB.sh" \
    CREATE_DB_FILE="createDB.sh" \
    SETUP_LINUX="setupLinuxEnv.sh" \
    INSTALL_DB_BINARIES="installDBBinaries.sh" \
    RBM_DUMP_FILE="geneva_admin.dmp" \
    RBM_CUSTOM_SQL_FILE="geneva_permission.sql"

# Use second ENV so that variable get substituted
ENV INSTALL_DIR=$ORACLE_BASE/install \
    PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch/:/usr/sbin:$PATH \
    LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/lib \
    CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

COPY installers/perl-5.24.0.tar.gz installers/$INSTALL_FILE installers/$INSTALL_RSP scripts/$PERL_INSTALL_FILE scripts/$SETUP_LINUX scripts/$INSTALL_DB_BINARIES $INSTALL_DIR/
COPY scripts/$RUN_FILE scripts/$START_FILE scripts/$CREATE_DB_FILE installers/$CONFIG_RSP scripts/$PWD_FILE $ORACLE_BASE/

RUN chmod ug+x $INSTALL_DIR/$SETUP_LINUX && \
    sync && \
    $INSTALL_DIR/$SETUP_LINUX

USER oracle
RUN chmod ug+x $INSTALL_DIR/$INSTALL_DB_BINARIES && \ 
    $INSTALL_DIR/$INSTALL_DB_BINARIES SE2

USER root
RUN $ORACLE_BASE/oraInventory/orainstRoot.sh && \
    $ORACLE_HOME/root.sh 

#Cleanup all install files    
RUN rm -rf $INSTALL_DIR

USER oracle
WORKDIR /home/oracle

VOLUME ["$ORACLE_BASE/oradata"]
EXPOSE 1521 5500
    
# Define default command to start Oracle Database. 
CMD $ORACLE_BASE/$RUN_FILE