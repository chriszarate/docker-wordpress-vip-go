# WordPress VIP development for Docker

This repo provides a Docker-based development environment for [WordPress VIP Go][vip-go]
development. It provides WordPress, MariaDB, WP-CLI, PHPUnit, and the WordPress
unit testing suite. It further adds VIP shared plugins, VIP mu-plugins, and a
[Photon][photon] server.

If you only need Docker WordPress development environment for a single plugin or
theme, my [docker-compose-wordpress][simple] repo is a simpler place to start.


# "Classic" VIP

For an environment suitable for "classic" VIP development, check out my
[docker-wordpress-vip][vip] repo.


## Set up

1. Clone or fork this repo.

2. Add `project.test` to your `/etc/hosts` file:

   ```
   127.0.0.1 localhost project.test
   ```

3. Edit `setup.sh` to check out your organization’s code into the `src` folder
   folder (replace the example repo `Automattic/vip-go-skeleton` with your own).
   Then, adjust `docker-compose.yml` to reflect your changes (update the
   `vip-go-skeleton` mapping to reflect your theme).

4. Run `./setup.sh`.

5. Run `docker-compose up -d`.


## Interacting with containers

**Refer to [docker-compose-wordpress][simple] for general instructions** on how
to interact with the stack, including WP-CLI, PHPUnit, and preloading
content.

The main difference with this stack is that all code is synced to the WordPress
container from the `src` subfolder and, generally, is assumed to be its own
separate repo.


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
self-signed certificates for the domain specified in `.env`. You may wish to add
the generated root certificate to your system’s trusted root certificates. This
will allow you to browse your dev environment over HTTPS without accepting a
browser security warning. On OS X:

```sh
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain certs/ca-root/ca.crt
```

If you do not want to use HTTPS, add `HTTPS_METHOD: "nohttps"` to the
`services/proxy/environment` section of `docker-compose.yml`.


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
