sudo systemctl stop httpd
sudo wget http://nginx.org/keys/nginx_signing.key
sudo rpm --import nginx_signing.key

sudo tee /etc/yum.repos.d/nginx.repo << EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/amazon/2/x86_64/
gpgcheck=0
enabled=1
EOF

sudo yum update
sudo yum install nginx
sudo systemctl start nginx

sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
sudo tee /etc/nginx/conf.d/server1.conf << EOF
server {
    root /home/ec2-user/public_html;
    location / {
        proxy_pass http://localhost:8080;
    }
}
EOF

sudo nginx -s reload

sudo amazon-linux-extras install docker
sudo curl -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest
sudo chmod +x /usr/local/bin/ecs-cli
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

sudo mkdir -p /etc/ecs
sudo tee /etc/ecs/ecs.config << EOF
ECS_CLUSTER=cicd-test-cluster
EOF

sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-ecs-agent-us-west-2/latest/ecs-agent.rpm
sudo rpm -i ecs-agent.rpm
sudo systemctl start ecs