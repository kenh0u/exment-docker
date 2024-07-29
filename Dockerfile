FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root

RUN apt update && \
    apt install -y curl git wget gnupg unzip zip && \
    apt install -y php mariadb-client libxml2-dev libpng-dev libzip-dev libonig-dev \
                   php-gd php-dom php-bcmath php-mbstring php-xml php-zip php-curl php-mysql && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer create-project "laravel/laravel=10.*" exment && \
    cd exment && \
    yes | composer require exceedone/exment:"v6.1.1" -W && \
    php artisan vendor:publish --provider="Exceedone\Exment\ExmentServiceProvider" && \
    apt purge -y curl git wget gnupg && \
    sed -i 's/post_max_size = 8M/post_max_size = 20M/' /etc/php/8.2/cli/php.ini && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/' /etc/php/8.2/cli/php.ini && \
    sed -i 's/max_execution_time = 30/max_execution_time = 240/' /etc/php/8.2/cli/php.ini && \
    sed -i 's/;max_input_vars = 1000/max_input_vars = 3000/' /etc/php/8.2/cli/php.ini && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./Handler.php /root/exment/app/Exceptions/Handler.php

WORKDIR /root/exment
CMD ["php","artisan","serve","--host","0.0.0.0","--port","80","--no-reload"]
