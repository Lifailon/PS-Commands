# Jenkins Pipelines

Коллекция универсальных Jenkins Pipeline, которые я использую в своей домашней лаборатории для автоматизации базовых задач по направлению DevOps.

Каждый проект имеет краткое описание и скриншоты с примерами работы.

Для запуска сервера и сборщика Jenkins используется [docker-compose](../Docker-Compose/ci-cd-stack/jenkins/docker-compose.yml).

## Plugins

Список используемых плагинов:

| Плагин                                                                                            | Описание                                                                                                                        |
| -                                                                                                 | -                                                                                                                               |
| [Pipeline Nodes and Processes](https://jenkins.io/doc/pipeline/steps/workflow-durable-task-step)  | Плагин, который предоставляет доступ к интерпретаторам `sh`, `bat`, `powershell` и `pwsh`                                       |
| [Pipeline Utility Steps](https://jenkins.io/doc/pipeline/steps/pipeline-utility-steps)            | Добавляет методы `readJSON`, `writeJSON`, `readYaml`, `writeYaml`, `readTOML`, `writeTOM`, `untar`, `unzip`, и другие           |
| [HTTP Request](https://plugins.jenkins.io/http_request)                                           | Простой `REST` API Client для отправки и обработки `GET` и `POST` запросов через метод `httpRequest(url: url, httpMode: "GET")` |
| [Credentials Binding](https://jenkins.io/doc/pipeline/steps/credentials-binding)                  | Добавляет метод `withCredentials` для доступа к секретам                                                                        |
| [HashiCorp Vault](https://plugins.jenkins.io/hashicorp-vault-plugin)                              | Автоматизирует процесс получения содержимого значений из `HashCorp Vault` с помощью метода `withVault`                          |
| [Ansible](https://plugins.jenkins.io/ansible)                                                     | Параметраризует запуск `ansible-playbook` (требуется установка на агенте) через метод `ansiblePlaybook`                         |
| [Node.js](https://plugins.jenkins.io/nodejs)                                                      | Автоматически устанавливает заданную версию `Node.js` на каждом агенте Jenkins, где она потребуется                             |
| [SSH Pipeline Steps](https://plugins.jenkins.io/ssh-steps)                                        | Плагин для подключения к удаленным машинам через протокол `ssh` по ключу или паролю                                             |
| [SSH Agent](https://www.jenkins.io/doc/pipeline/steps/ssh-agent)                                  | Плагин для подключения к удаленным машинам с использованием `ssh-agent` и `Credentials`                                         |
| [File System SCM](https://plugins.jenkins.io/filesystem_scm)                                      | Заменяет использование Git репозитория на директорию на локальном диске или сетевом ресурсе                                     |
| [Workspace Cleanup](https://plugins.jenkins.io/ws-cleanup)                                        | Плагин добавляет метод `cleanWs()` для удаления рабочей область сборки                                                          |
| [HTML Publisher](https://plugins.jenkins.io/htmlpublisher)                                        | Добавляем метод `publishHTML` для публикации статической страницы в формате `HTML`                                              |
| [Pipeline Stage View](https://plugins.jenkins.io/pipeline-stage-view)                             | Визуализация шагов (`stages`) в интерфейсе проекта с временем их выполнения                                                     |
| [Pipeline Graph View](https://plugins.jenkins.io/pipeline-graph-view)                             | Группирует все шаги и выполняемые команды, добавляя кнопку `Pipeline Overview` и заменяя стандартный лог сборки                 |
| [Rebuilder](https://plugins.jenkins.io/rebuild)                                                   | Позволяет перезапускать параметризованную сборку с предустановленными параметрами в выбранной сборке                            |
| [Schedule Build](https://plugins.jenkins.io/schedule-build)                                       | Позволяет запланировать сборку на указанный момент времени                                                                      |
| [Webhook Trigger](https://plugins.jenkins.io/generic-webhook-trigger)                             | Принимает `POST` запросы на конечной точке `/generic-webhook-trigger/invoke` для извлечения значений и запуска Pipeline         |
| [Multibranch Scan Webhook Trigger](https://plugins.jenkins.io/multibranch-scan-webhook-trigger)   | Запускает сканирование многоветочных проектов с помощью веб-хука `/multibranch-webhook-trigger/invoke?token=TOKEN`              |
| [Job Configuration History](https://plugins.jenkins.io/jobConfigHistory)                          | Сохраняет копию файла сборки в формате `xml` (который хранится на сервере) в истории для сверки                                 |
| [Export Job Parameters](https://plugins.jenkins.io/export-job-parameters)                         | Добавляет кнопку `Export Job Parameters` для конвертации все параметров в декларативный синтаксис Pipeline                      |
| [Active Choices Parameters](https://plugins.jenkins.io/uno-choice)                                | Активные параметры, которые позволяют динамически обновлять содержимое параметров                                               |
| [HTML Parameters](https://plugins.jenkins.io/html-parameters)                                     | Позволяет создавать формы с помощью параметра `uiHtmlFormParameter` для доступа к выбранным значениями через `env`              |
| [File Parameters](https://plugins.jenkins.io/file-parameters)                                     | Добавляет параметры для загрузки файлов                                                                                         |
| [Separator Parameter](https://plugins.jenkins.io/parameter-separator)                             | Параметр для визуального разделения набора параметров на странице сборки задания с поддержкой `HTML`                            |
| [Custom Tools](https://plugins.jenkins.io/custom-tools-plugin)                                    | Позволяет загружать пакеты (исполняемые файлы) из Интернета с помощью предустановленного набора команд                          |
| [Copy Artifact](https://plugins.jenkins.io/copyartifact)                                          | Позволяет копировать артифакты из одной сборки в другую (например, из последней успешной `copyArtifacts(projectName: jobName)`) |
| [ANSI Color](https://plugins.jenkins.io/ansicolor)                                                | Добавляет поддержку стандартных escape-последовательностей `ANSI` для покраски вывода                                           |
| [Email Extension](https://plugins.jenkins.io/email-ext)                                           | Отправка сообщений на почту по протоколу `SMTP` из Pipeline                                                                     |
| [Config File Provider](https://plugins.jenkins.io/config-file-provider)                           | Хранение конфигураци (например, `settings.xml` для `Maven`) в интерфейсе Jenkins и их шаблонизация c `Credentials`              |
| [Allure](https://plugins.jenkins.io/allure-jenkins-plugin)                                        | Создает отчеты [Allure](https://allurereport.org) для автотестов в интерфейсе Pipeline с отправкой в TestOps                    |
| [SonarQube Scanner](https://plugins.jenkins.io/sonar)                                             | Интегрирует статический анализ кода с помощью метода [withSonarQubeEnv](https://jenkins.io/doc/pipeline/steps/sonar)            |
| [Coverage](https://plugins.jenkins.io/coverage)                                                   | Собирает отчеты о покрытии кода тестами с помощью метода `recordCoverage()` и отображает его в интерфейсе Jenkins               |
| [JUnit](https://plugins.jenkins.io/junit)                                                         | Обрабатывает XML-отчеты и формирует отчет с результатами тестирования с помощью метода `junit(testResults: "report.xml")`       |
| [Test Results Analyzer](https://plugins.jenkins.io/test-results-analyzer)                         | Собирает отчеты, вызываемые с помощью плагина `junit` из предыдущих сборок и строит график для анализа динамики тестирования    |
| [Embeddable Build Status](https://plugins.jenkins.io/embeddable-build-status)                     | Предоставляет настраиваемые значки [Shields](https://shields.io), который возвращает статус сборки                              |
| [Prometheus Metrics](https://plugins.jenkins.io/prometheus)                                       | Предоставляет конечную точку `/prometheus` с метриками, которые используются для сбора данных                                   |
| [Web Monitoring](https://plugins.jenkins.io/monitoring)                                           | Добавляет конечную точку `/monitoring` для отображения графиков мониторинга в веб-интерфейсе                                    |
| [CloudBees Disk Usage](https://plugins.jenkins.io/cloudbees-disk-usage-simple)                    | Отображает использование диска всеми заданиями во вкладке `Manage-> Disk usage` для анализа                                     |

## Jenkins Agent

Для сбороки проектов используется Jenkins агент, в [образе](../Docker-Compose/ci-cd-stack/jenkins/Dockerfile) которого предусмотрена установка некоторых DevOps инструментов:

- [ansible](https://github.com/ansible/ansible)
- [golang](https://github.com/golang/go)
- git
- curl
- ping
- netcat
- make
- tmux

> [!TIP]
> Образ агента для платформ `amd64` и `arm64` опубликован на [Docker Hub](https://hub.docker.com/r/lifailon/jenkins-agent).

Параметры подключения агента на сервере Jenkins:

- name: `local-agent-01`
- remote root dir: `/home/jenkins`
- label: `linux amd64`

## Custom Tools

Список используемых пользовательских утилит, которые устанавливаются с помощью [скриптов](./custom-tools/), используя плагин [Custom Tools](https://plugins.jenkins.io/custom-tools-plugin):

| Tool                                                  | Version   |
| -                                                     | -         |
| [docker cli](https://github.com/docker/cli)           | 29.5.0    |
| [docker buildx](https://github.com/docker/buildx)     | 0.34.1    |
| [docker compose](https://github.com/docker/compose)   | 5.1.0     |
| [kubectl](https://github.com/kubernetes/kubectl)      | 1.36.0    |
| [helm](https://github.com/helm/helm)                  | 4.2.0     |
| [krew](https://github.com/kubernetes-sigs/krew)       | 0.5.0     |
| [node-js](https://github.com/nodejs/node)             | 24.17.0   |

Пример настройки:

![](docker-ci/img/tools.jpg)

## Shared library

Для работоспособности некоторых Pipeline, требуется добавить [rudocs-shared-library](./shared-library/vars/) с пользовательскими функциями в настройках проектной области:

![](jenkins-clean-builds/img/add-shared-library.jpg)

Подключение библиотеки в Pipeline:

```groovy
@Library([
    'rudocs-shared-library@main'
]) _
```

## Credentials

Список секретов, которые используются в проектах:

| ID                    | Type                          |
| -                     | -                             |
| `jenkins-api-cred`    | `Username with password`      |
| `ssh-creds`           | `Username with password`      |
| `ssh-key`             | `Username with private key`   |
| `docker-hub`          | `Username with password`      |
| `k3s-approle`         | `Vault App Role Credential`   |
| `k3s-token`           | `Secret text`                 |
| `kubeconfig-file`     | `Secret file`                 |
| `telegram-token`      | `Secret text`                 |
| `telegram-channel`    | `Secret text`                 |