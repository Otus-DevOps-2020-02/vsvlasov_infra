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

Доп. задание:
  Прописать 35.205.58.96.xip.io в Pritunl Setting -> Lets Encrypt Domain
