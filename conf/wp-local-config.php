<?php
/**
 * WordPress local config
 *
 * @package docker-vip
 */

// Conditionally turn on HTTPS since we're behind nginx-proxy.
if ( isset( $_SERVER['HTTP_X_FORWARDED_PROTO'] ) && 'https' === $_SERVER['HTTP_X_FORWARDED_PROTO'] ) { // Input var ok.
	$_SERVER['HTTPS'] = 'on';
}

// Indicate VIP Go environment.
define( 'VIP_GO_ENV', 'local' );

// Project-specific config.
