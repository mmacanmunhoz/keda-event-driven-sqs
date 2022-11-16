### After Execution Terraform, Follow Step by Step

### (Step 1) Update KubeConfig

- aws eks update-kubeconfig --name '<Eks Cluster Name>' --region '<Region>'

### (Step 2) Create Policy IAM For SQS (Add ARN Your Queue)

- aws iam create-policy --policy-name '<Name Policy>' --policy-document file://policy/sqs.json

### (Step 3) Create Namespace for KEDA

- kubectl create namespace keda

### (Step 4) Create ServiceAccount for Operator Queda Access SQS

- eksctl create iamserviceaccount --name keda-operator --namespace keda --cluster '<Eks Cluster Name>' --attach-policy-arn '<Arn Policy>' --region '<Region>' --approve

### (Step 5) Deploy KEDA

- helm repo add kedacore https://kedacore.github.io/charts
- helm install keda kedacore/keda --namespace keda --set serviceAccount.create=false --set serviceAccount.name=keda-operator

### (Step 6) Change Info Manifest k8s and Apply (Files in Folder k8s)

- kubectl apply -f deployment.yml
- kubectl apply -f scaleobject.yml

### (Step 7) Monitoring Namespace

- kubectl get pods -w

### (Step 8) Monitoring Operator Keda

- kubectl logs -f '<Name Pod Operator Keda>'

### (Step 9) Upload Message in SQS Queue

for i in `seq 50`; do 
  aws sqs send-message --queue-url '<Url Queue>' --message-body "XXXX" --region '<Region>' --no-cli-pager --output text
done

### (Step 10) Monitoring Pod Scale Up

- kubectl get pods -w

### (Step 11) After Testing Success, Purge Queue

- aws sqs purge-queue --queue-url '<Url Queue>'

### (Step 12) Monitoring Pod Scale Down

- kubectl get pods -w