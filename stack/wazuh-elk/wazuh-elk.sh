
# ELK

apt-get install apt-transport-https zip unzip lsb-release curl gnupg


curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -

echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list

apt-get update

apt-get install elasticsearch=7.14.2

curl -so /etc/elasticsearch/elasticsearch.yml https://packages.wazuh.com/resources/4.2/elastic-stack/elasticsearch/7.x/elasticsearch_all_in_one.yml

curl -so /usr/share/elasticsearch/instances.yml https://packages.wazuh.com/resources/4.2/elastic-stack/instances_aio.yml

/usr/share/elasticsearch/bin/elasticsearch-certutil cert ca --pem --in instances.yml --keep-ca-key --out ~/certs.zip

unzip ~/certs.zip -d ~/certs

mkdir /etc/elasticsearch/certs/ca -p
cp -R ~/certs/ca/ ~/certs/elasticsearch/* /etc/elasticsearch/certs/
chown -R elasticsearch: /etc/elasticsearch/certs
chmod -R 500 /etc/elasticsearch/certs
chmod 400 /etc/elasticsearch/certs/ca/ca.* /etc/elasticsearch/certs/elasticsearch.*
rm -rf ~/certs/ ~/certs.zip

mkdir -p /etc/elasticsearch/jvm.options.d
echo '-Dlog4j2.formatMsgNoLookups=true' > /etc/elasticsearch/jvm.options.d/disabledlog4j.options
chmod 2750 /etc/elasticsearch/jvm.options.d/disabledlog4j.options
chown root:elasticsearch /etc/elasticsearch/jvm.options.d/disabledlog4j.options

systemctl daemon-reload
systemctl enable elasticsearch
systemctl start elasticsearch

/usr/share/elasticsearch/bin/elasticsearch-setup-passwords auto

curl -XGET https://localhost:9200 -u elastic:<elastic_password> -k

# Wazuh local server

apt-get install python gcc g++ make libc6-dev curl policycoreutils automake autoconf libtool


curl -OL https://packages.wazuh.com/utils/cmake/cmake-3.18.3.tar.gz && tar -zxf cmake-3.18.3.tar.gz
cd cmake-3.18.3 && ./bootstrap --no-system-curl
make -j$(nproc) && make install
cd .. && rm -rf cmake-*

echo "deb-src http://deb.debian.org/debian $(lsb_release -cs) main" >> /etc/apt/sources.list
apt-get update
apt-get build-dep python3.5 -y

curl -Ls https://github.com/wazuh/wazuh/archive/v4.2.5.tar.gz | tar zx

cd wazuh-*
./install.sh

cd wazuh-*
make -C src clean
make -C src clean-deps

systemctl start wazuh-manager