FROM ubuntu

sudo apt-get update
sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev \
  libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

# Install Rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Install 'rbenv install' command
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
sudo ~/.rbenv/plugins/ruby-build/install.sh

# Install Nginx
sudo apt-get install nginx

# Install Postgresql
sudo apt-get install postgresql

rbenv install 2.3.1
