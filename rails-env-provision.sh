# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.

OUT=''
#OUT='>/dev/null 2>&1'

function install {
    echo installing $1
    shift
    apt-get -y install "$@" ${OUT}
}

install 'development tools' build-essential
install 'apt-get transport' apt-transport-https ca-certificates

echo adding key for passenger
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7

echo updating package information
echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main' \
    > /etc/apt/sources.list.d/passenger.list
apt-add-repository -y ppa:brightbox/ruby-ng ${OUT}
add-apt-repository -y ppa:chris-lea/node.js ${OUT}
add-apt-repository -y ppa:nginx/stable ${OUT}
apt-get -y update ${OUT}

echo installing core libraries
install Libs zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev \
        python-software-properties libffi-dev

install Ruby ruby2.2 ruby2.2-dev
update-alternatives --set ruby /usr/bin/ruby2.2 ${OUT}
update-alternatives --set gem /usr/bin/gem2.2 ${OUT}

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
gem install bundler ${OUT}
gem install rails ${OUT}
gem install nokogiri ${OUT}
gem install rails -v 4.2.1 ${OUT}

sudo service nginx start
