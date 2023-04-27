sudo mkdir -p /etc/ecs
sudo tee /etc/ecs/ecs.config << EOF
ECS_CLUSTER=cicd-test-cluster
EOF

sudo yum install -y ecs-init
sudo service docker start
sudo service ecs start
