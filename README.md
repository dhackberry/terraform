# terraform

version 1.1.3

# Using docker

docker version: v20.10.18
```
cd docker
docker compose build --no-cache
docker compose up -d

docker compose exec tf-azcli az login --use-device-code
docker compose exec tf-azcli terraform apply
(docker compose exec tf-azcli /bin/ash)

#VM一括起動/停止
az vm list -g <rg-xxx> --query "[].name" -otsv | xargs -n1 az vm stop -g <rg-xxx> -n --no-wait
```

