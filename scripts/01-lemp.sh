#!/bin/bash

# DigitalOcean Marketplace Image Validation Tool
# © 2021 DigitalOcean LLC.
# This code is licensed under Apache 2.0 license (see LICENSE.md for details)

rm -rvf /etc/nginx/sites-enabled/default

# Install LaraSail: https://github.com/thedevdojo/larasail
curl -sL https://github.com/thedevdojo/larasail/archive/master.tar.gz | tar xz && source larasail-master/install

# Run the LaraSail setup script
sh /etc/.larasail/larasail setup
chown larasail: /home/larasail/.my.cnf

# Create a new Laravel project
cd /var/www && export COMPOSER_ALLOW_SUPERUSER=1; $HOME/.config/composer/vendor/bin/laravel new laravel

ln -s /etc/nginx/sites-available/laravel \
      /etc/nginx/sites-enabled/laravel

chown -R larasail: /var/www/laravel
chown -R larasail:www-data /var/www/laravel/storage
chmod -R 775 /var/www/laravel/storage
chown -R larasail:www-data /var/www/laravel/bootstrap/cache
chmod -R 775 /var/www/laravel/bootstrap/cache

# Lock larasail user
passwd -ld larasail