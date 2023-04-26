sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -sSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch="$(dpkg --print-architecture)"] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo curl -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest
sudo chmod +x /usr/local/bin/ecs-cli
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ubuntu
sudo mkdir -p /etc/ecs
sudo touch /etc/ecs/ecs.config
echo "ECS_CLUSTER=cicd-test-cluster" | sudo tee /etc/ecs/ecs.config
curl -O https://s3.us-west-2.amazonaws.com/amazon-ecs-agent-us-west-2/amazon-ecs-init-latest.amd64.deb
sudo dpkg -i amazon-ecs-init-latest.amd64.deb

#curl -o /tmp/ecs-agent.tar https://amazon-ecs-agent.s3.amazonaws.com/ecs-agent-latest.tar.gz
#sudo tar xzf /tmp/ecs-agent.tar -C /opt
#sudo mkdir -p /var/log/ecs /var/lib/ecs/data /var/lib/ecs/scratch
#sudo docker volume create --name ecs-vol
#sudo docker run --name ecs-agent \
#  --detach=true \
#  --restart=on-failure:10 \
#  --volume=/var/run/docker.sock:/var/run/docker.sock \
#  --volume=/var/log/ecs:/log \
#  --volume=/var/lib/ecs/data:/data \
#  --volume=/var/lib/ecs/scratch:/scratch \
#  --volume=ecs-vol:/var/lib/ecs/volumes \
#  --publish=127.0.0.1:51678:51678 \
#  --env-file=/etc/ecs/ecs.config \
#  amazon/amazon-ecs-agent:latest
