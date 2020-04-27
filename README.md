# vsvlasov_infra
vsvlasov Infra repository

# ДЗ-3 "Знакомство с облачной инфраструктурой"

bastion_IP = 35.205.58.96

someinternalhost_IP = 10.132.0.4

Подключение в одну комманду:
```sh
ssh -i .ssh/appuser -A -J appuser@35.205.58.96 appuser@10.132.0.4
```

Подключение через `ssh someinternalhost`:
1) Добавить в `~/.ssh/config`
```
Host bastion
    HostName     35.205.58.96
        User         appuser
	    IdentityFile ~/.ssh/appuser
	        ForwardAgent yes

Host someinternalhost
    HostName     10.132.0.4
    User         appuser
    ProxyJump    bastion
```
2) `ssh someinternalhost`

##### Доп. задание:
Прописать 35.205.58.96.xip.io в Pritunl Setting -> Lets Encrypt Domain


# ДЗ-4 "Деплой тестового приложения"

testapp_IP = 35.233.75.73
testapp_port = 9292

Создание интанса и деплой с помощью gcloud SDK:
```shell script
gcloud compute instances create reddit-app --boot-disk-size=10GB --image-family ubuntu-1604-lts --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --metadata-from-file startup-script=./startup-script.sh
```


##### Доп. задание:
Создание правила фаервола с помощью gcloud
 ```shell script
 gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --target-tags puma-server
```
