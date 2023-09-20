#/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
docker pull justalternate/justmonitor-image
docker run -d -p 80:8080 justmonitor-image
