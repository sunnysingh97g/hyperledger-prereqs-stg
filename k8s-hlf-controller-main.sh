gcloud compute instances create controller-main-0 \
    --async \
    --boot-disk-size 200GB \
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

    gcloud compute scp ./installpkg.sh controller-main-0:~/