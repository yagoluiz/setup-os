echo "init"

sudo apt-get update

echo "installing curl" 
sudo apt install curl -y

echo "utilities"

echo "installing spotify" 
snap install spotify

echo "installing chrome" 
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

echo "comunication"

echo "Use Slack for comunication? (y/n)"
read comunication_slack
if echo "$comunication_slack" | grep -iq "^y" ;then
	wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.9.1-amd64.deb
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
    sudo dpkg -i franz.deb
    sudo apt-get install -y -f 
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "dev"

echo "installing git" 
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

echo "Generating a GPG Key"
sudo apt install gnupg
gpg --default-new-key-algo rsa4096 --gen-key
# export public key: gpg --armor --export {your_email}

echo "enabling workspaces for both screens" 
gsettings set org.gnome.mutter workspaces-only-on-primary false

echo "installing clustergit"
sudo curl -SsLo /usr/local/bin/clustergit https://raw.githubusercontent.com/mnagel/clustergit/master/clustergit
sudo chmod +x /usr/local/bin/clustergit

echo "installing vim"
sudo apt install vim -y
clear

echo "installing code"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c "echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list"
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y # or code-insiders

echo "Install extensions code? (y/n)"
echo "Install if "Sync is On" not active"
read code_sync
if echo "$code_sync" | grep -iq "^y" ;then
    echo "installing extensions"
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
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "NodeJS developer? (y/n)"
read developer_node
if echo "$developer_node" | grep -iq "^y" ;then
    echo "installing nvm" 
    sh -c "$(curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash)"

    export NVM_DIR="$HOME/.nvm" && (
    git clone https://github.com/creationix/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    ) && \. "$NVM_DIR/nvm.sh"

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo "installing yarn"
    sudo curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    sudo sh -c "echo 'deb https://dl.yarnpkg.com/debian/ stable main' >> /etc/apt/sources.list"

    sudo apt-get install yarn -y
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Dotnet developer? (y/n)"
read developer_dotnet
if echo "$developer_dotnet" | grep -iq "^y" ;then
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb

    echo "installing sdk"
    sudo apt-get install -y apt-transport-https
    sudo apt-get install -y dotnet-sdk-5.0

    echo "installing nuget"
    sh -c "$(wget https://raw.githubusercontent.com/microsoft/artifacts-credprovider/master/helpers/installcredprovider.sh -O -)"

    # error: https://github.com/dotnet/aspnetcore/issues/8449
    echo "installing resolve System.IO.IOException"
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "installing terminator"
sudo apt-get update
sudo apt-get install terminator -y

echo "installing postman"
sudo snap install postman

echo "installing docker" 
sudo apt-get remove docker docker-engine docker.io
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
docker --version

chmod 777 /var/run/docker.sock
docker run hello-world

echo "installing docker-compose" 
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo "What is your root user for remove "sudo" docker?"
read docker_user
sudo usermod -aG docker $docker_user

echo "installing kubernetes"
sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

echo "installing minikube"
sudo curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/

echo "installing Dbeaver"
wget -c https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -O dbeaver.deb
sudo dpkg -i dbeaver.deb
sudo apt-get install -f

echo "installing uuid"
sudo apt-get uuid

echo "cloud"

echo "AWS developer? (y/n)"
read developer_aws
if echo "$developer_aws" | grep -iq "^y" ;then
    echo "installing aws-cli" 
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    aws --version

    echo "installing AWS SAM (Serverless Application Model)"
    sudo apt-get install python3-pip
    pip3 install --user aws-sam-cli
    sam --version
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Azure developer? (y/n)"
read developer_azure
if echo "$developer_azure" | grep -iq "^y" ;then
    echo "installing azure-cli"
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    az --version
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Serverless developer? (y/n)"
read developer_serverless
if echo "$developer_serverless" | grep -iq "^y" ;then
    echo "installing serverless framework"
    curl -o- -L https://slss.io/install | bash
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "zsh"

echo "installing zsh"
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s /bin/zsh

echo "installing tool to handle clipboard via CLI"
sudo apt-get install xclip -y

export alias pbcopy="xclip -selection clipboard"
export alias pbpaste="xclip -selection clipboard -o"
source ~/.zshrc

echo "installing autosuggestions" 
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
source ~/.zshrc

# themes: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#theme-description-format
echo "installing theme (wezm)"
sudo apt install fonts-firacode -y
wget -O ~/.oh-my-zsh/themes/wezm.zsh-theme https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/themes/wezm.zsh-theme 
sed -i "s/.*ZSH_THEME=.*/ZSH_THEME="wezm"/g" ~/.zshrc

if echo "$developer_node" | grep -iq "^y" ;then
    echo "node version install"
    source ~/.zshrc
    nvm --version
    nvm install 14
    nvm alias default 14
    node --version
    npm --version
