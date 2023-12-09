# terraform

```
terraform version
Terraform v1.2.4
on darwin_arm64
+ provider registry.terraform.io/hashicorp/azurerm v2.99.0
+ provider registry.terraform.io/hashicorp/local v2.2.3
+ provider registry.terraform.io/hashicorp/tls v3.4.0
```

# How to access
```
# ssh
az network bastion ssh --n bas-${env} -g rg-${user}-${env} --target-resource-id (az vm show -g rg-${user}-${env} -n vm-${env} | jq -r .id) --auth-type ssh-key --username ${user}user --ssh-key ./bas_ssh_key.pem

# tunneling
az network bastion tunnel -n bas-${env} -g rg-${user}-${env} --target-resource-id (az vm show -g rg-${user}-${env} -n vm-${env} | jq -r .id)  --resource-port 22  --port 10200
ssh enkuser@localhost -p 10200 -i ~/path/to/bas_ssh_key.pem
```