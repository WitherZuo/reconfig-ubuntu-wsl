#!/bin/bash

# Pre-install and update.
sudo apt update -y
sudo apt upgrade -y

# Configure Microsoft Edge Dev sources.
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
sudo rm microsoft.gpg

# Install and remove some compoments.
sudo apt update -y
sudo apt install -y vim git build-essential golang-go microsoft-edge-dev gedit fonts-roboto fonts-noto mesa-utils zip
sudo apt remove snapd -y
git --version
zip --version

# Configure Go Proxy settings.
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.io,direct

# Install powerline-go.
go get -u github.com/justjanne/powerline-go

# Configure powerline-go and .dircolors
sudo cp ~/.bashrc ~/.bashrc.backup

dircolors -p > ~/.dircolors
sed --in-place 's/OTHER_WRITABLE 34;42/OTHER_WRITABLE 34;01/g' ~/.dircolors

echo '# Powerling-go settings.
GOPATH=$HOME/go
function _update_ps1() {
	PS1="$($GOPATH/bin/powerline-go -modules venv,user,host,ssh,cwd,perms,git,hg,jobs,exit,root,time -newline -error $?)"
}

if [ "$TERM" != "linux" ] && [ -f "$GOPATH/bin/powerline-go" ]; then
	    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls="ls --color=auto"
        alias dir="dir --color=auto"
        alias vdir="vdir --color=auto"
        alias grep="grep --color=auto"
        alias fgrep="fgrep --color=auto"
        alias egrep="egrep --color=auto"
fi' >> ~/.bashrc

# Configure nvm (Node version manager).
cd ~/
git clone https://hub.fastgit.org/nvm-sh/nvm.git .nvm
cd ~/.nvm
git checkout v0.38.0
. ./nvm.sh

echo 'export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.bashrc

echo 'export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.profile

# Reload all .bashrc and .profile
source ~/.bashrc
source ~/.profile

# Install Node.js with nvm, and then configure them.
nvm install node # "node" is an alias for the latest version
nvm install --lts # Install Node.js LTS version
nvm use --lts # make Node.js LTS version to default choice.

node -v
npm -v

npm config set registry https://registry.npm.taobao.org
npm install yarn -g
yarn -v
yarn config set registry https://registry.npm.taobao.org

# Configure your Ubuntu distro to the latest non-LTS version update channel.
sudo apt install update-manager-core -y
sudo sed --in-place 's/Prompt=lts/Prompt=normal/g' /etc/update-manager/release-upgrades
sudo apt update -y && sudo apt upgrade -y

# Configure OpenGL renderer for WSLg.
sudo add-apt-repository ppa:kisak/kisak-mesa
sudo apt-get update -y && sudo apt dist-upgrade

# Update Ubuntu to latest version.
sudo do-release-upgrade
