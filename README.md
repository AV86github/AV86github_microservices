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
