#!/usr/bin/env bash

# sed -i -e 's~ch.archive.ubuntu.com/ubuntu/~de.archive.ubuntu.com/ubuntu/~' /etc/apt/sources.list

# apt-add-repository ppa:ansible/ansible -y
# apt-get update
# apt-get install ansible -y
# ansible --version
	
echo *********** removing old docker version *******************	

apt-get remove docker docker-engine docker.io

echo *********** update repository for docker *******************	

apt-get update
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
echo *********** install docker ***********
apt-get update
apt-get -qq --allow-unauthenticated install docker-ce

echo *********** get mongo docker image ***********

docker pull mongo

docker run -p 27017:27017 --name duftfinder -d mongo

echo "*********** install mongo tools (only used to access mongo on the docker image) ***********"

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

echo **************** end mongo installed *****************

echo "*********** install netcat ***********"
apt install netcat -y

sleep 7s

echo restarting duftfinder
docker restart duftfinder
docker ps

echo *************** provisioning mongo database ************

echo "Waiting for mongo to be ready:"

until mongo --eval "print(\"waited for connection\")"
  do
    sleep 10s
  done

# until nc -z localhost 27017
# do
#     sleep 5s
# done

echo "counting Role in database duftfinder"
let count=`mongo duftfinder --eval "printjson(db.Role.count());" --quiet`
echo $count



echo "verifiying if $count is equal to 0"
# $count = 0
if [ "$count" == "0" ]
then
    #sleep 3s
    echo "initializing database duftfinder"
    #mongo duftfinder --eval 'var document = {name  : "document_name",title : "document_title",};db.Upsala.insert(document);'
    rm -d -r -f setup
    git clone https://github.com/flozi76/vagrant-linux-docker-vm.git setup


    #sleep 5s
    FILES=setup/DuftfinderData/*

    #cd setup/DuftfinderData
    for f in $FILES
    do
        #echo "Importing $f file to mongodb"

        fullfilename=$f
        filename=$(basename "$fullfilename")
        fname="${filename%.*}"
        ext="${filename##*.}"

        echo $filename
        echo $fname
        #echo $ext
        echo "importing file $f to collection $fname... "
        mongoimport --db duftfinder --collection "$fname" --drop --file "$f"

    # take action on each file. $f store current file name
    #cat $f
    done

    rm -d -r -f setup
else
    echo "database duftfinder allready initialized"    
fi



#echo ******** install minikube ***********
#
##curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.30.0/minikube-linux-amd64 && chmod +x minikube && sudo cp minikube /usr/local/bin/ && rm minikube
#curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
#  && sudo install minikube-linux-amd64 /usr/local/bin/minikube
#
# echo ******** install kubernetes ***********

# sudo apt-get update && sudo apt-get install -y apt-transport-https
# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
# sudo apt-get update
# sudo apt-get -qq --allow-unauthenticated install -y kubectl

echo ################## END ######################