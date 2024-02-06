# WSO2_APIM_HELM_Deployment

## Task 
![image](https://github.com/Nareash20010150/WSO2_APIM_HELM_Deployment/assets/102378093/1cfce687-9b26-47c7-9394-1c9b10ed2b04)
Deploying the Active-Active Api manager deployment shown above in AKS cluster

## Technologies

1. Docker
2. Kubernetes
3. Helm
4. Terraform
5. Azure portal

## prerequisites

1. Azure account
2. Docker installed
3. kubernetes installed
4. helm installed
5. Terraform installed
6. kubens installed

## Steps

### Local environment

1. Move to the repository directory
2. Create and start the minikube node with the command `miniube start`
3. Create namespace 'apim-aks' with the command `kubectl create namespace apim-aks`
4. Move to the new namespace 'apim-aks' with the command `kubens apim-aks`
5. Go to `./apim/values.yaml`
6. Relace the value in EXTERNAL_IP to `localhost`
7. Move back to the previous location
8. Now start deployments
   - `helm install postgres-release postgres/`
   - `helm install apim-release apim/`
   - `helm install adminer-release adminer/`
10. Now access the service with `minkube service apim-service -n apim-aks`
       
### Deployment

1. Move to the repository directory
2. Create namespace 'apim-aks' with the command `kubectl create namespace apim-aks`
3. Move to the new namespace 'apim-aks' with the command `kubens apim-aks`
4. Go to `./terraform-modules/`
5. Create the infrastructure layer using the command
   - `terraform init`
   - `terraform apply`  *type yes to continue*
6. Move back to the previous location
7. Now start deployments
   - `helm install postgres-release postgres/`
   - `helm install apim-release apim/`
   - `helm install adminer-release adminer/`
8. Now display the services and note down the public IP of the apim-release withe the command `kubectl get svc apim-service`
9. Go to `./apim/values.yaml`
10. Relace the value in EXTERNAL_IP with the above public IP.
11. Now upgrade the helm deployment after the update with the command `helm upgrade apim-release apim/`
12. Go to azure portal and make sure the IP addresses in the svc list are added to outbound traffic list.
13. Make sure the IP addresses in the svc list are added to inbound traffic list of AKS cluster's network security group.
14. Now you should be able to access the application publicly with the url
    - `https://<EXTERNAL_IP_OF_APIM_SERVICE>:9443/publisher`
    - `http://<EXTERNAL_IP_OF_ADMINER>:8080`


     
