# 🔧 Ansible Powered AWS EC2 Infrastructure Management
This project demonstrates automated provisioning and configuration management using **Ansible** on a set of AWS EC2 Ubuntu instances. The goal is to:

* 🧠 Centrally manage remote servers using Ansible (without manual SSH).

* 🌐 Install and configure NGINX via Ansible playbooks.

* 🚀 Deploy a static website to a production server.

* 🛠️ Showcase infrastructure as code (IaC) and configuration automation capabilities.

---

## 🏗️ Infrastructure Setup

Four EC2 Ubuntu instances were launched on AWS:

| 🖥️ Instance Name | 🔧 Role           | 📦 Installation            |
| ----------------- | ----------------- | -------------------------- |
| `ansible-master`  | 🧭 Control Node   | 🛠️ `Ansible` on Master    |
| `server-1`        | 🌐 Web Server     | 📥 `nginx` by Master       |
| `server-2`        | 🌐 Web Server     | 📥 `nginx` by Master       |
| `server-3`        | 🌍 Production Web | 🖼️ `static web host` by Master |

> 🔐 All instances were launched with the **same SSH key** named `ansible-master.pem`.

---

## 📂 Project Structure

```swift
project/
├── 🔑 keys/
│   └── ansible-master.pem
├── 📁 /etc/ansible/hosts (default inventory)
├── 📜 scritps/
│   ├── install_nginx.yml
│   └── install_nginx_static.yml
│   └── install_ansible.sh
│   └── index.html
```
## 🚀 Prerequisites

Before you begin, ensure you have the following ready:

* **AWS Account:** Access to launch and manage EC2 instances.

* **Key Pair (.pem file):** A valid SSH key pair for connecting to your EC2 instances.

* **Security Groups:** Properly configured to allow inbound traffic on ports:

  * SSH (22)
  * HTTP (80)
  * HTTPS (443)
* **Basic Knowledge:**

  * SSH and Linux command line

  * Basic understanding of Ansible and YAML syntax

* **Local Environment:**

  * `ssh` client installed (Linux/Mac) or `git bash` on windows

  * `scp` command for secure file transfer

* **Ubuntu EC2 Instances:** Recommended AMI versions compatible with Ansible and NGINX installation.

---
## 🏗️ Create Infrastructure

To begin the project, launch 4 EC2 instances on AWS.

Steps to launch EC2 Instances, [click\_here](https://github.com/iam-avinash-jagtap/Linux-Server-Deployment-on-AWS-E2.git)

📝 *Note:- Ensure that the correct **key pair name** and **AMI (Amazon Machine Image)** are selected before launching the instances. Additionally, make sure to allow inbound traffic for **SSH (port 22)**, **HTTP (port 80)**, and **HTTPS (port 443)** in the security group settings.*

![Running_instances](https://github.com/iam-avinash-jagtap/Ansible-Powered-AWS-EC2-Infrastructure-Management/blob/master/Images/Running%20Instances.png)

---

## ⚙️ Configuration Steps

### 🔐 Step 1: Access the Ansible Master Node

SSH into the Ansible master instance:

```bash
ssh -i "ansible-master.pem" ubuntu@<ansible-master-public-ip>
```

---

### 🛠️ Step 2: Install Ansible on Master Node

To manage `server-nodes` Install **Ansible** on Master mode:

1. 📥 Clone repository to access `install_ansible.sh` script:

```bash
git clone https://github.com/iam-avinash-jagtap/Ansible-Powered-AWS-EC2-Infrastructure-Management.git
# Rename Directory 
mv Ansible Powered AWS EC2 Infrastructure Management/ project
```

2. 📂 Navigate to `scripts` Directory:

```bash
cd project/scripts

# Then Verify all playbooks and scritps
```

3. ✅ Assign permission and run script:

```bash
# Assign permisson 
chmod +x install_ansible.sh

# Run script to install ansible
./install_ansible.sh
```

4. 🧪 Verify ansible installation:

```bash
ansible --version
```

---

### 🔑 Step 3: Transfer the PEM Key on Master node

To connect servers using SSH ansible master needs private key, using `SCP` copy key

1. 📁 Create new Directory -`keys`:

```bash
mkdir keys
```

2. 💻 Open another Terminal

3. 📍 Navigate to priavte key location

4. 📤 Use `SCP` Command:

```bash
scp -i ansible-master.pem ansible-master.pem ubuntu@<ansible-master-ip>:/home/ubuntu/project/keys/
```

5. 🔐 Ensure the key file has correct permissions:

```bash
chmod 400 /home/ubuntu/project/keys/ansible-master.pem
```

✅ Ansible is installed and PEM key configured — ready to begin lab setup!

---

### 🧪 Step 4: Ansible setup Lab

✅ After setting up Ansible and configuring the PEM key, the lab environment is ready using server public IPs and key — prepared to perform automation tasks.

1. 📝 Edit `/etc/ansible/hosts` file:

```bash
sudo vim /etc/ansible/hosts
```

2. 📋 Copy following Script:

```bash
[servers]
server1 ansible_host=<public_IP of server-1>
server2 ansible_host=<public_IP of server-2>

[prd]
server3 ansible_host=<public_IP of server-3>

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/ubuntu/project/keys/ansible-master.pem
```
_Note:- Ensure you correctly paste the public IP addresses of your servers in the configuration file, and double-check all settings before running any commands._

3. 🧪 Test lab setup:

```bash
ansible all -m ping
```

![ping](https://github.com/iam-avinash-jagtap/Ansible-Powered-AWS-EC2-Infrastructure-Management/blob/master/Images/Ping.png)

4. 💡 Check memory usage on all managed servers using ad-hoc command:

```bash
ansible all -a "free -h"
```

![ad-hoc](https://github.com/iam-avinash-jagtap/Ansible-Powered-AWS-EC2-Infrastructure-Management/blob/master/Images/ad-hoc.png)

---

### 🌐 Step 5: Install nginx on Servers

Now install Nginx on servers (server-1, server-2). The playbook is already prepared — you just need to execute the `ansible-playbook` command.

```bash
ansible-playbook install_nginx.yml
```

![Install_nginx](https://github.com/iam-avinash-jagtap/Ansible-Powered-AWS-EC2-Infrastructure-Management/blob/master/Images/Install%20nginx.png)

#### ✅ Nginx has been successfully installed and activated on server-1 and server-2.
- Copy the Public IP of `server-1` or `server-2` from your AWS EC2 dashboard.

- Open your browser and visit: `http://<Public_IP_of_Server-1>`
  
![Nginx_webserver](https://github.com/iam-avinash-jagtap/Ansible-Powered-AWS-EC2-Infrastructure-Management/blob/master/Images/nginx_webpage.png)  

---

### 🌍 Step 6: Install nginx on prod with static website

Now install nginx on prod (server-3). The playbook is already prepared - you just need to execute the `ansible-playbook` command.

```bash
ansible-playbook install_nginx_static.yml
```

![Install_Nginx_Static_Website](https://github.com/iam-avinash-jagtap/Ansible-Powered-AWS-EC2-Infrastructure-Management/blob/master/Images/Install%20nginx%20%20static.png)

#### ✅ Nginx has been successfully installed and activated on server-3, and a static website has also been hosted on it.

- Copy the Public IP of `server-1` or `server-2` from your AWS EC2 dashboard.

- Open your browser and visit: `http://<Public_IP_of_Server-3>`

![Static_Website](https://github.com/iam-avinash-jagtap/Ansible-Powered-AWS-EC2-Infrastructure-Management/blob/master/Images/Static%20Website.png)

---

### ✅ Outcome

✔️ Successfully managed 3 EC2 servers using Ansible from a single control node without manual SSH login.

✔️ Installed NGINX on remote servers with a simple YAML playbook.

✔️ Deployed a personal static site automatically on a production server.

---

### 📘 Skills Demonstrated

* 🗂️ Ansible Inventory & Configuration

* 🔐 Secure SSH Key Management
  
* ⚡ Ad-Hoc Ansible Commands

* 📜 Playbook Design

* 🛠️ Web Server Setup

* 🌐 Static Website Deployment

---

## 📌 Summary

This project showcases the power of Ansible in managing AWS EC2 infrastructure with complete automation. Using a centralized Ansible control node (ansible-master), we managed three additional EC2 Ubuntu servers (server-1, server-2, server-3) without using traditional SSH logins. 🔐 The PEM key was securely transferred and configured, and a custom Ansible inventory file allowed logical grouping of servers into environments like `[servers]` and `[prd]`. Basic connectivity and memory usage were validated using Ansible ad-hoc commands, demonstrating real-time infrastructure interaction from a single control point.

Beyond configuration, Ansible playbooks were leveraged to automate NGINX installation on two web servers and to deploy a static website on the production server. This project illustrates key DevOps practices such as Infrastructure as Code (IaC), automated provisioning, and configuration management. It not only simplifies server administration but also reflects real-world scenarios like centralized management, scalable deployments, and automated service delivery — essential skills for any DevOps Engineer. 💼🌐🧑‍💻

---
