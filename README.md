![alt text](https://craftech.io/blog/wp-content/uploads/2022/02/keda-sqs.drawio.png)

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


## TERRAFORM

### Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.39.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_master"></a> [master](#module\_master) | ./modules/master | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |
| <a name="module_node"></a> [node](#module\_node) | ./modules/node | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_sqs_queue.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | `"keda-eks"` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | n/a | `number` | `1` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | n/a | `string` | `"1.22"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | n/a | `number` | `1` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | n/a | `number` | `0` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-2"` | no |

## Outputs

No outputs.
