#!/bin/bash
wget http://zabbix.repo.timeweb.ru/debian/pool/main/z/zabbix-agent-timeweb/zabbix-agent-timeweb_127_amd64.deb
dpkg -i zabbix-agent-timeweb_127_amd64.deb
rm ./zabbix-agent-timeweb_127_amd64.deb
