# SeleniumBase Debian Linux Dependency Installation
# (Installs all required dependencies on Linux)

# Make sure this is only run on Linux
value="$(uname)"
if [ $value == "Linux" ]
then
  echo "Initializing Requirements Setup..."
else
  echo "Not on a Linux machine. Exiting..."
  exit
fi

# Configure apt-get resources
sudo sh -c "echo \"deb http://packages.linuxmint.com debian import\" >> /etc/apt/sources.list"
sudo sh -c "echo \"deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main\" >> /etc/apt/sources.list"

# Install Xvfb (headless display system) and other dependencies
cd ~
sudo aptitude update
sudo aptitude install -y xvfb
sudo aptitude install -y x11-xkb-utils
sudo aptitude install -y xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic
sudo aptitude install -y xserver-xorg-core

# Install Firefox
sudo gpg --keyserver pgp.mit.edu --recv-keys 3EE67F3D0FF405B2
sudo gpg --export 3EE67F3D0FF405B2 > 3EE67F3D0FF405B2.gpg
sudo apt-key add ./3EE67F3D0FF405B2.gpg
sudo rm ./3EE67F3D0FF405B2.gpg
sudo apt-get update
sudo apt-get install -y python-setuptools
sudo apt-get -qy --no-install-recommends install -y firefox
sudo apt-get -qy --no-install-recommends install -y $(apt-cache depends firefox | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ')
cd /tmp
sudo wget --no-check-certificate -O firefox-esr.tar.bz2 'https://download.mozilla.org/?product=firefox-esr-latest&os=linux32&lang=en-US'
sudo tar -xjf firefox-esr.tar.bz2 -C /opt/
sudo rm -rf /usr/bin/firefox
sudo ln -s /opt/firefox/firefox /usr/bin/firefox
sudo rm -f /tmp/firefox-esr.tar.bz2
sudo apt-get -f install -y firefox

# Install more dependencies
sudo apt-get update
sudo apt-get install -y xvfb
sudo apt-get install -y build-essential chrpath libssl-dev libxft-dev
sudo apt-get install -y libfreetype6 libfreetype6-dev
sudo apt-get install -y libfontconfig1 libfontconfig1-dev
sudo apt-get install -y unzip

# Install PhantomJS
cd ~
export PHANTOM_JS="phantomjs-1.9.8-linux-x86_64"
sudo wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
sudo tar xvjf $PHANTOM_JS.tar.bz2
sudo mv -f $PHANTOM_JS /usr/local/share
sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin

# Install Chrome
cd /tmp
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get -f install -y
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Install Chromedriver
sudo wget -N http://chromedriver.storage.googleapis.com/2.20/chromedriver_linux64.zip -P ~/Downloads
sudo unzip -o ~/Downloads/chromedriver_linux64.zip -d ~/Downloads
sudo chmod +x ~/Downloads/chromedriver
sudo rm -f /usr/local/share/chromedriver
sudo rm -f /usr/local/bin/chromedriver
sudo rm -f /usr/bin/chromedriver
sudo mv -f ~/Downloads/chromedriver /usr/local/share/chromedriver
sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
sudo ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

# Other Dependencies
sudo apt-get -f install -y
sudo easy_install pip
