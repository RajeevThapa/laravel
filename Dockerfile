# Use an official PHP runtime as a parent image
FROM php:8.1-apache

# Set the working directory in the container
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && \
    apt-get install -y libzip-dev zip && \
    docker-php-ext-install pdo pdo_mysql zip && \
    a2enmod rewrite

# Copy the local code to the container
COPY . /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install application dependencies
RUN composer install --no-interaction

# Set permissions
# RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
# RUN chown -R www-data:www-data /var/www/html/storage && \
#    chmod -R 775 /var/www/html/storage

RUN chmod -R 775 /var/www/html/storage \
    && chown -R www-data:www-data /var/www/html/storage


# Expose port 80 for the webserver
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]