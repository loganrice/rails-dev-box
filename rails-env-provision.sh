# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    sudo apt-get -y install "$@" > /dev/null
}


echo installing core libraries
install git-all
install curl
install zlib1g-dev
install build-essential
install libssl-dev
install libreadline-dev
install libyaml-dev
install sqlite3
install libsqlite3-dev
install libxml2-dev
install libxslt1-dev
install libcurl4-openssl-dev
install python-software-properties
install libffi-dev
install imagemagick
install libmagickwand-dev
apt-get update

echo installing ruby
sudo git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

sudo git clone git://github.com/sstephenson/ruby-build.git
~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

sudo git clone https://github.com/sstephenson/rbenv-gem-rehash.git
~/.rbenv/plugins/rbenv-gem-rehash

sudo rbenv install 2.2.2
sudo rbenv global 2.2.2

echo 'ruby -v'

echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install bundler
gem install rails
gem install nokogiri


echo installing Ruby on Rails
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
install nodejs
gem install rails -v 4.2.1


echo install PostgreSQL
sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg
main' > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo
apt-key add -
sudo apt-get update
install postgresql-common
install postgresql-9.3 
install libpq-dev
sudo -u postgres createuser  User -s



echo install nginx
echo Install Phusions PGP key to verify packages
gpg --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
gpg --armor --export 561F9B9CAC40B2F7 | sudo apt-key add -

echo Add HTTPS support to APT
install apt-transport-https

echo Add the passenger repository
sudo sh -c "echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger
trusty main' >> /etc/apt/sources.list.d/passenger.list"
sudo chown root: /etc/apt/sources.list.d/passenger.list
sudo chmod 600 /etc/apt/sources.list.d/passenger.list
sudo apt-get update

# Install nginx and passenger
sudo apt-get install nginx-extras passenger
sudo service nginx start





