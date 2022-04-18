# Laravel 1-Click installation - DigitalOcean Marketplace

[![Apache license](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

This repository contains resources for building the 1-Click installation of [Laravel on DigitalOcean](https://marketplace.digitalocean.com/apps/laravel).

## 1-Click installation

To install the latest version of [Laravel](https://laravel.com/) on DigitalOcean with 1-Click, you can use the following link:

> [Laravel 1-Click installation - DigitalOcean Marketplace](https://marketplace.digitalocean.com/apps/laravel?refcode=dc19b9819d06&action=deploy)

## Steps after the installation

In addition to the package installation, the One-Click also:

- Enables the UFW firewall to allow only SSH (port 22, rate limited), HTTP (port 80), and HTTPS (port 443) access.
- Creates the initial Laravel configuration file to set up database credentials and allow the Laravel instance to connect to the database.
- After you create a Laravel One-Click Droplet, you’ll need to log into the Droplet via SSH to finish the Laravel setup.

From a terminal on your local computer, connect to the Droplet as root. Make sure to substitute the Droplet’s public IPv4 address.

```
ssh root@your_droplet_public_ipv4
```

If you did not add an SSH key when you created the Droplet, you’ll first be prompted to reset your root password.

Then, the interactive script that runs will first prompt you for your domain or subdomain:

```
--------------------------------------------------
This setup requires a domain name.  If you do not have one yet, you may
cancel this setup, press Ctrl+C.  This script will run again on your next login
--------------------------------------------------
Enter the domain name for your new Laravel site.
(ex. example.org or test.example.org) do not include www or http/s
--------------------------------------------------
Domain/Subdomain name:
```

The next prompt asks if you want to use SSL for your website via Let’s Encrypt, which we recommend:

```
Next, you have the option of configuring LetsEncrypt to secure your new site.  Before doing this, be sure that you have pointed your domain or subdomain to this server's IP address.  You can also run LetsEncrypt certbot later with the command 'certbot --nginx'

Would you like to use LetsEncrypt (certbot) to configure SSL(https) for your new site? (y/n):
```

At this point, you can visit the Droplet’s IP address or your domain name in your browser to see the Laravel installation.

The web root is `/var/www/laravel`, and the Laravel configuration file is `/var/www/laravel/.env`.

You can get information about the PHP installation by logging into the Droplet and running `php -i`.

If you didn’t enable HTTPS during the initial setup script, you can enable it manually at any time after your domain name has been pointed to the Droplet's IP address.

Setting up an SSL certificate enables HTTPS on the web server, which secures the traffic between the server and the clients connecting to it. Certbot is a free and automated way to set up SSL certificates on a server. It’s included as part of the Laravel One-Click to make securing the Droplet easier.

To use Certbot, you’ll need a registered domain name and two DNS records:

- An A record from the domain (e.g., `example.com`) to the server’s IP address
- An A record from a domain prefaced with www (e.g., [www.example.com](<http://www.example.com>)) to the server’s IP address

Additionally, if you’re using a server block file, you’ll need to make sure the server name directive in the Nginx server block (e.g., `server_name example.com`) is correctly set to the domain.

Once the DNS records and, optionally, the server block files are set up, you can generate the SSL certificate. Make sure to substitute the domain in the command.

```
certbot --nginx -d example.com -d www.example.com
```

For a more detailed walkthrough, you can follow [How to Secure Nginx with Let’s Encrypt](<https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-18-04>) or view [Certbot’s official documentation](<https://certbot.eff.org/docs/using.html>).

You can serve files from the web server by adding them to the web root (`/var/www/laravel`) using [SFTP](<https://www.digitalocean.com/community/tutorials/how-to-use-sftp-to-securely-transfer-files-with-a-remote-server>) or other tools.

## LaraSail

The Laravel 1-Click installation ships with the [LaraSail](https://github.com/thedevdojo/larasail) script.

LaraSail is a CLI tool for Laravel to help you sail the servers of the DigitalOcean.

For more information on LaraSail, please visit the [LaraSail README.md file](https://github.com/thedevdojo/larasail/blob/master/README.md).

## Creating a new site

### Switching to the larasail user

When you SSH into your server you may want to switch users back to the `larasail` user, you can do so with the following command:

```
su - larasail
```

#### :sparkles: Automatically

##### Laravel

After setting up the server you can create a new project by running:

```
larasail new <project-name> [--jet <livewire|inertia>] [--teams] [--www-alias]
```

This will automatically create a project folder in `/var/www` and set up a host if the provided project name contains periods (they will be replaced with underscores for the directory name). By default, LaraSail sets up the Nginx site configuration and [Let’s Encrypt](https://letsencrypt.org/) SSL certificate for your domain. If you would like both the `www` alias and root domain setup (i.e. `example.com` and `www.example.com`) kindly pass the `--www-alias` flag.

##### Wave

[Wave](https://github.com/thedevdojo/wave) - The Software as a Service Starter Kit, designed to help you build the SAAS of your dreams. :rocket: :moneybag:
LaraSail allows you to create a new Wave project automatically by adding `--wave` flag to the `new` command as follows:

```
larasail new <project-name> [--wave]
```

Just like Laravel above, this will create a project folder, setup the Nginx site configuration and Let’s Encrypt SSL certificate for your domain. By default, you will be prompted to create a project database and if successful, will migrate and seed the database.

#### :construction: Manually

Alternatively, you can clone a repository or create a new Laravel app within the `/var/www` folder:

```
cd /var/www && laravel new mywebsite
```

If you want to include [Laravel Jetstream](https://jetstream.laravel.com/) into your project, you need to specify the `--jet` option:

```
cd /var/www && laravel new mywebsite --jet
```

Then, you'll need to setup a new Nginx host by running:

```
larasail host mywebsite.com /var/www/mywebsite --www-alias
```

`larasail host` accepts three parameters:

1. Your website domain *(mywebsite.com)*
2. The location of the files for your site *(/var/www/mywebsite/public)*
3. Optional flag if you would like to include your project's `www` alias: `www.mywebsite.com` *(--www-alias)*

Finally, point your domain to the IP address of your new server. And wallah, you're ready to rock 🤘 with your new Laravel website. If you used the `--www-alias` flag, don't forget to add your domain's www `CNAME` record

### Passwords

When installing and setting up LaraSail there are two passwords that are randomly generated:

1. The password for the `larasail` user created
2. The default MySQL password

To get the `larasail` user password you can type in the following command:

```
larasail pass
```

And the password for the `larasail` user will be displayed. Next, to get the default MySQL root password you can type the following command:

```
larasail mysqlpass
```

And the MySQL root password will be displayed.

### Creating a database

After you have created your project you can create a database and user for it by using the following command:

```
larasail database init [--user larasail] [--db larasail] [--force]
```

By default it will create a database and the user `larasail` and grant all permissions to that user.

**TIP**: If you are in the project directory when you run this command, it will also try to update the `.env` file
with the newly generated credentials.

After you have created a database, you can show the newly generated passwords using the following command:

```
larasail database pass
```

## DevDojo

This image is supported by the DevDojo team.

DevDojo is a resource to learn all things web development and web design. Learn on your lunch break or wake up and enjoy a cup of coffee with us to learn something new.

Join this developer community, and we can all learn together, build together, and grow together.

- [Join DevDojo](https://devdojo.com/)

For more information, please visit https://www.devdojo.com or follow [@thedevdojo](https://twitter.com/thedevdojo) on Twitter.

## Build Automation with Packer

[Packer](https://www.packer.io/intro) is a tool for creating images from a single source configuration. Using this Packer template reduces the entire process of creating, configuring, validating, and snapshotting a build Droplet to a single command:

```
export DIGITALOCEAN_TOKEN=your_digital_ocean_token_here
packer build template.json
```

By doing this, there is a reduced likelihood of having to submit an image multiple times as a result of falling in any of the next steps:

- Installing OS updates
- Deleting bash history.
- Removing log files and SSH keys from the root user
- Enabling the firewall (i.e. ufw if you use Ubuntu)

For more information, check out the DigitalOcean Packer project:
> https://github.com/digitalocean/droplet-1-clicks/
