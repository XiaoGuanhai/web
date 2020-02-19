# @author Siu <xiaoguanhai@gmail.com>
# @link http://www.ddtechs.cn
ARG PHP_VERSION=7.3
FROM php:${PHP_VERSION}-apache
ENV DEBIAN_FRONTEND=noninteractive
# 环境设置
ENV PHP_USER_ID=33 \
    PHP_ENABLE_XDEBUG=${PHP_ENABLE_XDEBUG} \
    PATH=/app:/app/vendor/bin:/root/.composer/vendor/bin:$PATH \
    TERM=linux \
    VERSION_PRESTISSIMO_PLUGIN=^0.3.7 \
    COMPOSER_ALLOW_SUPERUSER=1 \
    # OCI
    LD_LIBRARY_PATH=/usr/local/instantclient:${LD_LIBRARY_PATH} \
    ORACLE_HOME=/usr/local/instantclient
# 添加自定义配置文件
COPY files/ /
## 使用网易源
RUN echo \
    deb http://mirrors.163.com/debian/ buster main non-free contrib \
    deb-src http://mirrors.163.com/debian/ buster main non-free contrib \
    > /etc/apt/sources.list \
## 安装软件
    && apt-get update \
    && apt-get -y install \
        g++ \
        git \
        curl \
        imagemagick \
        libcurl3-dev \
        libicu-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libjpeg62-turbo-dev \
        libmagickwand-dev \
        libpq-dev \
        libpng-dev \
        libxml2-dev \
        libzip-dev \
        zlib1g-dev \
        openssh-client \
        nano \
        unzip \
        libcurl4-openssl-dev \
        libssl-dev \
        iputils-ping \
        vim \
        # OCI依赖
        libaio1 \
        --no-install-recommends
### 安装扩展
RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure bcmath \
    && docker-php-ext-install \
        soap \
        zip \
        curl \
        bcmath \
        exif \
        gd \
        iconv \
        intl \
        mbstring \
        opcache \
        pdo_mysql \
        pdo_pgsql \
        mysqli \
    # 安装OCI扩展
    && unzip -o /tmp/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /usr/local/ \
    && unzip -o /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /usr/local/ \
    && unzip -o /tmp/instantclient-sqlplus-linux.x64-12.2.0.1.0.zip -d /usr/local/ \
    && ln -s /usr/local/instantclient_12_2 /usr/local/instantclient \
    && ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so \
    && ln -s /usr/local/instantclient/libclntshcore.so.12.1 /usr/local/instantclient/libclntshcore.so \
    && ln -s /usr/local/instantclient/libocci.so.12.1 /usr/local/instantclient/libocci.so \
    && ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus \
    && echo 'instantclient,/usr/local/instantclient' | pecl install /tmp/pear/download/oci8-2.2.0.tgz \
    && docker-php-ext-enable \
                      oci8 \
    && docker-php-ext-configure pdo_oci \
        --with-pdo-oci=instantclient,/usr/local/instantclient \
    && docker-php-ext-install pdo_oci \
    # 安装其他扩展
    # @see http://stackoverflow.com/a/8154466/291573) for usage of `printf`
    && printf "\n" | pecl install \
#       imagick \
#       mongodb \
#       igbinary \
#       xdebug \
    # 需要7.0以上
        /tmp/pear/download/redis-5.1.1.tgz \
        /tmp/pear/download/imagick-3.4.4.tgz \
        /tmp/pear/download/mongodb-1.6.1.tgz \
        /tmp/pear/download/igbinary-3.1.0.tgz \
        /tmp/pear/download/xdebug-2.9.0.tgz \
    && docker-php-ext-enable \
        imagick \
        mongodb \
        igbinary \
        xdebug \
        redis
### 配置GITHUB TOKEN
# Add GITHUB_API_TOKEN support for composer
#    && chmod 700 \
#        /usr/local/bin/docker-php-entrypoint \
#        /usr/local/bin/composer \
### 安装 composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer.phar \
        --install-dir=/usr/local/bin
### 安装 composer 插件
#    && composer global require --optimize-autoloader \
#        "hirak/prestissimo:${VERSION_PRESTISSIMO_PLUGIN}" \
#    composer global dumpautoload --optimize \
#    composer clear-cache
## 设置系统
RUN cp /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime \
    # 配置时区
    && echo "Asia/Hong_Kong" >  /etc/timezone \
    # 配置Apache
    && if command -v a2enmod >/dev/null 2>&1; then \
        a2enmod rewrite headers \
    ;fi \
    # 清空缓存
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/
# Application environment
WORKDIR /app