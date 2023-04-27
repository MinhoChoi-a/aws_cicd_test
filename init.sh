# create ecs cluster
# create ec2 instance follwing the requirements what we set on ecs cluster
# ec2 should have role("containerService...") to serve ecs

# git clone to get code

sudo systemctl stop apache2
sudo wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key

cd /etc/apt
sudo echo "deb http://nginx.org/packages/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" nginx" >> ./sources.list
sudo echo "deb-src http://nginx.org/packages/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" nginx" >> ./sources.list

sudo apt-get update
sudo apt-get install nginx
sudo systemctl start nginx.service
#
cd /etc/nginx/conf.d
sudo mv ./default.conf ./default.conf.bak
sudo touch ./server1.conf
sudo echo "server { root /home/ubuntu/public_html; location /osrm/route/default { proxy_pass http://localhost:5000/route/v1/driving; } location /osrm/route/avoidtoll { proxy_pass http://localhost:5001/route/v1/driving; } }" > ./server1.conf
sudo nginx -s reload

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
sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-ecs-agent-us-west-2/amazon-ecs-init-latest.amd64.deb
sudo dpkg -i amazon-ecs-init-latest.amd64.deb
sudo systemctl start ecs