<?php
/**
 * WordPress local config
 *
 * @package docker-wordpress-vip-go
 */

// Conditionally turn on HTTPS since we're behind nginx-proxy.
if ( isset( $_SERVER['HTTP_X_FORWARDED_PROTO'] ) && 'https' === $_SERVER['HTTP_X_FORWARDED_PROTO'] ) { // Input var ok.
	$_SERVER['HTTPS'] = 'on';
}

// Indicate VIP Go environment.
define( 'VIP_GO_ENV', 'local' );

// Disable automatic updates.
define( 'AUTOMATIC_UPDATER_DISABLED', true );

// This provides the host and port of the development Memcached server. The host
// should match the container name in `docker-compose.memcached.yml`. If you
// aren't using Memcached, it will simply be ignored.
$memcached_servers = array(
	array(
		'memcached',
		11211,
	),
);

// Put project-specific config below this line.
