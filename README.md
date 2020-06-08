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


# ДЗ-5 "Сборка образов VM при помощи Packer"

Реализованно создание образов ВМ с использованием Packer.

Добавлено
 - Packer template ubuntu16.json для создания reddit-base образа с MongoDB и Ruby.
 - Packer template immutable.json для создания reddit-full образа (на основе base) c puma-server.
 - puma.service для systemd.
 - create-reddit-vm.sh для деплоя reddit-full образа с использованием gcloud.
 - Параметризация темплейтов.


# ДЗ-6 "Практика IaC с использованием Terraform"

Реализован деплой puma-server с использованием Terraform.

Добавлено:
 - Конфиг Terraform для деплоя puma-server
 - input переменные с дефольными значениями в terraform.tfvars
 - Добавление project wide SSH ключей

#### Доп. задание 1:
  Добавление ключей SSH через Terraform удаляет ключи, которые были добавленны вручную.

#### Доп. задание 2:
  Проблемы при добавлении инстансов копированием:
  - Необходимость отслеживать множество переменных для каждого инстанса
  - Большой бойлерплейт
  - При Count > 2 файл конфигурации сильно разрастается
  - Трудно вносить изменения (к примеру при добавлении нового параметра),
   нужно добавлять в каждый инстанс вручную

# ДЗ-7 "Принципы организации инфраструктурного кода и работа над инфраструктурой в команде на примере Terraform."

Реализован деплой приложения с отдельными инстансами под MongoDB и APP с использованием Terraform

Добавлено:
  - App, DB, VPC Terraform модули
  - Prod и Stage конфиги
  - Внешний модуль storage-bucket для удаленного хранения Terraform state
  - puma.service.tmpl для передачи DATABASE_URL в App
  - Переменная enable_provisioning для включения/отключения provisioning

Notes:
  - При одновременном запуске деплоя конфигураций происходит блокировка стейта

# ДЗ-8 "Управление конфигурацией. Основные DevOps инструменты. Знакомство с Ansible"
Добавлен Ansible для работы с reddit-app.
Добавлен простой Ansible playbook для клонирования репозитория reddit-app.
Добавлен inventory.py для получения списка инстансов с gcp с использованием gcloud и генерации json "на лету"

Описание inventory.py:
1. Получение GCE с использованием gcloud клиента
2. Фильтрация GCE по тэгу 'reddit-app'
3. Фильтрация GCE по тэгу 'reddit-db'
4. Генерация json
5. Print json в stdout

Опционально можно получить inventory.json:

`ansible-inventory --list > inventory.json`

Для пинга с использованием Ansible для db & app инстансов:

`ansible all -m ping`


Результат запуска Ansible-плэйбука при склонированном репозитории
```
PLAY RECAP **********************************************************************************************
appserver                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
После удаления:
```
PLAY RECAP **********************************************************************************************
appserver                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
В первом случае Ansible не клонирует репозиторий заново.
Во втором случае `changed=1`, Ansible склонировал репозиторий заново.
