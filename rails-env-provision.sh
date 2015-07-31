#!/usr/bin/env bash
# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.

OUT=''
#OUT='>/dev/null 2>&1'

function install {
    echo installing $1
    shift
    apt-get -y install "$@"
}

install development-tools build-essential
install apt-get-transport apt-transport-https ca-certificates

echo adding key for passenger
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7

echo updating package information
UMASK_ORIG=$(umask -p)
umask 0177
echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main' \
    > /etc/apt/sources.list.d/phusionpassenger-passenger-trusty.list
echo 'deb https://deb.nodesource.com/node_0.12 trusty main'\
    > /etc/apt/sources.list.d/nodesource-nodejs-trusty.list
echo 'deb-src https://deb.nodesource.com/node_0.12 trusty main'\
    >> /etc/apt/sources.list.d/nodesource-nodejs-trusty.list
$UMASK_ORIG
apt-add-repository -y ppa:brightbox/ruby-ng
apt-add-repository -y ppa:chris-lea/node.js
apt-add-repository -y ppa:nginx/stable
apt-get -y update

echo installing core libraries
install Libs zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev \
        python-software-properties libffi-dev

install Ruby ruby2.1 ruby2.1-dev
update-alternatives --set ruby /usr/bin/ruby2.1
update-alternatives --set gem /usr/bin/gem2.1

install Git git
install SQLite sqlite3 libsqlite3-dev
install Curl curl libcurl4-openssl-dev
install ImageMagick imagemagick libmagickwand-dev
install NodeJS nodejs
install Nginx nginx nginx-extras passenger
install PostgreSQL postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser vagrant
sudo -u postgres createdb -O vagrant activerecord_unittest
sudo -u postgres createdb -O vagrant activerecord_unittest2

echo "gem: --no-ri --no-rdoc" > /etc/gemrc

echo install gems
gem install bundler
gem install rubygems-bundler
gem install rails
gem install execjs

usermod -a -G www-data ubuntu
usermod -a -G www-data vagrant
# sed -e 's,# passenger_root,passenger_root,' -e 's,# passenger_ruby,passenger_ruby,'\
#     -i /etc/nginx/nginx.conf
cat > /etc/nginx/conf.d/passanger.conf <<EOF
passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
passenger_ruby /usr/bin/ruby;
passenger_show_version_in_header off;
passenger_max_pool_size 10;
EOF

cat > /etc/nginx/sites-enabled/rails.project <<EOF
server {
  listen 80;
  server_name rails.project;
  charset utf-8;
  root /var/www/rails.project/public;
  passenger_enabled on;
  rails_spawn_method smart;
  rails_env development;
}
EOF
mkdir -p /var/www
chown www-data:www-data /var/www
cd /var/www
rails new rails.project

service nginx stop
service nginx start
