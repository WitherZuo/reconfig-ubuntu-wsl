#!/bin/bash

if (whiptail --title "重要！需要您留意的事项" --yesno "该远程脚本将对您的 Ubuntu 实例进行开箱预先配置，具体来说，脚本执行完毕后，您的 Ubuntu 实例中将会被安装在脚本中已写明的组件，并配置和启用 Powerline 终端体验、Node 版本管理器、mesa 管理组件等内容，以及修改 Ubuntu 的更新通道为 normal。\n\n如果脚本执行完毕后终端并未自动刷新和加载 Powerline，您可以通过执行 [source ~/.bashrc] 手动加载（仅需执行一次）；\n\n在脚本执行完毕后，您可以通过执行 [sudo do-release-upgrade] 升级 Ubuntu 到更新版本。\n\n已经准备好了？请选中 [我已知晓] 继续，否则请选中 [暂不执行] 退出。" --yes-button "我已知晓" --no-button "暂不执行" --fullbuttons 20 90) then
    # Pre-install and update.
    sudo apt update -y
    sudo apt upgrade -y

    # Install and remove some compoments.
    sudo apt update -y
    sudo apt install -y vim git build-essential gedit fonts-roboto fonts-noto mesa-utils zip neofetch
    sudo apt remove snapd -y
    git --version
    zip --version

    # Configure powerline-go and .dircolors
    wget https://download.fastgit.org/justjanne/powerline-go/releases/download/v1.21.0/powerline-go-linux-amd64 -O ~/powerline-go
    chmod +x ~/powerline-go

    cp ~/.bashrc ~/.bashrc.backup

    dircolors -p > ~/.dircolors
    sed --in-place 's/OTHER_WRITABLE 34;42/OTHER_WRITABLE 34;01/g' ~/.dircolors

    echo '    
    # Powerling-go settings.
    function _update_ps1() {
        PS1="$($HOME/powerline-go -modules venv,user,host,ssh,cwd,perms,git,hg,jobs,exit,root,time -newline -error $?)"
    }

    if [ "$TERM" != "linux" ] && [ -f "$HOME/powerline-go" ]; then
            PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
    fi

    # dircolors configuration.
    if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
            alias ls="ls --color=auto"
            alias dir="dir --color=auto"
            alias vdir="vdir --color=auto"
            alias grep="grep --color=auto"
            alias fgrep="fgrep --color=auto"
            alias egrep="egrep --color=auto"
    fi' >> ~/.bashrc

    source ~/.bashrc

    # Configure nvm (Node version manager).
    cd ~/
    git clone https://hub.fastgit.xyz/nvm-sh/nvm.git .nvm
    cd ~/.nvm
    git checkout v0.39.1
    . ./nvm.sh

    echo '    
    # nvm configuration.
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.bashrc

    echo '    
    # nvm configuration.
    export NVM_DIR="$HOME/.nvm"
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

    # Configure Startup Actions.
    echo 'cd ~ && clear' >> ~/.bashrc
    echo 'cd ~ && clear' >> ~/.profile

    source ~/.bashrc
    source ~/.profile
else
    echo "Bye-bye."
fi
