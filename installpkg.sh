sudo localectl set-locale LANG=en_US.UTF-8
localectl set-locale LANG=en_US.UTF-8
sudo yum install langpacks-en glibc-all-langpacks -y
sudo yum clean all -y
sudo yum update -y
sudo yum install curl -y
sudo yum install wget -y
sudo yum install git -y
sudo yum install yum-plugin-downloadonly -y
sudo yum install yum-utils createrepo httpd -y
sudo yum install epel-release -y
sudo yum clean all -y
sudo yum groupinstall "Development tools" -y
sudo yum install device-mapper-persistent-data lvm2 -y
sudo yum install python2 -y
sudo yum install nodejs -y
sudo yum install yum-utils device-mapper-persistent-data lvm2 -y
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum update -y
sudo yum install containerd.io-1.2.13 -y
sudo yum install docker-ce-19.03.11 -y
sudo yum docker-ce-cli-19.03.11 -y
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo ssystemctl enable docker
sudo usermod -aG docker $USER
sudo yum install docker-compose -y
sudo yum clean all -y
sudo yum update -y
wget https://golang.org/dl/go1.14.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.14.4.linux-amd64.tar.gz
mkdir -p go/{src/github.com/sunnysingh07g,bin,pkg}
cat <<EOF >> ./.bash_profile
  export GOPATH=/home/shishirsingh66/go
  export GOPATHBIN=$GOPATH/bin
  export GOROOT=/usr/local/go
  export GOBIN=$GOROOT/bin
  export PATH=$PATH:$GOBIN:$GOPATHBIN
EOF
mkdir -p ~/go/src/github.com/sunnysingh97gi && mkdir -p ~/go/bin && mkdir -p ~/go/pkg
source ./.bash_profile
sudo cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable kubelet
sudo systemctl start kubelet
sudo swapoff -a
# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
grep disabled /etc/selinux/config | grep -v ‘#’
sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
 net.bridge.bridge-nf-call-ip6tables = 1
 net.bridge.bridge-nf-call-iptables = 1
EOF
sudo cat <<EOF | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables
1
EOF
sudo cat <<EOF | sudo tee /proc/sys/net/ipv4/ip_forward
1
EOF
sudo sysctl net.bridge.bridge-nf-call-ip6tables=1
sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo sysctl --system
sudo systemctl stop firewalld
sudo systemctl disable firewalld
lsmod | grep br_netfilter
sudo modprobe br_netfilter
#TCP	Inbound	6443*	Kubernetes API server	All
#TCP	Inbound	2379-2380	etcd server client API	kube-apiserver, etcd
#TCP	Inbound	10250	Kubelet API	Self, Control plane
#TCP	Inbound	10251	kube-scheduler	Self
#TCP	Inbound	10252	kube-controller-manager	Self
#TCP	Inbound	10250	Kubelet API	Self, Control plane
#TCP	Inbound	30000-32767	NodePort Services†	All
#sudo cat /sys/class/dmi/id/product_uuid
#sudo kubeadm init —pod-network-cidr=10.240.0.0/16
#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config
#export KUBECONFIG=/etc/kubernetes/admin.conf