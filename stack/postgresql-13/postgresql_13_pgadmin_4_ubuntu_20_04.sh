#!/bin/bash

# Update all your packages
sudo apt update
sudo apt upgrade -y

# Add postgresql repository and key
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' 

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update again
sudo apt-get update

# Install pgadmin4
sudo apt install pgadmin4

# Install postgresql-13
sudo apt-get -y install postgresql-13

# Check version to see if it's correct
psql --Version

# Allow remote connections
# edit line #listen_addresses to listen_addresses = '*'
sudo nano /etc/postgresql/13/main/postgresql.conf

# edit file
sudo nano /etc/postgresql/13/main/pg_hba.conf
# add line at the end (change 192.168.0.0/24 to your network or 0.0.0.0/0 to all)
host    all     all             192.168.0.0/24            md5
# FOR SSL: add line at the end (change 192.168.0.0/24 to your network or 0.0.0.0/0 to all)
hostssl    all     all             192.168.0.0/24            md5 clientcert=1

# Restart postgres
sudo systemctl restart postgresql

# Access psql to create users, databases and passwords
sudo -u postgres psql

# Add a stronger password to default postgres user
alter user postgres with encrypted password 'the_postgres_user_password';

# Create user
create user your_username with encrypted password 'your_user_password';

# OR a superuser
CREATE ROLE your_username WITH LOGIN SUPERUSER CREATEDB CREATEROLE PASSWORD 'your_user_password';

# Create a database
CREATE DATABASE db_name2 WITH OWNER your_username;

# Grant permissions to user on database
GRANT ALL PRIVILEGES ON DATABASE db_name TO your_username;

# Read security tips here
# https://www.digitalocean.com/community/tutorials/how-to-secure-postgresql-against-automated-attacks