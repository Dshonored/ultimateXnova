# ultimateXnova friends-edition: PHP 8.5 + Apache, hardened defaults
# Latest stable PHP (8.5.12, Oct 2026) pinned exactly; 8.6 is still RC and gets no security support.
# Bump this tag when a new 8.5.x / 8.6.x security release ships.
FROM php:8.5.12-apache-trixie

# (OPcache is part of the PHP 8.5 core, no extension build needed)
RUN apt-get update \
 && apt-get upgrade -y --no-install-recommends \
 && apt-get install -y --no-install-recommends libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j"$(nproc)" gd pdo_mysql mysqli bcmath \
 && a2enmod rewrite headers \
 && rm -rf /var/lib/apt/lists/*

COPY docker/php.ini      /usr/local/etc/php/conf.d/zz-game.ini
COPY docker/apache.conf  /etc/apache2/conf-enabled/zz-game.conf
COPY docker/entrypoint.sh /usr/local/bin/game-entrypoint
RUN chmod +x /usr/local/bin/game-entrypoint

WORKDIR /var/www/html
COPY --chown=www-data:www-data . /var/www/html
RUN rm -rf docker .git .github \
 && mkdir -p cache/sessions cache/templates cache/throttle cache/logincodes \
 && chown -R www-data:www-data cache includes

ENTRYPOINT ["game-entrypoint"]
CMD ["apache2-foreground"]
