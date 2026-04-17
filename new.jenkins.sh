#!/bin/bash
# Give execute permission
chmod +x jenkins.sh

# Update system
sudo yum update -y

# Add Jenkins repo
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import Jenkins key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Upgrade packages
sudo yum upgrade -y

# Install Java and Jenkins
sudo yum install java-21-amazon-corretto -y
sudo yum install jenkins git -y

# Create Jenkins own temp directory (SAFE - avoids /tmp issues)
sudo mkdir -p /var/jenkins_tmp
sudo chown jenkins:jenkins /var/jenkins_tmp
sudo chmod 1777 /var/jenkins_tmp

# Tell Jenkins to use its own temp directory
sudo mkdir -p /etc/systemd/system/jenkins.service.d/
sudo bash -c 'cat > /etc/systemd/system/jenkins.service.d/override.conf << EOF
[Service]
Environment="JAVA_OPTS=-Djava.io.tmpdir=/var/jenkins_tmp"
EOF'

# Reload systemd to pick up the override
sudo systemctl daemon-reload

# Enable and start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
