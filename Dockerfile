FROM centos:7

MAINTAINER Juliano Buzanello <juliano.buzanello@engesoftware.com.br>

RUN yum -C install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
        http://rpms.famillecollet.com/enterprise/7/remi/x86_64/remi-release-7.7-2.el7.remi.noarch.rpm \
    && rm -rf /var/cache/yum/* \
    && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 /etc/pki/rpm-gpg/RPM-GPG-KEY-remi /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

RUN yum-config-manager --enable remi,remi-php72 && yum clean all

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo

RUN yum -y update

ENV ACCEPT_EULA=Y

RUN yum install -y deltarpm \
    msodbcsql17 \
    mssql-tools \
    unixODBC-devel \
    git \
    unzip \
    httpd \
    mod_ssl \
    php \
    php-devel \
    php-pear \
    php-gd \
    php-pdo \
    php-cli \
    php-curl \
    php-process \
    php-xml \
    php-mbstring \
    php-sqlsrv \
    php-pgsql \
    php-gd \
    php-pecl-zip \
    which \
    && yum update -y \
    && rm -rf /var/cache/yum/* \
    && echo 'date.timezone=America/Sao_Paulo' > /etc/php.d/00-docker-php-date-timezone.ini \
    && yum -y update bash

RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
    source ~/.bashrc

#INSTALANDO COMPOSER
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN chmod +x /usr/bin/composer

#INSTALANDO XDEBUG
RUN pecl channel-update pecl.php.net
RUN pecl install xdebug-2.9.8 docker-php-ext-enable xdebug-2.9.8

#AJUSTANDO CONFIGURAÇÕES DO PHP
RUN sed -E -i -e 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' /etc/php.ini && \
    sed -E -i -e 's/display_errors = Off/display_errors = On/' /etc/php.ini

#
# UTC Timezone & Networking
#
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
    && echo "NETWORKING=yes" > /etc/sysconfig/network


CMD /usr/sbin/httpd -c "ErrorLog /dev/stdout" -DFOREGROUND
