#Pre-Requisite

##1. REQUIRED FILES TO BUILD THIS IMAGE
Download below files from http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html
linuxamd64_12102_database_se2_1of2.zip
linuxamd64_12102_database_se2_2of2.zip

extract and combin both into linuxamd64_12102_database_se2.zip


##2. Download Perl
wget http://www.cpan.org/src/5.0/perl-5.24.0.tar.gz


##3. Build images
```bash
docker build -t hshekhar/oraclelinux12c .
```

##4. Start docker container
###Option 1. Start with detach mode
```bash
docker run -d --name hshekhar12c \
    -p 1521:1521 \
    -p 5500:5500 \
    -v /c/Users/609080540/docker-vol/oradata:/opt/oracle/oradata \
    hshekhar/oraclelinux12c:latest
```

Note: Monitor startup logs and ensure that you see below message in the log
"#########################"
"DATABASE IS READY TO USE!"
"#########################"

### Watch database startup logs
```bash
docker logs -f hshekhar12c
```

##5. Connecting database
Once container is ready you can connect to database
#### a) Connect database as SYS(SYSDBA)
```bash
docker exec -it hshekhar12c sqlplus / as sysdba
```
Note: SYS connects to base container, you need to switch to PDB container by 
```sql
ALTER SESSION SET CONTAINER = RBMPDB;
```
#### b) Connect database as SYSTEM 
```bash
docker exec -it hshekhar12c sqlplus 'system/0racle$@RBMPDB' 
```
OR 
```bash
docker exec -it hshekhar12c sqlplus 'SYSTEM/0racle$@//<docker-machine IP>:1521/RBMPDB'
```
#### c) Connect database as PDBADMIN 
```bash
docker exec -it hshekhar12c sqlplus 'system/0racle$@RBMPDB' 
```
OR 
```bash
docker exec -it hshekhar12c sqlplus 'PDBADMIN/0racle$@//<docker-machine IP>:1521/RBMPDB'
```

###2. Create custom users and schema 
```bash
docker cp customization/sql/geneva_permission.sql hshekhar12c:/tmp
docker exec -u 0 -it hshekhar12c chown oracle:dba /tmp/geneva_permission.sql
docker exec hshekhar12c sqlplus / as sysdba @/tmp/geneva_permission.sql
docker exec -u 0 -it hshekhar12c rm /tmp/geneva_permission.sql
```
After this you will be able to access database as geneva_admin user
#### i) Connect database as GENEVA_ADMIN 
```bash
docker exec -it hshekhar12c sqlplus 'geneva_admin/geneva_admin$@RBMPDB' 
```
#### ii) Check if dump is applied properly
```sql
SELECT GNVGEN.SYSTEMDATE FROM DUAL;
```

###3. Create base RBM schema
```bash
docker cp customization/dmps/geneva_admin.dmp hshekhar12c:/tmp
docker exec -u 0 -it hshekhar12c chown oracle:dba /tmp/geneva_admin.dmp
docker exec -it hshekhar12c \
    /opt/oracle/product/12.1.0.2/dbhome_1/bin/imp geneva_admin/geneva_admin@RBMPDB \
    file=/tmp/geneva_admin.dmp \
    FROMUSER=KRISHNA903 TOUSER=GENEVA_ADMIN \
    grants=Y constraints=N \
    log=/tmp/geneva_admin.log
docker exec hshekhar12c rm /tmp/geneva_admin.dmp
```

### Apply full config data 
```bash
docker cp customization/dmps/export_config_data_only.dmp hshekhar12c:/tmp
docker exec -u 0 -it hshekhar12c chown oracle:dba /tmp/export_config_data_only.dmp
docker exec -it hshekhar12c \
    /opt/oracle/product/12.1.0.2/dbhome_1/bin/imp geneva_admin/geneva_admin@RBMPDB \
    file=/tmp/export_config_data_only.dmp \
    FROMUSER=GENEVA_ADMIN TOUSER=GENEVA_ADMIN \
    grants=Y constraints=N log=/tmp/export_config_data_only.log
docker exec hshekhar12c rm /tmp/export_config_data_only.dmp
```