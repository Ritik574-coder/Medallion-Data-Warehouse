####################################################################################
# PROJECT SETUP: requirement tools for data pipeline (Docker + SQL Server)
# Author: Ritik
# Purpose: Setup virtual environment, install dependencies, configure database
#          credentials, and run the pipeline script.
####################################################################################



################################################################################
################### DOCKER INSTRALLITION AND SETUP #############################
################################################################################
#Install dependencies
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release

#Adding Docker official GPG key
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Adding Docker repository
echo \
"deb [arch=$(dpkg --print-architecture) \
signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Starting and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

#Fixing permission
sudo usermod -aG docker $USER

# Verify versions
docker --version
docker compose version

################################################################################
################### MSSQL INSTRALLITION AND SETUP ##############################
################################################################################
# Pulling SQL Server image
docker pull mcr.microsoft.com/mssql/server:2022-latest

# creting and running container
docker run -e "ACCEPT_EULA=Y" \
    -e "MSSQL_SA_PASSWORD=Ritik@843313" \
    -p 1433:1433 \
    --name sqlserver \
    -v sql_data:/var/opt/mssql \
    -d mcr.microsoft.com/mssql/server:2022-latest

# Check running containers
docker ps

# Check all containers 
docker ps -a

# Check downloaded images
docker images

# Check Docker volumes 
docker volume ls

# Start container 
docker start sqlserver

# Stop container
docker stop sqlserver

# Access container terminal
docker exec -it -u root sqlserver bash


# Add Microsoft repo
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list

# Update
sudo apt update

# Install ODBC Driver 18 
sudo ACCEPT_EULA=Y apt install msodbcsql18

# Optional but useful tools
sudo apt install unixodbc-dev

# This opens SQL CLI (sqlcmd)
docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd 
-S localhost -U sa -P "Ritik@843313"

# moving data 
docker cp /workspaces/dbt_learning_project/dataset sqlserver:/data/

# access SQL serve cli
docker exec -it -u root sqlserver bash

#chage file permition 
chmod -R 777 /workspaces/dbt_learning_project/dataset
################################################################################
########################### ADDING GIT COMMAND  ################################
################################################################################  

# authenticate github account
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"

# create new branch
git branch warehouse_branch

# switch to branch
git switch warehouse_branch

# add single file
git add README.md

# check repository status
git status

# add all files
git add .

# commit changes
git commit -m "Implement bronze layer ETL process"

# commit with co-author
git commit -m "Implement silver layer transformations and data standardization

Co-authored-by: ritsky-project <ritsky598@gmail.com>"

# push changes to github
git push origin warehouse_branch

# view commit history
git log

################################################################################
########################### ADDING SUPERSET COMMAND  ###########################
################################################################################   
# Get Superset 
git clone https://github.com/apache/superset

# Start the latest official release of Superset
# Enter the repository you just cloned
$ cd superset

# Set the repo to the state associated with the latest official version
$ git checkout tags/6.0.0

# Fire up Superset using Docker Compose
$ docker compose -f docker-compose-image-tag.yml up

# Log into Superset 
username: admin
password: admin