#!/bin/bash

sudo su - magento -s /bin/sh -c "cd /home/magento/public_html/magento && mkdir -p var/composer_home && \
cp composer.json var/composer_home/ && \
bin/magento setup:install \
--db-host=<db-endpoint> \
--db-name=magento_db \
--db-user=magento_db_user \
--db-password=<db-password> \
--admin-firstname=admin \
--admin-lastname=admin \
--admin-email=admin@admin.com \
--admin-user=admin \
--admin-password=admin123 \
--backend-frontname=admin \
--language=en_US \
--currency=USD \
--timezone=America/Chicago \
--use-rewrites=1"

sudo chmod -R 777 /home/magento/public_html/magento
sudo chown magento. -R /home/magento/public_html/magento
cd /home/magento/public_html/magento
sudo -u magento php -dmemory_limit=-1 /home/magento/public_html/magento/bin/magento maintenance:enable
sudo su - magento -s /bin/bash -c 'cd /home/magento/public_html/magento  && composer install'
sudo rm -rf var/cache/* generated/code/* generated/metadata/* var/page_cache/* var/view_preprocessed/* var/di/*
sudo -u magento php -dmemory_limit=-1 /home/magento/public_html/magento/bin/magento setup:upgrade
sudo -u magento php -dmemory_limit=-1 /home/magento/public_html/magento/bin/magento setup:di:compile
sudo -u magento php -dmemory_limit=-1 /home/magento/public_html/magento/bin/magento setup:static-content:deploy -f en_US ar_EG
sudo -u magento php -dmemory_limit=-1 /home/magento/public_html/magento/bin/magento cache:flush
sudo -u magento php -dmemory_limit=-1 /home/magento/public_html/magento/bin/magento cache:status
sudo -u magento php -dmemory_limit=-1 /home/magento/public_html/magento/bin/magento cache:enable
sudo -u magento php -dmemory_limit=-1 /home/magento/public_html/magento/bin/magento maintenance:disable
sudo -u magento php -dmemory_limit=-1 /home/magento/public_html/magento/bin/magento maintenance:status
sudo service nginx restart && sudo service php7.4-fpm restart