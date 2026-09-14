#!/bin/bash

# Manual deployment script for GPS-WOX
# Run this on your VPS for first-time setup or manual deploys

set -e

echo "=== Moto Track ==="

# Configuration - UPDATE THESE
VPS_PATH="/var/www/mototrack"
BRANCH="main"

cd "$VPS_PATH" || { echo "Directory $VPS_PATH not found!"; exit 1; }

echo "[1/7] Pulling latest code..."
git pull origin "$BRANCH"

echo "[2/7] Installing dependencies..."
composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

echo "[3/7] Running migrations..."
php artisan migrate --force

echo "[4/7] Running seeders (if fresh database)..."
read -p "Run database seeders? (y/n): " run_seed
if [ "$run_seed" = "y" ]; then
    php artisan db:seed --force
fi

echo "[5/7] Clearing and caching..."
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "[6/7] Setting permissions..."
sudo chown -R www-data:www-data storage bootstrap/cache
sudo chmod -R 775 storage bootstrap/cache

echo "[7/7] Restarting services..."
sudo service php-fpm restart
sudo service nginx restart

echo "=== Deployment Complete ==="
echo "Visit: http://$(hostname -I | awk '{print $1}')"
