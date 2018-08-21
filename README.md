# WordPress VIP Go development for Docker

This repo provides a Docker-based environment for [WordPress VIP Go][vip-go]
development. It provides WordPress, MariaDB, Memcached, WP-CLI, and PHPUnit. It
further adds VIP Go mu-plugins and a [Photon][photon] server to closely mimic a
VIP Go environment.

# "Classic" VIP and non-VIP

For an environment suitable for "classic" VIP development, check out my
[docker-wordpress-vip][vip] repo.

If you only need a Docker WordPress development environment for a single plugin
or theme, my [docker-compose-wordpress][simple] repo is a simpler place to start.


## Set up

1. Clone or fork this repo.

2. Add `project.test` to your `/etc/hosts` file:

   ```
   127.0.0.1 localhost project.test
   ```

3. Edit `update.sh` to provide your VIP Go repo in the `wp_repo` variable.

4. Run `./setup.sh`.

5. Run `docker-compose up -d`.


## Install WordPress

```sh
docker-compose run --rm wp-cli install-wp
```

Log in to `http://project.test/wp-admin/` with `wordpress` / `wordpress`.

Alternatively, you can navigate to `http://project.test/` and manually perform
the famous five-second install.


## WP-CLI

You will probably want to create a shell alias for this:

```sh
docker-compose run --rm wp-cli wp [command]
```


## Running tests (PHPUnit)

The testing environment is provided by a separate Docker Compose file
(`docker-compose.phpunit.yml`) to ensure isolation. To use it, you must first
start it, then manually run your test installation script. These are example
commands and will vary based on your test scaffold.

Note that, in the PHPUnit container, your code is mapped to `/app`.

```sh
docker-compose -f docker-compose.yml -f docker-compose.phpunit.yml up -d
docker-compose -f docker-compose.phpunit.yml run --rm wordpress_phpunit /app/bin/install-wp-tests.sh
```

Now you are ready to run PHPUnit. Repeat this command as necessary:

```sh
docker-compose -f docker-compose.phpunit.yml run --rm wordpress_phpunit phpunit
```


## Configuration

Put project-specific WordPress config in `conf/wp-local-config.php` and PHP ini
changes in `conf/php-local.ini`, which are synced to the container. PHP ini
changes are only reflected when the container restarts. You may also adjust the
Nginx config of the reverse proxy container via `conf/nginx-proxy.conf`.


## Photon

A [Photon][photon] server is included and enabled by default to more closely
mimic the WordPress VIP production environment. Requests to `/wp-content/uploads`
will be proxied to the Photon container—simply append Photon-compatible query
string parameters to the URL.


## Memcached

A Memcached server and `object-cache.php` drop-in are available via the separate
`docker-compose.memcached.yml` but are not enabled by default. To use it, either
manually merge it into the main `docker-compose.yml` or reference it explicitly
when interacting with the stack:

```
docker-compose -f docker-compose.yml -f docker-compose.memcached.yml up -d
```


## HTTPS support

This repo provide HTTPS support out of the box. The setup script generates
self-signed certificates for the domain specified in `.env`. To enforce the use
of HTTPS, comment out (or remove) `HTTPS_METHOD: "nohttps"` from the
`services/proxy/environment` section of `docker-compose.yml`.

You may wish to add the generated root certificate to your system’s trusted root
certificates. This will allow you to browse your dev environment over HTTPS
without accepting a browser security warning. On OS X:

```sh
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain certs/ca-root/ca.crt
```


## Multiple environments

Multiple instances of this dev environment are possible. Make an additional copy
of this repo with a different folder name. Then, either juggle them by stopping
one and starting another, or modify `/etc/hosts` and `.env` to use another
domain, e.g., `project2.test`.


## Troubleshooting

If your stack is not responding, the most likely cause is that a container has
stopped or failed to start. Check to see if all of the containers are "Up":

```
docker-compose ps
```

If not, inspect the logs for that container, e.g.:

```
docker-compose logs wordpress
```

Running `update.sh` again can also help resolve problems.

If your self-signed certs have expired (`ERR_CERT_DATE_INVALID`), simply delete
the `certs/self-signed` directory, run `./certs/create-certs.sh`, and restart
the stack.


[vip-go]: https://vip.wordpress.com/documentation/vip-go/
[photon]: https://jetpack.com/support/photon/
[image]: https://hub.docker.com/r/chriszarate/wordpress/
[simple]: https://github.com/chriszarate/docker-compose-wordpress
[vip]: https://github.com/chriszarate/docker-wordpress-vip
