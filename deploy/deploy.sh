#!/bin/sh

# Создаем ключ
# ssh-keygen -t rsa -C "your_email@example.com"
# Переносим публичный ключ на сервер
# cat /hdd2/id_rsa.pub >> ./.ssh/authorized_keys
# chmod 700 ./.ssh/authorized_keys

cd /tmp
rm -rf site_checkout
git clone git@github.com:ifrogmedia/petrik.ru.git site_checkout
cd site_checkout
git checkout master
rm -rf .git
#rsync -zr -e ssh . sub1319_15@62.213.111.107:httpdocs
rsync -zr -e ssh . sub1319_15@62.213.111.107:httpdocs
cd ..
rm -rf site_checkout