#!/bin/bash

#Update the pacjage list 
sudo apt update -y
sudo apt install -y git curl wget vim
sudo apt upgrade -y

#Install Java (required by jenkins )
sudo apt install -y openjdk-17-jdk