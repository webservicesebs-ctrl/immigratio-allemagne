#!/bin/bash
set -e

echo "==> Updating apt and installing PHP extensions"
sudo apt-get update
sudo apt-get install -y unzip php8.2-mbstring php8.2-xml php8.2-bcmath php8.2-curl

echo "==> Installing Composer (verified)"
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
    >&2 echo 'ERROR: Invalid Composer installer checksum'
    rm composer-setup.php
    exit 1
fi
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

echo "==> Installing Laravel installer globally"
composer global require laravel/installer
if ! grep -q 'composer/vendor/bin' ~/.bashrc; then
  echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc
fi
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Create Laravel app if missing
if [ ! -d "salary-app" ]; then
  echo "==> Creating Laravel 11 app with Jetstream (Livewire + Teams)"
  laravel new salary-app --jet --stack=livewire --teams
fi

echo "==> Configuring Laravel .env for MySQL 8"
sed -i "s/^DB_CONNECTION=.*/DB_CONNECTION=mysql/" salary-app/.env || true
sed -i "s/^DB_HOST=.*/DB_HOST=127.0.0.1/" salary-app/.env || true
sed -i "s/^DB_PORT=.*/DB_PORT=3306/" salary-app/.env || true
sed -i "s/^DB_DATABASE=.*/DB_DATABASE=salary_db/" salary-app/.env || true
sed -i "s/^DB_USERNAME=.*/DB_USERNAME=root/" salary-app/.env || true
sed -i "s/^DB_PASSWORD=.*/DB_PASSWORD=root/" salary-app/.env || true

echo "==> Installing Laravel dependencies and running migrations"
pushd salary-app
  composer install --no-interaction --prefer-dist
  php artisan key:generate || true
  php artisan migrate --force || true
popd

# Create Next.js app if missing
if [ ! -d "salary-frontend" ]; then
  echo "==> Creating Next.js 14 app (TypeScript + Tailwind + ESLint + App Router)"
  npx create-next-app@latest salary-frontend --typescript --tailwind --eslint --app --no-src-dir --use-npm --yes
fi

echo "==> Installing Next.js dependencies (npm ci)"
pushd salary-frontend
  if [ -f package-lock.json ]; then npm ci; else npm install; fi
popd

echo "==> Done. Start apps with:"
echo "    cd salary-app && php artisan serve --host=0.0.0.0 --port=8000"
echo "    cd salary-frontend && npm run dev -- --host 0.0.0.0 --port=3000"
