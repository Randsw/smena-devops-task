# Тестовое задание DevOps разработчик

1. [Первичная установка](docs/project_install.md)
1. [Задание](docs/assignment.md)

## Решение

1. Поправить конфиг запуска Gunicorn
   Так как мы используем приложение на FastApi необходимо вместо:

   ```bash
   -- worker 1
   ```

   использовать другие worker'ы

   ```bash
    -k uvicorn.workers.UvicornWorker 
   ```

   Дополнительно нужно исправить имя запускаемого приложения - в нашем случае оно `main:app` вместо `farfor.wsgi:application`
2. Сборка образа приложения:?

   ```bash
   docker build -t <имя образа>:<тег образа> .
   ```

3. Загрузка образа в репозиторий(на примере Docker Hub)
    Региструемся на Docker Hub.
    Получаем токен.
    Логинимся в Docker Hub

    ```bash
    docker login -u <имя пользователя>
    ```

    Вводим токен.
    Загружаем образ:

    ```bash
    docker push <имя образа>:<тег образа>
    ```

4. Создание кластера Kubernetes

   [Следуем инструкции по созданию кластера с помощью kind c установленным ingress-nginx контроллером](https://kind.sigs.k8s.io/docs/user/ingress/#ingress-nginx)

5. Развертываение приложения - считаем что установлен helm(с плагинами helm secret и helm diff), sops cli и сам helmfile

    Шифруем секреты с помощью helm secrets. Инструкция в документации к helm secrets.

   ```bash
    helmfile -e <environment> apply
   ```

   где environment - одна из `dev`, `stage`, `prod`.

    Для установки нужен ключ, который расшифрует секреты(его место хранения нужно узнать у того, кто зашифровывал) Ключ нужно описать в файле `deploy/.sops.yaml`. Инструкция в репозитории [SOPS](https://github.com/getsops/sops)

    Добавляем в файл `/etc/hosts` строку:

    ```bash
    127.0.0.1 localhost farforstaging.ru farfor.ru
    ```

    В случае `dev` среды выполняем:

    ```bash
    curl -kL localhost
    curl -kL localhost/docs
    ```

    и убеждаемся в верных значения

    В случае `stage` среды выполняем:

    ```bash
    curl -kL --header 'Host: farforstaging.ru' localhost
    curl -kL --header 'Host: farforstaging.ru' localhost/docs
    ```

    и убеждаемся в верных значения

    В случае `prod` среды выполняем:

    ```bash
    curl -kL --header 'Host: farfor.ru' localhost
    curl -kL --header 'Host: farfor.ru' localhost/docs
    ```

    и убеждаемся в верных значения

Вот как-то так вкратце.
