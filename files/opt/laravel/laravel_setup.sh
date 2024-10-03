#!/bin/bash
#
# Laravel activation script
#
# This script will configure Nginx with the domain
# provided by the user and offer the option to set up
# LetsEncrypt as well.

# Setup Laravel on firstlogin
echo "--------------------------------------------------"
echo "This setup requires a domain name.  If you do not have one yet, you may"
echo "cancel this setup, press Ctrl+C.  This script will run again on your next login"
echo "--------------------------------------------------"
echo "Enter the domain name for your new Laravel site."
echo "(ex. example.org or test.example.org) do not include www or http/s"
echo "--------------------------------------------------"

a=0
while [ $a -eq 0 ]
do
 read -p "Domain/Subdomain name: " dom
 if [ -z "$dom" ]
 then
  a=0
  echo "Please provide a valid domain or subdomain name to continue to press Ctrl+C to cancel"
 else
  a=1
fi
done

sed -i "s/DOMAIN/$dom/g" /etc/nginx/sites-enabled/laravel

systemctl restart nginx

echo "Configuring Laravel database details"

function create_database_details() {
    password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 14 | head -n 1)
    mysql -e "CREATE DATABASE laravel DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    mysql -e "CREATE USER 'laravel_user'@'localhost' IDENTIFIED WITH mysql_native_password BY '$password';"
    mysql -e "GRANT ALL ON laravel.* TO 'laravel_user'@'localhost';"

    # Laravel now has sqlite as default, so we need to change the database details:
    sed -i 's/DB_CONNECTION=sqlite/DB_CONNECTION=mysql/' /var/www/laravel/.env
    sed -i 's/# DB_HOST/DB_HOST/' /var/www/laravel/.env
    sed -i 's/# DB_PORT/DB_PORT/' /var/www/laravel/.env
    sed -i 's/# DB_DATABASE/DB_DATABASE/' /var/www/laravel/.env
    sed -i 's/# DB_USERNAME/DB_USERNAME/' /var/www/laravel/.env
    sed -i 's/# DB_PASSWORD/DB_PASSWORD/' /var/www/laravel/.env

    # Change password and user
    sed -i "s/^DB_PASSWORD=/DB_PASSWORD=${password}/g" /var/www/laravel/.env
    sed -i "s/^DB_USERNAME=root/DB_USERNAME=laravel_user/g" /var/www/laravel/.env
}

create_database_details

echo "Generating new Laravel App Key"
cd /var/www/laravel/ && php artisan key:generate
sed -i 's/APP_ENV=local/APP_ENV=production/g' /var/www/laravel/.env
sed -i 's/APP_DEBUG=true/APP_DEBUG=false/g' /var/www/laravel/.env

echo "Running Laravel Migrations"
cd /var/www/laravel/ && php artisan migrate

# Set default PHP version
update-alternatives --set php /usr/bin/php8.3

echo -en "\n\n\n"
echo "Next, you have the option of configuring LetsEncrypt to secure your new site.  Before doing this, be sure that you have pointed your doma
in or subdomain to this server's IP address.  You can also run LetsEncrypt certbot later with the command 'certbot --nginx'"
echo -en "\n\n\n"
read -p "Would you like to use LetsEncrypt (certbot) to configure SSL(https) for your new site? (y/n): " yn
    case $yn in
        [Yy]* ) certbot --nginx; echo "Laravel has been enabled at https://$dom"
            ;;
        [Nn]* ) echo "Skipping LetsEncrypt certificate generation"
            ;;
        * ) echo "Please answer y or n."
            ;;
    esac

echo "Installation completed"
cp /etc/skel/.bashrc /root
