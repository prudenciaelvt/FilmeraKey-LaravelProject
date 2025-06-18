FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    curl \
    git \
    libzip-dev \
    libpq-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy all project files to container
COPY . .

# Install PHP dependencies (Laravel)
RUN composer install --no-dev --optimize-autoloader

# Copy example environment file and generate Laravel app key
RUN cp .env.example .env && php artisan key:generate

# Expose port 8000 to the outside
EXPOSE 8000

# Run Laravel server from the public directory
CMD php artisan serve --host=0.0.0.0 --port=8000

