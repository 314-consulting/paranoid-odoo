#!/bin/bash

sudo apt install -y git python3-pip build-essential python3-psycopg2 libpq-dev wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools

wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb

sudo dpkg -i wkhtmltox_0.12.6-1.focal_amd64.deb

sudo apt --fix-broken install

sudo pip3 install wheel

git clone --single-branch -b 14.0 --depth 1  https://github.com/JuanDCG/OCB.git

cd OCB

sudo pip3 install -r requirements.txt

python3 odoo-bin -c odoo.conf -d db-postgres --addons-path=addons --db-filter=db-postgres$ --no-database-list
