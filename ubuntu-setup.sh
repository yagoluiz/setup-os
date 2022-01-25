echo "init"

sudo apt-get update && sudo apt-get upgrade

echo "installing curl" 
apt install curl -y

echo "installing clipboard"
apt-get install xclip -y

echo "utilities"

echo "installing chrome" 
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb

echo "comunication"

echo "Use Slack for comunication? (y/n)"
read comunication_slack
if echo "$comunication_slack" | grep -iq "^y" ;then
	wget https://downloads.slack-edge.com/releases/linux/4.19.2/prod/x64/slack-desktop-4.19.2-amd64.deb
    apt install ./slack-desktop-*.deb -y
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Use Teams for comunication? (y/n)"
read comunication_teams
if echo "$comunication_teams" | grep -iq "^y" ;then
	wget https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_1.4.00.7556_amd64.deb
    apt install ./teams*.deb -y
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Use Franz for comunication? (y/n)"
read comunication_franz
if echo "$comunication_franz" | grep -iq "^y" ;then
	wget https://github.com/meetfranz/franz/releases/download/v5.1.0/franz_5.1.0_amd64.deb -O franz.deb
    dpkg -i franz.deb
    apt-get install -y -f 
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "dev"

echo "installing git" 
apt install git -y

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
apt install gnupg
gpg --default-new-key-algo rsa4096 --gen-key
# export public key: gpg --armor --export {your_email}

echo "enabling workspaces for both screens" 
gsettings set org.gnome.mutter workspaces-only-on-primary false

echo "installing clustergit"
curl -SsLo /usr/local/bin/clustergit https://raw.githubusercontent.com/mnagel/clustergit/master/clustergit
chmod +x /usr/local/bin/clustergit

echo "installing vim"
apt install vim -y
clear

echo "installing VS Code"
wget https://az764295.vo.msecnd.net/stable/7f6ab5485bbc008386c4386d08766667e155244e/code_1.60.2-1632313585_amd64.deb -O vscode.deb
dpkg -i vscode.deb

echo "NodeJS developer? (y/n)"
read developer_node
if echo "$developer_node" | grep -iq "^y" ;then
    echo "installing nvm" 
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

    export NVM_DIR="$HOME/.nvm" && (
    git clone https://github.com/creationix/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    ) && \. "$NVM_DIR/nvm.sh"

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo "installing yarn"
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    sh -c "echo 'deb https://dl.yarnpkg.com/debian/ stable main' >> /etc/apt/sources.list"

    apt-get install yarn -y
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Dotnet developer? (y/n)"
read developer_dotnet
if echo "$developer_dotnet" | grep -iq "^y" ;then
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    dpkg -i packages-microsoft-prod.deb

    echo "installing sdk"
    apt-get install -y apt-transport-https
    apt-get install -y dotnet-sdk-6.0

    echo "installing nuget"
    sh -c "$(wget https://raw.githubusercontent.com/microsoft/artifacts-credprovider/master/helpers/installcredprovider.sh -O -)"

    # error: https://github.com/dotnet/aspnetcore/issues/8449
    echo "installing resolve System.IO.IOException"
    echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p

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
    apt install gnupg ca-certificates
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
    echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list
    apt update
    apt install mono-devel
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Go developer? (y/n)"
read developer_go
if echo "$developer_go" | grep -iq "^y" ;then
    echo "installing go"
    wget -c https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz -O go.tar.gz
    rm -rf /usr/local/go
    tar -C /usr/local -xzf go.tar.gz
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
    tar -C "$TOOLBOX_TEMP_DIR" -xf toolbox.tar.gz
    rm ./toolbox.tar.gz
    "$TOOLBOX_TEMP_DIR"/*/jetbrains-toolbox
    rm -r "$TOOLBOX_TEMP_DIR"
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "installing terminator"
apt-get update
apt-get install terminator -y

echo "installing postman"
snap install postman

echo "installing docker" 
apt-get remove docker docker-engine docker.io containerd runc
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io
systemctl enable docker

docker run hello-world

echo "installing docker-compose" 
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

echo "What is your root user for remove "sudo" docker?"
read docker_user
usermod -aG docker $docker_user

echo "installing kubernetes"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
mkdir -p ~/.local/bin/kubectl
mv ./kubectl ~/.local/bin/kubectl
kubectl version --client

echo "installing minikube"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
mkdir -p /usr/local/bin/
install minikube /usr/local/bin/

echo "installing Dbeaver"
wget -c https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -O dbeaver.deb
dpkg -i dbeaver.deb
apt-get install -f

echo "Use Robo3t? (y/n)"
read developer_robo3t
if echo "$developer_robo3t" | grep -iq "^y" ;then
    echo "installing Robo3t"
    wget -c https://download.studio3t.com/robomongo/linux/robo3t-1.4.3-linux-x86_64-48f7dfd.tar.gz -O robomongo.tar.gz
    tar -xvzf robomongo.tar.gz
    mkdir /usr/local/bin/robo3t
    mv robomongo/* /usr/local/bin/robo3t
    chmod +x robo3t ./robo3t
    # icon and desktop: https://gist.github.com/abdallahokasha/37911a64ad289487387e2d1a144604ae
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "installing uuid"
apt-get install uuid

echo "installing terraform"
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && apt-get install terraform
terraform -help

echo "Use Filezilla? (y/n)"
read developer_filezilla
if echo "$developer_filezilla" | grep -iq "^y" ;then
    echo "installing filezilla"
    add-apt-repository ppa:n-muench/programs-ppa
    apt-get update
    apt-get install filezilla
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "cloud"

echo "AWS developer? (y/n)"
read developer_aws
if echo "$developer_aws" | grep -iq "^y" ;then
    echo "installing aws-cli" 
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install
    aws --version

    echo "installing AWS SAM (Serverless Application Model)"
    apt-get install python3-pip
    pip3 install --user aws-sam-cli
    sam --version
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Azure developer? (y/n)"
read developer_azure
if echo "$developer_azure" | grep -iq "^y" ;then
    echo "installing azure-cli"
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash
    az --version

    echo "installing azure functions"
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list'
    
    apt-get install azure-functions-core-tools-3

    echo "installing storage explorer"
    snap install storage-explorer
    snap connect storage-explorer:password-manager-service :password-manager-service
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Google developer? (y/n)"
read developer_gcp
if echo "$developer_gcp" | grep -iq "^y" ;then
    echo "installing gcp-cli"
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    apt-get install apt-transport-https ca-certificates gnupg
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    apt-get update && apt-get install google-cloud-sdk
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

echo "Use oh-my-zsh? (y/n)"
read zsh_developer
if echo "$zsh_developer" | grep -iq "^y" ;then
    echo "installing zsh"
    apt-get install zsh -y
    sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    chsh -s /bin/zsh

    export alias pbcopy="xclip -selection clipboard"
    export alias pbpaste="xclip -selection clipboard -o"
    source ~/.zshrc

    echo "installing autosuggestions" 
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    source ~/.zshrc

    # themes: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#theme-description-format
    echo "installing theme (wezm)"
    apt install fonts-firacode -y
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
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "bash"

echo "Use oh-my-bash? (y/n)"
read bash_developer
if echo "$bash_developer" | grep -iq "^y" ;then
    echo "installing bash"
    sh -c "$(curl -fsSL https://raw.github.com/ohmybash/oh-my-bash/master/tools/install.sh)"

    #themes: https://github.com/ohmybash/oh-my-bash/tree/master/themes
  
    if echo "$developer_node" | grep -iq "^y" ;then
        echo "node version install"
        source ~/.bashrc
        nvm --version
        nvm install 14
        nvm alias default 14
        node --version
        npm --version
else
	echo "Okay, no problem. :) Let's move on!"
fi

echo "Setup finished :)"
