Homework1:
1.0. Install psql and pgAdmin.
1.1. Create database, run script to fill up data https://resources.oreilly.com/examples/9781565928466/blob/master/booktown.sql,  
1.2. Make backup and restore backup.
1.3. Create separated roles with certain permission (read only, read/write role). Grant roles to user.

        1.0. instalation:
                # installation of psql
                $ sudo apt install postgresql postgresql-contrib
                # installation of pgAdmin3
                $ sudo apt install pgadmin3

        1.1. create database:
                # login as user postgres and connect to psql
                $ sudo su - postgres
                $ psql
                # createdb
                $ CREATE DATABASE booktown;
                # run script booktown.sql
                $ psql -f thefile.sql targetdatabase

        1.2. make and restore backup:
                $ pg_dump booktown > booktown.bak
                $ drop database booktown;
                $ psql test < dbname.bak

	1.3. create separated roles:
		# role read only
		$ create role r_role;
		$ grant select on all tables in schema public to r_role;
		
		# role read/write
		$ create role rw_role;
		$ grant select, update on all tables in schema public to rw_role;
		# grant roles to user
	
Homework2:
2.1. Preparing Master and Slave. 
2.2. Setup streaming replication.

	2.1. preparing Master and Slave:
		#Generate a self signed certificate
                $ openssl genrsa -out server.key 2048
		
		#Create a certificate signing request (csr)
		$ openssl req -new -key server.key -out server.csr
		
		#Sign the CSR
		$ openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
		
		# Setup SSL on PostgreSQL: 
		# a) copy your private key and your certificate in the directory of your choice. Be carefull that the postgresql user can read 
		# them (usually user postgres on Linux or _postgresql on OpenBSD)
		# b) edit the file postgresql.conf and change these lines:
		ssl = on
		ssl_cert_file = '/etc/ssl/postgresql/cert/server.crt'
		ssl_key_file = '/etc/ssl/postgresql/private/server.key'
		#Create a role dedicated to the replication
		$ postgres=# CREATE ROLE replicate WITH REPLICATION LOGIN;
		$ postgres=# set password_encryption = 'scram-sha-256';
		$ postgres=# \password replicate
		
		# Verify that your PostgreSQL server listen on your interface. 
		# Edit postgresql.conf and change from 
                $ listen_addresses = 'localhost'
		# to
		$ listen_addresses = 'your_master_server_IP'
		
		# Change the parameters for the streaming replication in
		$ wal_level = replica
		$ max_wal_senders = 3 # max number of walsender processes
		$ wal_keep_segments = 64 # in logfile segments, 16MB each; 0 disables
		
		# Allow slave to connect to the master. Edit pg_hba.conf and add:	
                $ hostssl  DATABASE  USER  ADDRESS  METHOD  [OPTIONS]
