# AV86github_microservices
AV86github microservices repository

Лекция 14. Домашнее задание
==========================

Практика работы с **Docker**. Было сделано:

1. Вся работа ведется с созданным docker-host в облаке *GCP*:
    ```
    docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-
    os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    --google-zone europe-west1-b \
    docker-host
    # активируем нужный docker-host
    eval $(docker-machine env docker-host)
    # проверяем
    docker-machine active
    ```

1. Создан **Dockerfile** для сборки образа с приложением reddit (*mongo + puma*).
    ```
    cd docker-monolith
    docker build -t reddit:latest .
    docker run --name reddit -d --network=host reddit:latest
    ```

1. Созданный образ отправлен в docker-hub
    ```
    docker push <your-login>/otus-reddit:1.0
    ```
1. Выполнено дополнительное задание:
    2. Создан образ с установленным докером:
        ```
        packer build -var-file packer/variables.json packer/docker.json
        ```
    2. Написан шаблон терраформ для поднятия необходимого кол-ва инстансов на основе созданного ранее образа:
        ```
        cd infra/terraform
        terraform init
        terraform apply
        ```
    2. Написан playbook **site.yml** для запуска контейнера

Лекция 15. Домашнее задание
===========================

Практика работы с **Dockerfile**. Было сделано:

1. Приложение разбито на несколько сервисов, каждый из которых запущен в отдельном докер-контейнере.
1. Все контейнеры добавлены в новую bridge-сеть:
    ```
    docker network create reddit
    docker run -d --network=reddit --network-alias=post_db.....
    ```
1. Для контейнера с БД создан Volume для хранения данных
    ```
    docker volume create reddit_db
    docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest
    ```
1. Оптимизирван **Dockerfile** для образа *UI*:
    * Базовый образ изменен на **alpine:3.12**
    * В начало перенесены слои, для которых может быть использован кэш (скорее помагает скорости сборки, чем размеру образа) - **ENV, RUN apk..**
    * Сразу после установки пакетов удаляется кэш apk (в тойже команде RUN)
1. Запуск линетра:
    ```
    docker run --rm -i hadolint/hadolint < Dockerfile
    ```

Лекция 16. Домашнее задание
===========================

Практика работы с **docker network**, **docker-compose**. Было сделано:
1. Изучен механизм работы docker сетей:
    * None
    * host
    * bridge
1. Микросервисы приложения разбиты по разным подсетям - *fornt*, *back*
1. Приложение запущено через **docker-compose** (конфигурация описывается в *docker-compose.yml*, переменные в *.env*)
1. При именовании объектов docker (container, network, etc) *docker-compose* в качестве префикса использует название проекта:
    * По уолмчанию - имя папки, в которой лежит конфигурационный файл.
    * Можно задать ключем -P
        ```
        docker-copmpose -P ProjectName -f config_faile up -d
        ```
1. Выполнено дополнительное задание - написан файл **docker-compose.override.yml** для переопределения части параметров. Проверить корректность можно командой:
    ```
    docker-compose config
    ```

Лекция 16. Домашнее задание
===========================

Практика работы с gitlab. В процессе сделано:
1. Установлен **Gitlab**, пакет omnibus (использован готовый докер-образ). Для автоматической установки написан playbook:
    ```
    cd gitlab-ci/ansible
    ansible-playbook playbooks/gitlab.yml
    ```
2. В отдельном docker конейнере запущен gitlab-runner
    ```
    gitlab-runner start
    gitlab-runner register
    ```
3. Для тестирования ci\cd процессов в gitlab создан проект. В проекте настроено:
    * динамические окружения
    * stages для сборки, тестирования, деплоя
    * push собранного образа в докер-хаб
4. Выполнены дополнительные задания:
    * сборка образа в gitlab, пуш на docker-hub
    * образ поднимается на сервере с Gitlab. Можно настроить на отдельный сервер - через создание инфтрастуктуры (terraform, etc), можно использовать docker-machine в различных конфигурациях (driver - google, driver - generic), например:
        ```
        docker-machine create \
            --driver generic \
            --generic-ip-address=<your_ip> \
            --generic-ssh-key <rsa_privat_key> \
            generic_machine
        ```
    * интеграция со slack
    * ansible playbook для понятия произвольного кол-ва раннеров
        для машин с раннерами создается отдельная группа в инвентори - *gitlab_runners*, токены для регистрации раннеров в gitlab прописывыатся в **group_vars/gitlab_runners**, конфигурация раннеров (список докер контейнеров и список ранеров для каждого контейнера) прописываются в словаре - **host_vars/gitlab-0** (для каждого из хоста с ранерами)
        ```
        ansible-playbook playbooks/gitlab-runners.yml
        ```
