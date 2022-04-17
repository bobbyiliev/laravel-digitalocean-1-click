# Laravel 1-Click installation - DigitalOcean Marketplace

[![Apache license](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

This repository contains resources for building the 1-Click installation of [Laravel on DigitalOcean](https://marketplace.digitalocean.com/apps/laravel).

## 1-Click installation

To install the latest version of [Laravel](https://laravel.com/) on DigitalOcean with 1-Click, you can use the following link:

> [Laravel 1-Click installation - DigitalOcean Marketplace](https://marketplace.digitalocean.com/apps/laravel?refcode=dc19b9819d06&action=deploy)

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
packer build marketplace-image.json
```

By doing this, there is a reduced likelihood of having to submit an image multiple times as a result of falling in any of the next steps:

- Installing OS updates
- Deleting bash history.
- Removing log files and SSH keys from the root user
- Enabling the firewall (i.e. ufw if you use Ubuntu)

For more information, check out the DigitalOcean Packer project:
> https://github.com/digitalocean/droplet-1-clicks/
