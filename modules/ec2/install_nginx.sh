#!/bin/bash
echo "<h1>------------------------Staring Script !!!--------------------------</h1>"
sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
echo "<h1>Deployed via Terraform !!</h1>" | sudo tee /var/www/html/index.html