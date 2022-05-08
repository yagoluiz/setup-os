# /bin/bash

echo "init"

mkdir ~/setup-temp

sudo apt update && sudo apt upgrade

echo "installing curl" 
sudo apt install curl -y

echo "installing clipboard"
sudo apt install xclip -y

echo "utilities"

echo "installing chrome" 
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

echo "spotify"
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt update && sudo apt install spotify-client

echo "vlc"
sudo apt install vlc -y

echo "comunication"

echo "Use Slack for comunication? (y/n)"
read comunication_slack
if echo "$comunication_slack" | grep -iq "^y" ;then
	wget https://downloads.slack-edge.com/releases/linux/4.23.0/prod/x64/slack-desktop-4.23.0-amd64.deb
    sudo apt install ./slack-desktop-*.deb -y
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

echo "What email do you want to use in GIT user.email?"
echo "For example, mine will be \"yago.luiz@hotmail.com\""
read git_config_user_email
git config --global user.email $git_config_user_email

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

echo "installing VS Code"
wget https://az764295.vo.msecnd.net/stable/899d46d82c4c95423fb7e10e68eba52050e30ba3/code_1.63.2-1639562499_amd64.deb -O vscode.deb
sudo dpkg -i vscode.deb

echo "NodeJS developer? (y/n)"
read developer_node
if echo "$developer_node" | grep -iq "^y" ;then
    echo "installing nvm" 
    sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

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

    sudo apt install yarn -y
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Dotnet developer? (y/n)"
read developer_dotnet
if echo "$developer_dotnet" | grep -iq "^y" ;then
    wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb

    echo "installing sdk"
    sudo apt update; \
    sudo apt install -y apt-transport-https && \
    sudo apt update && \
    sudo apt install -y dotnet-sdk-6.0

    echo "installing nuget"
    sh -c "$(wget https://raw.githubusercontent.com/microsoft/artifacts-credprovider/master/helpers/installcredprovider.sh -O -)"

    # error: https://github.com/dotnet/aspnetcore/issues/8449
    echo "installing resolve System.IO.IOException"
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

    echo "installing global packages"
    dotnet tool install --global dotnet-ef
    dotnet tool install --global dotnet-reportgenerator-globaltool  
    dotnet tool install --global dotnet-sonarscanner
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Mono developer? (y/n)"
read developer_mono
if echo "$developer_mono" | grep -iq "^y" ;then
    echo "installing mono"
    sudo apt install gnupg ca-certificates
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
    echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
    sudo apt update
    sudo apt install mono-devel
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Go developer? (y/n)"
read developer_go
if echo "$developer_go" | grep -iq "^y" ;then
    echo "installing go"
    wget -c https://go.dev/dl/go1.18.linux-amd64.tar.gz -O go.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go.tar.gz
    export PATH=$PATH:/usr/local/go/bin
    go version
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "JetBrains developer? (y/n)"
read developer_jetbrains
if echo "$developer_jetbrains" | grep -iq "^y" ;then
    echo "installing jetbrains toolkit"
    wget --show-progress -qO ./toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
    TOOLBOX_TEMP_DIR=$(mktemp -d)
    sudo tar -C "$TOOLBOX_TEMP_DIR" -xf toolbox.tar.gz
    rm ./toolbox.tar.gz
    "$TOOLBOX_TEMP_DIR"/*/jetbrains-toolbox
    rm -r "$TOOLBOX_TEMP_DIR"
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "installing terminator"
sudo apt install terminator -y

echo "installing postman"
wget -c https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
sudo tar -xvzf postman.tar.gz
sudo mv Postman /opt/Postman/
sudo ln -s /opt/Postman/ /usr/local/bin/postman

# desktop icon: sudo vim /usr/share/applications/postman.desktop

# [Desktop Entry]
# Encoding=UTF-8
# Name=Postman
# Exec=/opt/Postman/app/Postman %U
# Icon=/opt/Postman/app/resources/app/assets/icon.png
# Terminal=false
# Type=Application
# Categories=Development;

echo "installing docker" 
sudo apt remove docker docker-engine docker.io containerd runc
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker

docker run hello-world

echo "installing docker-compose" 
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

echo "What is your root user for remove "sudo" docker?"
read docker_user
sudo usermod -aG docker $docker_user

echo "installing docker-slim"
wget -c https://downloads.dockerslim.com/releases/1.37.3/dist_linux.tar.gz
sudo tar -xvf dist_linux.tar.gz
sudo mv dist_linux/docker-slim /usr/local/bin/
sudo mv dist_linux/docker-slim-sensor /usr/local/bin/

echo "installing kubernetes"
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
sudo mkdir -p ~/.local/bin/kubectl
sudo mv ./kubectl ~/.local/bin/kubectl
kubectl version --client

echo "installing minikube"
sudo curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/

echo "installing Dbeaver"
wget -c https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -O dbeaver.deb
sudo dpkg -i dbeaver.deb

echo "installing terraform"
sudo curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update && sudo apt install terraform
terraform -help

echo "Use Filezilla? (y/n)"
read developer_filezilla
if echo "$developer_filezilla" | grep -iq "^y" ;then
    echo "installing filezilla"
    sudo add-apt-repository ppa:n-muench/programs-ppa
    sudo apt update
    sudo apt install filezilla
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "FortiClient VPN? (y/n)"
read forticlient_vpn
if echo "$forticlient_vpn" | grep -iq "^y" ;then
    echo "installing FortiClient VPN"
    wget https://links.fortinet.com/forticlient/deb/vpnagent -O fortinet.deb
    sudo dpkg -i fortinet.deb
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "installing uuid"
sudo apt install uuid

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
    sudo apt install python3-pip
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

    echo "installing azure functions"
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list'
    
    sudo apt install azure-functions-core-tools-3
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Google developer? (y/n)"
read developer_gcp
if echo "$developer_gcp" | grep -iq "^y" ;then
    echo "installing gcp-cli"
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt install apt-transport-https ca-certificates gnupg
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt update && sudo apt install google-cloud-sdk
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Serverless developer? (y/n)"
read developer_serverless
if echo "$developer_serverless" | grep -iq "^y" ;then
    echo "installing serverless framework"
    sudo curl -o- -L https://slss.io/install | bash
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "zsh"

echo "Use oh-my-zsh? (y/n)"
read zsh_developer
if echo "$zsh_developer" | grep -iq "^y" ;then
    echo "installing zsh"
    sudo apt install zsh -y
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    chsh -s /usr/bin/zsh

    echo "installing autosuggestions" 
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    source ~/.zshrc

    if echo "$developer_node" | grep -iq "^y" ;then
        echo "node version install"
        source ~/.zshrc
        nvm --version
        nvm install 16
        nvm alias default 16
        node --version
        npm --version
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "text editor"

echo "installing vim"
sudo apt install vim -y

echo "Setup finished :)"

rm -rf ~/setup-temp
