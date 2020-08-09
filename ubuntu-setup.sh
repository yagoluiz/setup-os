echo 'init'

sudo apt-get update

echo 'installing curl' 
sudo apt install curl -y

echo 'utilities'

echo 'installing spotify' 
snap install spotify

echo 'installing chrome' 
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

echo 'comunication'

echo "Use Slack for comunication? (y/n)"
read comunication_slack
if echo "$comunication_slack" | grep -iq "^y" ;then
	wget https://downloads.slack-edge.com/linux_releases/slack-desktop-3.3.8-amd64.deb
  sudo apt install ./slack-desktop-*.deb -y
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Use Teams for comunication? (y/n)"
read comunication_teams
if echo "$comunication_teams" | grep -iq "^y" ;then
	sudo snap install teams-for-linux
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Use Franz for comunication? (y/n)"
read comunication_franz
if echo "$comunication_franz" | grep -iq "^y" ;then
	wget https://github.com/meetfranz/franz/releases/download/v5.1.0/franz_5.1.0_amd64.deb -O franz.deb
    sudo dpkg -i franz.debchristian-kohler.path-intellisense
    sudo apt-get install -y -f 
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo 'dev'

echo 'installing git' 
sudo apt install git -y

echo "What name do you want to use in GIT user.name?"
echo "For example, mine will be \"Yago Luiz\""
read git_config_user_name
git config --global user.name "$git_config_user_name"
clear 

echo "What email do you want to use in GIT user.email?"
echo "For example, mine will be \"yago.luiz@hotmail.com\""
read git_config_user_email
git config --global user.email $git_config_user_email
clear

echo "Can I set VIM as your default GIT editor for you? (y/n)"
read git_core_editor_to_vim
if echo "$git_core_editor_to_vim" | grep -iq "^y" ;then
	git config --global core.editor vim
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Generating a SSH Key"
ssh-keygen -t rsa -b 4096 -C $git_config_user_email
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

echo 'enabling workspaces for both screens' 
gsettings set org.gnome.mutter workspaces-only-on-primary false

echo 'installing zsh'
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s /bin/zsh

echo 'installing tool to handle clipboard via CLI'
sudo apt-get install xclip -y

export alias pbcopy='xclip -selection clipboard'
export alias pbpaste='xclip -selection clipboard -o'
source ~/.zshrc

echo 'installing vim'
sudo apt install vim -y
clear

echo 'installing code'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y # or code-insiders

echo 'installing extensions'
code --install-extension ms-vscode.azure-account
code --install-extension ms-azuretools.vscode-azurefunctions
code --install-extension ms-dotnettools.csharp
code --install-extension k--kato.docomment
code --install-extension cake-build.cake-vscode
code --install-extension ryanluker.vscode-coverage-gutters
code --install-extension ms-azuretools.vscode-docker
code --install-extension dbaeumer.vscode-eslint
code --install-extension donjayamanne.githistory
code --install-extension github.github-vscode-theme
code --install-extension eamodio.gitlens
code --install-extension hashicorp.terraform
code --install-extension ms-vscode.js-debug-nightly
code --install-extension pkief.material-icon-theme
code --install-extension quicktype.quicktype
code --install-extension ms-python.python
code --install-extension humao.rest-client
code --install-extension yagoluiz.sonar-dotnet-vscode # my extension <3
code --install-extension gruntfuggly.todo-tree
code --install-extension zxh404.vscode-proto3

echo "NodeJS developer? (y/n)"
read developer_node
if echo "$developer_node" | grep -iq "^y" ;then
    echo 'installing nvm' 
    sh -c "$(curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash)"

    export NVM_DIR="$HOME/.nvm" && (
    git clone https://github.com/creationix/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    ) && \. "$NVM_DIR/nvm.sh"

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    source ~/.zshrc
    nvm --version
    nvm install 12
    nvm alias default 12
    node --version
    npm --version
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Dotnet developer? (y/n)"
read developer_dotnet
if echo "$developer_dotnet" | grep -iq "^y" ;then
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb

    echo 'install sdk'
    sudo apt-get install -y apt-transport-https
    sudo apt-get install -y dotnet-sdk-3.1
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo 'installing autosuggestions' 
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
source ~/.zshrc

# themes: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#theme-description-format
echo 'installing theme (wezm)'
sudo apt install fonts-firacode -y
wget -O ~/.oh-my-zsh/themes/wezm.zsh-theme https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/themes/wezm.zsh-theme 
sed -i 's/.*ZSH_THEME=.*/ZSH_THEME="wezm"/g' ~/.zshrc

echo 'installing insomnia'
sudo snap install insomnia

echo 'installing terminator'
sudo apt-get update
sudo apt-get install terminator -y

echo 'installing docker' 
sudo apt-get remove docker docker-engine docker.io
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
docker --version

chmod 777 /var/run/docker.sock
docker run hello-world

echo 'installing docker-compose' 
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
