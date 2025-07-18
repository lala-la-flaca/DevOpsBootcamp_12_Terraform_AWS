#!/bin/bash
sudo dnf update -y
sudo dnf install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
sleep 10
sudo docker run -d -p 8080:80 nginx 
  
