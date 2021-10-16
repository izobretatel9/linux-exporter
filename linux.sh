#!/bin/bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz # Заменить на актуальную версию
tar -xvzf node_exporter-1.1.2.linux-amd64.tar.gz
cp node_exporter-1.1.2.linux-amd64/node_exporter /usr/local/bin/
/usr/sbin/useradd --no-create-home --shell /bin/false node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter
#Добавляем
tee /etc/systemd/system/node_exporter.service <<"EOF"
[Unit]
Description=Node Exporter
 
[Service]
User=node_exporter
Group=node_exporter
EnvironmentFile=-/etc/sysconfig/node_exporter
ExecStart=/usr/local/bin/node_exporter $OPTIONS
 
[Install]
WantedBy=multi-user.target
EOF
#Создаем    
mkdir /etc/sysconfig
tee /etc/sysconfig/node_exporter <<"EOF"
OPTIONS="--collector.disable-defaults --collector.cpu --collector.cpufreq --collector.diskstats --collector.meminfo --collector.filesystem --collector.netdev"
EOF
chown node_exporter:node_exporter /etc/sysconfig/node_exporter
#Удаляем
rm node_exporter-1.1.2.linux-amd64.tar.gz
rm -rf node_exporter-1.1.2.linux-amd64
#Запускаем
systemctl daemon-reload && \
systemctl enable node_exporter && \
systemctl start node_exporter && \
systemctl status node_exporter