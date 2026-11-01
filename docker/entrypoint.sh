#!/bin/sh
set -e
cd /var/www/html

# Write includes/config.php from the environment (no credentials in git or in the image)
if [ -n "$DB_HOST" ]; then
  cat > includes/config.php <<'PHP'
<?php
// Generated at container start from environment variables. Do not edit.
$database                 = array();
$database['host']         = getenv('DB_HOST');
$database['port']         = getenv('DB_PORT') ?: '3306';
$database['user']         = getenv('DB_USER');
$database['userpw']       = getenv('DB_PASSWORD');
$database['databasename'] = getenv('DB_NAME');
$database['tableprefix']  = getenv('DB_PREFIX') ?: 'uni1_';
$salt                     = getenv('APP_SALT');
PHP
  chown www-data:www-data includes/config.php
  chmod 640 includes/config.php
fi

mkdir -p cache/sessions cache/templates cache/throttle cache/logincodes
chown -R www-data:www-data cache

for v in RESEND_API_KEY MAIL_FROM APP_URL APP_SECRET; do
  eval "val=\${$v:-}"
  [ -n "$val" ] || echo "[entrypoint] WARNING: $v is not set" >&2
done

exec docker-php-entrypoint "$@"
