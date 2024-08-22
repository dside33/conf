#!/bin/bash

OAUTH_TOKEN=''

setup_creds() {
    yc config profile create side2
    yc config set token $OAUTH_TOKEN
    yc config set folder-id ""
    yc config list
}

case $OSTYPE in
        linux-gnu)
                if [ -f /etc/redhat-release ]; then
                        sudo yum update -y
                        sudo yum update -y
                        echo "Redhat"
                elif [ -f /etc/lsb-release ]; then
                        sudo apt update
                        sudo apt install -y curl

                fi
                ;;

        darwin)
                brew install curl
                ;;

        msys)
                echo "windows"
                ;;
esac

curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash

echo "Обновление сессии оболочки..."
source ~/.bashrc || exec -l $SHELL

setup_creds
