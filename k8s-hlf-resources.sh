gcloud compute networks create k8s-hlf-net-01 --subnet-mode custom

gcloud compute networks subnets create k8s-hlf-subnet-01 \
  --network k8s-hlf-net-01 \
  --range 10.240.0.0/24

gcloud compute firewall-rules create k8s-hlf-01-net-allow-internal \
  --allow tcp,udp,icmp \
  --network k8s-hlf-net-01 \
  --source-ranges 10.240.0.0/24,10.200.0.0/16

gcloud compute firewall-rules create k8s-hlf-net-01-allow-external \
  --allow tcp:22,tcp:6443,icmp \
  --network k8s-hlf-net-01 \
  --source-ranges 0.0.0.0/0

gcloud compute firewall-rules list --filter="network:k8s-hlf-net-01"

gcloud compute addresses create k8s-hlf-01 \
  --region $(gcloud config get-value compute/region)

gcloud compute addresses list --filter="name=('k8s-hlf-01')"

for i in 0 1 2; do
  gcloud compute instances create worker-node-${i} \
    --async \
    --boot-disk-size 50GB \
    --can-ip-forward \
    --image-family centos-7 \
    --image-project centos-cloud \
    --machine-type e2-standard-2 \
    --private-network-ip 10.240.0.1${i} \
    --subnet k8s-hlf-subnet-01 \
    --tags k8s-hlf,controller,master \
    --maintenance-policy=MIGRATE \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --no-shielded-secure-boot 
done

for i in 0 1 2; do
  gcloud compute instances create worker-node-${i} \
    --async \
    --boot-disk-size 50GB \
    --can-ip-forward \
    --image-family centos-7 \
    --image-project centos-cloud \
    --machine-type e2-standard-2 \
    --private-network-ip 10.240.0.1${i} \
    --subnet k8s-hlf-subnet-01 \
    --tags k8s-hlf,controller,master \
    --maintenance-policy=MIGRATE \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --no-shielded-secure-boot 
done

for i in 0 1 2; do
echo controller-node-${i} worker-node-${i}
  gcloud compute scp ./installpkg.sh controller-node-${i}:~/
  gcloud compute ssh controller-node-${i} --command 'chmod 775 installpkg.sh && ls -ltr' &
  gcloud compute scp ./installpkg.sh worker-node-${i}:~/
  gcloud compute ssh worker-node-${i} --command 'chmod 775 installpkg.sh && ls -ltr' &
done

for i in 0 1 2; do
echo controller-node-${i} worker-node-${i}
  gcloud compute scp ./installpkg.sh worker-node-${i}:~/
  gcloud compute ssh worker-node-${i} --command 'chmod 775 installpkg.sh && ls -ltr' &
done


for i in 0 1 2; do
echo controller-node-${i} worker-node-${i}
  gcloud compute scp ./installpkg.sh controller-node-${i}:~/
  gcloud compute ssh controller-node-${i} --command '/bin/bash installpkg.sh'
  gcloud compute scp ./installpkg.sh worker-node-${i}:~/
  gcloud compute ssh worker-node-${i} --command './installpkg.sh'
done