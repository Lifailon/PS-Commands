<p align="center">
    <a href="https://lifailon.github.io/compose/"><img title="Docker Compose Stacks"src="../Images/compose-stacks.png"></a>
</p>

Коллекция стеков Docker Compose из более чем 300 сервисов. Каждое приложение было проверено и отлажено в домашней лаборатории, конфигурации к некоторым сервисам доступны в [репозитории](https://github.com/Lifailon/rudocs/tree/main/Docker-Compose).

---

## OS

### Windows

[Windows](https://github.com/dockur/windows) внутри контейнера Docker.

```yaml
services:
  windows:
    image: dockurr/windows
    container_name: windows
    restart: always
    stop_grace_period: 2m
    devices:
      - /dev/kvm
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
    ports:
      - 8066:8006
      - 3389:3389/tcp
      - 3389:3389/udp
    environment:
      - VERSION=11
      - USERNAME=admin
      - PASSWORD=admin
      - REGION=en-US
      - KEYBOARD=en-US
      - CPU_CORES=2
      - RAM_SIZE=4G
      - DISK_SIZE=64G
    volumes:
      - ./windows_data:/storage
```

### macOS

[macOS](https://github.com/dockur/macos) внутри контейнера Docker.

```yaml
services:
  macos:
    image: dockurr/macos
    container_name: macos
    restart: always
    stop_grace_period: 2m
    devices:
      - /dev/kvm
      - /dev/net/tun
      - /dev/vhost-net
    device_cgroup_rules:
      - 'c *:* rwm'
    cap_add:
      - NET_ADMIN
    ports:
      - 8067:8006
      - 5900:5900/tcp
      - 5900:5900/udp
    environment:
      - VERSION=15
      - CPU_CORES=1
      - RAM_SIZE=4G
      - DISK_SIZE=64G
      - DHCP=Y
    volumes:
      - ./macos_data:/storage
```

### Puter

[Puter](https://github.com/heyputer/puter) - операционная система работающая в браузере (WebOS), которая организует персональное облако для рабочего окружения, хранения файлов (альтернатива Dropbox, Google Drive, Microsoft OneDrive и других), запуска приложений и игр в одном месте.

```yaml
services:
  puter:
    image: heyputer/puter:latest
    container_name: puter
    restart: always
    user: root
    ports:
      - 4100:4100
    volumes:
      - ./puter_data:/var/puter
```

### ArozOS

[ArozOS](https://github.com/tobychui/arozos) - операционная система работающая в браузере (WebOS) для запуска в облаке.

> [!NOTE]
> Используется неофициальный образ [lifailon/arozos](https://hub.docker.com/r/lifailon/arozos), собранный в репозитории [ruDocs](https://github.com/Lifailon/rudocs) для публичного использования.

```yaml
services:
  arozos:
    # build: .
    image: lifailon/arozos:3
    container_name: arozos
    restart: always
    ports:
      - 8080:8080
    volumes:
      - ./arozos_data/files:/arozos/files
      - ./arozos_data/web:/arozos/web
      - ./arozos_data/system:/arozos/system
```

### Android

#### DockDroid

[DockDroid](https://github.com/sickcodes/dock-droid) - позволяет запускать Android x86 и ARM в контейнере Docker с использованием `QEMU` и `KVM`. Поддерживает X11 Forwarding, что позволяет отображать графический интерфейс Android, ADB на порту 5555, ssh-доступ через порт 50922, проброс веб-камеры (`/dev/video0`), аудио (`/dev/snd`) и GPU (`/dev/dri`) в контейнер.

```yaml
services:
  dock-droid:
    image: sickcodes/dock-droid:latest
    container_name: dock-droid
    restart: always
    privileged: true
    stdin_open: true
    tty: true
    environment:
      - EXTRA=-display none -vnc 0.0.0.0:99,password=on
      - VNC_PASSWORD=admin
      - CPU=qemu64
      - ENABLE_KVM=
      - KVM=
      - CPUID_FLAGS=
    ports:
      - 5555:5555 # ADB
      - 5999:5999 # VNC
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
```

#### Android Emulator

[Docker Android](https://github.com/HQarroum/docker-android) (Android Emulator) - минимальный и настраиваемый Docker-образ на базе Alpine (включает поддержку KVM, а также Java Runtime Environment 11), запускающий эмулятор Android в качестве сервиса.

```yaml
services:
  android-emulator:
    image: halimqarroum/docker-android:api-33
    container_name: android-emulator
    ports:
      - 5554:5554
      - 127.0.0.1:5555:5555
    privileged: true
    tty: true
    stdin_open: true
    environment:
      - DISABLE_ANIMATION=false
      - DISABLE_HIDDEN_POLICY=true
      - SKIP_AUTH=false
      #- ANDROID_ADB_SERVER_ADDRESS=host.docker.internal
      - MEMORY=16384
      - CORES=16
    volumes:
      - ./keys/adbkey:/root/.android/adbkey:ro
      - ./keys/adbkey.pub:/root/.android/adbkey.pub:ro
      - ./android_avd:/data
    extra_hosts:
      - host.docker.internal:host-gateway
    devices:
      - /dev/kvm:/dev/kvm
```

## Bot Stack

### SSH Bot

[SSH Bot](https://github.com/Lifailon/ssh-bot) - Telegram бот, который позволяет запускать заданные команды на выбранном хосте в домашней сети и возвращать результат их выполнения. Бот не устанавливает постоянное соединение с удаленным хостом, что позволяет выполнять команды асинхронно.

```yaml
services:
  OpenRouter-Bot:
    image: lifailon/openrouter-bot:latest
    container_name: OpenRouter-Bot
    restart: unless-stopped
    volumes:
      - ./openrouter-bot.env:/openrouter-bot/.env
```

env:

```ini
# Telegram api key from https://telegram.me/BotFather
TELEGRAM_BOT_TOKEN=XXXXXXXXXX:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# Your Telegram id from https://t.me/getmyid_bot
TELEGRAM_USER_ID=7777777777

# Interpreter used only when running the bot local in Windows
# Available values: powershell/pwsh
WIN_SHELL=pwsh
# Interpreter used on local and remote hosts in Linux
# Available values: sh/bash/zsh or other
LINUX_SHELL=bash

# Parallel (async) execution of commands (default: false)
PARALLEL_EXEC=true

# Global parameters for ssh connection (low priority)
SSH_PORT=2121
SSH_USER=lifailon
# Use password to connect (optional)
SSH_PASSWORD=
# Full path to private key (default: ~/.ssh/id_rsa)
SSH_PRIVATE_KEY_PATH=
SSH_CONNECT_TIMEOUT=2
# Save and reuse passed variables and functions (default: false)
SSH_SAVE_ENV=true
# List of hosts separated by comma (high priority for username and port)
SSH_HOST_LIST=192.168.3.101,root@192.168.3.102:22,root@192.168.3.103:22,192.168.3.105,192.168.3.106

# Log the output of command execution
LOG_MODE=DEBUG
```

### OpenRouter Bot

[OpenRouter Bot](https://github.com/Lifailon/openrouter-bot) - Telegram бота для общения с бесплатными и платными моделями ИИ через [OpenRouter](https://openrouter.ai), или локальными LLM, например, через [LM Studio](https://lmstudio.ai).

```yaml
services:
  ssh-bot:
    image: lifailon/ssh-bot:latest
    container_name: ssh-bot
    restart: unless-stopped
    volumes:
      - ./ssh-bot.env:/ssh-bot/.env
      - $HOME/.ssh/id_rsa:/root/.ssh/id_rsa
```

env:

```ini
# OpenRouter api key from https://openrouter.ai/settings/keys
API_KEY=

# Telegram api key from https://telegram.me/BotFather
TELEGRAM_BOT_TOKEN=

# Your Telegram id from https://t.me/getmyid_bot
ADMIN_IDS=
# List of users to access the bot, separated by commas
ALLOWED_USER_IDS=

BASE_URL=https://openrouter.ai/api/v1
# List of free models: https://openrouter.ai/models?max_price=0
MODEL=deepseek/deepseek-r1:free
# System preset that specifies the role for AI
#ASSISTANT_PROMPT="Ты переводчик, умеешь только переводить текст с русского на англйский язык (и наоборот) и не отвечаешь на вопросы."

# Using local LLM via LM Studio (https://lmstudio.ai)
#BASE_URL=http://localhost:1234/v1
# Using local model: https://huggingface.co/ruslandev/llama-3-8b-gpt-4o-ru1.0
#MODEL=llama-3-8b-gpt-4o-ru1.0

VISION=false
#VISION_PROMPT="Описание изображения"
#VISION_DETAIL="низкий"

# The maximum number of messages or time in minutes for store messages in history
MAX_HISTORY_SIZE=20
MAX_HISTORY_TIME=60

#BUDGET_PERIOD=monthly
# Enable user access (default)
#USER_BUDGET=1
# Disable guest access (enabled by default)
GUEST_BUDGET=0

# Language used for bot responses (supported: EN/RU)
LANG=RU

# ADMIN/USER/GUEST
STATS_MIN_ROLE=ADMIN
```

### Kinozal Bot

[Kinozal Bot](https://github.com/Lifailon/Kinozal-Bot) - Telegram бот, который позволяет автоматизировать процесс доставки контента до вашего телевизора, используя только телефон. С помощью бота вы получите удобный и привычный интерфейс для взаимодействия с торрент трекером [Кинозал](https://kinozal.tv) и базой данных [TMDB](https://www.themoviedb.org) для отслеживания даты выхода серий, сезонов и поиска актеров для каждой серии, а также возможность управлять торрент клиентом [qBittorrent](https://github.com/qbittorrent/qBittorrent) или [Transmission](https://github.com/transmission/transmission) на вашем компьютере, находясь удаленно от дома, а главное, все это доступно из единого интерфейса и без установки клиентского приложения на конечные устройства. В отличии от других приложений, предназначенных для удаленного управления торрент клиентами, вам не нужно находиться в той же локальной сети или использовать VPN.

```yaml
services:
  kinozal-bot:
    image: lifailon/kinozal-bot:latest
    container_name: kinozal-bot
    restart: unless-stopped
    volumes:
      - ./torrents:/kinozal-bot/torrents
      - ./kinozal-bot.conf:/kinozal-bot/kinozal-bot.conf
```

### yt-dlp Telegram Bot

[yt-dlp Telegram Bot](https://github.com/nonoo/yt-dlp-telegram-bot) - Telegram бот для загрузки видео из YouTube с помощью [yt-dlp](https://github.com/yt-dlp/yt-dlp) (like [Gozilla Bot](https://t.me/Gozilla_bot)).

> [!NOTE]
> Используется неофициальный мультиплатформенный образ [lifailon/yt-dlp-telegram-bot](https://hub.docker.com/r/lifailon/yt-dlp-telegram-bot), собранный в репозитории [ruDocs](https://github.com/Lifailon/rudocs) для публичного использования.

```yaml
services:
  yt-dlp-telegram-bot:
    image: lifailon/yt-dlp-telegram-bot:latest
    container_name: yt-dlp-telegram-bot
    restart: unless-stopped
    env_file:
      - .env
```

env:

```ini
API_ID=             # get from https://my.telegram.org
API_HASH=           # get from https://my.telegram.org
BOT_TOKEN=          # get from https://telegram.me/BotFather

ALLOWED_USERIDS=    # get from https://t.me/getmyid_bot
ADMIN_USERIDS=      # get from https://t.me/getmyid_bot

YTDLP_PATH=         # default: /tmp/yt-dlp
ALLOWED_GROUPIDS=
MAX_SIZE=
YTDLP_COOKIES=
```

### RSS to Telegram Bot

[RSS to Telegram Bot](https://github.com/BoKKeR/RSS-to-Telegram-Bot) - мониторит указанные RSS-ленты, добавленные через интерфейс Telegram и отправляет ссылки при обнаружение новых новостей.

🔗 [Telegram Bot Demo](https://t.me/rss_t_bot) ↗

```yaml
services:
  rss-bot:
    image: bokker/rss.to.telegram
    container_name: rss-bot
    restart: unless-stopped
    environment:
      - TOKEN=<CHAT>:<TOKEN>
      - DEBUG=false
      - REDIS_HOST=rss-redis
      - REDIS_PORT=6379
      - REDIS_USER=admin
      - REDIS_PASSWORD=admin
      - REDIS_MUTEX=random-value
    volumes:
      - /path/to/host/config:/app/config

  rss-redis:
    image: redis:latest
    container_name: rss-redis
    restart: unless-stoppedd
```

### Free Games Claimer Bot

[Free Games Claimer Bot](https://github.com/vogler/free-games-claimer) - Автоматически получает список бесплатных игр и DLC в Telegram из Epic Games Store, Amazon Prime Gaming и GOG.

```yaml
services:
  fgc-bot:
    image: ghcr.io/vogler/free-games-claimer
    container_name: fgc-bot
    restart: unless-stopped
    pull_policy: always
    stdin_open: true
    tty: true
    ports:
      - 6080:6080
    volumes:
      - ./fgc_data:/fgc/data
```

### Telegram Bot API

[Telegram Bot API](https://github.com/tdlib/telegram-bot-api) - это локальный сервер Telegram Bot API, который выступает в роле посредника для Telegram ботов, что позволяет снять ограничения на загрузку файлов с 50 МБ до 2 ГБ и настроить подключение через прокси сервер для всех запросов.

```yaml
services:
  telegram-bot-api:
    image: aiogram/telegram-bot-api:latest
    container_name: telegram-bot-api
    restart: unless-stopped
    environment:
      - TELEGRAM_API_ID=<api-id>
      - TELEGRAM_API_HASH=<api-hash>
      # - http_proxy=http://user:password@ip:port
      # - https_proxy=http://user:password@ip:port
    volumes:
      - ./telegram_bot_api_data:/var/lib/telegram-bot-api
    ports:
      - 8081:8081
```

### Telegram Media Downloader

[Telegram Media Downloader](https://github.com/tangyoha/telegram_media_downloader) - приложение для массовой загрузки медиафайлов из Telegram чатов и каналов, включая аудио, документы, фото и видео.

```yaml
services:
  telegram-downloader:
    image: tangyoha/telegram_media_downloader:latest
    container_name: telegram-downloader
    restart: unless-stopped
    ports:
      - 5000:5000
    volumes:
      - ./downloads:/app/downloads
      - ./config.yaml:/app/config.yaml
      - ./data.yaml:/app/data.yaml
      - ./log/:/app/log/
      - ./sessions/:/app/sessions
      - ./temp/:/app/temp
```

### Pentaract

[Pentaract](https://github.com/Dominux/Pentaract) - система облачного хранения данных, использующая Telegram в качестве хранилища, не используя файловую систему локального сервера или стороннего облачного хранилища.

```yaml
services:
  pentaract:
    image: pentaract
    container_name: pentaract
    restart: unless-stopped
    build: .
    env_file:
      - PORT=5050
      - TELEGRAM_API_BASE_URL=https://api.telegram.org
      - SECRET_KEY=<TOKEN>
      - SUPERUSER_EMAIL=pentaract@pentaract.pentaract
      - SUPERUSER_PASS=pentaract
      - ACCESS_TOKEN_EXPIRE_IN_SECS=1800
      - REFRESH_TOKEN_EXPIRE_IN_DAYS=14
      - WORKERS=4
      - CHANNEL_CAPACITY=32
      # Database
      - DATABASE_HOST=pentaract-db
      - DATABASE_PORT=5432
      - DATABASE_NAME=pentaract
      - DATABASE_USER=pentaract
      - DATABASE_PASSWORD=pentaract
    ports:
      - 5050:5050
    depends_on:
      - pentaract-db

  pentaract-db:
    image: postgres:15.0-alpine
    container_name: pentaract-db
    restart: unless-stopped
    environment:
      - POSTGRES_USER=pentaract
      - POSTGRES_PASSWORD=pentaract
    volumes:
      - ./pentaract_data:/var/lib/postgresql/data
    healthcheck:
      test: pg_isready --username=${DATABASE_USER} --dbname=${DATABASE_NAME}
      interval: 10s
      timeout: 5s
      retries: 10
```

### Telemt

[Telemt](https://github.com/telemt/telemt) - быстрый и безопасный прокси-сервер, который реализует официальный алгоритм прокси Telegram через TLS.

[Бесплатные MTProto сервера](https://mtproto.ru)

```yaml
services:
  telemt:
    image: ghcr.io/telemt/telemt:latest
    container_name: telemt
    restart: always
    ports:
      - 4343:4343             # Proxy
      - 127.0.0.1:19090:9090  # Metrics
      - 127.0.0.1:19091:9091  # API
    working_dir: /run/telemt
    volumes:
      - ./config.toml:/run/telemt/config.toml:ro
    tmpfs:
      - /run/telemt:rw,mode=1777,size=1m
    environment:
      - RUST_LOG=debug
    cap_drop:
      - ALL
    # allow binding to port 443
    # cap_add:
    #   - NET_BIND_SERVICE
    read_only: true
    security_opt:
      - no-new-privileges:true
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
```

### Pusk

[Pusk](https://github.com/getpusk/pusk) - автономная платформа для оповещений и командной коалиции. Webhook из любого, ACK одним инструментом, нажмите на телефон. Один бинарник, без внешних зависимостей.

```yaml
services:
  pusk:
    image: ghcr.io/getpusk/pusk:latest
    container_name: pusk
    restart: unless-stopped
    ports:
      - 8443:8443
    environment:
      - PUSK_ALERTMANAGER_URL=http://alertmanager:9093
    volumes:
      - ./pusk_data:/app/data
```

## LLM Stack

### Open WebUI

[Open WebUI](https://github.com/open-webui/open-webui) - платформа для самостоятельного размещения AI (веб-интерфейс для LLM), предназначенная для работы в полностью автономном режиме. Она поддерживает различные среды выполнения LLM, такие как Ollama и совместимые с OpenAI API.

```yaml
services:
  # ollama:
  #   image: ollama/ollama:latest
  #   container_name: ollama
  #   restart: unless-stopped
  #   tty: true
  #   # ports:
  #   #   - 12345:12345
  #   volumes:
  #     - ./ollama_data:/root/.ollama

  # docker exec -it ollama bash
  # ollama pull deepseek-r1:8b
  # ollama list
  # ollama run deepseek-r1:8b

  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    restart: unless-stopped
    ports:
      - 2025:8080
    environment:
      - WEBUI_SECRET_KEY=${WEBUI_SECRET_KEY}
      - OLLAMA_BASE_URL=${OLLAMA_BASE_URL}
      - OPENAI_API_BASE_URL=${OPENAI_API_BASE_URL}
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - CORS_ALLOW_ORIGIN=${CORS_ALLOW_ORIGIN}
      - FORWARDED_ALLOW_IPS=${FORWARDED_ALLOW_IPS}
      - SCARF_NO_ANALYTICS=${SCARF_NO_ANALYTICS}
      - DO_NOT_TRACK=${DO_NOT_TRACK}
      - ANONYMIZED_TELEMETRY=${ANONYMIZED_TELEMETRY}
    extra_hosts:
      - host.docker.internal:host-gateway
    volumes:
      - ./open_webui_data:/app/backend/data
    # depends_on:
    #   - ollama
```

env:

```ini
WEBUI_SECRET_KEY=OpenWebUiAdmin

OLLAMA_BASE_URL=http://ollama:11434

OPENAI_API_BASE_URL=http://192.168.3.100:12345/v1 # LM Studio
OPENAI_API_KEY=

FORWARDED_ALLOW_IPS=*
CORS_ALLOW_ORIGIN=*

SCARF_NO_ANALYTICS=true
DO_NOT_TRACK=true
ANONYMIZED_TELEMETRY=false
```

### NextChat

[NextChat](https://github.com/ChatGPTNextWeb/NextChat) (ранее ChatGPT-Next-Web) - веб-интерфейс для ChatGPT, Gemini и других AI совместимсых с OpenAI API.


```yaml
services:
  nextchat:
    container_name: nextchat
    image: yidadaa/chatgpt-next-web
    ports:
      - 3000:3000
    environment:
      - CODE=$CODE
      - BASE_URL=$BASE_URL
      - OPENAI_API_KEY=$OPENAI_API_KEY
      - DEFAULT_MODEL=$DEFAULT_MODEL
      - CUSTOM_MODELS=$CUSTOM_MODELS
      - HIDE_USER_API_KEY=$HIDE_USER_API_KEY
      - ENABLE_BALANCE_QUERY=$ENABLE_BALANCE_QUERY
```

env:

```ini
CODE=NextChatAdmin

BASE_URL=http://192.168.3.100:12345 # LM Studio
OPENAI_API_KEY=
DEFAULT_MODEL=qwen/qwen3-8b
CUSTOM_MODELS=

HIDE_USER_API_KEY=1     # отключить использование пользовательского API ключа
ENABLE_BALANCE_QUERY=1  # отключить возможность запрашивать баланс для пользователей

OPENAI_ORG_ID=
DISABLE_GPT4=
PROXY_URL=
ENABLE_MCP=
DISABLE_FAST_LINK=
GOOGLE_URL=
GOOGLE_API_KEY=
DEEPSEEK_API_KEY=
ANTHROPIC_URL=
ANTHROPIC_API_KEY=
ANTHROPIC_API_VERSION=
SILICONFLOW_URL=
SILICONFLOW_API_KEY=
AI302_API_KEY=
AI302_URL=
WHITE_WEBDAV_ENDPOINTS=
```

### Continue

[Continue](https://github.com/continuedev/continue) - интеграция AI-агентов для выполнения рефакторинга во время написания кода в IDE.

🔗 [Continue VSCode Extension](https://marketplace.visualstudio.com/items?itemName=Continue.continue) ↗

```yaml
{
  "models": [
    {
      "apiBase": "http://192.168.3.100:12345/v1/",
      "model": "qwen/qwen3-8b",
      "title": "LM Studio (QWEN 3 8B)",
      "provider": "lmstudio",
      "apiKey": "123"
    }
  ],
  "tabAutocompleteModel": [
    {
      "apiBase": "http://192.168.3.100:12345/v1/",
      "model": "qwen/qwen3-8b",
      "title": "LM Studio (QWEN 3 8B)",
      "provider": "lmstudio",
      "apiKey": "123"
    }
  ]
}
```

## API Stack

### Scalar

[Scalar](https://github.com/scalar/scalar) - интерактивный справочник для документации OpenAPI (like Swagger UI) и REST API клиент в одном веб-приложение.

🔗 [API Reference Playground](https://docs.scalar.com/editor#/reference) ↗

🔗 [API Client Playground](https://client.scalar.com/workspace/default/request/default) ↗

```yaml
services:
  scalar:
    image: scalarapi/api-reference:latest
    container_name: scalar
    restart: unless-stopped
    ports:
      - 4005:8080
    environment:
      API_REFERENCE_CONFIG: |
        {
          "theme": "purple"
        }
    volumes:
      - ./docs:/docs:ro
```

### Restfox

[Restfox](https://github.com/flawiddsouza/Restfox) - легковесный и быстрый офлайн API-клиент (WebUI/Desktop) с поддержкой импорт коллекций из OpenAPI и экспорт в Postman и Insomnia.

🔗 [Restfox API Client Playground](https://restfox.dev) ↗

🔗 [Restfox Desktop Client](https://github.com/flawiddsouza/Restfox/releases) ↗

```yaml
services:
  restfox:
    image: flawiddsouza/restfox:latest
    container_name: restfox
    restart: unless-stopped
    ports:
      - 4004:4004
```

### Yaade

[Yaade](https://github.com/EsperoTech/yaade) — это среда совместной разработки API, размещаемая на собственном сервере (еще один API клиент с веб-интерфейсом).

```yaml
services:
  yaade:
    image: esperotech/yaade:latest 
    container_name: yaade
    restart: unless-stopped
    ports:
      - 9339:9339
    environment:
      - YAADE_ADMIN_USERNAME=admin
      - YAADE_ADMIN_PASSWORD=password
    volumes:
      - ./yaade_data:/app/data
```

🔗 [Hoppscotch API Client Playground](https://hoppscotch.io/) ↗

🔗 [HTTPie API Client Playground](https://httpie.io/app) ↗

🔗 [Postman Collections to OpenAPI Docs](https://kevinswiber.github.io/postman2openapi) ↗

### HTTPBin

[go-httpbin](https://github.com/mccutchen/go-httpbin) - API сервер клиент для тестирования HTTP запросов и ответов (fork [httpbin](https://github.com/postmanlabs/httpbin) от Postman Labs).

🔗 [HTTPBin Playground](https://httpbin.org) ↗

🔗 [HTTPBin Go Playground](https://httpbingo.org) ↗

```yaml
services:
  httpbin:
    image: ghcr.io/mccutchen/go-httpbin
    container_name: httpbin
    restart: unless-stopped
    ports:
      - 8888:8080
```

### Swagger UI

[Swagger UI](https://github.com/swagger-api/swagger-ui) - браузер для спецификации OpenAPI (поддерживает загрузку любой переданной спецификации через url).

🔗 [Swagger UI Playground](https://petstore.swagger.io) ↗

🔗 [Swagger Viewer VSCode Extension](https://github.com/arjun-g/vs-swagger-viewer) ↗

```yaml
services:
  swagger-ui:
    image: docker.swagger.io/swaggerapi/swagger-ui
    container_name: swagger-ui
    restart: unless-stopped
    ports:
      - 8889:8080
    environment:
      - PORT=8080
      - SWAGGER_JSON=/app/swagger.json
      - SWAGGER_JSON_URL=
      - API_KEY=**None**
    volumes:
      - ./docs/httpbin.json:/app/swagger.json:ro
    depends_on:
      - httpbin
```

### Swagger Editor

[Swagger Editor](https://github.com/swagger-api/swagger-editor) - онлайн редактор документации OpenAPI с поддержкой генерации клентов и заглушек API для разных языков с помощью [codegen](https://github.com/swagger-api/swagger-codegen).

🔗 [Swagger Editor Playground](https://editor.swagger.io) ↗

```yaml
services:
  swagger-editor:
    image: docker.swagger.io/swaggerapi/swagger-editor
    container_name: swagger-editor
    restart: unless-stopped
    ports:
      - 8890:8080
    environment:
      - PORT=8080
      - BASE_URL=/
      - URL=http://192.168.3.101:8889/swagger.json
    depends_on:
      - httpbin
```

### Step CI

[Step CI](https://github.com/stepci/stepci) - инструмент командной строки для тестирования GraphQL, gRPC, SOAP и REST API в DevOps Pipelines (например, локально в консоли или в GitHub Actions)

🔗 [Step CI Playground](https://stepci.com) ↗

```yaml
services:
  step-ci:
    image: ghcr.io/stepci/stepci
    container_name: step-ci
    volumes:
      - ./step-ci-tests:/tests
    command: tests/httpbin.yml
```

### OpenSERP

[OpenSERP](https://github.com/karust/openserp) - бесплатный API и интерфейс командной строки для работы с поисковыми запросами из Google, Yandex, Baidu, Bing, DuckDuckGo и Ecosia .

```yaml
services:
  openserp:
    image: karust/openserp:latest
    container_name: serp
    restart: unless-stopped
    shm_size: 2gb
    command: serve -l
    ports:
      - 7000:7000
    environment:
      OPENSERP_SERVER_HOST: "0.0.0.0"
      OPENSERP_SERVER_PORT: 7000
      OPENSERP_BAIDU_RATE_REQUESTS: 6
      OPENSERP_BAIDU_RATE_BURST: 2
    volumes:
      - ./config.yaml:/usr/src/app/config.yaml:ro
```

## Network Stack

### Networking Toolbox

[Networking Toolbox](https://github.com/lissy93/networking-toolbox) - более 100 сетевых инструментов и утилит, предназначенных для работы в автономном режиме (от создателя web-check, [dashy](https://github.com/Lissy93/dashy) и [AdGuardian-Term](https://github.com/Lissy93/AdGuardian-Term)).

🔗 [Networking Toolbox Playground](https://networkingtoolbox.net) ↗

```yaml
services:
  networking-toolbox:
    image: lissy93/networking-toolbox:latest
    container_name: networking-toolbox
    restart: unless-stopped
    environment:
      - NODE_ENV=production
      - PORT=3000
      - HOST=0.0.0.0
    ports:
      - 3100:3000
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://127.0.0.1:3000/health"]
      start_period: 40s
      interval: 30s
      timeout: 10s
      retries: 3
```

### Web Check

[Web Check](https://github.com/Lissy93/web-check) - универсальный инструмент OSINT для анализа любого веб-сайта.

🔗 [Web Check Playground](https://web-check.xyz) ↗

```yaml
services:
  web-check:
    image: lissy93/web-check:latest
    container_name: web-check
    restart: unless-stopped
    ports:
      - 3101:3000
```

### IP Check

[IP Check / MyIP](https://github.com/jason5ng32/MyIP) - набор инструментов для проверки IP-адресов. Включаем в себя проверки DNS, соединения WebRTC, speedtest, ICMP, MTR, доступность веб-сайтов и другие возможности.

🔗 [IP Check Playground](https://ipcheck.ing/#/) ↗

```yaml
services:
  ip-check:
    container_name: ip-check
    image: jason5ng32/myip:latest
    restart: unless-stopped
    stdin_open: true
    tty: true
    ports:
      - 3102:18966
```

### ZoneMaster

[ZoneMaster](https://github.com/zonemaster/zonemaster) - веб-интерфейс, API и инструмент командной строки для проверки DNS.

`docker run -t --rm zonemaster/cli zonemaster.net`

🔗 [ZoneMaster Test Domains Playground](https://zonemaster.net/en/run-test) ↗

[Check Host](https://check-host.net/?lang=ru) - бесплатный онлайн инструмент и API для ICMP, HTTP/HTTPS, TCP, UDP и DNS проверок доступности узлов из разных стран.

[Looking.House](https://looking.house/looking-glass) - инструмент для проверки скорости загрузки и выгрузки (а также проверок ping, traceroute и mtr) из множества точек [Looking Glass](https://github.com/gnif/LookingGlass), расположенных в ДЦ по всему миру.

### Pinguem

[Pinguem](https://github.com/Lifailon/pinguem) - веб-интерфейс и экспортер Prometheus для асинхронной проверки доступности выбранных хостов или подсетей с использованием библиотеки [node-ping](https://github.com/danielzzz/node-ping).

```yaml
services:
  pinguem:
    image: lifailon/pinguem:latest
    container_name: pinguem
    restart: unless-stopped
    ports:
      - 8085:8085 # Fronend (WebUI)
      - 3005:3005 # Backend (API)
```

### SmokePing

[SmokePing](https://github.com/oetiker/SmokePing) - система регистрации, построения графиков и оповещения о задержках, которая состоит из демона для организации измерения задержек и CGI-интерфейса для отображения графиков.

🔗 [SmokePing Playground](https://smokeping.oetiker.ch/?target=Customers.OP) ↗

```yaml
services:
  smokeping:
    image: lscr.io/linuxserver/smokeping:latest
    container_name: smokeping
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
      - MASTER_URL=https://smokeping.docker.local/smokeping/
      - SHARED_SECRET=password
      - CACHE_DIR=/tmp
    volumes:
      - ./smokeping_conf:/config
      - ./smokeping_data:/data
    ports:
      - 8000:80
```

### Ntopng

[Ntopng](https://github.com/ntop/ntopng) — форк оригинального `ntop` (написанного в 1998 году), с улучшенной производительностью, новыми функциями и веб-интерфейсом для анализа и мониторинга сетевого трафика. Поддерживает отображение графиков использования пропускной способности, анализ `pcap` файлов, списки активных подключений (like `netstat` или `ss`) и другую информацию.

```yaml
services:
  ntopng:
    image: ntop/ntopng:latest
    container_name: ntopng
    restart: unless-stopped
    volumes:
      - ./ntopng_data:/var/lib/ntopng
    # command: --community -d /var/lib/ntopng -i eth0 -r ntopng-redis:6379@0 -w 0.0.0.0:3080
    command: --community -d /var/lib/ntopng -i eth0 -r localhost:6379@0 -w 0.0.0.0:3080
    network_mode: host
    # ports:
    #   - 3080:3080

  ntopng-redis:
    image: redis:alpine
    restart: unless-stopped
    container_name: ntopng-redis
    volumes:
      - ./ntopng_redis:/data
    command: --save 900 1
    ports:
      - 6379:6379
```

### NetAlertX

[NetAlertX](https://github.com/jokob-sk/NetAlertX) - сканер присутствия (форк [Pi.Alert](https://github.com/leiweibau/Pi.Alert) для Docker) и обнаружения в локальной или WiFi сети с отправкой уведомлений (например, в Telegram через [Apprise](https://github.com/caronc/apprise)).

```yaml
services:
  # sudo mkdir -p ./netalertx_data/db ./netalertx_data/config
  # sudo chown -R 20211:20211 ./netalertx_data
  # sudo chmod -R 775 ./netalertx_data
  # sudo rm -f ./netalertx_data/db/app.db
  netalertx:
    image: jokobsk/netalertx:latest
    container_name: netalertx
    restart: unless-stopped
    read_only: true
    mem_limit: 2048m
    mem_reservation: 1024m
    cpu_shares: 512
    pids_limit: 512
    user: 20211:20211
    network_mode: host
    cap_drop:
      - ALL
    cap_add:
      - NET_ADMIN         # Требуется для сканирования ARP 
      - NET_RAW           # Требуется для операций с необработанными сокетами
      - NET_BIND_SERVICE  # Требуется для привязки к привилегированным портам (nbtscan)
    volumes:
      - ./netalertx_data:/data
      - /etc/localtime:/etc/localtime:ro
    tmpfs:
      - /tmp:uid=20211,gid=20211,mode=1700,rw,noexec,nosuid,nodev,async,noatime,nodiratime
    environment:
      - LISTEN_ADDR=0.0.0.0
      - PORT=20211
      - GRAPHQL_PORT=20212
      - ALWAYS_FRESH_INSTALL=false
      - NETALERTX_DEBUG=0
```

### IVRE

[IVRE](https://github.com/ivre/ivre) (Instrument de veille sur les réseaux extérieurs) - платформа сетевой разведки, включающая инструменты для пассивной и активной разведки (например, [Nmap](https://github.com/nmap/nmap) и [Masscan](https://github.com/robertdavidgraham/masscan)).

```yaml
services:
  ivredb:
    image: mongo
    container_name: ivredb
    restart: unless-stopped
    volumes:
      - ./var_lib_mongodb:/data/db

  ivreuwsgi:
    image: ivre/web-uwsgi
    container_name: ivreuwsgi
    restart: unless-stopped
    volumes:
      - ./dokuwiki_data:/var/www/dokuwiki/data
    depends_on:
      - ivredb

  ivredoku:
    image: ivre/web-doku
    container_name: ivredoku
    restart: unless-stopped
    volumes:
      - ./dokuwiki_data:/var/www/dokuwiki/data

  ivreweb:
    image: ivre/web
    container_name: ivreweb
    restart: unless-stopped
    volumes:
      - ./dokuwiki_data:/var/www/dokuwiki/data
    ports:
      - 7077:80
    depends_on:
      - ivreuwsgi
      - ivredoku

  ivreclient:
    image: ivre/client
    container_name: ivreclient
    stdin_open: true
    tty: true
    volumes:
      - ./ivre_share:/ivre-share
    depends_on:
      - ivredb
```

### WebMan

[WebMan](https://github.com/SabyasachiRana/WebMap) - веб-интерфейс для XML отчетов [nmap](https://github.com/nmap/nmap).

```yaml
services:
  webmap:
    image: reborntc/webmap:latest
    container_name: webmap
    restart: unless-stopped
    ports:
      - 7005:8000
    volumes:
      - ./nmap_reports:/opt/xml

# nmap -sT -A -T4 -oX ./nmap_reports/network.xml 192.168.3.0/24
```

### RTSP to Web

[RTSP to Web](https://github.com/deepch/RTSPtoWeb) - `RTSP` клиент в браузере.

```yaml
services:
  rtsptoweb:
    image: ghcr.io/deepch/rtsptoweb:latest
    container_name: rtsp-to-web
    restart: unless-stopped
    # volumes:
    #   - ./rtsp_config/config.json:/config/config.json
    ports:
      - 8083:8083
```

### Gotify

[Gotify](https://github.com/gotify/server) - легковесный сервер для отправки и получения push-уведомлений в режиме реального времени, работающий через Веб-сокеты, который позволяет развернуть собственный сервис уведомлений, получая сообщения через API на мобильные приложения или в Веб-интерфейс. Поддерживает отправку сообщений через REST-API, Swagger документацию, управление пользователями и приложениями через WebUI и собственное Android приложение.

```yaml
services:
  gotify:
    image: gotify/server
    container_name: gotify
    restart: always
    ports:
      - 5080:80
    environment:
      GOTIFY_DEFAULTUSER_PASS: admin
    volumes:
      - ./gotify_data:/app/data
```

### Apprise

[Apprise](https://github.com/caronc/apprise) - система для отправки уведомления более чем в 100+ служб, с поддержкой веб интерфейса для настройки конфигураций (используется в [NetAlertX](https://github.com/jokob-sk/NetAlertX) для отправки уведомлений в Telegram).

```yaml
services:
  apprise:
    image: caronc/apprise:latest
    container_name: apprise
    restart: unless-stopped
    ports:
      - 8000:8000
    volumes:
      - ./apprise_config:/config
```

### Alerta

[Alerta](https://github.com/alerta/alerta) - инструмент, который озволяет с помощью одной системы отслеживать оповещения из множества других инструментов мониторинга на одном экране.

```yaml
services:
  alerta-api:
    image: ghcr.io/alerta/alerta-api
    container_name: alerta
    restart: unless-stopped
    ports:
      - 8845:8080
    environment:
      - DATABASE_URL=postgres://postgres:postgres@alerta-db:5432/monitoring
    depends_on:
      - alerta-db

  alerta-db:
    image: alerta-db
    container_name: alerta-db
    restart: unless-stopped
    # ports:
    #   - 5432:5432
    environment:
      POSTGRES_DB: monitoring
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
```

### LibreSpeedTest

[LibreSpeedTest](https://github.com/librespeed/speedtest) - сервер измерения скорости сети в Интернете на базе HTML5 для размещения на собственном сервере, с поддержкой мобильных устройств.

🔗 [LibreSpeedTest Playground](https://librespeed.org) ↗

```yaml
services:
  libre-speedtest:
    image: lscr.io/linuxserver/librespeed:latest
    container_name: libre-speedtest
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/GMT+3
      - PASSWORD=PASSWORD # пароль для базы данных результатов
      - CUSTOM_RESULTS=true # опционально, включить пользовательскую страницу результатов в /config/www/results/index.php
      # - DB_TYPE=sqlite # по умолчанию sqlite (доступно mysql и postgresql)
      # - DB_NAME=DB_NAME # опционально, имя базы данных (требуется для mysql и pgsql)
      # - DB_HOSTNAME=DB_HOSTNAME # опционально
      # - DB_USERNAME=DB_USERNAME # опционально
      # - DB_PASSWORD=DB_PASSWORD # опционально
      # - DB_PORT=DB_PORT # опционально
      # - IPINFO_APIKEY=ACCESS_TOKEN # опционально, токен доступа от ipinfo.io (требуется для подробной информации об ip)
    volumes:
      - ./librespeed/config:/config
    ports:
      - 8088:80
```

### OpenSpeedTest

[OpenSpeedTest](https://github.com/openspeedtest/Speed-Test) - бесплатный веб-инструмент для оценки производительности сети на базе HTML5, написанный на чистом JavaScript и использующий только встроенные веб-API.

🔗 [OpenSpeedTest Playground](https://openspeedtest.com) ↗

```yaml
services:
  open-speedtest:
    image: openspeedtest/latest:latest
    container_name: opens-peedtest
    restart: unless-stopped
    # environment:
    #   - ENABLE_LETSENCRYPT=True
    #   - DOMAIN_NAME=speedtest.domain.com
    #   - USER_EMAIL=name@domain.com
    ports:
      - 3000:3000
      - 3001:3001
```

### SpeedTest Tracker

[SpeedTest Tracker](https://github.com/alexjustesen/speedtest-tracker) - веб-приложение для отслеживания производительности и времени безотказной работы Интернет-соединения с собственным веб-интерфейсом для визуализации графиков измерений, а а также интеграция с [Homapage](https://gethomepage.dev/widgets/services/speedtest-tracker).

```yaml
# Generate app key: echo -n 'base64:'; openssl rand -base64 32;
# Default credentials: admin@example.com:password

services:
  speedtest-tracker:
    image: lscr.io/linuxserver/speedtest-tracker:latest
    container_name: speedtest-tracker
    restart: unless-stopped
    ports:
      - 8778:80
    # labels:
    #   - traefik.enable=true
    #   - traefik.http.routers.speedtest-tracker.rule=Host(`speedtest.docker.local`)
    #   - traefik.http.services.speedtest-tracker.loadbalancer.server.port=80
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
      - APP_KEY=base64:e6otzoFWjt0GoEOL/QlPQw2Xgm63OMU3lA5V4nLgXJ4=
      - APP_URL=http://192.168.3.101
      # - APP_URL=http://speedtest.docker.local
      - DB_CONNECTION=sqlite
      # - DB_CONNECTION=pgsql
      # - DB_HOST=speedtest-db
      # - DB_PORT=5432
      # - DB_DATABASE=speedtest_tracker
      # - DB_USERNAME=speedtest
      # - DB_PASSWORD=PgAdmin
    volumes:
      - ./speedtest_config:/config
      - ./ssl:/config/keys
    # depends_on:
    #   - speedtest-db

  # speedtest-db:
  #   image: postgres:17
  #   container_name: speedtest-db
  #   restart: unless-stopped
  #   # ports:
  #   #   - 5432:5432
  #   environment:
  #     - POSTGRES_DB=speedtest_tracker
  #     - POSTGRES_USER=speedtest
  #     - POSTGRES_PASSWORD=PgAdmin
  #   volumes:
  #     - ./speedtest_data:/var/lib/postgresql/data
  #   healthcheck:
  #     test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
  #     interval: 5s
  #     retries: 5
  #     timeout: 5s
```

### MySpeed

[MySpeed](https://github.com/gnmyt/MySpeed) - веб-приложение от создателя [Nexterm](https://github.com/gnmyt/Nexterm) для автоматизации тестирования скорости Интернет-канала связи. Поддерживает сервера проверки скорости [Ookla SpeedTest](https://www.speedtest.net), [LibreSpeed](https://librespeed.org) ​​и [Cloudflare SpeedTest](https://speed.cloudflare.com), настройку времени между тестами с помощью выражений Cron, отправку оповещений в Telegram, хранение результатов до 30 дней, а также метрики Prometheus и виджет для [Homapage](https://gethomepage.dev/widgets/services/myspeed).

```yaml
services:
  myspeed:
    image: germannewsmaker/myspeed:latest
    container_name: myspeed
    restart: unless-stopped
    environment:
      - SERVER_PORT=5216
    volumes:
      - ./myspeed_data:/myspeed/data
    ports:
      - 5216:5216

# Получить идентификаторы ближайших серверов
# curl -s https://www.speedtest.net/api/js/servers?engine=js | jq '.[] | select(.country == "Russia")'
```

### Netronome

[Netronome](https://github.com/autobrr/netronome) - инструмент для тестирования и мониторинга скорости сети, от создателя autobrr и [qu](https://github.com/autobrr/qui), разработанный с использованием Go и React. Поддерживает сервера [iperf3](https://github.com/esnet/iperf) и [Librespeed](https://github.com/librespeed/speedtest), а также базовый мониторинг метрик через агентов. 

```yaml
services:
  netronome:
    image: ghcr.io/autobrr/netronome:latest
    container_name: netronome
    restart: unless-stopped
    user: root
    ports:
      - 7575:7575
    volumes:
      - ./netronome_data:/data
```

### SpeedTest Exporter

[SpeedTest Exporter](https://github.com/MiguelNdeCarvalho/speedtest-exporter) - экспортер Prometheus, написанный на Python с использованием официального интерфейса командной строки Ookla Speedtest.

🔗 [Grafana Dashboard](https://grafana.com/grafana/dashboards/13665-speedtest-exporter-dashboard/) ↗

```yaml
services:
  speedtest-exporter:
    image: miguelndecarvalho/speedtest-exporter
    container_name: speedtest-exporter
    restart: unless-stopped
    # environment:
      # - SPEEDTEST_PORT=9798
      # - SPEEDTEST_SERVER=21110 
    ports:
      - 9798:9798
```

### iperf

[iperf](https://github.com/esnet/iperf) - утилита командной строки (клиент-серверная архитектура) для проверки скорости загрузки и выгрузки в локальной сети.

```yaml
services:
  iperf-server:
    image: alpine:latest
    container_name: iperf-server
    restart: unless-stopped
    command: >
      sh -c "
        apk add --no-cache iperf3 &&
        exec iperf3 -s -p $$PORT
      "
    environment:
      - PORT=5201
    ports:
      - 5201:5201
```

### Temp Mail

🔗 [Temp Mail UI](https://github.com/mehmetkahya0/temp-mail) ↗

🔗 [Temp Mail UI Playground](https://mehmetkahya0.github.io/temp-mail) ↗

🔗 [Temp Fast Mail](https://github.com/kasteckis/TempFastMail) ↗

🔗 [Temp Fast Mail Playground](https://tempfastmail.com) ↗

### Portracker

[Portracker](https://github.com/mostafa-wahied/portracker) - система мониторинга портов для автоматического выявления сервисов и отрисовки карты сети. Поддерживает сборщиков данных для Docker и TrueNAS, а также возможность мониторинга в режиме peer-to-peer.

```yaml
services:
  portracker:
    image: mostafawahied/portracker:latest
    container_name: portracker
    restart: unless-stopped
    pid: host  # Required for port detection
    cap_add:
      - SYS_PTRACE
      - SYS_ADMIN
    security_opt:
      - apparmor:unconfined
    ports:
      - 4999:4999
    # environment:
    #   - TRUENAS_API_KEY=api-key
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./portracker_data:/data
```

## SMTP Stack

### SMTP to Telegram

[SMTP to Telegram](https://github.com/KostyaEsmukov/smtp_to_telegram) - SMTP сервер (листенер) для переадресации сообщений в Telegram.

```yaml
services:
  smtp2telegram:
    image: kostyaesmukov/smtp_to_telegram
    container_name: smtp2telegram
    restart: unless-stopped
    environment:
      - ST_SMTP_LISTEN=0.0.0.0:2525
      - ST_TELEGRAM_CHAT_IDS=
      - ST_TELEGRAM_BOT_TOKEN=
      - "ST_TELEGRAM_MESSAGE_TEMPLATE=Subject: {subject}\\\\n\\\\n{body}"
    ports:
      - 2525:2525

# echo -e "Subject: Test\n\nThis is test body" | curl smtp://localhost:2525 \
#   --mail-from admin@docker.local \
#   --mail-rcpt admin@docker.local \
#   --user admin:admin \
#   -T -
```

### Docker MailServer

[Docker MailServer](https://github.com/docker-mailserver/docker-mailserver) - простой и готовый к продакшену контейнеризированный почтовый сервер в стеке из SMTP, IMAP, LDAP, анти-спам системы и антивируса. Настраивается с помощью одного конфигурационного файл, не требует SQL базы данных.

```yaml
services:
  mailserver:
    image: ghcr.io/docker-mailserver/docker-mailserver:latest
    container_name: mailserver
    restart: always
    hostname: mail.docker.local
    env_file: mailserver.env
    ports:
      - 25:25    # SMTP
      - 143:143  # IMAP4
      - 465:465  # ESMTP
      - 587:587  # ESMTP
      - 993:993  # IMAP4
    volumes:
      - ./docker-data/dms/mail-data/:/var/mail/
      - ./docker-data/dms/mail-state/:/var/mail-state/
      - ./docker-data/dms/mail-logs/:/var/log/mail/
      - ./docker-data/dms/config/:/tmp/docker-mailserver/
      - /etc/localtime:/etc/localtime:ro
    stop_grace_period: 1m
    # Uncomment if using `ENABLE_FAIL2BAN=1`:
    # cap_add:
    #   - NET_ADMIN
    healthcheck:
      test: "ss --listening --ipv4 --tcp | grep --silent ':smtp' || exit 1"
      timeout: 3s
      retries: 0
```

### MailPit

[MailPit](https://github.com/axllent/mailpit) - SMTP-сервер для тестирования электронной почты, основанный на [MailHog](https://github.com/mailhog/MailHog) (который больше не поддерживается), с поддержкой веб-интерфейса (SMTP-клиент) для просмотра получаемх писем, а также API для автоматизированного тестирования и интеграции.

🔗 [MailPit API Docs](https://mailpit.axllent.org/docs/api-v1/view.html#get-/api/v1/info) ↗

```yaml
services:
  mailpit:
    image: axllent/mailpit
    container_name: mailpit
    restart: unless-stopped
    volumes:
      - ./mailpit_data:/data
    environment:
      - TZ=Etc/GMT+3
      - MP_DATABASE=/data/mailpit.db
      # - MP_UI_AUTH_FILE=/data/authfile
      - MP_SMTP_AUTH_ACCEPT_ANY=1
      - MP_SMTP_AUTH_ALLOW_INSECURE=1
    ports:
      - 8125:8025
      - 8225:1025
```

### MailDev

[MailDev](https://github.com/maildev/maildev) - SMTP-сервер и веб-интерфейс для просмотра и тестирования почты во время разработки (например, используется для проверки содержимого письма при отправки оповещений, сброса пароля и т.п.).

```yaml
services:
  maildev:
    image: maildev/maildev
    container_name: maildev
    restart: unless-stopped
    environment:
      - TZ=Etc/GMT+3
      - MAILDEV_WEB_PORT=1080
      - MAILDEV_SMTP_PORT=1025
    ports:
      - 8028:1080
      - 8025:1025
```

### Happy Deliver

[Happy Deliver](https://github.com/happyDomain/happydeliver) - инструмент для тестирования доставки электронных писем, с анализом писем и оценкой `SPF`, `DKIM`, `DMARC`, `BIMI`, `ARC`, SpamAssassin, записи `DNS`, статус черного списка, качество контента и многое другое. Поддерживает полнофункциональный REST API для создания тестов и получения отчетов, встроенный сервер `LMTP` для бесшовной интеграции `MTA` и присвоения оценок (от `A` до `F`).

🔗 [Happy Deliver Playground](https://happydeliver.org) ↗

```yaml
services:
  happydeliver:
    image: happydomain/happydeliver:latest
    container_name: happydeliver
    restart: unless-stopped
    hostname: happydeliver.docker.local
    environment:
      DOMAIN: docker.local
      HOSTNAME: happydeliver.docker.local
    volumes:
      - ./happydeliver_data:/var/lib/happydeliver
      - ./happydeliver_logs:/var/log/happydeliver
    ports:
      - 8525:25
      - 8580:8080
```

### Open Trashmail

[Open Trashmail](https://github.com/HaschekSolutions/opentrashmail) - почтовый сервер для временной электронной почты. Позволяет получать доступ к электронным письмам через веб-интерфейс, JSON API и RSS-ленту. Поддерживает настройку доменов, портов, TLS и других параметров через файл конфигурации, а также интеграцию с другими проектами через вебхуки.

```yaml
services:
  trashmail:
    image: hascheksolutions/opentrashmail:1
    container_name: trashmail
    restart: unless-stopped
    ports:
      - 2525:25
      - 8080:80
    environment:
      - URL=http://localhost:8080
      - DOMAINS=example.com
      - DATEFORMAT=D.M.YYYY HH:mm
      - SKIP_FILEPERMISSIONS=true
      - DISCARD_UNKNOWN=false
      - ADMIN_ENABLED=true
      - ADMIN_PASSWORD=Admin123098
      - PASSWORD=Admin123098
      - ATTACHMENTS_MAX_SIZE=10000000
      # - MAILPORT_TLS=465
      # - TLS_CERTIFICATE=cert.pem
      # - TLS_PRIVATE_KEY=key.pem
      # - WEBHOOK_URL=https://example.com/webhook
      # - ALLOWED_IPS=192.168.0.0/16,2a02:ab:cd:ef::/60
    volumes:
      - ./trashmail_data:/var/www/opentrashmail/data
      - ./trashmail_logs:/var/www/opentrashmail/logs
```

## Development Stack

### IT Tools

IT Tools - большая коллекция утилит для разработчиков (криптография, конверторы, веб инструменты и многое другое).

🔗 [IT Tools Playground](https://it-tools.tech) ↗

```yaml
services:
  it-tools:
    image: corentinth/it-tools:latest
    container_name: it-tools
    restart: unless-stopped
    ports:
      - 6990:80
```

### CyberChef

[CyberChef](https://github.com/gchq/CyberChef) - веб-приложение для выполнения всевозможных кибер-операций в веб-браузере, которые включают в себя простое кодирование (например, `XOR` и `Base64`), более сложное шифрование (например, `AES`, `DES` и `Blowfish`), создание двоичных и шестнадцатеричных дампов, сжатие и распаковка данных, вычисление хешей и контрольных сумм, парсинг `IPv6` и `X.509`, изменение кодировок символов и многое другое.

🔗 [CyberChef Playground](https://gchq.github.io/CyberChef) ↗

```yaml
services:
  cyberchef:
    image: mpepping/cyberchef:latest
    container_name: cyberchef
    restart: unless-stopped
    ports:
      - 6990:8000
```

### Transform

[Transforms](https://github.com/ritz078/transform) - универсальный веб-конвертер.

🔗 [Transforms Playground](https://transform.tools) ↗

> [!NOTE]
> Используется неофициальный образ [lifailon/transform](https://hub.docker.com/r/lifailon/transform), собранный в репозитории [ruDocs](https://github.com/Lifailon/rudocs) для публичного использования.

```yaml
services:
  transform:
    image: lifailon/transform:amd64
    # build:
    #   context: .
    #   dockerfile: Dockerfile
    container_name: transform
    restart: unless-stopped
    ports:
      - 3090:3000
```

### Browsery Tools

[Browsery Tools](https://github.com/aghyad97/browserytools) - коллекция из более чем 130 браузерных инструментов, например, конвертации файлов, сжатия изображений, генерации паролей и форматирование кода, выполняемые непосредственно в браузере. Все инструменты работают локально, гарантируя, что данные пользователя не покидают его устройство.

🔗 [Browsery Tools Playground](https://browserytools.com) ↗

### Mazanoke

[Mazanoke](https://github.com/civilblur/mazanoke) - веб-приложение для сжатия (в процентах или мб), изменения разрешения (в пикселях) и конвертации изображений.

🔗 [Mazanoke Playground](https://mazanoke.com) ↗

```yaml
services:
  mazanoke:
    image: ghcr.io/civilblur/mazanoke:latest
    container_name: mazanoke
    restart: unless-stopped
    ports:
      - 3474:80
```

### ImgCompress

[ImgCompress](https://github.com/karimz1/imgcompress) - инструмент для обработки изображений, который позволяет сжимать, конвертировать, изменять размер и массово обрабатывать изображения, а также удалять фон с помощью локального ИИ без использования облачных сервисов.

```yaml
services:
  imgcompress:
    image: karimz1/imgcompress:latest
    container_name: imgcompress
    restart: unless-stopped
    ports:
      - 5000:5000
    environment:
      - DISABLE_LOGO=false
      - DISABLE_STORAGE_MANAGEMENT=false
```

### 8mb.local

[8mb.local](https://github.com/JMS1717/8mb.local) - веб-интерфейс для сжатия видео. Позволяет загружать видеофайлы, выбирать целевой размер в МБ и получать сжатые версии с использованием современных кодеков. Поддерживается аппаратное ускорение с помощью NVIDIA/Intel/AMD и CPU.

```yaml
services:
  8mb-local:
    image: jms1717/8mblocal:latest
    container_name: 8mb-local
    restart: unless-stopped
    ports:
      - 8001:8001
    volumes:
      - ./uploads:/app/uploads
      - ./outputs:/app/outputs
      - ./.env:/app/.env  # custom settings (optional)
    gpus: all
    # NVIDIA runtime / GPU environment (keep REDIS_URL above)
    environment:
      - REDIS_URL=redis://127.0.0.1:6379/0
      - NVIDIA_VISIBLE_DEVICES=all
      - NVIDIA_DRIVER_CAPABILITIES=compute,video,utility
      # Optional: enable VAAPI driver name for Intel/AMD when /dev/dri is mounted
      - LIBVA_DRIVER_NAME=iHD
```

🔗 [8mb.local Playground](https://video.elhacker.net) ↗

```yaml
services:
  mazanoke:
    image: ghcr.io/civilblur/mazanoke:latest
    container_name: mazanoke
    restart: unless-stopped
    ports:
      - 3474:80
```

### JSON Crack

[JSON Crack](https://github.com/AykutSarac/jsoncrack.com) - веб-приложение для визуализации JSON, YAML, XML и CSV в интерактивные графики.

🔗 [JSON Crack Playground](https://jsoncrack.com/editor) ↗

🔗 [JSON Crack VSCode Extension](https://github.com/AykutSarac/jsoncrack-vscode)  ↗

```yaml
services:
  jsoncrack:
    image: shokohsc/jsoncrack:latest
    container_name: jsoncrack
    restart: unless-stopped
    environment:
      - NODE_ENV=production
    # Доступ через Proxy по FQDN
    # ports:
    #   - 3080:8080
    labels:
      - traefik.enable=true
```

### Markmap

[Markmap](https://github.com/markmap/markmap) - как JSON Crack для Markdown.

🔗 [Markmap Playground](https://markmap.js.org/repl) ↗

🔗 [Markmap VSCode Extension](https://github.com/markmap/markmap-vscode)  ↗

### Termix

[Termix](https://github.com/Termix-SSH/Termix) - платформа для управления серверами с веб-интерфейсом. Поддерживает SSH-терминал с разделением экрана, управление SSH-туннелями, удалённый редактор файлов с подсветкой синтаксиса и мониторинг ресурсов сервера.

```yaml
services:
  termix:
    image: ghcr.io/lukegus/termix:latest
    container_name: termix
    restart: unless-stopped
    environment:
      PORT: 8080
    ports:
      - 6988:8080
    volumes:
      - ./termix_data:/app/data
```

### kkTerminal

[kkTerminal](https://github.com/zyyzyykk/kkTerminal) - веб-терминал для SSH-подключений с доступом к файлам и базовым мониторингом.

```yaml
services:
  kkterminal:
    image: zyyzyykk/kkterminal:latest
    container_name: kkterminal
    restart: unless-stopped
    ports:
      - 6989:3000
    environment:
      - BANNER=kkTerminal
      - STORAGE=P5P1SIqVe6kaOxMX
      - PASSWORD=admin
    volumes:
      - ./cloud_data:/cloud
```

### NexTerm

[NexTerm](https://github.com/gnmyt/Nexterm) - управление сервером в браузере с поддержкой 2FA для SSH (с поддержкой файлового браузера через SFTP), VNC и RDP, контейнерами Proxmox LXC, QEMU и развертывание приложений через Docker.

```yaml
services:
  nexterm:
    image: germannewsmaker/nexterm:latest
    container_name: nexterm
    restart: unless-stopped
    environment:
      # head -c 32 /dev/urandom | base64 || openssl rand -base64 32
      # head -c 32 /dev/urandom | xxd -p -c 32 || openssl rand -hex 32
      - ENCRYPTION_KEY=9dbde894647845ab33e13a9334cdbadc5f8d22abe42df0b3daff431eec0df870
    ports:
      - 6989:6989
    volumes:
      - ./nexterm_data:/app/data
```

### Code Server

[Code Server](https://github.com/coder/code-server) - VSCode сервер в браузере.

🔗 [VSCode Playground](https://vscode.dev) ↗

```yaml
services:
  code-server:
    image: linuxserver/code-server:latest
    container_name: code-server
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/GMT+3
      - PASSWORD=CodeServerAdmin
    volumes:
      - ./vscode_config:/config
      - $HOME:/home
    ports:
      - 9443:8443
```

### Judge0

[Judge0 IDE](https://github.com/judge0/ide) - онлайн-редактор кода, позволяющий писать и выполнять код (использует [Judge0](https://github.com/judge0/judge0) под капотом, для выполнения исходного кода) на широком спектре языков. Подходит для тех, кто хочет быстро внести правки и запустить код или изучаения нового языка, не открывая полнофункциональную IDE на своем компьютере.

🔗 [Judge0 IDE Playground](https://ide.judge0.com) ↗

```yaml
service:
  judge0-server:
    image: judge0/judge0:latest
    container_name: judge0-server
    restart: unless-stopped
    volumes:
      - ./judge0.conf:/judge0.conf:ro
    ports:
      - "2358:2358"
    privileged: true

  judge0-worker:
    image: judge0/judge0:latest
    container_name: judge0-worker
    restart: unless-stopped
    command: ["./scripts/workers"]
    volumes:
      - ./judge0.conf:/judge0.conf:ro
    privileged: true

  judge0-db:
    image: postgres:16.2
    container_name: judge0-db
    restart: unless-stopped
    env_file: judge0.conf
    volumes:
      - ./judge0_data:/var/lib/postgresql/data/

  judge0-redis:
    image: redis:7.2.4
    container_name: judge0-redis
    restart: unless-stopped
    command: [
      "bash", "-c",
      'docker-entrypoint.sh --appendonly no --requirepass "$$REDIS_PASSWORD"'
    ]
    env_file: judge0.conf
```

### Go Playground

[Better Go Playground](https://github.com/x1unix/go-playground) - улучшенная [Go Playground](https://go.dev/play) на базе [Monaco Editor](https://github.com/microsoft/monaco-editor) и React.

🔗 [Go Better Playground](https://goplay.tools) ↗

🔗 [Go Oficial Playground](https://go.dev/play) ↗

```yaml
services:
  go-playground:
    image: x1unix/go-playground:latest
    container_name: go-playground
    restart: unless-stopped
    environment:
      - APP_CLEAN_INTERVAL=30m
    ports:
      - 9444:8000
```

### Go Template Playground

[Repeatit](https://github.com/rytsh/repeatit) (Go Template Playground) - игровая площадка для проверки шаблонов GoLang. Поддерживает рендиринг текста и html шаблонов, функции spting и heml, а также ввод параметров шаблона в форматах yaml, json и toml.

🔗 [Go Template Playground](https://repeatit.io) ↗

🔗 [Jinja2 Playground](https://www.dainiak.com/jinja2-playground) ↗

> [!NOTE]
> Используется неофициальный образ [lifailon/go-template-playground](https://hub.docker.com/r/lifailon/go-template-playground), собранный в репозитории [ruDocs](https://github.com/Lifailon/rudocs) для публичного использования. Официальный образ `ghcr.io/rytsh/repeatit` был добавлен для Issue [#9](https://github.com/rytsh/repeatit/issues/9).

```yaml
services:
  go-template-playground:
    image: ghcr.io/rytsh/repeatit:latest
    # image: lifailon/go-template-playground:latest # 0.5.5-amd64
    container_name: go-template-playground
    restart: unless-stopped
    stdin_open: true
    tty: true
    ports:
      - 9445:8080
```

### Helm Playground

[Helm Playground](https://github.com/shipmight/helm-playground) - интерактивное веб-приложение для отладки шаблонизации Helm, включающий в себя шпаргалка по синтаксису.

🔗 [Helm Playground](https://helm-playground.com) ↗

> [!NOTE]
> Используется неофициальный мультиплатформенный образ [lifailon/helm-playground](https://hub.docker.com/r/lifailon/helm-playground), собранный в репозитории [ruDocs](https://github.com/Lifailon/rudocs) для публичного использования.

```yaml
  helm-playground:
    image: lifailon/helm-playground:latest
    container_name: helm-playground
    restart: always
    ports:
      - 8080:80
```

### TuxMate

[TuxMate](https://github.com/abusoww/tuxmate) - формирует скрипты для автоматической установки приложений для разных дистрибутивов Linux.

🔗 [TuxMate Playground](https://tuxmate.com) ↗

```yaml
services:
  tuxmate:
    image: ghcr.io/abusoww/tuxmate:latest
    container_name: tuxmate
    restart: unless-stopped
    ports:
      - 3080:80
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:80"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 10s
```

### D2 Playground

[D2 Playground](https://github.com/terrastruct/d2-playground) - игровая площадка для современного языка сценариев диаграмм, преобразующий текст в диаграммы.

🔗 [D2 Playground](https://play.d2lang.com) ↗

🔗 [D2 VSCode Extension](https://github.com/terrastruct/d2-vscode) ↗

> [!NOTE]
> Используется неофициальный образ [lifailon/d2-playground](https://hub.docker.com/r/lifailon/d2-playground), собранный в репозитории [ruDocs](https://github.com/Lifailon/rudocs) для публичного использования.

```yaml
services:
  d2-playground:
    image: lifailon/d2-playground:latest
    # build:
    #   context: .
    #   dockerfile: Dockerfile
    container_name: d2-playground
    restart: unless-stopped
    ports:
      - 9089:9090
```

### DrawIO

[Draw.io](https://github.com/jgraph/drawio) (like MS Visio) - веб-версия бесплатного приложения для создания различных диаграмм, блок-схем и т.п.

🔗 [Draw.io Playground](https://app.diagrams.net) ↗

🔗 [Draw.io VSCode Extension](https://github.com/hediet/vscode-drawio) ↗

```yaml
services:
  draw.io:
    image: jgraph/drawio:latest
    container_name: draw.io
    restart: unless-stopped
    stdin_open: true
    tty: true
    ports:
      - 9447:8080
```

### LicenseAPI

[LicenseAPI](https://github.com/gnmyt/LicenseAPI) - размещенная на собственном сервере система лицензирования для программного обеспечения от создателя Nexterm и MySpeed. Поддерживает графический интерфейс управления, систему разрешений, назначение метаданных лицензиям, проверка лицензий в автономном режиме и интеграцию с использованием REST API или SDK.

```yaml
services:
  licenseapi:
    image: germannewsmaker/licenseapi:development
    container_name: licenseapi
    restart: unless-stopped
    environment:
      - MONGOOSE_STRING=mongodb://licenseapi-mongo:27017/licenseapi
      - MAIL_SERVER=smtp.gmail.com
      - MAIL_PORT=587
      - MAIL_USER=noreply@gmail.com
      - MAIL_PASS=password
      - APP_URL=http://localhost:8025
      - DISABLE_SIGNUPS=false
    ports:
      - 8025:8025
    depends_on:
      - licenseapi-mongo

  licenseapi-mongo:
    image: mongo:latest
    container_name: licenseapi-mongo
    restart: unless-stopped
    volumes:
      - ./licenseapi_mongo_data:/data/db
```

### ConvertX

[ConvertX](https://github.com/C4illin/ConvertX) - онлайн-конвертер файлов, поддерживающий более 1000 форматов, включая документы, изображения, видео, аудио, электронные книги и 3D-модели. Использует веб-интерфейс для загрузки файлов, выбора целевого формата и загрузки результатов.

```yaml
services:
  convertx:
    image: ghcr.io/c4illin/convertx
    container_name: convertx
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      # non-http
      - HTTP_ALLOWED=true
      # randomUUID
      - JWT_SECRET=aLongAndSecretStringUsedToSignTheJSONWebToken1234
    volumes:
      - ./convertx_data:/app/data
```

### Certimate

[Certimate](https://github.com/certimate-go/certimate) - интерфейс и система автоматизации полного цикла управления SSL-сертификатами (выпуск, развертывание, обновление и мониторинг).

Он поддерживает более 70 DNS-провайдеров и свыше 150 мест развертывания, обеспечивая гибкость в выборе сервисов.

Программа не требует внешних зависимостей, что упрощает ее установку и использование

## Database Stack

### Tools

- [Outerbase Studio SQLite Playground](https://studio.outerbase.com/local) - веб-интерфейс для управления базами данных.

- [SQLite Viewer Playground](https://sqliteviewer.app) - веб-интерфейс для управления файловыми базами данных SQLite.

- [DBeaver](https://github.com/dbeaver/dbeaver)  - кросплатформенный и универсальный SQL-клиент и инструмент для работы с базами данных.

- [Beekeeper Studio](https://github.com/beekeeper-studio/beekeeper-studio) - современный и простой в использовании SQL-клиент для MySQL, Postgres, SQLite, SQL Server и других баз данных для систем Linux, MacOS и Windows.

- [HeidiSQL](https://github.com/HeidiSQL/HeidiSQL) - легковесный графический интерфейс для управления MySQL/MariaDB, SQL Server, PostgreSQL, SQLite, Interbase и Firebird для системы Windows.

- [RainFrog](https://github.com/achristmascarl/rainfrog) - TUI для управления Postgres, MySQL, SQLite, DuckDB и Oracle.

- [DBLab](https://github.com/danvergara/dblab) - TUI клиент для PostgreSQL, MySQL, SQLite3, Oracle и SQL Server.

- [LazySQL](https://github.com/jorgerojas26/lazysql) - кроссплатформенный инструмент управления базами данных с помощью TUI.

- [Dolphie](https://github.com/charles-001/dolphie) - TUI панель для аналитики MySQL/MariaDB и ProxySQL в реальном времени.

- [usql](https://github.com/xo/usql) - универсальный интерфейс командной строки для PostgreSQL, MySQL, Oracle Database, SQLite3, Microsoft SQL Server и многих других баз данных, включая NoSQL и нереляционные базы данных.

- [sq](https://github.com/neilotoole/sq) - инструмент командной строки, обеспечивающий доступ в стиле `jq` из баз данных, а также CSV или Excel.

### CloudBeaver

[CloudBeaver](https://github.com/dbeaver/cloudbeaver) - веб-версий [DBeaver](https://github.com/dbeaver/dbeaver) для управления базами данных из браузера.

```yaml
services:
  cloudbeaver:
    image: dbeaver/cloudbeaver:latest
    container_name: cloudbeaver
    tty: true
    stdin_open: true
    ports:
      - 8978:8978
    volumes:
      - ./cbeaver_data:/opt/cloudbeaver/workspace
```

### Bytebase

[Bytebase](https://github.com/bytebase/bytebase) - инструмент DevOps и GitOps для управления базами данных и интеграцией в CI/CD - встроенная интеграция с GitHub/GitLab для рабочих процессов база данных как код и управления миграцией автоматическая миграция схем с поддержкой отката.

```yaml
services:
  bytebase:
    image: bytebase/bytebase:latest
    container_name: bytebase
    restart: unless-stopped
    init: true
    ports:
      - 8980:8080
    volumes:
      - ./bytebase_data:/var/opt/bytebase
```

### DBGate

[DBGate](https://github.com/dbgate/dbgate) - менеджер баз данных для MySQL, PostgreSQL, SQL Server, MongoDB, SQLite и других. Работает под управлением Windows, Linux, Mac или как веб-приложение.

```yaml
services:
  dbgate:
    image: dbgate/dbgate
    container_name: dbgate
    restart: unless-stopped
    volumes:
      - ./dbgate_data:/root/.dbgate
    ports:
      - 3400:3000
    # environment:
    #   CONNECTIONS: con1,con2,con3,con4
    #   LABEL_con1: MySql
    #   SERVER_con1: mysql
    #   USER_con1: root
    #   PASSWORD_con1: TEST
    #   PORT_con1: 3306
    #   ENGINE_con1: mysql@dbgate-plugin-mysql
    #   LABEL_con2: Postgres
    #   SERVER_con2: postgres
    #   USER_con2: postgres
    #   PASSWORD_con2: TEST
    #   PORT_con2: 5432
    #   ENGINE_con2: postgres@dbgate-plugin-postgres
    #   LABEL_con3: MongoDB
    #   URL_con3: mongodb://mongo:27017
    #   ENGINE_con3: mongo@dbgate-plugin-mongo
    #   LABEL_con4: SQLite
    #   FILE_con4: /home/jan/feeds.sqlite
    #   ENGINE_con4: sqlite@dbgate-plugin-sqlite
```

### Redis Insight

[Redis Insight](https://github.com/redis/RedisInsight) - официальный веб-интерфейс для управления Redis.

```yaml
services:
  redisinsight:
    image: redis/redisinsight:latest
    container_name: redisinsight
    restart: unless-stopped
    volumes:
      - ./redisinsight_data:/data
    environment:
      - RI_APP_PORT=5540
      - RI_APP_HOST=0.0.0.0
      - RI_LOG_LEVEL=info
      - RI_FILES_LOGGER=false
      - RI_STDOUT_LOGGER=true
      - RI_DATABASE_MANAGEMENT=true
      - RI_REDIS_HOST=redis
      - RI_REDIS_PORT=6379
      - RI_REDIS_USERNAME=default
      - RI_REDIS_PASSWORD=
      - RI_REDIS_TLS=FALSE
    ports:
      - 5540:5540

  redis:
    image: redis:latest
    container_name: redis
    restart: unless-stopped
    volumes:
      - ./redis_data:/data
```

### libSQL

[libSQL](https://github.com/tursodatabase/libsql?tab=readme-ov-file) - форк SQLite, разработанный [Turso](https://github.com/tursodatabase/turso) для удаленного доступа к SQLite, аналогичный PostgreSQL или MySQL с встроенной поддержкой репликации данных.

```yaml
services:
  libsql-main:
    image: ghcr.io/tursodatabase/libsql-server:latest
    container_name: some-sqld-main
    restart: unless-stopped
    tty: true
    stdin_open: true
    volumes:
      - ./libsql_main_data:/var/lib/sqld
    environment:
      - SQLD_NODE=primary
    ports:
      - 8080:8080
      - 5001:5001

  libsql-replica:
    image: ghcr.io/tursodatabase/libsql-server:latest
    container_name: some-sqld-replica
    restart: unless-stopped
    volumes:
      - ./libsql_replica_data:/var/lib/sqld
    environment:
      - SQLD_NODE=replica
      - SQLD_PRIMARY_URL=https://libsql-main:8080
    ports:
      - 8081:8080
    tty: true
    stdin_open: true
```

### PostgreSQL

[PostgreSQL](https://github.com/postgres/postgres) - объектно-реляционная база данных (СУБД) с открытым исходным кодом.

```yaml
services:
  postgresql:
    image: postgres
    container_name: postgresql
    restart: unless-stopped
    ports:
      - 5432:5432
    environment:
      POSTGRES_DB: dbname
      POSTGRES_USER: dbuser
      POSTGRES_PASSWORD: dbpass
    volumes:
      - ./postgresql_data:/var/lib/postgresql/data
    healthcheck:
      test: pg_isready -U pgweb -h 127.0.0.1
      interval: 5s
```

### PgWeb

[PgWeb](https://github.com/sosedoff/pgweb) - веб-клиент для работы с СУБД PostgreSQL, который возможно запустить из одного бинарного файла, а также позволяет подключиться к БД напрямую или через SSH туннель.

```yaml
services:
  pgweb:
    container_name: pgweb
    image: sosedoff/pgweb:latest
    build: .
    environment:
      PGWEB_DATABASE_URL: postgres://dbuser:dbpass@postgresql:5432/dbname?sslmode=disable
    ports:
      - 5443:8081
    healthcheck:
      test: ["CMD", "nc", "-vz", "127.0.0.1", "8081"]
      interval: 5s
    depends_on:
      postgresql:
        condition: service_healthy
```

### pgHero

[pgHero](https://github.com/ankane/pghero) - панель управления для производительности PostgreSQL.

🔗 [pgHero Performance Dashboard Demo](https://pghero.dokkuapp.com/system) ↗

```yaml
services:
  pghero:
    image: ankane/pghero
    container_name: pghero
    restart: unless-stopped
    environment:
      - DATABASE_URL=postgres://user:pass@postgresql:5432/dbname
    ports:
      - 5444:8080
    tty: true
    stdin_open: true
```

### PostgreSUS

[PostgreSUS](https://github.com/RostislavDugin/postgresus) - инструмент для резервного копирования, с поддержкой локального хранение бекапов, а также в Google Drive или S3 совместимом хранилища по расписанию с проверкой доступности (health check), визуализации в веб-интерфейсе и оповщениями в Telegram, Slack, Discord и другие системы.

```yaml
services:
  postgresus:
    image: rostislavdugin/postgresus:latest
    container_name: postgresus
    restart: unless-stopped
    ports:
      - 5445:4005
    volumes:
      - ./postgresus-data:/postgresus-data
    depends_on:
      - postgresql
```

### Portabase

[Portabase](https://github.com/Portabase/portabase) - инструмент для резервного копирования и восстановления баз данных, поддерживающий PostgreSQL, MySQL/MariaDB и MongoDB. Система состоит из агентов и веб-интерфейс для мониторинга, планирования и восстановления.

```yaml
services:
  portabase:
    image: tusproject/tusd:v2.8.0
    container_name: portabase
    restart: unless-stopped
    ports:
      - 1080:8080
    extra_hosts:
      - localhost:host-gateway
    command: >
      -upload-dir /data/uploads/tmp
      -hooks-http http://localhost:8887/api/tus/hooks
      -max-size 21474836480
      -base-path /tus/files/
    volumes:
      - ./private/uploads/tmp:/data/uploads/tmp
```

### PG Backup

[Docker PG Backup](https://github.com/kartoza/docker-pg-backup) - контейнер для резервного копирования любой совместимой с PostgreSQL базы данных (например, [PostGIS](https://postgis.net/)) по расписанию cron.

```yaml
services:
  pg-backup:
    image: kartoza/pg-backup:latest
    container_name: pg-backup
    restart: unless-stopped
    volumes:
      - db-backups:/backups
    environment:
      - DUMPPREFIX=PG
      - POSTGRES_HOST=postgresql
      - POSTGRES_USER=root
      - POSTGRES_PASS=root
      - POSTGRES_PORT=5432
      - RUN_AS_ROOT=true
      - CRON_SCHEDULE="*/5 * * * *"
      - CONSOLE_LOGGING=TRUE
      # S3
      # - STORAGE_BACKEND=S3
      # - ACCESS_KEY_ID=minio_admin
      # - SECRET_ACCESS_KEY=secure_minio_secret
      # - DEFAULT_REGION=us-west-2
      # - BUCKET=pg_backups
      # - HOST_BASE=minio:9000
      # - HOST_BUCKET=backup
      # - SSL_SECURE=False
    depends_on:
      postgresql:
        condition: service_healthy
```

### PostgREST

[PostgREST](https://github.com/PostgREST/postgrest) - полноценный RESTful API для управления базами данных PostgreSQL.

```yaml
services:
  postgrest:
    image: postgrest/postgrest
    container_name: postgrest
    restart: unless-stopped
    ports:
      - 3000:3000
    environment:
      PGRST_DB_URI: postgres://dbuser:dbpass@postgresql:5432/dbname
      PGRST_OPENAPI_SERVER_PROXY_URI: http://127.0.0.1:3000
    depends_on:
      - postgresql

  swagger:
    image: swaggerapi/swagger-ui
    ports:
      - 3001:8080
    expose:
      - 8080
    environment:
      API_URL: http://localhost:3000/
    depends_on:
      - postgresql
      - postgrest
```

### pREST

[pREST](https://github.com/prest/prest) - простой и готовый к использованию API, который обеспечивает работающее в реальном времени и высокопроизводительное приложение поверх существующей или новой базы данных Postgres.

```yaml
  prest:
    image: prest/prest:latest
    container_name: prest
    restart: unless-stopped
    environment:
      - PREST_DEBUG=true
      - PREST_PG_HOST=postgres
      - PREST_PG_CACHE=false
      - PREST_JWT_DEFAULT=false
      - PREST_CACHE_ENABLED=false
    ports:
      - 3000:3000
    depends_on:
      postgresql:
        condition: service_healthy
```

### Patroni

[Patroni](https://github.com/patroni/patroni) - шаблон для обеспечения высокой доступности (HA) серверов баз данных PostgreSQL с помощью `etcd`, [HashiCorp/Consul](https://github.com/hashicorp/consul), [Apache/ZooKeeper](https://github.com/apache/zookeeper) или [Kubernetes](https://github.com/kubernetes/kubernetes).

```yaml
services:
  haproxy:
    image: haproxy:latest
    container_name: haproxy
    restart: unless-stopped
    ports:
      - 5430:5430 # Write endpoint (master)
      - 5431:5431 # Read endpoint (replicas)
      - 7000:7000 # Stats dashboard
    networks:
      - patroni-net
    volumes:
      - ./haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro
    depends_on:
      - patroni1
      - patroni2
      - patroni3

  # Patroni Node 1
  patroni1:
    image: postgres:17.2
    container_name: patroni1
    restart: unless-stopped
    environment:
      - PATRONI_NAME=patroni1
      - PATRONI_RAFT_SELF_ADDR=patroni1:2221
      - PATRONI_POSTGRESQL_DATA_DIR=/var/lib/postgresql/data
      - PATRONI_POSTGRESQL_CONNECT_ADDRESS=patroni1:5432
      - PATRONI_POSTGRESQL_LISTEN=0.0.0.0:5432
      - PATRONI_RESTAPI_CONNECT_ADDRESS=patroni1:8008
      - PATRONI_RESTAPI_LISTEN=0.0.0.0:8008
      - PATRONI_SCOPE=mycluster
      - PATRONI_SUPERUSER_USERNAME=postgres
      - PATRONI_SUPERUSER_PASSWORD=postgres
      - PATRONI_REPLICATION_USERNAME=replicator
      - PATRONI_REPLICATION_PASSWORD=replicatorpass
      - PATRONI_admin_PASSWORD=admin
    # ports:
    #   - 5432:5432
    #   - 8008:8008
    #   - 2221:2221
    networks:
      - patroni-net
    volumes:
      - ./patroni1_data:/var/lib/postgresql/data
      - ./patroni.yml:/etc/patroni.yml:ro
    command: patroni /etc/patroni.yml

  # Patroni Node 2
  patroni2:
    image: postgres:17.2
    container_name: patroni2
    restart: unless-stopped
    environment:
      - PATRONI_NAME=patroni2
      - PATRONI_RAFT_SELF_ADDR=patroni2:2222
      - PATRONI_POSTGRESQL_DATA_DIR=/var/lib/postgresql/data
      - PATRONI_POSTGRESQL_CONNECT_ADDRESS=patroni2:5432
      - PATRONI_POSTGRESQL_LISTEN=0.0.0.0:5432
      - PATRONI_RESTAPI_CONNECT_ADDRESS=patroni2:8008
      - PATRONI_RESTAPI_LISTEN=0.0.0.0:8008
      - PATRONI_SCOPE=mycluster
      - PATRONI_SUPERUSER_USERNAME=postgres
      - PATRONI_SUPERUSER_PASSWORD=postgres
      - PATRONI_REPLICATION_USERNAME=replicator
      - PATRONI_REPLICATION_PASSWORD=replicatorpass
      - PATRONI_admin_PASSWORD=admin
    # ports:
    #   - 5433:5432
    #   - 8009:8008
    #   - 2222:2222
    networks:
      - patroni-net
    volumes:
      - ./patroni2_data:/var/lib/postgresql/data
      - ./patroni.yml:/etc/patroni.yml:ro
    command: patroni /etc/patroni.yml

  # Patroni Node 3
  patroni3:
    image: postgres:17.2
    container_name: patroni3
    restart: unless-stopped
    environment:
      - PATRONI_NAME=patroni3
      - PATRONI_RAFT_SELF_ADDR=patroni3:2223
      - PATRONI_POSTGRESQL_DATA_DIR=/var/lib/postgresql/data
      - PATRONI_POSTGRESQL_CONNECT_ADDRESS=patroni3:5432
      - PATRONI_POSTGRESQL_LISTEN=0.0.0.0:5432
      - PATRONI_RESTAPI_CONNECT_ADDRESS=patroni3:8008
      - PATRONI_RESTAPI_LISTEN=0.0.0.0:8008
      - PATRONI_SCOPE=mycluster
      - PATRONI_SUPERUSER_USERNAME=postgres
      - PATRONI_SUPERUSER_PASSWORD=postgres
      - PATRONI_REPLICATION_USERNAME=replicator
      - PATRONI_REPLICATION_PASSWORD=replicatorpass
      - PATRONI_admin_PASSWORD=admin
    # ports:
    #   - 5434:5432
    #   - 8010:8008
    #   - 2223:2223
    networks:
      - patroni-net
    volumes:
      - ./patroni3_data:/var/lib/postgresql/data
      - ./patroni.yml:/etc/patroni.yml:ro
    command: patroni /etc/patroni.yml

networks:
  patroni-net:
    driver: bridge
```

### Ivory

[Ivory](https://github.com/veegres/ivory) - инструмент для визуализации работы с кластерами Postgres, который представляет из себя веб-интерфейс управления кластером Patroni и конструктор запросов Postgres.

```yaml
services:
  ivory:
    image: veegres/ivory:latest
    container_name: ivory
    restart: unless-stopped
    ports:
      - 7070:80
```

### PgWatch

[PgWatch](https://github.com/cybertec-postgresql/pgwatch) - веб-интерфейс и экспортер метрик для мониторинга Postgres.

```yaml
services:
  pgwatch:
    image: cybertecpostgresql/pgwatch:latest
    container_name: pgwatch
    restart: unless-stopped
    environment:
      PGUSER: postgres
      PW_SOURCES: postgresql://pgwatch@postgres:5432/pgwatch
      # PW_METRICS: /etc/pgwatch/metrics.yml
    command:
      - "--sink=postgresql://pgwatch@postgres:5432/pgwatch_metrics"
      - "--sink=prometheus://pgwatch:9187/pgwatch"
      # - "--web-base-path=pgwatch"
    ports:
      - 8080:8080
      - 9187:9187
      # - "6060:6060" # profiling
    volumes:
      - ../internal/metrics/metrics.yaml:/etc/pgwatch/metrics.yml
      - ./bootstrap/.pgpass:/root/.pgpass:ro
    depends_on:
      postgres:
        condition: service_healthy
```

### Kafka

[Apache Kafka](https://github.com/apache/kafka) - распределенная потоковая платформа с открытым исходным кодом, которая позволяет приложениям публиковать, подписываться, хранить и обрабатывать потоки данных. Для работы требует JVM и [Zookeeper](https://zookeeper.apache.org) для координации распределенных систем, обеспечения их согласованности и отказоустойчивости.

[KafkaLet](https://github.com/sneiko/kafkalet) - быстрый и легкий настольный клиент Kafka, не требущий сервера для своей работы, который напрямую подключается к брокерам.

```yaml
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:latest
    container_name: zookeeper
    restart: unless-stopped
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
    ports:
      - 2181:2181

  kafka:
    image: confluentinc/cp-kafka:latest
    container_name: kafka
    restart: unless-stopped
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT
      KAFKA_INTER_BROKER_LISTENER_NAME: PLAINTEXT
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_AUTO_CREATE_TOPICS_ENABLE: "true"
    volumes:
      - ./kafka-data:/var/lib/kafka/data
    ports:
      - 9092:9092
    depends_on:
      - zookeeper

# Создать топик
# docker exec kafka \
#   kafka-topics --create \
#   --topic test-topic \
#   --bootstrap-server localhost:9092 \
#   --replication-factor 1 \
#   --partitions 3

# Отправить сообщение
# docker exec -it kafka \
#   kafka-console-producer \
#   --topic test-topic \
#   --bootstrap-server localhost:9092

# Получить сообщения
# docker exec -it kafka \
#   kafka-console-consumer \
#   --topic test-topic \
#   --from-beginning \
#   --bootstrap-server localhost:9092
```

### Kafbat

[Kafbat/Kafka UI](https://github.com/kafbat/kafka-ui) - веб-интерфейс для мониторинга и управления кластерами Apache Kafka.

```yaml
services:
  kafka-ui:
    image: ghcr.io/kafbat/kafka-ui:latest
    container_name: kafka-ui
    restart: unless-stopped
    environment:
      - DYNAMIC_CONFIG_ENABLED=true
    volumes:
      - ./kui_config.yml:/etc/kafkaui/dynamic_config.yaml
    ports:
      - 4080:8080
```

### Kafka UI

[Kafka UI](https://github.com/provectus/kafka-ui) - веб-интерфейс для управления Apache Kafka.

```yaml
services:
  kafka-ui:
    image: provectuslabs/kafka-ui:latest
    container_name: kafka-ui
    restart: unless-stopped
    ports:
      - 8080:8080
    environment:
      KAFKA_CLUSTERS_0_NAME: local
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: kafka0:29092
      KAFKA_CLUSTERS_0_METRICS_PORT: 9997
      KAFKA_CLUSTERS_0_SCHEMAREGISTRY: http://schemaregistry0:8085
      KAFKA_CLUSTERS_0_KAFKACONNECT_0_NAME: first
      KAFKA_CLUSTERS_0_KAFKACONNECT_0_ADDRESS: http://kafka-connect0:8083
      KAFKA_CLUSTERS_1_NAME: secondLocal
      KAFKA_CLUSTERS_1_BOOTSTRAPSERVERS: kafka1:29092
      KAFKA_CLUSTERS_1_METRICS_PORT: 9998
      KAFKA_CLUSTERS_1_SCHEMAREGISTRY: http://schemaregistry1:8085
      DYNAMIC_CONFIG_ENABLED: 'true'
    depends_on:
      - kafka0
      - kafka1
      - schemaregistry0
      - schemaregistry1
      - kafka-connect0

  kafka0:
    image: confluentinc/cp-kafka:7.2.1
    container_name: kafka0
    hostname: kafka0
    restart: unless-stopped
    ports:
      - 9092:9092
      - 9997:9997
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: 'CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT'
      KAFKA_ADVERTISED_LISTENERS: 'PLAINTEXT://kafka0:29092,PLAINTEXT_HOST://localhost:9092'
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
      KAFKA_JMX_PORT: 9997
      KAFKA_JMX_OPTS: -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=kafka0 -Dcom.sun.management.jmxremote.rmi.port=9997
      KAFKA_PROCESS_ROLES: 'broker,controller'
      KAFKA_NODE_ID: 1
      KAFKA_CONTROLLER_QUORUM_VOTERS: '1@kafka0:29093'
      KAFKA_LISTENERS: 'PLAINTEXT://kafka0:29092,CONTROLLER://kafka0:29093,PLAINTEXT_HOST://0.0.0.0:9092'
      KAFKA_INTER_BROKER_LISTENER_NAME: 'PLAINTEXT'
      KAFKA_CONTROLLER_LISTENER_NAMES: 'CONTROLLER'
      KAFKA_LOG_DIRS: '/tmp/kraft-combined-logs'
    volumes:
      - ./scripts/update_run.sh:/tmp/update_run.sh
    command: "bash -c 'if [ ! -f /tmp/update_run.sh ]; then echo \"ERROR: Did you forget the update_run.sh file that came with this docker-compose.yml file?\" && exit 1 ; else /tmp/update_run.sh && /etc/confluent/docker/run ; fi'"

  kafka1:
    image: confluentinc/cp-kafka:7.2.1
    container_name: kafka1
    hostname: kafka1
    restart: unless-stopped
    ports:
      - 9093:9092
      - 9998:9998
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: 'CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT'
      KAFKA_ADVERTISED_LISTENERS: 'PLAINTEXT://kafka1:29092,PLAINTEXT_HOST://localhost:9092'
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS: 0
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
      KAFKA_JMX_PORT: 9998
      KAFKA_JMX_OPTS: -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=kafka0 -Dcom.sun.management.jmxremote.rmi.port=9998
      KAFKA_PROCESS_ROLES: 'broker,controller'
      KAFKA_NODE_ID: 1
      KAFKA_CONTROLLER_QUORUM_VOTERS: '1@kafka1:29093'
      KAFKA_LISTENERS: 'PLAINTEXT://kafka1:29092,CONTROLLER://kafka1:29093,PLAINTEXT_HOST://0.0.0.0:9092'
      KAFKA_INTER_BROKER_LISTENER_NAME: 'PLAINTEXT'
      KAFKA_CONTROLLER_LISTENER_NAMES: 'CONTROLLER'
      KAFKA_LOG_DIRS: '/tmp/kraft-combined-logs'
    volumes:
      - ./scripts/update_run.sh:/tmp/update_run.sh
    command: "bash -c 'if [ ! -f /tmp/update_run.sh ]; then echo \"ERROR: Did you forget the update_run.sh file that came with this docker-compose.yml file?\" && exit 1 ; else /tmp/update_run.sh && /etc/confluent/docker/run ; fi'"

  schemaregistry0:
    image: confluentinc/cp-schema-registry:7.2.1
    ports:
      - 8085:8085
    environment:
      SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS: PLAINTEXT://kafka0:29092
      SCHEMA_REGISTRY_KAFKASTORE_SECURITY_PROTOCOL: PLAINTEXT
      SCHEMA_REGISTRY_HOST_NAME: schemaregistry0
      SCHEMA_REGISTRY_LISTENERS: http://schemaregistry0:8085
      SCHEMA_REGISTRY_SCHEMA_REGISTRY_INTER_INSTANCE_PROTOCOL: "http"
      SCHEMA_REGISTRY_LOG4J_ROOT_LOGLEVEL: INFO
      SCHEMA_REGISTRY_KAFKASTORE_TOPIC: _schemas
    depends_on:
      - kafka0

  schemaregistry1:
    image: confluentinc/cp-schema-registry:7.2.1
    ports:
      - 18085:8085
    environment:
      SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS: PLAINTEXT://kafka1:29092
      SCHEMA_REGISTRY_KAFKASTORE_SECURITY_PROTOCOL: PLAINTEXT
      SCHEMA_REGISTRY_HOST_NAME: schemaregistry1
      SCHEMA_REGISTRY_LISTENERS: http://schemaregistry1:8085
      SCHEMA_REGISTRY_SCHEMA_REGISTRY_INTER_INSTANCE_PROTOCOL: "http"
      SCHEMA_REGISTRY_LOG4J_ROOT_LOGLEVEL: INFO
      SCHEMA_REGISTRY_KAFKASTORE_TOPIC: _schemas
    depends_on:
      - kafka1

  kafka-connect0:
    image: confluentinc/cp-kafka-connect:7.2.1
    ports:
      - 8083:8083
    environment:
      CONNECT_BOOTSTRAP_SERVERS: kafka0:29092
      CONNECT_GROUP_ID: compose-connect-group
      CONNECT_CONFIG_STORAGE_TOPIC: _connect_configs
      CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR: 1
      CONNECT_OFFSET_STORAGE_TOPIC: _connect_offset
      CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR: 1
      CONNECT_STATUS_STORAGE_TOPIC: _connect_status
      CONNECT_STATUS_STORAGE_REPLICATION_FACTOR: 1
      CONNECT_KEY_CONVERTER: org.apache.kafka.connect.storage.StringConverter
      CONNECT_KEY_CONVERTER_SCHEMA_REGISTRY_URL: http://schemaregistry0:8085
      CONNECT_VALUE_CONVERTER: org.apache.kafka.connect.storage.StringConverter
      CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL: http://schemaregistry0:8085
      CONNECT_INTERNAL_KEY_CONVERTER: org.apache.kafka.connect.json.JsonConverter
      CONNECT_INTERNAL_VALUE_CONVERTER: org.apache.kafka.connect.json.JsonConverter
      CONNECT_REST_ADVERTISED_HOST_NAME: kafka-connect0
      CONNECT_PLUGIN_PATH: "/usr/share/java,/usr/share/confluent-hub-components"
    depends_on:
      - kafka0
      - schemaregistry0

  kafka-init-topics:
    image: confluentinc/cp-kafka:7.2.1
    volumes:
       - ./data/message.json:/data/message.json
    depends_on:
      - kafka1
    command: "bash -c 'echo Waiting for Kafka to be ready... && \
               cub kafka-ready -b kafka1:29092 1 30 && \
               kafka-topics --create --topic second.users --partitions 3 --replication-factor 1 --if-not-exists --bootstrap-server kafka1:29092 && \
               kafka-topics --create --topic second.messages --partitions 2 --replication-factor 1 --if-not-exists --bootstrap-server kafka1:29092 && \
               kafka-topics --create --topic first.messages --partitions 2 --replication-factor 1 --if-not-exists --bootstrap-server kafka0:29092 && \
               kafka-console-producer --bootstrap-server kafka1:29092 -topic second.users < /data/message.json'"
```

## Backup Stack

### Restic

[Restic](https://github.com/restic/restic) — это быстрая, эффективная и безопасная система резервного копирования, которая поддерживает хранение резервных копий на S3, SFTP, [REST Server](https://github.com/restic/rest-server) и других хранилищах.

### REST Server

[REST Server](https://github.com/restic/rest-server) - HTTP-сервер, реализующий REST API бэкэнда для Restic, который предоставляет безопасный и эффективный способ удалённого резервного копирования данных с помощью клиента резервного копирования restic по адресу `rest: URL`.

```yaml
services:
  rest-server:
    image: restic/rest-server
    container_name: rest-server
    restart: always
    ports:
      - 2048:8000
    volumes:
      - ./backup_data:/data
```

### Zerobyte

[Zerobyte](https://github.com/nicotsx/zerobyte) - инструмент автоматизации резервного копирования для хранения данных в нескольких хранилищах. Он создан на основе Restic и предоставляет современный веб-интерфейс для планирования, управления и мониторинга зашифрованного резервного копирования удаленного хранилища. Поддерживает источники данных (volumes) из локального хранилища, NFS, SMB и WebDAV, хранилища данных (repositories) в S3, SSH/SFTP, rcloud (40+ cloud providers) и отправку уведомлений в Telegram, Discord, Slack, [Pushover](https://pushover.net/api), [Gotify](https://github.com/gotify/server), а также по SMTP или через [Shoutrrr](https://github.com/containrrr/shoutrrr).

```yaml
services:
  zerobyte:
    image: ghcr.io/nicotsx/zerobyte:v0.19
    container_name: zerobyte
    restart: always
    ports:
      - 4096:4096
    cap_add:
      - SYS_ADMIN
    devices:
      - /dev/fuse:/dev/fuse
    environment:
      - TZ=Etc/UTC+3
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/lib/zerobyte:/var/lib/zerobyte
      - /home/lifailon/docker/gitea/gitea_data:/backup_data/gitea
```

### Backrest

[Backrest](https://github.com/garethgeorge/backrest) — это веб-интерфейс для резервного копирования, построенное на основе Restic.

```yaml
services:
  backrest:
    image: garethgeorge/backrest:latest
    container_name: backrest
    restart: unless-stopped
    hostname: backrest
    volumes:
      - ./backrest/data:/data
      - ./backrest/config:/config
      - ./backrest/cache:/cache
      - ./backrest/tmp:/tmp
      - ./backrest/rclone:/root/.config/rclone  # Mount for rclone config (needed when using rclone remotes)
      - /path/to/backup/data:/userdata          # Mount local paths to backup
      - /path/to/local/repos:/repos             # Mount local repos (optional for remote storage)
    environment:
      - BACKREST_DATA=/data
      - BACKREST_CONFIG=/config/config.json
      - XDG_CACHE_HOME=/cache
      - TMPDIR=/tmp
      - TZ=Etc/UTC+3
    ports:
      - 9898:9898
```

### Duplicati

[Duplicati](https://github.com/duplicati/duplicati) - клиент резервного копирования, который безопасно хранит зашифрованные, инкрементальные и сжатые резервные копии в облачных хранилищах и на удаленных файловых серверах (поддерживает SFTP, WebDAV, S3-совместимые, Google Cloud и другие системы хранения). Поддерживает плагины, например, отправку оповещений в [Telegram](https://docs.duplicati.com/detailed-descriptions/sending-reports-via-email/sending-telegram-notifications).

```yaml
services:
  duplicati:
    image: lscr.io/linuxserver/duplicati:latest
    container_name: duplicati
    restart: unless-stopped
    environment:
      - PUID=0
      - PGID=0
      - TZ=Etc/UTC+3
      - SETTINGS_ENCRYPTION_KEY=DuplicatiKey
      - DUPLICATI__WEBSERVICE_PASSWORD=DuplicatiAdmin
      - CLI_ARGS=
    volumes:
      - ./duplicati_config:/config
      - ./duplicati_backup:/backups
      - /home/lifailon/docker:/source:ro
      - ./duplicati_restore:/restore
    ports:
      - 8200:8200
```

### Kopia

[Kopia](https://github.com/kopia/kopia) - кроссплатформенный инструмент резервного копирования для Windows, macOS и Linux с быстрым инкрементным резервным копированием, сквозным шифрованием на стороне клиента, сжатием и дедупликацией данных. Поддерживается Веб-интерфейс поверх cli в стиле отображения флагов для исполняемого файла.

```yaml
services:
  kopia:
    image: kopia/kopia:latest
    container_name: kopia
    restart: unless-stopped
    ports:
      - 51515:51515
    command:
      - server
      - start
      - --disable-csrf-token-checks
      - --insecure
      - --address=0.0.0.0:51515
      - --server-username=admin
      - --server-password=KopiaAdmin
    environment:
      - KOPIA_PASSWORD=KopiaAdmin
      - USER=User
    volumes:
        - ./kopia_config:/app/config
        - ./kopia_cache:/app/cache
        - ./kopia_logs:/app/logs
        - ./kopia_backup:/repository
        - /home/lifailon/docker:/data:ro
```

## FS Stack

### Samba

[Samba](https://github.com/dperson/samba) - SMB/CIFS сервер для запуска в контейнере Docker, без конфигурации и с поддержкой корзины по умолчанию (директория `.deleted` в корне шары).

```yaml
services:
  samba:
    image: dperson/samba
    container_name: samba
    restart: always
    user: root
    ports:
      - 445:445
    environment:
      - USER=admin;admin
      - SHARE=docker;/storage;yes;no;no;admin
      - FORCE_USER=root
      - FORCE_GROUP=root
      - PERMISSIONS=true
    volumes:
      - /home/lifailon/docker:/storage
```

[Samba](https://github.com/dockur/samba) - еще одна реализация запуска сервера Samba в контейнере Docker, от создателя [Windows](https://github.com/dockur/windows) и [macOS](https://github.com/dockur/macos) в Docker.

```yaml
services:
  samba:
    image: dockurr/samba
    container_name: samba
    restart: always
    ports:
      - 445:445
    environment:
      - NAME=docker
      - USER=admin
      - PASS=admin
    volumes:
      - /home/lifailon:/storage
```

### Rclone

[Rclone](https://github.com/rclone/rclone) - инструмент командной строки для синхронизации файлов и каталогов между различными поставщиками облачного хранилища.

```yaml
services:
  rclone:
    image: pfidr/rclone
    container_name: rclone
    restart: always
    volumes:
      - ./rclone.conf:/config/rclone.conf:ro
      - /home/lifailon/docker:/backup:ro
    environment:
      - MODE=sync
      - SYNC_SRC=/backup
      - SYNC_DEST=plex-01:/backup
      - SYNC_OPTS=-vv --create-empty-src-dirs
      - FORCE_SYNC=1
      - CRON=0 9,21 * * *
      - TZ=Etc/UTC+3
```

Шифруем пароль:

`docker exec -it rclone rclone obscure PASSWORD`

Пример конфигурации для подключения к SMB серверу:

```conf
[plex-01]
type = smb
domain = WORKGROUP
host = 192.168.3.100
user = Lifailon
pass = PASSWORD
```

Официальный образ:

```yaml
services:
  rclone:
    image: mirror.gcr.io/rclone/rclone:latest
    container_name: rclone
    restart: always
    volumes:
      - ./rclone.conf:/config/rclone/rclone.conf:ro
      - /home/lifailon/docker:/backup:ro
    environment:
      - TZ=Etc/UTC+3
    entrypoint: /bin/sh
    command: >
      -c "
        echo '0 9,21 * * * rclone sync /backup plex-01:/backup -vv --create-empty-src-dirs' > /tmp/crontab &&
        crond -f -l 2 -c /tmp
      "
```

Ручной запуск:

```bash
docker run --rm -it \
  -v ./rclone.conf:/config/rclone/rclone.conf:ro \
  -v /home/lifailon/docker:/backup:ro \
  mirror.gcr.io/rclone/rclone:latest \
  sync /backup plex-01:/backup -vv --create-empty-src-dirs
```

### SFTPGo

[SFTPGo](https://github.com/drakkan/sftpgo) - SFTP, HTTP/S, FTP/S и WebDAV сервер, с поддержкой хранилища в локальной файловой системе, объектно-совместимом S3 хранилище, Google Cloud Storage, Azure Blob Storage или других SFTP-серверах.

```yaml
services:
  sftpgo:
    image: drakkan/sftpgo:edge
    container_name: sftpgo
    restart: unless-stopped
    ports:
      - 2022:2022
      - 8088:8080
```

### Syncthing

[Syncthing](https://github.com/syncthing/syncthing) - программа для непрерывной синхронизации файлов между двумя или более компьютерами. Работает на основе Block Exchange Protocol (BEP) для обмена данными, который использует TLS-шифрование для безопасной передачи данных по протоколу TCP.

```yaml
services:
  file-syncthing:
    image: syncthing/syncthing
    container_name: file-syncthing
    restart: unless-stopped
    network_mode: host
    # ports:
    #   - 8384:8384         # Web UI
    #   - 22000:22000/tcp   # TCP file transfers
    #   - 22000:22000/udp   # QUIC file transfers
    #   - 21027:21027/udp   # Receive local discovery broadcasts
    environment:
      - PUID=0
      - PGID=0
    volumes:
      - ./syncthing_data:/var/syncthing   # configs
      - $HOME/docker:/sync_data           # src sync data on server
      # - ./backup:/sync_data             # dst sync data on client (mkdir backup && chown -R 1000:1000 backup)
    healthcheck:
      test: curl -fkLsS -m 2 127.0.0.1:8384/rest/noauth/health | grep -o --color=never OK || exit 1
      interval: 1m
      timeout: 10s
      retries: 3
```

### FileBrowser

[FileBrowser](https://github.com/filebrowser/filebrowser) - веб-интерфейс для управления файлами в указанном каталоге. Поддерживает управление пользователями, загрузку, удаление, просмотр и редактирование файлов.

```yaml
services:
  # mkdir filebrowser_data filebrowser_conf && chown -R 1000:1000 filebrowser_data filebrowser_conf
  file-browser:
    image: filebrowser/filebrowser
    container_name: file-browser
    restart: unless-stopped
    user: 0:0
    volumes:
      - $HOME:/srv                    # root directory
      - ./filebrowser_data:/database  # filebrowser.db
      - ./filebrowser_conf:/config    # settings.json
    ports:
      - 8300:80
```

### Cloud Commander

[Cloud Commander](https://github.com/coderaiser/cloudcmd) - веб-интерфейс для файлового менеджера, с консолью, терминалом и файловым редактором (поддерживает [dword](https://github.com/cloudcmd/dword) на базе [CodeMirror](https://github.com/codemirror), [edward](https://github.com/cloudcmd/edward) на базе [Act](https://github.com/ajaxorg/ace) и [deepword](https://github.com/cloudcmd/deepword) на базе [Monaco Editor](https://github.com/microsoft/monaco-editor)).

```yaml
services:
  cloud-cmd:
    image: coderaiser/cloudcmd
    container_name: cloud-cmd
    restart: always
    ports:
      - 8123:8000
    volumes:
      - /home:/home
    environment:
      - CLOUDCMD_AUTH=true
      - CLOUDCMD_USERNAME=admin
      - CLOUDCMD_PASSWORD=admin
      - CLOUDCMD_THEME=dark
      - CLOUDCMD_EDITOR=deepword
      - CLOUDCMD_CONSOLE=true
      - CLOUDCMD_TERMINAL=true
```

### Tiny File Manager

[Tiny File Manager](https://github.com/prasathmani/tinyfilemanager) - универсальный веб-файловый PHP-менеджер, который позволяет хранить, загружать, редактировать и управлять файлами и папками прямо через веб-браузер.

🔗 [Tiny File Manager Demo](https://tinyfilemanager.github.io/demo) ↗

```yaml
services:
  tinyfilemanager:
    image: tinyfilemanager/tinyfilemanager:master
    container_name: tinyfilemanager
    restart: unless-stopped
    volumes:
      - $HOME:/var/www/html/data
    ports:
      - 8080:80
```

### DuFS

[DuFS](https://github.com/sigoden/dufs) - уникальный служебный файловый сервер, который поддерживает статическое обслуживание, загрузку, поиск и удаленное управление через API.

```yaml
services:
  dufs:
    image: sigoden/dufs
    container_name: dufs
    restart: unless-stopped
    ports:
    - 5000:5000
    volumes:
    - $HOME:/data
    - ./config.yaml:/config.yaml
    command: /data -A # --config /config.yaml
```

### GoSHS

[GoSHS](https://github.com/patrickhener/goshs) - простая замена `SimpleHTTPServer` из Python, написанная на Go, которая позволяет загружать и скачивать файлы по HTTP/S с использованием сертификатов и базовой HTTP-аутентификации.

```yaml
services:
  goshs:
    image: patrickhener/goshs:latest
    container_name: goshs
    restart: unless-stopped
    command: -d /public
    volumes:
      - $PWD:/pwd
    ports:
      - 8000:8000
    stdin_open: true
    tty: true
```

### h5ai

[h5ai](https://github.com/lrsjng/h5ai) - современный интерфейс веб-сервера для файлового индексера. Визуально напоминается FTP сервер для удобного отображения и загрузки (например, его использует [Libretro/RetroArch](https://buildbot.libretro.com) для публикации релизов).

```yaml
services:
  h5ai:
    image: awesometic/h5ai
    container_name: h5ai
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/GMT+3
      - HTPASSWD=false
      - HTPASSWD_USER=admin
      - HTPASSWD_PW=admin
    volumes:
      - $HOME/docker:/h5ai    # public data
      - ./h5ai_conf:/config
    ports:
      - 8889:80
```

## S3 Stack

### MinIO

[MinIO](https://github.com/minio/minio) - высокопроизводительное, совместимое S3 решение для хранения объектов с встроенной системой высокой доступности (например, используется в [Velero](https://github.com/vmware-tanzu/velero) для хранения данных резервного копирования Kubernetes).

```yaml
services:
  minio1:
    image: minio/minio
    container_name: minio1
    restart: unless-stopped
    hostname: minio1
    command: server http://minio1:9000/data http://minio2:9000/data --console-address ":9001"
    environment:
      - MINIO_ROOT_USER=admin
      - MINIO_ROOT_PASSWORD=MinioAdmin
    volumes:
      - ./minio1_data:/data
    ports:
      - 9000:9000 # API
      - 9001:9001 # WebUI

  minio2:
    image: minio/minio
    container_name: minio2
    restart: unless-stopped
    hostname: minio2  
    command: server http://minio1:9000/data http://minio2:9000/data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: admin
      MINIO_ROOT_PASSWORD: MinioAdmin
    volumes:
      - ./minio2_data:/data
    ports:
      - 9002:9000
      - 9003:9001
```

### s3fs

[s3fs](https://github.com/s3fs-fuse/s3fs-fuse) - инструмент для монтирования S3 совместимого хранилища на базе [FUSE](https://github.com/libfuse/libfuse), позволяя управлять файлами и каталогами в локальной файловой системе.

```yaml
services:
  s3fs:
    image: efrecon/s3fs:1.95
    container_name: velero_data
    restart: unless-stopped
    privileged: true
    stdin_open: true
    tty: true
    devices:
      - /dev/fuse
    cap_add:
      - SYS_ADMIN
    security_opt:
      - apparmor=unconfined
    environment:
      - AWS_S3_URL=http://minio1:9000
      - AWS_S3_BUCKET=velero
      - AWS_S3_ACCESS_KEY_ID=admin
      - AWS_S3_SECRET_ACCESS_KEY=MinioAdmin
      - S3FS_ARGS=use_path_request_style,allow_other
    volumes:
      - ./velero_data:/opt/s3fs/bucket:rshared 
```

### RustFS

[RustFS](https://github.com/rustfs/rustfs) - высокопроизводительная распределенная система объектного хранения, созданная на языке Rust (в 2-3 раза быстрее, чем MinIO, для объектов размером 4 КБ).

```yaml
services:
  rustfs:
    image: rustfs/rustfs:latest
    container_name: rustfs
    restart: unless-stopped
    ports:
      - 9000:9000
      - 9001:9001
    volumes:
      - ./rustfs_data:/data
```

### BlitzBrowser

[BlitzBrowser](https://github.com/blitzbrowser/blitzbrowser) - развертывание и управление браузерами с графическим интерфейсом в Docker для подключения к браузерам через Puppeteer, Playwright и любые другие CDP-фреймворки, с поддержкой хранения данных пользователей в S3.

```yaml
services:
  blitzbrowser:
    image: ghcr.io/blitzbrowser/blitzbrowser:latest
    container_name: blitzbrowser
    restart: unless-stopped
    shm_size: 2gb
    ports:
      - 9999:9999
    environment:
      S3_ENDPOINT: http://s3:9000
      S3_ACCESS_KEY_ID: rustfs
      S3_SECRET_ACCESS_KEY: rustfs
      S3_USER_DATA_BUCKET: user-data

  s3:
    image: rustfs/rustfs
    container_name: rustfs
    restart: unless-stopped
    ports:
      - 9000:9000
      - 9001:9001
    environment:
      RUSTFS_VOLUMES: /data
      RUSTFS_ADDRESS: :9000
      RUSTFS_ACCESS_KEY: rustfs
      RUSTFS_SECRET_KEY: rustfs
      RUSTFS_CONSOLE_ENABLE: true
    volumes:
      - ./s3_data:/data

  volume-permission-helper:
    image: alpine
    container_name: volume-permission-helper
    restart: no
    volumes:
      - ./s3_data:/data
    command: >
      sh -c "
        chown -R 10001:10001 /data &&
        echo 'Volume Permissions fixed' &&
        exit 0
      "
```

### S4 Core

[S4 Core](https://github.com/s4core/s4core) - сервер объектного хранилища, полностью совместимый с S3 API (aws cli, boto3 и т. д.), с поддержкой решения проблемы исчерпания `inode` (хранение логов только с добавлением данных).

```yaml
services:
  # S4 Storage Server
  s4-server:
    image: s4core/s4core:latest
    container_name: s4-server
    restart: unless-stopped
    # ports:
    #   - 9000:9000
    environment:
      - S4_BIND=0.0.0.0:9000
      - S4_DATA_DIR=/data
      - S4_ROOT_USERNAME=admin
      - S4_ROOT_PASSWORD=s4@admin
      - S4_ACCESS_KEY_ID=my-access-key-one
      - S4_SECRET_ACCESS_KEY=my-secret-key-one
      # - S4_JWT_SECRET=
      # - S4_MAX_UPLOAD_SIZE=5GB
      # - S4_LIFECYCLE_ENABLED=true
      # - S4_LIFECYCLE_INTERVAL_HOURS=24
      # - S4_METRICS_ENABLED=true
      # - RUST_LOG="s4_api=info,s4_server=info"
    volumes:
      - ./s4_data:/data
    healthcheck:
      test:
        [
          "CMD-SHELL",
          "wget --server-response --spider http://0.0.0.0:9000/ 2>&1 | grep -q -E 'HTTP/1.1 (200|403)' || exit 1",
        ]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 5s

  # S4 Web UI
  s4-ui:
    image: s4core/s4console:latest
    container_name: s4-ui
    restart: unless-stopped
    ports:
      - 3000:3000
    environment:
      - S4_BACKEND_URL=http://s4-server:9000
      - NODE_ENV=production
    depends_on:
      s4core:
        condition: service_healthy
```

## Cloud Stack

### NextCloud

[NextCloud](https://github.com/nextcloud) - кросплатфоренная и self-hosted облачная система хранения (fork ownCloud от 2016 года) с возможностью расширения за счет плагинов (поддерживает ВКС на базе [Talk](https://github.com/nextcloud/talk-desktop), Kanban на базе [Deck](https://github.com/nextcloud/deck) и ряд других возможностей).

```yaml
services:
  nextcloud:
    image: nextcloud
    container_name: nextcloud
    restart: unless-stopped
    environment:
      - POSTGRES_HOST=nextcloud-db
      - POSTGRES_DB=nextcloud
      - POSTGRES_USER=nextcloud
      # - POSTGRES_PASSWORD=NextCloudAdmin
      - POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
      # - MYSQL_HOST=nextcloud-db
      # - MYSQL_DATABASE=nextcloud
      # - MYSQL_USER=nextcloud
      # - MYSQL_PASSWORD=NextCloudAdmin
    volumes:
      # - smb_volume_web:/var/www/html
      - ./nextcloud_data/web:/var/www/html
    ports:
      - 8866:80
    depends_on:
      - nextcloud-db

  nextcloud-db:
    image: postgres:15
    container_name: nextcloud-db
    restart: unless-stopped
    environment:
      - POSTGRES_DB=nextcloud
      - POSTGRES_USER=nextcloud
      # - POSTGRES_PASSWORD=NextCloudAdmin
      - POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password
    volumes:
      # - smb_volume_db:/var/lib/postgresql/data
      - ./nextcloud_data/db:/var/lib/postgresql/data
    secrets:
      - postgres_password

  # nextcloud-db:
  #   image: mariadb:10.6
  #   container_name: nextcloud-db
  #   restart: unless-stopped
  #   command: --transaction-isolation=READ-COMMITTED --log-bin=binlog --binlog-format=ROW
  #   environment:
  #     - MYSQL_DATABASE=nextcloud
  #     - MYSQL_USER=nextcloud
  #     - MYSQL_PASSWORD=NextCloudAdmin
  #     - MYSQL_ROOT_PASSWORD=NextCloudAdmin
  #   volumes:
  #     - smb_volume_db:/var/lib/mysql

secrets:
  postgres_password:
    file: ./postgres_password

# volumes:
#   smb_volume_web:
#     driver_opts:
#       type: cifs
#       o: username=guest,password=,uid=1000,gid=1000
#       device: //192.168.3.100/docker-data/nextcloud/web

#   smb_volume_db:
#     driver_opts:
#       type: cifs
#       o: username=guest,password=,uid=1000,gid=1000
#       device: //192.168.3.100/docker-data/nextcloud/db
```

postgres_password:

```
NextCloudAdmin
```

### ownCloud

[ownCloud](https://github.com/owncloud) - прародитель NextCloud, основанный в 2010 году.

```yaml
services:
  owncloud:
    image: owncloud/server:${OWNCLOUD_VERSION}
    container_name: owncloud_server
    restart: always
    ports:
      - ${HTTP_PORT}:8080
    depends_on:
      - mariadb
      - redis
    environment:
      - OWNCLOUD_DOMAIN=${OWNCLOUD_DOMAIN}
      - OWNCLOUD_TRUSTED_DOMAINS=${OWNCLOUD_TRUSTED_DOMAINS}
      - OWNCLOUD_DB_TYPE=mysql
      - OWNCLOUD_DB_NAME=owncloud
      - OWNCLOUD_DB_USERNAME=owncloud
      - OWNCLOUD_DB_PASSWORD=owncloud
      - OWNCLOUD_DB_HOST=mariadb
      - OWNCLOUD_ADMIN_USERNAME=${ADMIN_USERNAME}
      - OWNCLOUD_ADMIN_PASSWORD=${ADMIN_PASSWORD}
      - OWNCLOUD_MYSQL_UTF8MB4=true
      - OWNCLOUD_REDIS_ENABLED=true
      - OWNCLOUD_REDIS_HOST=redis
    healthcheck:
      test: ["CMD", "/usr/bin/healthcheck"]
      interval: 30s
      timeout: 10s
      retries: 5
    volumes:
      - files:/mnt/data

  mariadb:
    image: mariadb:10.11
    container_name: owncloud_mariadb
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=owncloud
      - MYSQL_USER=owncloud
      - MYSQL_PASSWORD=owncloud
      - MYSQL_DATABASE=owncloud
      - MARIADB_AUTO_UPGRADE=1
    command: ["--max-allowed-packet=128M", "--innodb-log-file-size=64M"]
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-u", "root", "--password=owncloud"]
      interval: 10s
      timeout: 5s
      retries: 5
    volumes:
      - mysql:/var/lib/mysql

  redis:
    image: redis:6
    container_name: owncloud_redis
    restart: always
    command: ["--databases", "1"]
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
    volumes:
      - redis:/data

volumes:
  files:
    driver: local
  mysql:
    driver: local
  redis:
    driver: local
```

env:

```ini
OWNCLOUD_VERSION=10.15
OWNCLOUD_DOMAIN=localhost:8080
OWNCLOUD_TRUSTED_DOMAINS=localhost
ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin
HTTP_PORT=8080
```

### Cloud Paste

[Cloud Paste](https://github.com/ling-drag0n/CloudPaste) - сервис для онлайн-обмена текстом и файлами, основанный на Cloudflare, который поддерживает Markdown-редактирование с возможностью рендеринга, интеграцию с различными облачными хранилищами, самоуничтожающиеся сообщения, агрегацию хранилищ S3, защиту паролем и возможность монтирования в качестве WebDAV.

```yaml
services:
  cloud-paste-backend:
    image: dragon730/cloudpaste-backend:latest
    container_name: cloud-paste-backend
    restart: unless-stopped
    environment:
      - NODE_ENV=production
      - PORT=8787
      - ENCRYPTION_SECRET=custom-security-key
      - TASK_WORKER_POOL_SIZE=2
    volumes:
      - ./cloud_paste_sql_data:/data
    ports:
      - 8787:8787

  cloud-paste-frontend:
    image: dragon730/cloudpaste-frontend:latest
    container_name: cloud-paste-frontend
    restart: unless-stopped
    environment:
      - BACKEND_URL=http://cloud-paste-backend:8787
    ports:
      - 8080:80
    depends_on:
      - cloud-paste-backend
```

### Pingvin Share

🐧 [Pingvin Share](https://github.com/stonith404/pingvin-share) и форк [Pingvin Share X](https://github.com/smp46/pingvin-share-x) - платформа для обмена файлами с самостоятельным размещением, являющаяся альтернативой [WeTransfer](https://wetransfer.com).

```yaml
services:
  pingvin-share:
    image: smp46/pingvin-share-x
    # image: stonith404/pingvin-share
    # image: ghcr.io/stonith404/pingvin-share
    container_name: pingvin-share
    restart: unless-stopped
    ports:
      - 3000:3000
    environment:
      - TRUST_PROXY=false
    volumes:
      - ./pingvin_share_data:/opt/app/backend/data
      - ./pingvin_share_data/images:/opt/app/frontend/public/img
```

### Localstack

[Local Stack](https://github.com/localstack/localstack) - эмулятор облачных сервисов, работающий в одном контейнере на ноутбуке или в среде CI. Позволяет запускать свои приложения AWS (Amazon Web Services, например, S3 хранилище, CloudWatch Log Events или Lambda-функции) полностью на локальном компьютере, не подключаясь к удаленному облачному провайдеру.

```yaml
services:
  localstack:
    image: localstack/localstack
    container_name: localstack
    restart: always
    ports:
      - 4566:4566
      - 4510-4559:4510-4559
    environment:
      - DEBUG=1
      - PERSISTENCE=1
      - EXTRA_CORS_ALLOWED_ORIGINS=*
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./localstack_data:/var/lib/localstack
    logging:
      driver: fluentd
      options:
        fluentd-address: localhost:24224
        tag: localstack

  fluent-bit:
    image: fluent/fluent-bit:latest
    container_name: fluent-bit
    ports:
      - 24224:24224
    environment:
      - AWS_ENDPOINT_URL=http://localstack:4566
      - AWS_ACCESS_KEY_ID=test
      - AWS_SECRET_ACCESS_KEY=test
      - AWS_REGION=us-east-1
    volumes:
      - ./fluent-bit.conf:/fluent-bit/etc/fluent-bit.conf
```

## DNS Stack

### Technitium DNS Server

[Technitium DNS Server](https://github.com/TechnitiumSoftware/DnsServer) - авторитетный, рекурсивный и кэширующий DNS-сервер, который можно использовать для самостоятельного хостинга DNS. Поддерживает кластеризацию (в [14 релизе](https://blog.technitium.com/2025/11/technitium-dns-server-v14-released.html) от 08.11.2025), записи в формате wildcard для субдоменов, черные списки с автоматически обновлением из файлов и url (с поддержкой regex), браузер для управления кешем, [API](https://github.com/TechnitiumSoftware/DnsServer/blob/master/APIDOCS.md), встроенный DNS-клиент, магазин приложение и многое другое.

```yaml
services:
  tech-dns-srv:
    image: technitium/dns-server:latest
    container_name: tech-dns-srv
    restart: always
    volumes:
      - ./dns_data:/etc/dns
    environment:
      - DNS_SERVER_DOMAIN=dns.docker.local                  # Основное доменное имя, используемое этим DNS-сервером для своей идентификации.
      - DNS_SERVER_FORWARDERS=1.1.1.1,8.8.8.8               # Список адресов пересылки, разделенных запятыми.
      - DNS_SERVER_BLOCK_LIST_URLS=https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
      # - DNS_SERVER_ADMIN_PASSWORD=password                # Пароль администратора веб-консоли DNS.
      # - DNS_SERVER_ADMIN_PASSWORD_FILE=password.txt       # Путь к файлу, содержащему текстовый пароль администратора веб-консоли DNS.
      # - DNS_SERVER_PREFER_IPV6=false                      # DNS-сервер будет использовать IPv6 для запросов, когда это возможно, если эта опция включена.
      # - DNS_SERVER_WEB_SERVICE_LOCAL_ADDRESSES=172.17.0.1,127.0.0.1 # Список IP-адресов сетевых интерфейсов, разделенных запятыми, запросы на которых должен прослушивать веб-сервис. Адрес «172.17.0.1» — это встроенный мост Docker. Если не указано иное, «[::]» используется по умолчанию. Примечание! Этот параметр следует использовать только в сетевом режиме «host».
      # - DNS_SERVER_WEB_SERVICE_HTTP_PORT=5380             # Номер порта TCP для веб-консоли DNS по протоколу HTTP.
      # - DNS_SERVER_WEB_SERVICE_HTTPS_PORT=53443           # Номер порта TCP для веб-консоли DNS по протоколу HTTPS.
      # - DNS_SERVER_WEB_SERVICE_ENABLE_HTTPS=false         # Включает HTTPS для веб-консоли DNS.
      # - DNS_SERVER_WEB_SERVICE_USE_SELF_SIGNED_CERT=false # Включает самоподписанный TLS-сертификат для веб-консоли DNS.
      # - DNS_SERVER_OPTIONAL_PROTOCOL_DNS_OVER_HTTP=false  # Включает использование дополнительного протокола DNS-сервера DNS-over-HTTP на TCP-порту 8053 с обратным прокси-сервером, завершающим TLS, например, nginx.
      # - DNS_SERVER_RECURSION=AllowOnlyForPrivateNetworks  # Параметры рекурсии: Allow, Deny, AllowOnlyForPrivateNetworks, UseSpecifiedNetworkACL.
      # - DNS_SERVER_RECURSION_NETWORK_ACL=192.168.10.0/24  # Список IP-адресов или сетевых адресов, разделенных запятыми, для разрешения доступа. Добавьте символ «!» в начале, чтобы запретить доступ, например, «!192.168.10.0/24» запретит всю подсеть. Список ACL обрабатывается в том же порядке, в котором он указан. Если ни одна сеть не совпадает, политика по умолчанию запрещает все, кроме петлевой. Действительно только для параметра рекурсии `UseSpecifiedNetworkACL`.
      # - DNS_SERVER_RECURSION_DENIED_NETWORKS=1.1.1.0/24   # Список IP-адресов или сетевых адресов, разделенных запятыми, для запрета рекурсии. Действительно только для параметра рекурсии `UseSpecifiedNetworkACL`. Этот параметр устарел, вместо него следует использовать DNS_SERVER_RECURSION_NETWORK_ACL.
      # - DNS_SERVER_ENABLE_BLOCKING=false                  # Настраивает DNS-сервер на блокировку доменных имен с использованием заблокированной зоны и зоны списка заблокированных доменов.
      # - DNS_SERVER_ALLOW_TXT_BLOCKING_REPORT=false        # Указывает, должен ли DNS-сервер отвечать TXT-записями, содержащими отчет о заблокированном домене, на запросы типа TXT.
      # - DNS_SERVER_FORWARDER_PROTOCOL=Tcp                 # Параметры протокола пересылки: Udp, TCP, Tls, HTTPS, HttpsJson.
      # - DNS_SERVER_LOG_USING_LOCAL_TIME=true              # Включите этот параметр, чтобы использовать локальное время вместо UTC для ведения журнала.
    # Использовать сеть хоста в режиме DHCP или при использование кластеризации для инициализации внешнего IP
    # network_mode: host
    ports:
      - 5380:5380/tcp       # Web UI HTTP
      # - 53443:53443/tcp   # Web UI HTTPS
      - 53:53/udp           # DNS UDP
      - 53:53/tcp           # DNS TCP
      # - 853:853/udp       # DNS-over-QUIC service
      # - 853:853/tcp       # DNS-over-TLS service
      # - 443:443/udp       # DNS-over-HTTPS service (HTTP/3)
      # - 443:443/tcp       # DNS-over-HTTPS service (HTTP/1.1, HTTP/2)
      # - 80:80/tcp         # DNS-over-HTTP service (use with reverse proxy or certbot certificate renewal)
      # - 8053:8053/tcp     # DNS-over-HTTP service (use with reverse proxy)
      # - 67:67/udp         # DHCP service
      # - 53443:53443/tcp   # Cluster
    # sysctls:
    #   - net.ipv4.ip_local_port_range=1024 65000
```

### DNS Client

[DNS Client](https://github.com/TechnitiumSoftware/net.dnsclient) - веб-клиент, уже встроенный в DNS сервер, который позволяет отправлять запросы к любому DNS-серверу. Поддерживает проверку DNSSEC с использованием алгоритмов RSA, ECDSA и EdDSA для всех транспортных протоколов DNS, а также поддерживает протоколы DNS-over-HTTPS, DNS-over-TLS и DNS-over-QUIC.


🔗 [DNS Client Playground](https://dnsclient.net) ↗

```yaml
services:
  dns-client:
    image: technitium/dns-client:latest
    container_name: dns-client
    restart: unless-stopped
    hostname: dns-client
    ports:
      - 8001:8001/tcp
```

### Pi-hole

[Pi-hole](https://github.com/pi-hole/pi-hole) - популярное и легковесное решение для блокировки рекламы (отображает график блокировок, автоматически обновляет списки и поддерживает простое API).

[Pi-hole Exporter](https://github.com/eko/pihole-exporter) - экспортер метрик для Prometheus.

```yaml
services:
  # DNS Server + AdBlock
  pihole-server:
    container_name: pihole-server
    image: pihole/pihole:latest
    restart: unless-stopped
    ports:
      # DNS
      - 53:53/tcp
      - 53:53/udp
      # HTTP
      - 8000:8000/tcp
      # HTTPS
      # - 4443:4443/tcp
      # DHCP
      # - 67:67/udp
    environment:
      - TZ=Etc/GMT+3
      - FTLCONF_webserver_api_password=PiHoleAdmin # или docker logs pihole-server | grep random
      - FTLCONF_dns_upstreams=8.8.8.8;1.1.1.1      # корневые DNS-сервера верхнего уровн (TLD), на которые пересылаются запросы
    volumes:
      - ./pihole_data:/etc/pihole
      # - ./pihole.toml:/etc/pihole/pihole.toml
      # - ./custom.list:/etc/pihole/hosts/custom.list
      # - ./hosts:/etc/hosts
    # Для использования DHCP сервера
    # cap_add:
    #   - NET_ADMIN
    # Пробросить хостовую сеть и использовать режим listeningMode = "LOCAL"
    network_mode: host

  # Prometheus metrics from pi-hole
  pihole-exporter:
    container_name: pihole-exporter
    image: ekofr/pihole-exporter:latest
    restart: unless-stopped
    environment:
      # - PIHOLE_HOSTNAME=pihole-server
      - PIHOLE_HOSTNAME=192.168.3.105 # если pihole-server в режиме network_mode: host, указать ip-адрес хоста (или localhost и тоже использовать network_mode: host)
      - PIHOLE_PROTOCOL=http
      - PIHOLE_PORT=8000
      - PIHOLE_PASSWORD=PiHoleAdmin
      - INTERVAL=90s
      - PORT=9617
    ports:
      - 9617:9617
    depends_on:
      - pihole-server
```

### AdGuard Home

[AdGuard Home](https://github.com/AdguardTeam/AdGuardHome) - более современный блокировщик рекламы и отслеживания.

[AdGuard Home Sync](https://github.com/bakito/adguardhome-sync) - синхронизирует конфигурацию AdGuardHome (DNS записи, клиенты, фильтры и общие настройки) с экземплярами реплик.

```yaml
services:
  adguardhome-server:
    image: adguard/adguardhome
    container_name: adguardhome-server
    restart: unless-stopped
    volumes:
      - ./adguardhome_server_data:/opt/adguardhome/work
      - ./adguardhome_server_conf:/opt/adguardhome/conf
    ports:
      # DNS
      - "53:53/tcp"
      - "53:53/udp"
      # DHCP
      # - "67:67/udp"
      # - "68:68/udp"
      # Web
      - "80:80/tcp"
      - "443:443/tcp"
      - "443:443/udp"
      # Prometheus exporter
      - "3000:3000/tcp"
      # DNS over TLS
      # - "853:853/tcp"
      # DNS over QUIC⁠
      # - "784:784/udp"
      # - "853:853/udp"
      # - "8853:8853/udp"
      #  DNSCrypt⁠
      # - "5443:5443/tcp"
      # - "5443:5443/udp"

# Reset password by hash:
# sudo apt-get install apache2
# htpasswd -B -C 10 -n -b admin AdHuardHome
# sudo nano adguard_conf/AdGuardHome.yaml

  adguardhome-sync:
    image: ghcr.io/bakito/adguardhome-sync
    container_name: adguardhome-sync
    restart: unless-stopped
    command: run --config /config/adguardhome-sync.yaml
    volumes:
      - ./adguardhome-sync.yaml:/config/adguardhome-sync.yaml
    ports:
      - 8080:8080 # api + prometheus metrics

  # adguardhome-sync:
  #   image: lscr.io/linuxserver/adguardhome-sync:latest
  #   container_name: adguardhome-sync
  #   restart: unless-stopped
  #   environment:
  #     - PUID=1000
  #     - PGID=1000
  #     - TZ=Etc/UTC+3
  #     - CONFIGFILE=/config/adguardhome-sync.yaml
  #   volumes:
  #     - ./adguardhome-sync.yaml:/config/adguardhome-sync.yaml
  #   ports:
  #     - 8080:8080
```

[AdGuardian-Term](https://github.com/Lissy93/AdGuardian-Term) - TUI интерфейс для управления AdGuard.

`docker run -it lissy93/adguardian`

### CoreDNS

[CoreDNS](https://github.com/coredns/coredns) сервер с встроенным плагином [blocklist](https://github.com/relekang/coredns-blocklist).

> [!NOTE]
> Используется неофициальный образ [lifailon/coredns-blocklist](https://hub.docker.com/r/lifailon/coredns-blocklist), собранный в репозитории [ruDocs](https://github.com/Lifailon/rudocs) для публичного использования.

```yaml
services:
  coredns-blocklist:
    container_name: coredns-blocklist
    image: lifailon/coredns-blocklist:latest
    build:
      context: .
      dockerfile: coredns/Dockerfile
    command: -conf /etc/coredns/Corefile
    user: 1000:1000
    volumes:
      - ./coredns:/etc/coredns
    environment:
      - GOMAXPROCS=1
    ports:
      - 53:53/udp # DNS listener
      - 9153:9153 # Prometheus metrics
```

### PowerDNS

[PowerDNS/PDNS](https://github.com/PowerDNS/pdns) - DNS сервер.

[PowerDNS-Admin](https://github.com/PowerDNS-Admin/PowerDNS-Admin) - веб-интерфейс для PowerDNS с расширенными функциями. Поддерживает управление прямыми и обратными зонами, контроль доступа в определенной зоне, управление пользователями (а также LDAP, OAuth и 2FA), ведение журнала активности, конфигурация службы PDNS и мониторинг статистики, предоставляет API для управления зонами и записями, а также другие функции.

```yaml
services:
  powerdns-server:
    image: powerdns/pdns-auth-49:latest
    container_name: powerdns-server
    restart: unless-stopped
    environment:
      POWERDNS_launch: gsqlite3
      POWERDNS_gsqlite3_database: /var/lib/powerdns/pdns.sqlite
      POWERDNS_api: yes
      POWERDNS_api_key: power-dns-api-key
      POWERDNS_webserver: yes
      POWERDNS_webserver_address: 0.0.0.0
      POWERDNS_webserver_port: 8081
      POWERDNS_webserver_allow_from: 0.0.0.0/0,::/0
    ports:
      - 53:53/udp
      - 53:53/tcp
      - 8081:8081
    volumes:
      - ./powerdns_db_data:/var/lib/powerdns
    networks:
      - powerdns-network

  powerdns-admin:
    image: ngoduykhanh/powerdns-admin:latest
    container_name: powerdns-admin
    restart: unless-stopped
    environment:
      - PDNS_API_URL=http://powerdns-server:8081
      - PDNS_API_KEY=power-dns-api-key
      - PDNS_VERSION=4.9.0
    ports:
      - 9191:80
    volumes:
      - ./powerdns_admin_data:/var/lib/powerdns-admin
    networks:
      - powerdns-network
    depends_on:
      - powerdns-server

networks:
  powerdns-network:
```

### Blocky

[Blocky](https://github.com/0xERR0R/blocky) - быстрый и легкий DNS-прокси как блокировщик рекламы для локальной сети с множеством функций, поддерживает управление через встроенный [RapiDoc](https://github.com/rapi-doc/RapiDoc).

```yaml
services:
  blocky:
    image: spx01/blocky
    container_name: blocky
    restart: unless-stopped
    hostname: blocky-01
    ports:
      - 53:53/tcp
      - 53:53/udp
      - 4000:4000/tcp # RapiDoc
    environment:
      - TZ=Etc/GMT+3
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./config.yml:/app/config.yml:ro # Custom config

  blocky-swagger:
    image: docker.swagger.io/swaggerapi/swagger-ui
    container_name: blocky-swagger
    restart: unless-stopped
    ports:
      - 4001:8080
    environment:
      - SWAGGER_JSON_URL=blocky:4000/docs/openapi.yaml
    depends_on:
      - blocky
```

### Numa

[Numa](https://github.com/razvandimescu/numa) - портативный DNS-резолвер в одном исполняемом файле с поддержкой блокировки рекламы на ноутбуке без облачной учетной записи или Raspberry Pi.

```yaml
services:
  numa:
    image: ghcr.io/razvandimescu/numa:latest
    container_name: numa
    restart: unless-stopped
    command: ["/etc/numa/numa.toml"]
    ports:
      - 53:53/udp
      - 53:53/tcp
      - 5380:5380/tcp    # Dashboard + REST API
    volumes:
      - ./numa.toml:/etc/numa/numa.toml:ro
      - ./numa_data:/var/lib/numa
```

### Gravity

[Gravity](https://github.com/BeryJu/gravity) - легковесное решение DNS, DHCP и TFTP сервера, использующее `etcd` для полной репликации, подходящее для малых и средних сетей. Поддерживает встроенную кластеризацию (HA), кеширование DNS, блокировку рекламы и метрики Prometheus, а также современный интерфейс с графиками.

```yaml
services:
  gravity:
    image: ghcr.io/beryju/gravity:stable
    container_name: gravity
    restart: unless-stopped
    # Important for this to be static and unique
    hostname: gravity-01
    network_mode: host
    user: root
    volumes:
      - ./gravity_data:/data
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
```

### GoAway

[GoAway](https://github.com/pommee/goaway) - легкий DNS-сервер, с блокировкой рекрамы и современным интерфейсом панели управления (like Pi-hole).

```yaml
services:
  goaway:
    image: pommee/goaway:latest
    container_name: goaway
    restart: unless-stopped
    cap_add:
      - NET_BIND_SERVICE
      - NET_RAW
    volumes:
     - ./goaway_config:/app/config  # Custom settings.yaml configuration
     - ./goaway_data:/app/data      # Database
    environment:
      - DNS_PORT=53
      - WEBSITE_PORT=8080
      # - DOT_PORT=853
    ports:
      - 53/udp
      - 53/tcp
      - 8053:8080
```

### ACME DNS

[ACME DNS](https://github.com/joohoi/acme-dns) - DNS-сервер с поддержкой RESTful HTTP API, предоставляющий простой способ автоматизации запросов DNS ACME.

```yaml
services:
  acme-dns:
    image: joohoi/acme-dns:latest
    container_name: acme-dns
    restart: unless-stopped
    ports:
      - 53:53
      - 53:53/udp
      - 80:80
      - 443:443
    volumes:
      - ./acme_conf:/etc/acme-dns:ro
      - ./acme_data:/var/lib/acme-dns
```

### Dnsmasq

[Dnsmasq](https://github.com/dockur/dnsmasq) - образ для запуска DNS сервера [Dnsmasq](https://thekelleys.org.uk/dnsmasq) в контейнере Docker.

```yaml
services:
  dnsmasq:
    image: dockurr/dnsmasq
    container_name: dnsmasq
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
    ports:
      - 53:53/udp
      - 53:53/tcp
    environment:
      DNS1: 1.0.0.1
      DNS2: 1.1.1.1
```

### Chronyd

[Chronyd](https://github.com/dockur/chrony) - образ для запуска NTP сервера [Chronyd](https://chrony-project.org) в контейнере Docker.

```yaml
services:
  ntp:
    image: dockurr/chrony
    container_name: ntp-server
    restart: unless-stopped
    environment:
      NTP_SERVERS: pool.ntp.org
    ports:
      - 123:123/udp
```

## Proxy Stack

### Traefik

[Traefik](https://github.com/traefik/traefik) - обратный прокси сервер с поддержкой автоматического опредиления сервисов Docker, встроенным веб интерфейсом, метриками Prometheus и трассировкой OTLP.

```yaml
services:
  tech-dns-srv:
    image: technitium/dns-server:latest
    container_name: tech-dns-srv
    restart: always
    volumes:
      - ./dns_data:/etc/dns
    environment:
      - DNS_SERVER_DOMAIN=dns.docker.local
      - DNS_SERVER_FORWARDERS=1.1.1.1,8.8.8.8
      - DNS_SERVER_BLOCK_LIST_URLS=https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
    network_mode: host
    # ports:
    #   - 5380:5380/tcp
    #   - 53:53/udp
    #   - 53:53/tcp
    #   - 53443:53443/tcp
    # sysctls:
    #   - net.ipv4.ip_local_port_range=1024 65000
    labels:
      - traefik.enable=true
      - traefik.http.routers.tech-dns-srv.rule=Host(`dns.docker.local`)
      - traefik.http.services.tech-dns-srv.loadbalancer.server.port=5380

  traefik:
    image: traefik:v3
    container_name: traefik
    restart: always
    # Используем режим хоста для доступа к сети всех контейнеров 
    network_mode: host
    # ports:
    #   - 8080:8080   # Web UI
    #   - 80:80       # HTTP Proxy
    #   - 443:443     # HTTPS Proxy
    #   - 4318:4318   # Prometheus Metrics
    dns:
      - 127.0.0.1
    volumes:
      - ./traefik.yml:/etc/traefik/traefik.yml
      - ./rules:/rules
      - /var/run/docker.sock:/var/run/docker.sock:ro
    healthcheck:
      test: wget -qO- http://127.0.0.1:8080/ping
      start_period: 10s
      interval: 30s
      timeout: 5s
      retries: 5
    labels:
      # Включаем маршрутизацию и определяем имя хоста
      - traefik.enable=true
      - traefik.http.routers.traefik.rule=Host(`traefik.docker.local`)
      # Указываем порт назначения в контейнере (если используется несколько портов)
      - traefik.http.services.traefik.loadbalancer.server.port=8080
      # Создаем базовую авторизацию
      - traefik.http.middlewares.basic-auth-traefik.basicauth.users=admin:$$2y$$05$$c0r5A6SCKX4R6FjuCgRqrufbIE5tmXw2sDPq1vZ8zNrrwNZIH9jgW # htpasswd -nbB admin admin
      # Включаем базовую авторизацию в маршрутизацию текущего сервиса
      - traefik.http.routers.traefik.middlewares=basic-auth-traefik
      # Настраиваем подключение к Authentik
      # - traefik.http.middlewares.authentik.forwardauth.address=http://192.168.3.101:9000/outpost.goauthentik.io/auth/traefik
      # - traefik.http.middlewares.authentik.forwardauth.trustForwardHeader=true
      # - traefik.http.middlewares.authentik.forwardauth.authResponseHeaders=X-authentik-username,X-authentik-groups,X-authentik-entitlements,X-authentik-email,X-authentik-name,X-authentik-uid,X-authentik-jwt,X-authentik-meta-jwks,X-authentik-meta-outpost,X-authentik-meta-provider,X-authentik-meta-app,X-authentik-meta-version
      # Включаем авторизацию через Authentik из провайдера Docker
      # - traefik.http.routers.traefik.middlewares=authentik@docker
      # Включаем авторизацию через Authentik из провайдера file
      # - traefik.http.routers.traefik.middlewares=authentik@file

  jaeger:
    image: jaegertracing/all-in-one:1.55
    container_name: jaeger
    restart: always
    ports:
      - 16686:16686 # UI
      - 4317:4317   # Collector
    labels:
      - sablier.enable=true
```

### Sablier

[Sablier](https://github.com/sablierapp/sablier) - используется для автоматической остановки контейнеров при отсутствие активности по истечению заданного времени и запуску при обращение к сервисам через браузер.

```yaml
services:
  sablier:
    image: sablierapp/sablier:latest
    container_name: sablier
    restart: always
    ports:
      - 10000:10000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command:
      - start
      - --provider.name=docker
      - --sessions.default-duration=5m
      - --server.port=10000
```

### Traefik Log Dashboard

[Traefik Log Dashboard](https://github.com/hhftechnology/traefik-log-dashboard) - платформа анализа логов для обратного прокси-сервера Traefik.

```yaml
services:
  traefik-agent:
    image: hhftechnology/traefik-log-dashboard-agent:latest
    container_name: traefik-log-dashboard-agent
    restart: unless-stopped
    ports:
      - 5000:5000
    volumes:
      - ./data/logs:/logs:ro
      - ./data/positions:/data
    environment:
      # Генерируем токен: openssl rand -hex 32
      - TRAEFIK_LOG_DASHBOARD_AUTH_TOKEN=your_secure_token_here
      - TRAEFIK_LOG_DASHBOARD_ACCESS_PATH=/logs/access.log
      - TRAEFIK_LOG_DASHBOARD_ERROR_PATH=/logs/traefik.log
      - TRAEFIK_LOG_DASHBOARD_SYSTEM_MONITORING=true
      - TRAEFIK_LOG_DASHBOARD_LOG_FORMAT=json
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:5000/api/logs/status"]
      interval: 2m
      timeout: 10s
      retries: 3
      start_period: 30s

  traefik-dashboard:
    image: hhftechnology/traefik-log-dashboard:latest
    container_name: traefik-log-dashboard
    restart: unless-stopped
    ports:
      - 3000:3000
    volumes:
      - ./data/dashboard:/app/data
      - ./data/positions:/data
    environment:
      # Agent Configuration - REPLACE WITH YOUR TOKEN
      - AGENT_API_URL=http://traefik-agent:5000
      - AGENT_API_TOKEN=d41d8cd98f00b204e9800998ecf8427e
      - AGENT_NAME=Default Agent
      - NODE_ENV=production
      - PORT=3000
      - NEXT_PUBLIC_SHOW_DEMO_PAGE=true
      - NEXT_PUBLIC_MAX_LOGS_DISPLAY=500
    depends_on:
      traefik-agent:
        condition: service_healthy
```

### Crowdsec Manager

[Crowdsec Manager](https://github.com/hhftechnology/crowdsec_manager) - веб-интерфейс и мобильная панель управления от создателей [Traefik Log Dashboard](https://github.com/hhftechnology/traefik-log-dashboard) для стека безопасности [CrowdSec](https://github.com/crowdsecurity/crowdsec) с интеграцией Pangolin и поддержкой нескольких прокси (Caddy, NPM и др). В проекте bash скрипт заменен современным интерфейсом [Shadcn UI](https://github.com/shadcn-ui/ui).

```yaml
services:
  crowdsec:
    image: crowdsecurity/crowdsec:latest
    container_name: crowdsec
    restart: unless-stopped
    ports:
      - 6060:6060
    environment:
      - COLLECTIONS=crowdsecurity/linux
    volumes:
      - ./config/crowdsec/acquis.yaml:/etc/crowdsec/acquis.yaml:ro
      - ./crowdsec_db:/var/lib/crowdsec/data/
      - ./crowdsec_config:/etc/crowdsec/

  crowdsec-manager:
    image: hhftechnology/crowdsec-manager:independent
    container_name: crowdsec-manager
    restart: unless-stopped
    ports:
      - 8088:8080
    environment:
      - PORT=8080
      - ENVIRONMENT=production
      - CONFIG_DIR=/app/config
      - DATABASE_PATH=/app/data/settings.db
      - INCLUDE_CROWDSEC=true
      # Pangolin
      - TRAEFIK_CONTAINER_NAME=traefik
      - TRAEFIK_DYNAMIC_CONFIG=/etc/traefik/dynamic_config.yml
      - TRAEFIK_STATIC_CONFIG=/etc/traefik/traefik_config.yml
      - CROWDSEC_METRICS_URL=http://crowdsec:6060/metrics
      - ALERT_LIST_LIMIT=5000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./config:/app/config
      - ./logs/app:/app/logs
      - ./data:/app/data
    depends_on:
      - crowdsec

  pangolin:
    image: fosrl/pangolin:latest
    container_name: pangolin
    restart: unless-stopped
    networks:
      - crowdsec-network
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.pangolin.rule=Host(`pangolin.localhost`)"
      - "traefik.http.routers.pangolin.entrypoints=web"
```

### Pangolin

[Pangolin](https://github.com/fosrl/pangolin) — это обратный прокси-сервер с туннелированием, размещаемый на собственном сервере, с контролем доступа на основе личности и контекста, разработанный для легкого раскрытия и защиты приложений, работающих где угодно. Pangolin выступает в роли центрального узла и соединяет изолированные сети, даже находящиеся за строгими брандмауэрами, через зашифрованные туннели, обеспечивая легкий доступ к удаленным сервисам без открытия портов и использования VPN.

```yaml
services:
  pangolin:
    image: fosrl/pangolin:1.4.0
    container_name: pangolin
    restart: unless-stopped
    volumes:
      - ./config:/app/config
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3001/api/v1/"]
      interval: "3s"
      timeout: "3s"
      retries: 15
 
  gerbil:
    image: fosrl/gerbil:1.0.0
    container_name: gerbil
    restart: unless-stopped
    command:
      - --reachableAt=http://gerbil:3003
      - --generateAndSaveKeyTo=/var/config/key
      - --remoteConfig=http://pangolin:3001/api/v1/gerbil/get-config
      - --reportBandwidthTo=http://pangolin:3001/api/v1/gerbil/receive-bandwidth
    volumes:
      - ./config/:/var/config
    ports:
      - 51820:51820/udp
      # Порты из traefik через network_mode
      - 443:443
      - 80:80
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    depends_on:
      pangolin:
        condition: service_healthy
 
  traefik:
    image: traefik:v3.3.3
    container_name: traefik
    restart: unless-stopped
    # Порты для сервиса gerbil
    network_mode: service:gerbil
    command:
      - --configFile=/etc/traefik/traefik_config.yml
    volumes:
      - ./traefik.yml:/etc/traefik/traefik.yml
      - /var/run/docker.sock:/var/run/docker.sock:ro
      # - ./letsencrypt:/letsencrypt
    depends_on:
      pangolin:
        condition: service_healthy

networks:
  default:
    driver: bridge
    name: pangolin
```

### Nginx Proxy & Docker Gen

[Nginx Proxy](https://github.com/nginx-proxy/nginx-proxy) - настраивает контейнер, работающий под управлением nginx и docker-gen (docker-gen генерирует конфигурации обратного прокси-сервера для nginx и перезагружает nginx при запуске и остановке контейнеров).

[Docker Gen](https://github.com/nginx-proxy/docker-gen) - генератор файлов, который визуализирует шаблоны с использованием метаданных контейнера Docker.

[ACME Companion](https://github.com/nginx-proxy/acme-companion) - используется для автоматической генерации сертификатов letsencrypt, для хостов, использующих переменную `LETSENCRYPT_HOST`.

[Nginx Exporter](https://github.com/nginx/nginx-prometheus-exporter) - экспортер метрик для Prometheus.

```yaml
services:
  # Proxy Server + docker-gen
  nginx-proxy:
    container_name: nginx-proxy
    image: nginxproxy/nginx-proxy
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - ./nginx-status.conf:/etc/nginx/conf.d/status.conf # конфигурация для получения статуса с помощью nginx-exporter 
    ports:
      - 80:80
      - 443:443
    # Apply config to any container on the host (not limited to the current stack in compose)
    network_mode: host
    # labels:
    #   - "com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy=true"

  # Prometheus metrics from nginx
  nginx-exporter:
    image: nginx/nginx-prometheus-exporter:latest
    container_name: nginx-exporter
    restart: unless-stopped
    command:
      - "--nginx.scrape-uri=http://localhost:80/status"
    ports:
      - "9113:9113"
    network_mode: host
    depends_on:
      - nginx-proxy

  # Автоматическая генерация сертификатов letsencrypt, для хостов, использующих переменную LETSENCRYPT_HOST
  # acme-companion:
  #   image: nginxproxy/acme-companion
  #   container_name: nginx-proxy-acme
  #   depends_on:
  #     - nginx-proxy
  #   volumes:
  #     - /var/run/docker.sock:/var/run/docker.sock:ro
  #     - ./certs:/etc/nginx/certs
  #     - ./html:/usr/share/nginx/html
  #     - ./acme.sh:/etc/acme.sh
  #   environment:
  #     - DEFAULT_EMAIL=mail@yourdomain.tld
```

### Nginx Proxy Manager

[Nginx Proxy Manager](https://github.com/NginxProxyManager/nginx-proxy-manager) - веб-интерфейс для управления Nginx сервером в роли Proxy сервера.


```yaml
services:
  nginx-proxy-db:
    image: postgres:latest
    container_name: nginx-proxy-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: "npm"
      POSTGRES_PASSWORD: "npm_password"
      POSTGRES_DB: "npm"
    volumes:
      - ./postgres:/var/lib/postgresql/data
    networks:
      - nginx-network

  nginx-proxy-manager:
    image: docker.io/jc21/nginx-proxy-manager:latest
    container_name: nginx-proxy-manager
    restart: unless-stopped
    ports:
      - 81:81         # Web interface
      - 80:80         # Forward HTTP
      - 443:443       # Forward HTTPS
    environment:
      - DB_POSTGRES_HOST=nginx-proxy-db
      - DB_POSTGRES_PORT=5432
      - DB_POSTGRES_USER=npm
      - DB_POSTGRES_PASSWORD=npm_password
      - DB_POSTGRES_NAME=npm
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    depends_on:
      - nginx-proxy-db
    networks:
      - nginx-network
    # Auth default for Web interface:
    # login: admin@example.com
    # pass: changeme

  nginx-exporter:
    image: nginx/nginx-prometheus-exporter:latest
    container_name: nginx-exporter
    restart: unless-stopped
    ports:
      - "9113:9113"
    command:
      - "--nginx.scrape-uri=http://nginx-proxy-manager:80/status"
    depends_on:
      - nginx-proxy-manager
    networks:
      - nginx-network

networks:
  nginx-network:
    driver: bridge
```

### HAProxy

[HAProxy](https://github.com/haproxy/haproxy) - обратный прокси сервер и "умный" балансировщик нагрузки (поддерживает healthcheck для проверки доступности).

```yaml
services:
  httpbin-proxy:
    image: haproxy:3.2.4-alpine
    container_name: httpbin-proxy
    restart: unless-stopped
    ports:
      - 8089:8080
      - 2376:2376
    volumes:
      - ./haproxy.cfg:/haproxy.cfg
    command:
      - haproxy
      - -f
      - /haproxy.cfg
      - -d
    environment:
      - STATS_USER=admin
      - STATS_PASS=admin
      - STATS_URI=/
      - METRICS_URI=/metrics

  httpbin-go:
    image: ghcr.io/mccutchen/go-httpbin
    container_name: httpbin-go
    restart: unless-stopped
```

### GoDoxy

[GoDoxy](https://github.com/yusing/godoxy) - обратный прокси-сервер для контейнеров Docker или Podman с веб-интерфейсов и агентами для быстрого доступа к веб-интерфейсам сервисов, управления контейнерами и конфигурациями прокси сервера, мониторинга доступности и ресурсов серверов и контейнеров.

🔗 [GoDoxy Demo](https://demo.godoxy.dev) ↗

```yaml
services:
  godoxy-frontend:
    image: ghcr.io/yusing/godoxy-frontend:${TAG:-latest}
    container_name: godoxy-frontend
    restart: unless-stopped
    user: 0:0
    read_only: true
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - all
    tmpfs:
      - /app/.next/cache
    env_file: .env
    labels:
      proxy.aliases: godoxy
      proxy.godoxy.port: 3000
    network_mode: host
    # ports:
    #   - 3000:3000

  godoxy-proxy:
    image: ghcr.io/yusing/godoxy:${TAG:-latest}
    container_name: godoxy-proxy
    restart: unless-stopped
    user: 0:0
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - all
    cap_add:
      - NET_BIND_SERVICE
    # volumes:
    #   - ./config.yaml:/app/config/config.yaml
    #   - ./godoxy_data/logs:/app/logs
    #   - ./godoxy_data/error_pages:/app/error_pages:ro
    #   - ./godoxy_data/data:/app/data
    #   - ./godoxy_data/certs:/app/certs
    env_file: .env
    environment:
      - DOCKER_HOST=tcp://127.0.0.1:2375
    network_mode: host
    # ports:
    #   - 8888:8888 # API
    #   - 80:80     # Proxy HTTP
    #   - 443:443   # Proxy HTTPS
```

env:

```ini
GODOXY_FRONTEND_ALIASES=godoxy.docker.local
# API listening address
GODOXY_API_ADDR=127.0.0.1:8888
SOCKET_PROXY_LISTEN_ADDR=127.0.0.1:2375
DOCKER_SOCKET=/var/run/docker.sock
# DOCKER_SOCKET=/var/run/podman/podman.sock
# Proxy listening address
GODOXY_HTTP_ADDR=:80
GODOXY_HTTPS_ADDR=:443
GODOXY_HTTP3_ENABLED=true
GODOXY_DEBUG=false
TAG=latest
TZ=ETC/UTC+3
GODOXY_UID=0
GODOXY_GID=0
GODOXY_API_JWT_SECURE=true
# openssl rand -base64 32
GODOXY_API_JWT_SECRET=VlB4wAw96yiXpmzz1XF8VtWDB2CP0D8RK3fSxPV/zuw=
# API/WebUI user password login credentials (optional)
GODOXY_API_USER=admin
GODOXY_API_PASSWORD=admin
# OIDC Configuration (optional)
# GODOXY_OIDC_ISSUER_URL=https://accounts.google.com
# GODOXY_OIDC_CLIENT_ID=your-client-id
# GODOXY_OIDC_CLIENT_SECRET=your-client-secret
# GODOXY_OIDC_SCOPES=openid, profile, email, groups # you may also include `offline_access` if your Idp supports it (e.g. Authentik, Pocket ID)
# GODOXY_OIDC_ALLOWED_USERS=user1,user2
# GODOXY_OIDC_ALLOWED_GROUPS=group1,group2
# Metrics
GODOXY_METRICS_DISABLE_CPU=false
GODOXY_METRICS_DISABLE_MEMORY=false
GODOXY_METRICS_DISABLE_DISK=false
GODOXY_METRICS_DISABLE_NETWORK=false
GODOXY_METRICS_DISABLE_SENSORS=false
```

### Promxy

[Promxy](https://github.com/jacksontj/promxy) — это прокси-сервер Prometheus, который позволяет пользователю видеть множество сегментов Prometheus как единую конечную точку API.

```yaml
services:
  promxy:
    image: quay.io/jacksontj/promxy
    container_name: promxy
    restart: unless-stopped
    ports:
    - 8082:8082
    volumes:
    - ./../../cmd:/cmd
    - ./promxy_logs:/var/log
    command:
      - --config=/cmd/promxy/config.yaml
      - --log-level=info
      - --web.enable-lifecycle
```

### Tiny Proxy

[tinyproxy](https://github.com/tinyproxy/tinyproxy) — легковесный прямой (forward) HTTP/HTTPS-прокси-сервер.


```yaml
services:
  tinyproxy:
    image: vimagick/tinyproxy
    container_name: tinyproxy
    restart: unless-stopped
    ports:
      - 1080:8888
    volumes:
      - ./tinyproxy.conf:/etc/tinyproxy/tinyproxy.conf
```

### Proxyfor

[Proxyfor](https://github.com/sigoden/proxyfor) - прямой (forward) и обратный прокси сервер с TUI и Веб-интерфейсом от создателя [dufs](https://github.com/sigoden/dufs) для отображения и фильтрации запросов и ответов.

```yaml
services:
  proxyfor:
    image: sigoden/proxyfor
    container_name: proxyfor
    restart: unless-stopped
    volumes:
      - ~/.proxyfor:/.proxyfor
    # ports:
    #   - 1080:8080
    network_mode: host
    command: --listen 1080 --web

# Install Certificate Authority
# Linux
# sudo curl http://localhost:1080/__proxyfor__/certificate/proxyfor-ca-cert.pem -o /usr/local/share/ca-certificates/proxyfor.crt
# sudo update-ca-certificates
# Windows
# Invoke-RestMethod http://192.168.3.101:1080/__proxyfor__/certificate/proxyfor-ca-cert.cer -OutFile $HOME/Downloads/proxyfor-ca-cert.cer
# certutil -addstore root $HOME/Downloads/proxyfor-ca-cert.cer
```

### Froxy

[Froxy](https://github.com/Lifailon/froxy) - кроссплатформенная утилита командной строки для реализации SOCKS, HTTP и обратного прокси сервера на базе **.NET**. Поддерживается протокол **SOCKS5** для туннелирования TCP трафика и **HTTP** протокол для прямого (классического) проксирования любого **HTTPS** трафика (`CONNECT` запросы), а также **TCP**, **UDP** и **HTTP/HTTPS** протоколы для обратоного проксирования. Для переадресации веб-траффика через обратный прокси поддерживаются `GET` и `POST` запросы с передачей заголовков и тела запроса от клиента, что позволяет использовать `API` запросы и проходить авторизацию на сайтах (передача cookie).

```yaml
services:
  tmdb_web:
    image: lifailon/froxy
    environment:
      SOCKS: "0"
      FORWARD: "0"
      LOCAL: "*:8001"
      REMOTE: "https://themoviedb.org"
      USER: "false"
      PASSWORD: "false"
    ports:
      - "8001:8001"

  tmdb_api:
    image: lifailon/froxy
    environment:
      SOCKS: "0"
      FORWARD: "0"
      LOCAL: "*:8002"
      REMOTE: "https://api.themoviedb.org"
      USER: "false"
      PASSWORD: "false"
    ports:
      - "8002:8002"
```

### NoDPI

[NoDPI](https://github.com/GVCoder09/NoDPI/blob/main/README.ru.md) - утилита для обхода DPI (Deep Packet Inspection).

```yaml
# git clone https://github.com/GVCoder09/NoDPI
# cd NoDPI
# sudo docker build -t nodpi-proxy .

services:
  nodpi-proxy:
    image: nodpi-proxy
    container_name: nodpi
    restart: unless-stopped
    ports:
      - 8881:8881
    volumes:
      - ./blacklist.txt:/tmp/nodpi/blacklist.txt
    command: --host 127.0.0.1 --port 8881 --blacklist /tmp/nodpi/blacklist.txt --quiet
```

### Tor HTTP Proxy

[Tor Proxy](https://github.com/dockur/tor) - прокси-сервера на базе браузера Tor в контейнере Docker.

[ProxyBridge](https://github.com/InterceptSuite/ProxyBridge) - настольный клиент Windows и macOS для перенаправления любого `TCP` и `UDP` трафика через `HTTP` или `SOCKS5` прокси-сервер с фильтрацией по приложениям или url и анализом подключений в интерфейсе.

```yaml
services:
  tor-proxy:
    image: dockurr/tor
    container_name: tor-proxy
    restart: always
    ports:
      - 9050:9050
      - 9051:9051
    volumes:
      - ./tor_conf:/etc/tor
      - ./tor_data:/var/lib/tor
```

### Privoxy

[Tor](https://torproject.org) - браузер с встроенным `SOCKS5` сервером.

[obfs4](https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/lyrebird) - это транспортный плагин Tor для обхода DPI при подключение к сети Tor.

[Privoxy](https://www.privoxy.org) - прокси-сервер, который способен проксировать запросы из `SOCKS5` в `HTTP` и обратно (не поддерживает авторизацию). 

```yaml
services:
  tor-socks-proxy:
    image: alpine:latest
    container_name: tor
    restart: always
    ports:
      - 9150:9150/tcp
    volumes:
      - ./torrc:/etc/tor/torrc:ro
    command: >
      sh -c "apk add --no-cache tor obfs4proxy curl &&
        chmod 700 /var/lib/tor &&
        chown -R root:root /var/lib/tor &&
        tor --version &&
        /usr/bin/tor -f /etc/tor/torrc"
    healthcheck:
      test: ["CMD", "curl", "-sSLIf", "--connect-timeout", "10", "--socks5-hostname", "localhost:9150", "https://bridges.torproject.org"]
      start_period: 300s
      interval: 60s
      timeout: 5s
      retries: 3

  tor-http-proxy:
    image: alpine:latest
    container_name: privoxy
    restart: always
    ports:
      - 8118:8118
    command: >
      sh -c "apk add --no-cache privoxy curl &&
        echo 'listen-address 0.0.0.0:8118' > /etc/privoxy/config &&
        echo 'forward-socks5t / tor-socks-proxy:9150 .' >> /etc/privoxy/config &&
        echo 'debug 1' >> /etc/privoxy/config &&
        echo 'debug 2' >> /etc/privoxy/config &&
        echo 'debug 8' >> /etc/privoxy/config &&
        privoxy --no-daemon /etc/privoxy/config"
    healthcheck:
      test: ["CMD", "curl", "-sSLIf", "--connect-timeout", "10", "--proxy", "http://localhost:8118", "https://bridges.torproject.org"]
      start_period: 10s
      interval: 60s
      timeout: 5s
      retries: 3
```

### Mitm Proxy

[Mitm Proxy](https://github.com/mitmproxy/mitmproxy) - прямой (forward) прокси сервер для перехвата и изменения HTTP-трафика с веб-интерфейсом для анализа запросов и ответов (like [Fiddler](https://www.telerik.com/fiddler)), удобно для отладки мобильных приложений.

```yaml
services:
  mitmproxy:
    image: mitmproxy/mitmproxy:latest
    container_name: mitmproxy
    restart: unless-stopped
    ports:
      - 8880:8080 # Proxy
      - 8881:8081 # Web UI
    command: mitmweb --web-host 0.0.0.0 --listen-host 0.0.0.0
```

### Proxelar

[Proxelar](https://github.com/emanuele-em/proxelar) - веб-интерфейс и TUI инструмент типа MITM, предназначенный для перехвата и анализа HTTP и HTTPS трафика (like mitmproxy). Используется как посредник между приложением и Интернетом для анализа, изменения и мокирования трафика.

```yaml
services:
    proxelar:
      image: ghcr.io/emanuele-em/proxelar
      container_name: proxelar
      restart: always
      command: --interface gui --addr 0.0.0.0
      ports:
        - 8082:8080
        - 8081:8081
      volumes:
        - ./proxelar_data:/root/.proxelar
      # TUI mode
      # stdin_open: true
      # tty: true
      # command: --interface terminal --addr 0.0.0.0
```

### tun2socks

[tun2socks](https://github.com/xjasonlyu/tun2socks) - инструмент для создания и настройки перенаправления сетевого трафика с использованием виртуального сетевого интерфейса (создает интерфейс tun0) через любой внешний SOCKS прокси-сервер.

```yaml
services:
  raspap-gateway:
    image: ghcr.io/xjasonlyu/tun2socks:latest
    container_name: raspap-gateway
    restart: always
    privileged: true
    network_mode: host
    environment:
      - PROXY=socks5://192.168.3.100:2080
    entrypoint: tun2socks -device tun0 -proxy socks5://192.168.3.100:2080

# Проверка маршрутизации через указанный интерфейс  
# curl --interface tun0 https://ifconfig.me

# Настройка маршрутизации трафика для интерфейса wlan0 через интерфейс tun0
# sudo ip rule add iif wlan0 table 200
# sudo ip route add default dev tun0 table 200
# sudo iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
# sudo ip route flush cache
```

### Redsocks

[Redsocks](https://github.com/darkk/redsocks) - инструмент для перенаправления любого TCP-соединение на SOCKS или HTTPS-прокси на уровне системы и сети с помощью Firewall.

```yaml
services:
  redsocks:
    image: alpine:latest
    container_name: redsocks
    restart: always
    privileged: true
    network_mode: host
    volumes:
      - ./redsocks.conf:/etc/redsocks.conf:ro
    command: >
      sh -c "apk add --no-cache redsocks iptables && redsocks -c /etc/redsocks.conf"
```

## VPN

### WG UI

[WG UI](https://github.com/ngoduykhanh/wireguard-ui) - веб-интерфейс для управления настройкой сервера WireGuard [WireGuard](https://github.com/wireguard) и клиентов (peers).

[Amnezia Client](https://github.com/amnezia-vpn/amnezia-client) - клиент WireGuard для Windows, macOS, Linux и Android устройств.

```yaml
services:
  wg:
    image: ngoduykhanh/wireguard-ui:latest
    container_name: wg
    restart: always
    privileged: true
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      - net.ipv4.ip_forward=1
      - net.ipv4.conf.all.src_valid_mark=1
    ports:
      - 51821:51821/tcp
      - 51820:51820/udp
    environment:
      - BIND_ADDRESS=0.0.0.0:51821
      - WGUI_USERNAME=admin
      - WGUI_PASSWORD=WgAdmin
      - WGUI_SERVER_LISTEN_PORT=51820
      - WGUI_SERVER_INTERFACE_ADDRESSES=10.252.1.1/24
      - WGUI_DEFAULT_CLIENT_ALLOWED_IPS=10.252.1.0/24
      - WGUI_DNS=1.1.1.1
      - WGUI_MTU=1450
      - WGUI_CONFIG_FILE_PATH=/etc/wireguard/wg0.conf
      - WGUI_LOG_LEVEL=DEBUG
      - WGUI_MANAGE_START=true
      - WGUI_MANAGE_RESTART=true
      - WGUI_DEFAULT_CLIENT_USE_SERVER_DNS=false
      # Разрешает выход в интернет через внешний интерфейс
      # iptables -A FORWARD -i wg0 -o eth0 -j ACCEPT;

    volumes:
      - ./wg_db:/app/db
      - ./wg_etc:/etc/wireguard
    entrypoint: |
      sh -c "
        # Разрешает прохождение трафика между клиентами внутри VPN
        iptables -A FORWARD -i wg0 -o wg0 -j ACCEPT
        # Разрешает все ответы на уже установленные соединения из Интернета
        iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
        # iptables -A FORWARD -i eth0 -o wg0 -j ACCEPT
        # Разрешаем VPN-клиентам устанавливать новые соединения в Интернет через внешний интерфейс
        iptables -A FORWARD -i wg0 -o eth0 -j ACCEPT
        # Разрешает выход в интернет через внешний интерфейс
        iptables -t nat -A POSTROUTING -s 10.252.1.0/24 -o eth0 -j MASQUERADE
        # Разрешаем прохождение трафика от хостовой подсети в VPN подсеть
        iptables -t nat -A POSTROUTING -s 172.50.0.0/24 -o wg0 -j MASQUERADE
        ./init.sh
      "
    networks:
      wg_net:
        ipv4_address: 172.50.0.2

# Маршрут до подсети VPN на хосте
# sudo ip route add 10.252.1.0/24 via 172.50.0.2
networks:
  wg_net:
    ipam:
      config:
        - subnet: 172.50.0.0/24
          gateway: 172.50.0.1

# docker exec -it wg wg show
```

### WG Easy

[WG Easy](https://github.com/wg-easy/wg-easy) - веб-интерфейс для запуска сервер WireGuard и настройкой клиентов.

```yaml
services:
  wg:
    image: ghcr.io/wg-easy/wg-easy:latest
    container_name: wg
    restart: always
    privileged: true
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      - net.ipv4.ip_forward=1
      - net.ipv4.conf.all.src_valid_mark=1
    ports:
      - 51821:51821/tcp
      - 51820:51820/udp
    environment:
      # docker run --rm ghcr.io/wg-easy/wg-easy wgpw 'WgAdmin' | sed "s/\\$/\\$\\$/g"
      # - PASSWORD_HASH='$$2a$$12$$C1RWLpi.1v/JZltvKpwmIenskUG7jYMo4n1HMbha0DtZE6G6mb52y'
      - INSECURE=true
      - PORT=51821
      - HOST=0.0.0.0
      - WG_PORT=51820
      - WG_DEFAULT_ADDRESS=10.8.0.x
      - WG_ALLOWED_IPS=10.8.0.0/24
    volumes:
      - ./wg_etc:/etc/wireguard
```

### WG Portal

[WG Portal](https://github.com/h44z/wg-portal) - веб-интерфейс для настройки WireGuard с поддержкой авторизации через OAuth или LDAP в качестве источника данных для аутентификации и профилей пользователей.

```yaml
services:
  wg-portal:
    image: wgportal/wg-portal:v2
    container_name: wg-portal
    restart: unless-stopped
    network_mode: host
    cap_add:
      - NET_ADMIN
    volumes:
      - ./wg_etc:/etc/wireguard
      - ./wg_data:/app/data
      - ./wg_conf:/app/config
```

### NetBird

[NetBird](https://github.com/netbirdio/netbird) - создает оверлейную сеть на основе WireGuard, которая автоматически соединяет компьютеры через зашифрованный туннель, избавляя от необходимости открывать порты, устанавливать сложные правила брандмауэра, VPN-шлюзы и так далее.

```yaml
services:
  netbird-client:
    image: netbirdio/netbird:latest
    container_name: netbird-client
    cap_add:
        - NET_ADMIN
        - SYS_ADMIN
        - SYS_RESOURCE
    devices:
        - /dev/net/tun
    network_mode: host
    environment:
        - NB_SETUP_KEY=<SETUP KEY>
    volumes:
        - ./netbird_data:/var/lib/netbird
```

### 3X UI

[3X UI](https://github.com/MHSanaei/3x-ui) - панель для управления сервером [Xray-core](https://github.com/XTLS/Xray-core).

[v2rayN](https://github.com/2dust/v2rayN) - клиент Xray для Windows, macOS и Linux.

[NekoBox](https://github.com/MatsuriDayo/NekoBoxForAndroid) - клиент Xray для Android.

```yaml
services:
  3x:
    image: ghcr.io/mhsanaei/3x-ui:latest
    container_name: 3x
    restart: always
    # network_mode: host
    ports:
      - 20533:2053    # UI
      - 443:443       # Vless+Reality
      # - 12537:12537 # Mixed Proxy (HTTP+SOCKS5)
      # - 51318:51318 # WireGuard
    privileged: true
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      - net.ipv4.ip_forward=1
    environment:
      - XRAY_VMESS_AEAD_FORCED=false
      - XUI_ENABLE_FAIL2BAN=true
    volumes:
      - ./3x_data:/etc/x-ui
      - ./3x_cert:/root/cert
      # mkdir 3x_logs && touch ./3x_logs/access.log ./3x_logs/error.log
      - ./3x_logs/access.log:/app/access.log
      - ./3x_logs/error.log:/app/error.log
    logging:
      driver: journald
      options:
        tag: 3x
```

### v2rayA

[v2rayA](https://github.com/v2rayA/v2rayA) - клиент V2Ray/Xray с веб-интерфейсом для настройки подключения в роли VPN-клиента, который может использоваться как Proxy-сервер (поддерживает встроенный HTTP/SOCKS5) или для перенаправления трафика через VPN через компьютер на роутере, который не поддерживает протокол Vless.

```yaml
services:
  v2raya:
    image: ghcr.io/v2raya/v2raya:latest
    container_name: v2raya
    restart: always
    privileged: true
    network_mode: host
    volumes:
      - /lib/modules:/lib/modules:ro
      - /etc/resolv.conf:/etc/resolv.conf
      - ./service:/service:ro
```

### YACD

[YACD](https://github.com/haishanh/yacd) (Yet Another Clash Dashboard) - веб-интерфейс для графического мониторинга и настройки прокси-клиентов, работающих на ядрах Clash или sing-box.

```yaml
services:
  yacd:
    image: ghcr.io/haishanh/yacd:master
    container_name: yacd
    restart: always
    ports:
      - 1234:80
```

### Hiddify

[Hiddify Manager](https://github.com/hiddify/Hiddify-Manager) - инструмент для борьбы с цензурой, представляющий собой многопользовательскую панель с простой установкой и поддержкой более 20 протоколов, включая Reality и Telegram Proxy, для обхода фильтрации, который оптимизирован для обхода цензуры в Китае, России и Иране, а также включен в список Xray.

[Hiddify App](https://github.com/hiddify/hiddify-app/blob/main/README_ru.md) - прокси-клиент на основе ядра [Sing-box](https://github.com/SagerNet/sing-box) для Android, Windows, Linux и macOS.

```yaml
services:
  hiddify:
    image: ghcr.io/hiddify/hiddify-manager:latest
    container_name: hiddify
    restart: always
    ports:
      - 80:80
      - 443:443
    privileged: true
    cap_add:
      - NET_ADMIN
    volumes:
       - ./hiddify_data/:/hiddify-data/
    environment:
      - REDIS_PASSWORD=RedisAdmin
      - REDIS_URI_MAIN=redis://:RedisAdmin@hiddify-redis:6379/0
      - REDIS_URI_SSH=redis://:RedisAdmin@hiddify-redis:6379/1
      - SQLALCHEMY_DATABASE_URI=mysql+mysqldb://hiddify_usr:MySqlPassword@hiddify-mariadb/hiddify_db?charset=utf8mb4
    depends_on: 
      - hiddify-mariadb
      - hiddify-redis

  hiddify-mariadb:
    image: mariadb:latest
    container_name: mariadb_container
    restart: always
    environment:
      - MYSQL_PASSWORD=MySqlPassword
      - MARIADB_RANDOM_ROOT_PASSWORD=1
      - MYSQL_DATABASE=hiddify_db
      - MYSQL_USER=hiddify_usr
    volumes:
      - ./hiddify_data/mariadb_data:/var/lib/mysql

  hiddify-redis:
    image: redis:latest
    container_name: redis_container
    restart: always
    command: sh -c "redis-server --requirepass \"$REDIS_PASSWORD\""
    environment:
      - REDIS_PASSWORD=RedisAdmin
      - MYSQL_PASSWORD=MySqlPassword
    volumes:
      - ./hiddify_data/redis_data:/data
```

### Fail2Ban

[Fail2Ban](https://github.com/fail2ban/fail2ban) - инструмент для блокировки хостов (обновляя правила `iptables`), вызывающих множественные ошибки аутентификации по ssh и в веб-приложениях, используя анализ журналов (например, из лог-файлов или journald).

```yaml
services:
  fail2ban:
    image: lscr.io/linuxserver/fail2ban:latest
    container_name: fail2ban
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
      - NET_RAW
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
      - VERBOSITY=-vv
    volumes:
      - ./config:/config
      - /var/log:/var/log:ro
```

### Fail2Ban UI

[Fail2Ban UI](https://github.com/swissmakers/fail2ban-ui) - платформа управления Fail2Ban на локальном или удаленных хостах Linux через сокет или ssh, предоставляя централизованный интерфейс для просмотра блокировок, поиска и разблокировки IP-адресов, управления конфигурациями и фильтрами, а также получения уведомлений.

```yaml
services:
  fail2ban-ui:
    image: swissmakers/fail2ban-ui:latest
    container_name: fail2ban-ui
    restart: always
    network_mode: host
    environment:
      - PORT=18080
      - BIND_ADDRESS=0.0.0.0
      - AUTODARK=true
    volumes:
      - /var/log:/var/log:ro
      - /etc/fail2ban:/etc/fail2ban:Z
      - /var/run/fail2ban:/var/run/fail2ban
```

### AutoSSH

[AutoSSH](https://github.com/jnovack/autossh) - автоматически запускаем и поддерживает в активном состояние обратные туннели через SSH.

```yaml
services:
  it-tools-tunnel:
    image: jnovack/autossh
    container_name: it-tools-tunnel
    restart: always
    environment:
      # Input port on VDS
      - SSH_BIND_IP=0.0.0.0
      - SSH_TUNNEL_PORT=6990
      # SSH forward tunnel on VDS 
      - SSH_REMOTE_USER=
      - SSH_REMOTE_HOST=
      - SSH_REMOTE_PORT=
      # Destination port to local subnet
      - SSH_TARGET_HOST=192.168.3.101
      - SSH_TARGET_PORT=6990
      # Reverse mode
      - SSH_MODE=-R
      - SSH_OPTIONS=-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GatewayPorts=true
    volumes:
      - /home/lifailon/.ssh/id_rsa:/id_rsa:ro
```

## Wi-Fi

### RaspAP

[RaspAP](https://github.com/RaspAP/raspap-webgui) - позволяет превратить любой компьютер (например, одноплатник на Raspberry Pi) в роутер.

```yaml
services:
  raspap:
    image: ghcr.io/raspap/raspap-docker:latest
    container_name: raspap
    restart: always
    privileged: true
    network_mode: host
    # ports:
    #   - 8081:8081
    environment:
      - RASPAP_SSID=failon.vpn
      - RASPAP_SSID_PASS=12340987
      - RASPAP_COUNTRY=RU
      - RASPAP_WEBGUI_PORT=8081
      - RASPAP_WEBGUI_USER=admin
      - RASPAP_WEBGUI_PASS=admin
      - INTERFACE=uap0
      - UPSTREAM_INTERFACE=wlan0
    cap_add:
      - SYS_ADMIN
    volumes:
      - /lib/modules:/lib/modules:ro
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
    cgroup: host
```

### SPR

[SPR](https://github.com/spr-networks/super) (Super) - многофункциональный Wi-Fi роутер ОС, который запускается в контейнере Docker. Поддерживает Multi-PSK (включая WPA3), Wi-Fi 6, доступ к сети на основе политик, блокировку рекламы на основе DNS списков (Ad Block), подключение к VPN (например, Wireguard), многоканальную глобальную сеть с балансировкой нагрузки и другие функции.

🔗 [SPR Demo](https://demo.supernetworks.org) ↗

```bash
git clone https://github.com/spr-networks/super
cd super

# flash
# sudo base/setup.sh
# sdcard
# sudo base/setup-sdcard.sh

cp -R base/template_configs configs
./configs/scripts/gen_coredhcp_yaml.sh > configs/dhcp/coredhcp.yml
./configs/scripts/gen_watchdog.sh  > configs/watchdog/watchdog.conf
docker compose up -d
```

### OpenWRT-Docker

[OpenWRT-Docker](https://github.com/AlbrechtL/openwrt-docker) - 

```yaml
services:
  openwrt:
    image: albrechtloh/openwrt-docker:latest
    container_name: openwrt
    restart: always
    privileged: true
    environment:
      WAN_IF: host
      LAN_IF: veth
      FORWARD_LUCI: true
    ports:
      # TTY Console
      - 8006:8006
      # LuCI WebUI
      - 8007:8000
      # SSH
      - 8022:8022
    stop_grace_period: 2m
    devices:
      - /dev/kvm
    device_cgroup_rules:
      - 'c *:* rwm'
    cap_add:
      - NET_ADMIN
    pid: host
    volumes:
      - /dev:/dev/
      - ./openwrt_data:/storage/
```

## VRRP

### KeepAlived

[KeepAlived](https://github.com/acassen/keepalived) - используется для обеспечения высокой доступности (HA) за счет протокола [VRRP](https://ru.wikipedia.org/wiki/VRRP) (Virtual Router Redundancy Protocol), который поднимает один виртуальный IP-адрес для нескольких хостов с проверкой доступности и переключением адреса на другой хост в случае провального healthcheck. Чаще всего используется для отказоустойчивости балансировщиков нагрузки.

Образа контейнера на базе легковесного Alpine с использованием команд для установки и запуска keepalived.

```yaml
services:
  keepalived:
    image: alpine:3.18
    container_name: keepalived
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
      - NET_BROADCAST
      - NET_RAW
    volumes:
      - ./keepalived.conf:/etc/keepalived/keepalived.conf:ro
    network_mode: host
    command: |
      sh -c "
        apk add --no-cache keepalived curl &&
        keepalived --dont-fork --log-console
      "
```

## SSO

### Authentik

[Authentik](https://github.com/goauthentik/authentik) - IDP (поставщик идентификации) и SSO (единая точка входа), который построен с безопасностью в центре каждого фрагмента кода, каждой функции, с акцентом на гибкость и универсальность.

```yaml
services:
  authentik-postgres:
    image: docker.io/library/postgres:16-alpine
    container_name: authentik-postgres
    restart: unless-stopped
    env_file:
    - .env
    # ports:
    #   - 5432:5432
    volumes:
    - ./authentik_database:/var/lib/postgresql/data
    healthcheck:
      test:
      - CMD-SHELL
      - pg_isready -d $${POSTGRES_DB} -U $${POSTGRES_USER}
      interval: 30s
      retries: 5
      start_period: 20s
      timeout: 5s

  authentik-redis:
    image: docker.io/library/redis:alpine
    restart: unless-stopped
    container_name: authentik-redis
    command: --save 60 1 --loglevel warning
    # ports:
    #   - 6379:6379
    volumes:
    - ./redis_data:/data
    healthcheck:
      test:
      - CMD-SHELL
      - redis-cli ping | grep PONG
      interval: 30s
      retries: 5
      start_period: 20s
      timeout: 3s

  authentik-server:
    image: ghcr.io/goauthentik/server:2025.8.4
    restart: unless-stopped
    container_name: authentik-server
    command: server
    env_file:
    - .env
    ports:
    - 9000:9000
    - 9443:9443
    volumes:
    - ./authentik_media:/media
    - ./authentik_custom-templates:/templates
    depends_on:
      authentik-postgres:
        condition: service_healthy
      authentik-redis:
        condition: service_healthy

  authentik-worker:
    image: ghcr.io/goauthentik/server:2025.8.4
    restart: unless-stopped
    container_name: authentik-worker
    command: worker
    env_file:
    - .env
    user: root
    volumes:
    - ./authentik_media:/media
    - ./authentik_certs:/certs
    - ./authentik_custom-templates:/templates
    - /var/run/docker.sock:/var/run/docker.sock
    depends_on:
      authentik-postgres:
        condition: service_healthy
      authentik-redis:
        condition: service_healthy

# Go on http://authentik-server:9000/if/flow/initial-setup
```

env:

```ini
POSTGRES_DB=authentik
POSTGRES_USER=authentik
POSTGRES_PASSWORD=AuthentikAdmin

AUTHENTIK_POSTGRESQL__HOST=authentik-postgres
AUTHENTIK_POSTGRESQL__NAME=authentik
AUTHENTIK_POSTGRESQL__USER=authentik
AUTHENTIK_POSTGRESQL__PASSWORD=AuthentikAdmin
AUTHENTIK_REDIS__HOST=authentik-redis
AUTHENTIK_SECRET_KEY=J+fcRg0PtPRrILSeahxEtZwKGKM7irzJU15qp3ImG4XYoHyzsId5tnZjVoPs9XTnH5NwYaviRCVQZKSQ # openssl rand 60 | base64 -w 80
```

### Authelia

[Authelia](https://github.com/authelia/authelia) - сервер аутентификации и авторизации с открытым исходным кодом, обеспечивающий несколько методов двухфакторной аутентификации и единый вход (SSO) для приложений через веб-портал. Он действует как компаньон для обратных прокси, разрешая, запрещая или перенаправляя запросы.

```yaml
services:
  authelia:
    image: docker.io/authelia/authelia:latest
    container_name: authelia
    restart: unless-stopped
    environment:
      - AUTHELIA_IDENTITY_VALIDATION_RESET_PASSWORD_JWT_SECRET_FILE=/secrets/JWT_SECRET
      - AUTHELIA_SESSION_SECRET_FILE=/secrets/SESSION_SECRET
      - AUTHELIA_STORAGE_POSTGRES_PASSWORD_FILE=/secrets/STORAGE_PASSWORD
      - AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE=/secrets/STORAGE_ENCRYPTION_KEY
    volumes:
      - ./authelia_config:/config
      - ./authelia_secrets:/secrets
    ports:
      - 9091:9091
```

### Keycloak

[Keycloak](https://github.com/keycloak/keycloak) - сервер управления идентификацией и доступом с открытым исходным кодом. Позволяет добавить аутентификацию в приложения и защитить сервисы с минимальными усилиями (не нужно заниматься сохранением данных пользователей или их аутентификацией).

```yaml
services:
  keycloak:
    image: quay.io/keycloak/keycloak:26.4.0
    container_name: keycloak
    restart: unless-stopped
    command: start-dev
    environment:
      - KC_BOOTSTRAP_ADMIN_USERNAME=admin
      - KC_BOOTSTRAP_ADMIN_PASSWORD=admin
    ports:
      - 8080:8080
```

### Pocket ID

[Pocket ID](https://github.com/pocket-id/pocket-id) - OIDC-провайдер (как Keycloak или [ORY Hydra](https://github.com/ory/hydra), но проще) от создателей [Pingvin Share](https://github.com/stonith404/pingvin-share), позволяющий пользователям аутентифицироваться в ваших сервисах с помощью своих паролей.

```yaml
services:
  pocket-id:
    image: ghcr.io/pocket-id/pocket-id:v2
    container_name: pocket-id
    restart: unless-stopped
    env_file: .env
    ports:
      - 1411:1411
    environment:
      - APP_URL=https://your-pocket-id-domain.com
      # openssl rand -base64 32
      - ENCRYPTION_KEY=
      - TRUST_PROXY=false
      - MAXMIND_LICENSE_KEY=
      - PUID=1000
      - PGID=1000
    volumes:
      - ./pocket_id_data:/app/data
    healthcheck:
      test: [ "CMD", "/app/pocket-id", "healthcheck" ]
      interval: 1m30s
      timeout: 5s
      retries: 2
      start_period: 10s
```

### Zitadel

[Zitadel](https://github.com/zitadel/zitadel) - SSO решение, как альтернатива Keycloak. Поддерживает самообслуживание пользователей и идентификацию с помощью сторонних провайдеров, в том числе OpenID, OAuth 2.x, SAML2, LDAP, Passkey / FIDO2, OTP, 2FA.

```yaml
services:
  zitadel:
    restart: unless-stopped
    image: ghcr.io/zitadel/zitadel:latest
    command: start-from-init --masterkey "MasterkeyNeedsToHave32Characters"
    environment:
      ZITADEL_EXTERNALDOMAIN: localhost
      ZITADEL_EXTERNALSECURE: false
      ZITADEL_TLS_ENABLED: false
      ZITADEL_DATABASE_POSTGRES_HOST: zitadel-db
      ZITADEL_DATABASE_POSTGRES_PORT: 5432
      ZITADEL_DATABASE_POSTGRES_DATABASE: zitadel
      ZITADEL_DATABASE_POSTGRES_ADMIN_USERNAME: postgres
      ZITADEL_DATABASE_POSTGRES_ADMIN_PASSWORD: postgres
      ZITADEL_DATABASE_POSTGRES_ADMIN_SSL_MODE: disable
      ZITADEL_DATABASE_POSTGRES_USER_USERNAME: zitadel
      ZITADEL_DATABASE_POSTGRES_USER_PASSWORD: zitadel
      ZITADEL_DATABASE_POSTGRES_USER_SSL_MODE: disable
      ZITADEL_FIRSTINSTANCE_LOGINCLIENTPATPATH: /current-dir/login-client.pat
      ZITADEL_FIRSTINSTANCE_ORG_HUMAN_PASSWORDCHANGEREQUIRED: false
      ZITADEL_FIRSTINSTANCE_ORG_LOGINCLIENT_MACHINE_USERNAME: login-client
      ZITADEL_FIRSTINSTANCE_ORG_LOGINCLIENT_MACHINE_NAME: Automatically Initialized IAM_LOGIN_CLIENT
      ZITADEL_FIRSTINSTANCE_ORG_LOGINCLIENT_PAT_EXPIRATIONDATE: '2029-01-01T00:00:00Z'
      ZITADEL_DEFAULTINSTANCE_FEATURES_LOGINV2_BASEURI: http://localhost:3000/ui/v2/login
      ZITADEL_OIDC_DEFAULTLOGINURLV2: http://localhost:3000/ui/v2/login/login?authRequest=
      ZITADEL_OIDC_DEFAULTLOGOUTURLV2: http://localhost:3000/ui/v2/login/logout?post_logout_redirect=
      ZITADEL_SAML_DEFAULTLOGINURLV2: http://localhost:3000/ui/v2/login/login?samlRequest=
    healthcheck:
      test:
        - CMD
        - /app/zitadel
        - ready
      interval: 10s
      timeout: 60s
      retries: 5
      start_period: 10s
    user: "0"
    volumes:
      - .:/current-dir:delegated
    ports:
      - 8080:8080
      - 3000:3000
    depends_on:
      zitadel-db:
        condition: service_healthy

  login:
    restart: unless-stopped
    image: ghcr.io/zitadel/zitadel-login:latest
    environment:
      - ZITADEL_API_URL=http://localhost:8080
      - NEXT_PUBLIC_BASE_PATH=/ui/v2/login
      - ZITADEL_SERVICE_USER_TOKEN_FILE=/current-dir/login-client.pat
    network_mode: service:zitadel
    user: "0"
    volumes:
      - .:/current-dir:ro
    depends_on:
      zitadel:
        condition: service_healthy
        restart: false

  zitadel-db:
    restart: unless-stopped
    image: postgres:17
    environment:
      PGUSER: postgres
      POSTGRES_PASSWORD: postgres
    healthcheck:
      test: 
      - CMD-SHELL
      - pg_isready
      - -d
      - zitadel
      - -U
      - postgres
      interval: 10s
      timeout: 30s
      retries: 5
      start_period: 20s
    ports:
      - 5432:5432
    volumes:
      - ./zitadel_data:/var/lib/postgresql/data:rw
```

### Warpgate

[Warpgate](https://github.com/warp-tech/warpgate) — интеллектуальный и полностью прозрачный хост-бастион SSH, HTTPS, MySQL и PostgreSQL, которому не требуется клиентское приложение или оболочка SSH. Поддерживает 2FA и SSO (TOTP и OpenID Connect), а также позволяет настроить свой DMZ, добавлять учетные записи пользователей и определять их определенным хостам и URL-адресам в сети. Warpgate будет записывать каждый сеанс, чтобы вы могли просмотреть его в реальном времени и воспроизвести позже через встроенный веб-интерфейс администратора.

```yaml
services:
  warpgate:
    image: ghcr.io/warp-tech/warpgate
    container_name: warpgate
    restart: unless-stopped
    volumes:
      - ./warpgate_data:/data
    ports:
      - 2222:2222
      - 8888:8888
      - 33306:33306
    stdin_open: true
    tty: true
```

### Voidauth

[Voidauth](https://github.com/voidauth/voidauth) - провайдер SSO-аутентификации и поставщик OpenID Connect (OIDC) с открытым исходным кодом, который защищает ваши приложения, размещенные на собственном сервере. Поддерживает управление пользователями, пароли, приглашение пользователей, самостоятельную регистрацию, поддержку по электронной почте и другие функции.

```yaml
services:
  voidauth: 
    image: voidauth/voidauth:latest
    container_name: voidauth
    restart: unless-stopped
    environment:
      - APP_URL=
      - STORAGE_KEY=
      - DB_PASSWORD=VoidAuthPass
      - DB_HOST=voidauth-db
    volumes:
      - ./voidauth_config:/app/config
    depends_on:
      - voidauth-db

  voidauth-db:
    image: postgres:18
    restart: unless-stopped
    environment:
      - POSTGRES_PASSWORD=VoidAuthPass
    volumes:
      - ./voidauth_db:/var/lib/postgresql/18/docker
```

## PAM

### JumpServer

JumpServer - платформа управления привилегированным доступом (PAM - Privileged Access Management) с открытым исходным кодом, которая предоставляет безопасный доступ по требованию к конечным точкам SSH, RDP, Kubernetes, Database и RemoteApp через веб-браузер.

```yaml
services:
  jumpserver:
    image: jumpserver/jms_all
    container_name: jumpserver
    restart: unless-stopped
    environment:
      - SECRET_KEY=JumpServerSecretKey
      - BOOTSTRAP_TOKEN=JumpServerToken
    volumes:
      - ./js_data:/opt/data
      - ./pg_data:/var/lib/postgresql
    ports:
      - 2222:2222
      - 8282:80
```

## LDAP

### LLDAP

[LLDAP](https://github.com/lldap/lldap) - облегченный сервер аутентификации (Light LDAP), предоставляющий продуманный и упрощенный интерфейс LDAP для аутентификации и современный интерфейс управления (интегрируется со многими бэкендами, от KeyCloak до Authelia, Nextcloud и другими).

```yaml
services:
  lldap:
    image: lldap/lldap:stable
    ports:
      - 3890:3890   # LDAP
      - 6360:6360   # LDAPS (LDAP Over SSL)
      - 17170:17170 # Web front-end
    volumes:
      - ./lldap_data:/data
    environment:
      - UID=1000
      - GID=1000
      - TZ=Etc/UTC+3
      - LLDAP_JWT_SECRET=REPLACE_WITH_RANDOM
      - LLDAP_KEY_SEED=REPLACE_WITH_RANDOM
      - LLDAP_LDAP_BASE_DN=dc=docker,dc=local
      - LLDAP_LDAP_USER_PASS=LdapAdmin
      # If using LDAPS, set enabled true and configure cert and key path
      - LLDAP_LDAPS_OPTIONS__ENABLED=false
      # - LLDAP_LDAPS_OPTIONS__CERT_FILE=/path/to/certfile.crt
      # - LLDAP_LDAPS_OPTIONS__KEY_FILE=/path/to/keyfile.key
      # Database
      # - LLDAP_DATABASE_URL=mysql://mysql-user:password@mysql-server/my-database
      # - LLDAP_DATABASE_URL=postgres://postgres-user:password@postgres-server/my-database
      # SMTP
      # - LLDAP_SMTP_OPTIONS__ENABLE_PASSWORD_RESET=true
      # - LLDAP_SMTP_OPTIONS__SERVER=smtp.example.com
      # - LLDAP_SMTP_OPTIONS__PORT=465
      # - LLDAP_SMTP_OPTIONS__SMTP_ENCRYPTION=TLS
      # - LLDAP_SMTP_OPTIONS__USER=no-reply@example.com
      # - LLDAP_SMTP_OPTIONS__PASSWORD=PasswordGoesHere
      # - LLDAP_SMTP_OPTIONS__FROM=no-reply <no-reply@example.com>
      # - LLDAP_SMTP_OPTIONS__TO=admin <admin@example.com>
```

### Glauth

[Glauth](https://github.com/glauth/glauth) - современный и молодой сервер аутентификации (Go-lang LDAP Authentication) с управлением через конфигурацию и поддержкой метрик Prometheus.

```yaml
services:
  glauth:
    image: glauth/glauth:latest
    container_name: glauth
    restart: unless-stopped
    environment:
      - TZ=UTC
    ports:
      - 3893:3893    # LDAP port
      # - 3894:3894  # LDAPS port
      - 5555:5555    # API (Web UI and metrics for Prometheus)
    volumes:
      - ./glauth.cfg:/app/config/config.cfg

# sudo apt install ldap-utils
# ldapsearch -LLL -H ldap://localhost:3893 -D "cn=admin1,ou=admins,dc=docker,dc=local" -w LdapAdmin -b "dc=docker,dc=local" cn=admin2
```

### OpenLDAP & phpLDAPadmin

[OpenLDAP](https://github.com/osixia/docker-openldap) - реализация протокола Lightweight Directory Access Protocol с открытым исходным кодом. В состав входят LDAP-демон сервера (slapd) и автономный демон балансировки нагрузки LDAP (lloadd).

[phpLDAPadmin](https://github.com/osixia/docker-phpLDAPadmin) - универсальный Веб-интерфейс для LDAP.

```yaml
services:
  ldap-backend:
    image: osixia/openldap:latest
    container_name: openldap
    restart: unless-stopped
    environment:
      - LDAP_ORGANISATION=Docker Local
      - LDAP_DOMAIN=docker.local
      - LDAP_ADMIN_PASSWORD=LdapAdmin
    ports:
      - 1389:389
      - 1636:636
    volumes:
      - ./ldap_data:/var/lib/ldap
      - ./ldap_config:/etc/ldap/slapd.d
    # healthcheck:
    #   test: ["CMD", "ldapsearch", "-H", "ldap://localhost:1389", "-D", "cn=admin,dc=docker,dc=local", "-w", "LdapAdmin", "-b", "dc=docker,dc=local"]
    #   interval: 30s
    #   timeout: 10s
    #   retries: 3

  ldap-frontend:
    image: osixia/phpldapadmin:latest
    container_name: phpldapadmin
    restart: unless-stopped
    links:
      - ldap-backend:ldap-host
    environment:
      - PHPLDAPADMIN_LDAP_HOSTS=ldap-host
      - PHPLDAPADMIN_HTTPS=false
    ports:
      - 1443:443
    depends_on:
      - ldap-backend

  # ldap-ui:
  #   image: dnknth/ldap-ui
  #   container_name: ldap-ui
  #   restart: unless-stopped
  #   ports:
  #     - 5000:5000
  #   environment:
  #     - LDAP_URL=ldap://ldap-backend/
  #     - BASE_DN=dc=docker,dc=local
  #     - BIND_DN=cn=admin,dc=docker,dc=local
  #     - BIND_PASSWORD=LdapAdmin
  #   depends_on:
  #     - ldap-backend

# Web UI: https://localhost:6443
# Login DN: cn=admin,dc=docker,dc=local
# Password: LdapAdmin

# sudo apt install ldap-utils
# ldapsearch -LLL -H ldap://localhost:1389 -D "cn=admin,dc=docker,dc=local" -w LdapAdmin -b "dc=docker,dc=local"

# TUI LDAP Client: https://github.com/Macmod/godap
# brew install godap
# godap localhost -P 1389 -u "cn=admin,dc=docker,dc=local" -p "LdapAdmin" -r "dc=docker,dc=local"
```

### OpenDJ & LDAP UI

[OpenDJ](https://github.com/OpenIdentityPlatform/OpenDJ) - совместимая служба каталогов, разработанная для платформы Java и обеспечивающая высокопроизводительное, высокодоступное и безопасное хранилище для идентификационных данных.

[LDAP UI](https://github.com/dnknth/ldap-ui) - минималистичный Веб-интерфейс для каталогов LDAP.

```yaml
services:
  ldap-server:
    image: openidentityplatform/opendj:latest
    container_name: opendj
    restart: unless-stopped
    hostname: ldap.docker.local
    stdin_open: true
    tty: true
    ports:
      - 1389:1389
      - 1636:1636
      - 4444:4444
    environment:
      - PORT=1389
      - LDAPS_PORT=1636
      - BASE_DN=dc=docker,dc=local
      - ROOT_USER_DN=cn=admin
      - ROOT_PASSWORD=LdapAdmin

  # ldap-admin:
  #   image: osixia/phpldapadmin:latest
  #   container_name: phpldapadmin
  #   restart: unless-stopped
  #   environment:
  #     - PHPLDAPADMIN_LDAP_HOSTS=ldap-server
  #     - PHPLDAPADMIN_HTTPS=false
  #   ports:
  #     - 1443:443
  #   depends_on:
  #     - ldap-server

  ldap-ui:
    image: dnknth/ldap-ui
    container_name: ldap-ui
    restart: unless-stopped
    ports:
      - 5000:5000
    environment:
      - LDAP_URL=ldap://ldap-server/
      - BASE_DN=dc=docker,dc=local
      - BIND_DN=cn=admin,dc=docker,dc=local
      - BIND_PASSWORD=LdapAdmin
    depends_on:
      - ldap-server

# sudo apt install ldap-utils
# ldapsearch -LLL -H ldap://localhost:1389 -D "cn=admin,dc=docker,dc=local" -w LdapAdmin -b "dc=docker,dc=local"
```

## Docker Stack

### TUI

- [ctop](https://github.com/bcicen/ctop) - интерфейс в стиле TOP для отображения метрик для всех контейнеров Docker.

`sudo curl -sSL https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-darwin-amd64 -o /usr/local/bin/ctop && sudo chmod +x /usr/local/bin/ctop`

`docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock:ro quay.io/vektorlab/ctop:latest`

- [dtop](https://github.com/amir20/dtop) - терминальный интерфейс для мониторинга контейнеров Docker в стиле [ctop](https://github.com/bcicen/ctop) от создателя [Dozzle](https://github.com/amir20/dozzle) написанный на Rust, позволяющая отслеживать состояние нескольких хостов в режиме реального времени.

`curl -sSLf --proto '=https' --tlsv1.2 https://github.com/amir20/dtop/releases/latest/download/dtop-installer.sh | sh`

`docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/amir20/dtop:latest`

- [dockly](https://github.com/lirantal/dockly) - терминальный интерфейс для управления контейнерами Docker, сервисами Compose и образами, написанный на JavaScript и библиотеки [Blessed](https://github.com/chjj/blessed).

`npm install -g dockly`

`docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock lirantal/dockly:latest`

- [oxker](https://github.com/mrjackwills/oxker) - простой TUI для просмотра и управления контейнерами Docker, написанный на Rust и библиотеки [RataTUI](https://github.com/ratatui/ratatui) и [Bollard](https://github.com/fussybeaver/bollard) (библиотека для Docker API на Rust).

`curl https://raw.githubusercontent.com/mrjackwills/oxker/main/install.sh | bash`

`docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock:ro mrjackwills/oxker:latest`

- [dry](https://github.com/moncho/dry) - терминальный интерфейс для управления Docker и [Swarm](https://github.com/docker-archive/classicswarm), написанный на Go и библиотеки [TermUI](https://github.com/gizak/termui).

`docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -e DOCKER_HOST=$DOCKER_HOST moncho/dry:latest`

- [sen](https://github.com/TomasTomecek/sen) - терминальный пользовательский интерфейс для контейнеров Docker и [Podman](https://github.com/containers/podman), написанный на Python.

`docker run --rm -it -v /var/run/docker.sock:/run/docker.sock -e TERM tomastomecek/sen:latest`

- [gmd](https://github.com/ajayd-san/gomanagedocker) (goManageDocker) - TUI для управления объектами Docker или Podman, написанный на Go и библиотеки [BubbleTea](https://github.com/charmbracelet/bubbletea).

`docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock kakshipth/gomanagedocker:latest`

`systemctl --user start podman.socket && docker run --rm -it -v /run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock kakshipth/gomanagedocker:latest p`

- [ducker](https://github.com/robertpsoane/ducker) - управления контейнерами Docker через TUI.

`cargo install --locked ducker`

- [dockrtui](https://github.com/LuuNa-JD/dockrtui) - быстрая и современная терминальная панель для Docker, написанная на Rust и [RataTUI](https://github.com/ratatui/ratatui).

`cargo install dockrtui`

### LazyDocker

- [LazyDocker](https://github.com/jesseduffield/lazydocker) - терминальный интерфейс для управления контейнерами Docker и Podman, а также сервисами Compose, написанный на Go и библиотеки [GoCUI](https://github.com/jroimartin/gocui).

```yaml
services:
  lazydocker:
    image: lazyteam/lazydocker:latest
    container_name: lazydocker
    tty: true
    stdin_open: true
    volumes:
      - ~/.config/lazydocker/config.yml:/.config/jesseduffield/lazydocker/config.yml:ro
      - /var/run/docker.sock:/var/run/docker.sock
```

`docker compose up -d && docker attach lazydocker`

`curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash`

Конфигурация для управления Docker Compose:

```yaml
customCommands:
  services:
  - name: Compose edit
    command: sh -c "micro ${COMPOSE_FILE:-docker-compose.yml}"
    attach: true
  - name: Up stack
    command: "{{ .DockerCompose }} up -d"
    attach: false
  - name: Down stack
    command: "{{ .DockerCompose }} down"
    attach: false
  - name: Recreate stack
    command: "{{ .DockerCompose }} up -d --force-recreate"
    attach: false
  - name: Restart container
    command: "{{ .DockerCompose }} restart {{ .Service.Name }}"
    attach: false
  - name: Stop container
    command: "{{ .DockerCompose }} stop {{ .Service.Name }}"
    attach: false
  - name: Logs fuzzy
    command: sh -c "docker logs {{ .Service.Name }} --follow --timestamps 2>&1 | tspin | fzf --no-sort --ansi --reverse --bind 'result:last'"
    attach: true
  - name: Logs exact
    command: sh -c "docker logs {{ .Service.Name }} --follow --timestamps 2>&1 | tspin | fzf --no-sort --ansi --reverse --bind 'result:last' --exact"
    attach: true
  - name: Sh
    command: "{{ .DockerCompose }} exec {{ .Service.Name }} sh"
    attach: true
  - name: Bash
    command: "{{ .DockerCompose }} exec {{ .Service.Name }} bash"
    attach: true
```

### Docker Web Manager

[Docker Web Manager](https://hub.docker.com/r/lifailon/docker-web-manager) - менеджер управления контекстами Docker (context manager) на базе [fzf](https://github.com/junegunn/fzf) и веб-интерфейс для [LazyDocker](https://github.com/jesseduffield/lazydocker) и [ctop](https://github.com/bcicen/ctop) на базе [ttyd](https://github.com/tsl0922/ttyd) с поддержкой авторизации.

> [!NOTE]
> Используется образ [lifailon/docker-web-manager](https://hub.docker.com/r/lifailon/docker-web-manager), собранный в репозитории [ruDocs](https://github.com/Lifailon/rudocs) для публичного использования.

```yaml
services:
  docker-web-manager:
    image: lifailon/docker-web-manager:latest
    container_name: docker-web-manager
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - $HOME/.ssh/id_rsa:/root/.ssh/id_rsa
    environment:
      - WEB_USERNAME=admin
      - WEB_PASSWORD=admin
      - SSH_HOSTS=localhost,192.168.3.105,192.168.3.106
      - SSH_USER=lifailon
      - SSH_PORT=2121
      - DOCKER_CLIENT=lazydocker
    ports:
      - 3333:3333
```

### isaiah

[isaiah](https://github.com/will-moss/isaiah) - самостоятельный клон [LazyDocker](https://github.com/jesseduffield/lazydocker) для веб-браузера (JavaScript fontend).

```yaml
services:
  isaiah:
    image: mosswill/isaiah:latest
    container_name: isaiah
    restart: unless-stopped
    ports:
      - "4444:80"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      # - ./isaiah_hosts_list:/docker_hosts
      # local unix:///var/run/docker.sock
      # agent tcp://192.168.3.106:4382
    environment:
      SERVER_PORT: "80"
      AUTHENTICATION_SECRET: "secret"
      MULTI_HOST_ENABLED: "TRUE"

  isaiah-agent:
    image: mosswill/isaiah:latest
    container_name: isaiah-agent
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      SERVER_ROLE: "Agent"
      AUTHENTICATION_SECRET: "secret"
      MASTER_HOST: "192.168.3.105:4444"
      MASTER_SECRET: "secret"
      AGENT_NAME: "rpi-106"
```

### Dockge

[Dockge](https://github.com/louislam/dockge) - веб-интерфейс для управления стеками Docker Compose от создателя [Uptime-Kuma](https://github.com/louislam/uptime-kuma).

```yaml
services:
  # Web interface for Docker Compose
  dockge:
    image: louislam/dockge:1
    container_name: dockge
    restart: always
    volumes:
      - ./dockge_data:/app/data
      - /var/run/docker.sock:/var/run/docker.sock
      # Docker stacks directory on host:container
      - /home/lifailon/docker:/home/lifailon/docker
    # Enable routing for traffic
    # labels:
    #   - traefik.enable=true
    environment:
      # Enable routing for docker-gen
      # - VIRTUAL_HOST=dockge.local
      - DOCKGE_STACKS_DIR=/home/lifailon/docker
      # Доступ к консоли dockge
      - DOCKGE_ENABLE_CONSOLE=true
    ports:
      - 5001:5001
```

### Komodo

[Komodo](https://github.com/moghtech/komodo) - система для управления и мониторинга контейнеров Docker и стеков Compose.

🔗 [Komodo Demo](https://demo.komo.do) ↗

```yaml
services:
  mongo:
    image: mongo
    container_name: komodo-db
    restart: unless-stopped
    command: --quiet --wiredTigerCacheSizeGB 0.25
    labels:
      komodo.skip: StopAllContainers
    # ports:
    #   - 27017:27017
    volumes:
      - ./mongo_data:/data/db
      - ./mongo_config:/data/configdb
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${KOMODO_DB_USERNAME}
      MONGO_INITDB_ROOT_PASSWORD: ${KOMODO_DB_PASSWORD}
  
  core:
    image: ghcr.io/moghtech/komodo-core:latest
    container_name: komodo-core
    restart: unless-stopped
    labels:
      komodo.skip: StopAllContainers
    ports:
      - 9120:9120
    env_file: .env
    environment:
      KOMODO_DATABASE_ADDRESS: mongo:27017
      KOMODO_DATABASE_USERNAME: ${KOMODO_DB_USERNAME}
      KOMODO_DATABASE_PASSWORD: ${KOMODO_DB_PASSWORD}
    volumes:
      - ./backups:/backups
      ## Store sync files on server
      # - /path/to/syncs:/syncs
      ## Optionally mount a custom core.config.toml
      # - /path/to/core.config.toml:/config/config.toml
    depends_on:
      - mongo

  ## Deploy Periphery container using this block,
  ## or deploy the Periphery binary with systemd using 
  ## https://github.com/moghtech/komodo/tree/main/scripts
  periphery:
    image: ghcr.io/moghtech/komodo-periphery:latest
    container_name: komodo-periphery
    restart: unless-stopped
    labels:
      komodo.skip: StopAllContainers
    env_file: .env
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /proc:/proc
      - /home/lifailon/docker:/etc/komodo/stacks
```

env:

```ini
KOMODO_DB_USERNAME=admin
KOMODO_DB_PASSWORD=admin

TZ=Etc/UTC+3

# Используется для Oauth / предложения URL-адреса Webhook / обратного прокси-сервера Caddy
KOMODO_HOST=https://demo.komo.do
# Отображается во вкладке браузера
KOMODO_TITLE=Komodo
KOMODO_FIRST_SERVER=https://periphery:8120
# Дайте первому серверу индивидуальное имя
KOMODO_FIRST_SERVER_NAME=Local
# Сделать так, чтобы все кнопки вызывали только двойной щелчок, а не полное диалоговое окно подтверждения
KOMODO_DISABLE_CONFIRM_DIALOG=false

# Оценить, как Komodo опрашивает ваши серверы на предмет статуса / статуса контейнера / системной статистики / оповещений
# Параметры: 1-sec, 5-sec, 15-sec, 1-min, 5-min, 15-min (default: 15-sec)
KOMODO_MONITORING_INTERVAL="15-sec"
# Интервал опроса ресурсов на предмет обновлений / автоматизированных действий
# Параметры: 15-min, 1-hr, 2-hr, 6-hr, 12-hr, 1-day (default: 1-hr)
KOMODO_RESOURCE_POLL_INTERVAL="1-hr"

# Used to auth incoming webhooks. Alt: KOMODO_WEBHOOK_SECRET_FILE
KOMODO_WEBHOOK_SECRET=a_random_secret
# Used to generate jwt. Alt: KOMODO_JWT_SECRET_FILE
KOMODO_JWT_SECRET=a_random_jwt_secret
# Time to live for jwt tokens (options: 1-hr, 12-hr, 1-day, 3-day, 1-wk, 2-wk)
KOMODO_JWT_TTL="1-day"

# Включить вход с именем пользователя и паролем
KOMODO_LOCAL_AUTH=true
KOMODO_INIT_ADMIN_USERNAME=admin
KOMODO_INIT_ADMIN_PASSWORD=admin
# Отключить регистрацию новых пользователей
KOMODO_DISABLE_USER_REGISTRATION=false
# Все новые логины включаются автоматически
KOMODO_ENABLE_NEW_USERS=false
# Запретить НЕ администраторам создавать новые ресурсы
KOMODO_DISABLE_NON_ADMIN_CREATE=false
# Позволяет всем пользователям иметь доступ на чтение ко всем ресурсам
KOMODO_TRANSPARENT_MODE=false

# Более красивое ведение журнала с пустыми строками между журналами
KOMODO_LOGGING_PRETTY=false
# Более удобное для восприятия человеком протоколирование конфигурации запуска (многострочное)
KOMODO_PRETTY_STARTUP_CONFIG=false

KOMODO_OIDC_ENABLED=false
KOMODO_GITHUB_OAUTH_ENABLED=false
KOMODO_GOOGLE_OAUTH_ENABLED=false
KOMODO_AWS_ACCESS_KEY_ID=
KOMODO_AWS_SECRET_ACCESS_KEY=

PERIPHERY_ROOT_DIRECTORY=/etc/komodo
# Путь к корневой директории стеков compose (default: ${PERIPHERY_ROOT_DIRECTORY}/stacks)
PERIPHERY_STACK_DIR=/etc/komodo/stacks
KOMODO_PASSKEY=a_random_passkey
PERIPHERY_PASSKEYS=${KOMODO_PASSKEY}
PERIPHERY_SSL_ENABLED=true
PERIPHERY_DISABLE_TERMINALS=false
PERIPHERY_INCLUDE_DISK_MOUNTS=/etc/hostname
PERIPHERY_LOGGING_PRETTY=false
PERIPHERY_PRETTY_STARTUP_CONFIG=false
```

### 1panel

[1panel](https://github.com/1Panel-dev/1Panel) - веб-интерфейс для управления сервером на базе Linux, файлами, базами данных, контейнерами Docker и стеками Docker Compose.

```yaml
services:
  1panel:
    image: moelin/1panel:latest
    container_name: 1panel
    restart: always
    ports:
      - 10086:10086 # http://1panel.docker.local/entrance 1panel:1panel_password
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
      # Docker Compose root directroy
      # - $HOME:/etc/docker
      - $HOME:/opt/1panel/docker/compose
      - /opt:/opt
      # - /root:/root
    labels:
      createdBy: Apps
```

### Dockhand

[Dockhand](https://github.com/Finsys/dockhand) - интерфейс для управления контейнерами Docker и оркестровку стеков Compose.

```yaml
services:
  dockhand:
    image: fnsys/dockhand:latest
    container_name: dockhand
    restart: always
    ports:
      - 3000:3000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./dockhand_data:/app/data
      # Docker Compose root directroy
      - /home/lifailon/docker:/docker
```

### DockMan

[DockMan](https://github.com/RA341/dockman) - веб-интерфейс для управления контейнерами и файлами в стеках Docker Compose (like Dockge, но без форматирования).

```yaml
services:
  dockman:
    container_name: dockman
    image: ghcr.io/ra341/dockman:latest
    restart: always
    environment:
      - DOCKMAN_MACHINE_ADDR=192.168.3.101
      - DOCKMAN_PORT=8866
      - DOCKMAN_COMPOSE_ROOT=/home/lifailon/docker
      - DOCKMAN_AUTH_ENABLE=true
      - DOCKMAN_AUTH_USERNAME=admin
      - DOCKMAN_AUTH_PASSWORD=admin
      - DOCKMAN_LOG_LEVEL=debug
      - DOCKMAN_LOG_VERBOSE=true
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      # Stack directory
      - /home/lifailon/docker:/home/lifailon/docker
      - ./dockman_config:/config
    ports:
      - 8866:8866
```

### VPS Monitor

[VPS Monitor](https://github.com/hhftechnology/vps-monitor) - инструмент управления контейнерами Docker и сервисами Compose, с поддержкой анализа логов, мониторинга статистики контейнеров, управления образами, визуализации сети и поддержки нескольких удаленных хостов.

```yaml
services:
  vps-monitor:
    image: hhftechnology/vps-monitor:latest
    container_name: vps-monitor
    restart: always
    ports:
      - 6789:6789
    environment:
      - JWT_SECRET=your-super-secret-key-change-this-to-something-random-min-32-chars
      - ADMIN_USERNAME=admin
      - ADMIN_PASSWORD=admin
      - ADMIN_PASSWORD_SALT=admin
      - DOCKER_HOST=unix:///var/run/docker.sock
      # - DOCKER_HOSTS=local|unix:///var/run/docker.sock,remote|ssh://root@10.0.0.1
      - READONLY_MODE=false
    volumes:
      - ./vps_monitor_data:/data
      - /var/run/docker.sock:/var/run/docker.sock
      # - /root/.ssh:/root/.ssh:ro
      - /proc:/host/proc:ro
```

### Arcan

[Arcane](https://github.com/getarcaneapp/arcane) - интерфейс WebUI для управления контейнерами Docker, образами, сетями и томами. Для установки можно использовать [генератор compose](https://getarcane.app/generator) для настройки подключения БД PostgreSQL и OIDC Authentication.

```yaml
# Username: arcane
# Password: arcane-admin

services:
  arcane:
    image: ghcr.io/getarcaneapp/arcane:latest
    container_name: arcane
    restart: unless-stopped
    ports:
      - 3552:3552
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./arcane_data:/app/data
    environment:
      - APP_URL=http://localhost:3552
      - PUID=1000
      - PGID=1000
      - ENCRYPTION_KEY=37b916203568c0dfe4580bf6f562b81ff95e7c8235a63812b535970ec8c2e9f3
      - JWT_SECRET=b39de98d51a4e53a5a83731b6c10aea4772419cbf869a74152f997a6de23ba5c
      - LOG_LEVEL=info
      - LOG_JSON=false
      - OIDC_ENABLED=false
  #     - POSTGRES_DB=arcane
  #     - POSTGRES_USER=arcane
  #     - POSTGRES_PASSWORD=arcane
  #     - DATABASE_URL=postgresql://arcane:arcane@arcane-postgres:5432/arcane
  #   depends_on:
  #     - postgres

  # arcane-postgres:
  #   image: postgres:17-alpine
  #   container_name: arcane-postgres
  #   restart: unless-stopped
  #   environment:
  #     - POSTGRES_DB=arcane
  #     - POSTGRES_USER=arcane
  #     - POSTGRES_PASSWORD=arcane
  #   volumes:
  #     - ./postgres_data:/var/lib/postgresql/data
  #   ports:
  #     - 5432:5432
```

### DweebUI

[DweebUI](https://github.com/lllllllillllllillll/DweebUI) - веб-интерфейс для мониторинга ресурсов и управления контейнерамм, образами, томами и сетями, а также имеет встроенный магазин приложений (не работают логи и нет доступа к терминалу).

```yaml
services:
  dweebui:
    image: lllllllillllllillll/dweebui:latest
    container_name: dweebui
    restart: always
    environment:
      - PORT=8000
      - SECRET=AdminSecret # for registration
    volumes:
      - ./dweebui_data:/app/config
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - 8000:8000
```

### Dockpeek

[Dockpeek](https://github.com/dockpeek/dockpeek) — это веб-интерфейс для отображения статистики и обновления образов контейнеров Docker.

```yaml
services:
  dockpeek:
    image: ghcr.io/dockpeek/dockpeek:latest
    container_name: dockpeek
    restart: always
    environment:
      - SECRET_KEY=AdminSecret
      - USERNAME=admin
      - PASSWORD=admin
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - 3420:8000
```

### Watchtower

[Watchtower](https://github.com/containrrr/watchtower) - система для обнаружения новых образов в реестре Docker, а также их автоматического обновления и перезапуска контейнера с отправкой уведомлений.

```yaml
services:
  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    restart: always
    command: --interval 600 --http-api-metrics --http-api-update
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_NOTIFICATIONS=shoutrrr
      - WATCHTOWER_NOTIFICATIONS_HOSTNAME=<HOST_NAME>
      - WATCHTOWER_NOTIFICATION_URL=telegram://<BOT_API_KEY>@telegram/?channels=<CHAT/CHANNEL_ID>
      - WATCHTOWER_HTTP_API_TOKEN=demotoken
    ports:
      - 8088:8080 # api
```

### Diun

[Diun](https://github.com/crazy-max/diun) (Docker Image Update Notifier) - система для получения уведомлений об обновлении образа Docker в реестре Docker.

```yaml
services:
  diun:
    image: crazymax/diun:latest
    container_name: diun
    restart: always
    command: serve
    volumes:
      - ./diun_data:/data
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - TZ=Etc/GMT+3
      - LOG_LEVEL=info
      - LOG_JSON=false
      - DIUN_WATCH_SCHEDULE=0 */6 * * *
      - DIUN_PROVIDERS_DOCKER=true
      - DIUN_PROVIDERS_DOCKER_WATCHBYDEFAULT=true
      - DIUN_NOTIF_TELEGRAM_CHATIDS=<CHAT/CHANNEL_ID>
      - DIUN_NOTIF_TELEGRAM_TOKEN=<BOT_API_KEY>
      # https://crazymax.dev/diun/faq/?h=entry#notification-template
      - DIUN_NOTIF_TELEGRAM_TEMPLATEBODY=Image {{ .Entry.Image }} in `{{ .Entry.Status }}` status
      - HTTPS_PROXY=http://192.168.3.105:20171
      - NO_PROXY=localhost,127.0.0.1,192.168.3.0/24
    labels:
      - diun.enable=true
    healthcheck:
      test: diun notif test
      interval: 24h
      timeout: 10s
      retries: 3
      start_period: 10s
```

### WUD

[WUD](https://github.com/getwud/wud) (What's up Docker) - веб-интерфейс для поиска обновлений и автоматизации выполнения действий (триггеры для отправки оповещений в Telegram, Discord, Slack, [Rocket.Chat](https://getwud.github.io/wud/#/configuration/triggers/rocketchat/) или [Gotify](https://getwud.github.io/wud/#/configuration/triggers/gotify), автоматическая загрузка и пересоздание контейнеров на новом образе, обновление образа в файлах [docker-compose](https://getwud.github.io/wud/#/configuration/triggers/docker-compose) и другие).

```yaml
services:
  wud:
    image: getwud/wud
    container_name: wud
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - 5002:3000
    environment:
      # Включить доступ к управлению локальным docker socket
      - WUD_TRIGGER_DOCKER_LOCAL_ENABLED=true
      # Автоматически загружать образы
      - WUD_TRIGGER_DOCKER_LOCAL_MODE=pull
      # Автоматически перезапускать контейнеры на новом образе
      # - WUD_TRIGGER_DOCKER_LOCAL_MODE=recreate
      # Настройка триггера для отправки уведомлений в Telegram
      - WUD_TRIGGER_TELEGRAM_1_CHATID=<CHAT/CHANNEL_ID>
      - WUD_TRIGGER_TELEGRAM_1_BOTTOKEN=<BOT_API_KEY>
      # Прокси для доступа к Telegram API
      - HTTPS_PROXY=http://192.168.3.105:20171
      - NO_PROXY=localhost,127.0.0.1,192.168.3.0/24
      # Интеграция с Gotify для отправки уведомлений
      - WUD_TRIGGER_GOTIFY_LOCAL_URL=http://gotify:80
      - WUD_TRIGGER_GOTIFY_LOCAL_TOKEN=<API_KEY>
    labels:
      - wud.watch=true
```

### Dozzle

[Dozzle](https://github.com/amir20/dozzle) - веб интерфейс для просмотра, анализа и фильтрации (по stream, level, а также поиск с помощью regex и sql-запросов) логов контейнеров Docker или Kubernetes. Поддерживает подключение удаленных хостов с помощью агентов или сокета Docker (например, через прокси в ограниченном режиме доступа) и файловым журналам хостовой системы с помощью кастомного контейнера, а также управление контейнерами (запуск, остановка и доступ к терминалу).

```yaml
services:
  dozzle:
    image: amir20/dozzle:latest
    container_name: dozzle
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./dozzle_data:/data
    environment:
      # Отключить сбор и отправку аналитики
      - DOZZLE_NO_ANALYTICS=true
      # Включить действия (start/stop/restart)
      - DOZZLE_ENABLE_ACTIONS=true
      # Включить доступ к терминалу работающих контейнеров
      - DOZZLE_ENABLE_SHELL=true
      # Включить базовую авторизацию из файла /data/users.yml
      - DOZZLE_AUTH_PROVIDER=simple
      # Подключиться к удаленному хосту через Docker Socket API
      # - DOZZLE_REMOTE_HOST=tcp://192.168.3.105:2375|rpi-105,tcp://192.168.3.106:2375|rpi-106
      # Подключиться к удаленному хосту через Dozzle Agent
      # - DOZZLE_REMOTE_AGENT=192.168.3.105:7007,192.168.3.106:7007
    ports:
      - 9999:8080

  # dozzle-agent:
  #   image: amir20/dozzle:latest
  #   container_name: dozzle-agent
  #   restart: always
  #   command: agent
  #   volumes:
  #     - /var/run/docker.sock:/var/run/docker.sock:ro
  #   # environment:
  #   #   - DOZZLE_HOSTNAME=hv-us-101
  #   ports:
  #     - 7007:7007

  # dozzle-journald:
  #   image: debian:bookworm-slim
  #   container_name: dozzle-journald
  #   restart: always
  #   volumes:
  #     - /run/dbus/system_bus_socket:/run/dbus/system_bus_socket:ro
  #     - /run/systemd/system:/run/systemd/system:ro
  #     - /run/systemd/journal/socket:/run/systemd/journal/socket:ro
  #     - /etc/machine-id:/etc/machine-id:ro
  #   command: 
  #     - sh
  #     - -c
  #     - |
  #       apt-get update && \
  #         DEBIAN_FRONTEND=noninteractive \
  #         apt-get install -y --no-install-recommends systemd \
  #       journalctl --no-pager --follow

  # Container for monitoring syslog file on host
  # dozzle-syslog:
  #   image: alpine
  #   container_name: dozzle-syslog
  #   restart: always
  #   volumes:
  #     - /var/log/syslog:/var/log/custom.log
  #   command:
  #     - tail
  #     - -f
  #     - /var/log/custom.log

  # Container for monitoring files from /var/log on host
  dozzle-varlog:
    image: lifailon/dozzle-varlog:latest
    container_name: dozzle-varlog
    restart: always
    volumes:
      - /var/log:/logs
```

### Beszel

[Beszel](https://github.com/henrygd/beszel) - клиент-серверная система мониторинга не требующая настройки для контейнеров Docker и хостов, на которых они запущены. Использует [PocketBase](https://github.com/pocketbase/pocketbase) для backend, а также поддерживает оповещения в Telegram с помощью Webhook через [Shoutrrr](https://github.com/containrrr/shoutrrr).

```yaml
services:
  # Web interface for monitoring hosts and containers metrics + webhook via shoutrrr
  beszel-server:
    image: henrygd/beszel:latest
    container_name: beszel-server
    restart: always
    extra_hosts:
      - host.docker.internal:host-gateway
    environment:
      - HTTPS_PROXY=http://192.168.3.105:20171
    volumes:
      - ./beszel_server_data:/beszel_data
    ports:
      - 8090:8090

  # Agent for monitoring
  beszel-agent:
    image: henrygd/beszel-agent:latest
    container_name: beszel-agent
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./beszel_agent_data:/var/lib/beszel-agent
      # - /mnt/disk/.beszel:/extra-filesystems/sda1:ro
    environment:
      - KEY=Копируем публичный ключ из интерфейса и перезапускаем docker compose
      - HUB_URL=http://beszel-server:8090
      - LISTEN=45876
    # ports:
    #   - 45876:45876
```

### DockMon

[DockMon](https://github.com/darthnorse/dockmon) - платформа для мониторинга и управления Docker-контейнерами, которая поддерживает многохостный мониторинг и предлагает настраиваемый дашборд с WebSocket-обновлениями. Ключевые возможности включают статистику CPU, памяти, сети, просмотр логов, полный журнал событий, систему авто-рестарта и оповещения через различные платформы. 

```yaml
services:
  dockmon:
    image: darthnorse/dockmon:latest
    container_name: dockmon
    restart: always
    ports:
      - 8008:443
    environment:
      - TZ=Etc/GMT+3
    volumes:
      - ./dockmon_data:/app/data
      - /var/run/docker.sock:/var/run/docker.sock
    healthcheck:
      test: ["CMD", "curl", "-k", "-f", "https://localhost:443/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### Docker Socket Proxy

Docker Socket Proxy - прокси сервер для локального сокета Docker на основе HAProxy (не требуется внесение изменений в системные файлы демона или службы), который поддерживает ограничение доступа к конечным точкам с использованием переменных окружения, отображение статистики соединений и метрики Prometheus.

> [!NOTE]
> Используется образ [lifailon/docker-socket-proxy](https://hub.docker.com/r/lifailon/docker-socket-proxy), собранный для платформ `amd64` и `arm64` в репозитории [ruDocs](https://github.com/Lifailon/rudocs).

```yaml
services:
  docker-socket-proxy:
    image: lifailon/docker-socket-proxy:amd64
    # image: lifailon/docker-socket-proxy:arm64
    container_name: docker-socket-proxy
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - 2375:2375 # Docker API
      - 2376:2376 # HAProxy stats and Prometheus metrics
    environment:
      - SOCKET_PATH=/var/run/docker.sock
      - LOG_LEVEL=info
      - INFO=1
      - PING=1
      - VERSION=1
      - POST=1
      - GRPC=1
      - EXEC=1
      - ALLOW_RESTARTS=1
      - ALLOW_START=1
      - ALLOW_STOP=1
      - AUTH=1
      - CONTAINERS=1
      - IMAGES=1
      - NETWORKS=1
      - BUILD=1
      - COMMIT=1
      - DISTRIBUTION=1
      - EVENTS=1
      - PLUGINS=1
      - VOLUMES=1
      - SESSION=1
      # Swarm
      - SWARM=0             
      - NODES=0             
      - CONFIGS=0           
      - SECRETS=0           
      - SERVICES=0          
      - SYSTEM=0            
      - TASKS=0             
      # HAProxy stats and Prometheus metrics
      - STATS_USER=admin
      - STATS_PASS=admin
      - STATS_URI=/
      - METRICS_URI=/metrics
```

### Docker Registry

```yaml
# sudo apt install apache2-utils -y && htpasswd -Bbn admin admin > ./creds
# mkdir certs && \
# openssl req -x509 -new -nodes -days 365 \
#   -out ./certs/public.pem \
#   -keyout ./certs/private.key \
#   -subj "/C=RU/ST=MSK/L=MSK/O=Registry/OU=Registry/CN=registry.docker.local"

services:
  docker-registry:
    image: registry:latest
    container_name: docker-registry
    ports:
      - 5000:5000
    restart: unless-stopped
    volumes:
      - ./regrepo:/var/lib/registry
      - ./certs:/certs
      - ./creds:/creds
    environment:
      - REGISTRY_HTTP_TLS_CERTIFICATE=/certs/public.pem
      - REGISTRY_HTTP_TLS_KEY=/certs/private.key
      - REGISTRY_AUTH=htpasswd
      - REGISTRY_AUTH_HTPASSWD_REALM=docker-registry
      - REGISTRY_AUTH_HTPASSWD_PATH=/creds
```

### Nexus

[Nexus](https://github.com/sonatype/nexus-public) - единый репозиторий для хранения Docker образов (Docker Registry), двоичных файлов, пакетов (например, npm или nuget) и других артефактов.

```yaml
# mkdir nexus-data && chown -R 200:200 ./nexus-data && chmod -R u+rw ./nexus-data
# sudo cat nexus-data/admin.password

services:
  nexus:
    image: sonatype/nexus3:latest
    container_name: nexus
    restart: unless-stopped
    ports:
      - "8881:8081"
      - "8882:8082" # Settings => Repositories => Create repository => docker-hosted => HTTP
    volumes:
      - ./nexus_data:/nexus-data
    environment:
      - INSTALL4J_ADD_VM_PARAMS=-Xms1g -Xmx2g -XX:MaxDirectMemorySize=2g
```

### Nora

[Nora](https://github.com/getnora-io/nora) - легковесный реестр артефактов, поддерживающий `Docker`, `Maven`, `npm`, `PyPI`, `Cargo`, `Go`, `RubyGems`, `Terraform`, `NuGet` и другие. Один исполняемый файл и никаких зависимостей.

```yaml
services:
  nora:
    image: ghcr.io/getnora-io/nora:latest
    container_name: nora
    restart: unless-stopped
    ports:
      - 4000:4000
    environment:
      - RUST_LOG=info
      - NORA_HOST=0.0.0.0
      - NORA_AUTH_ENABLED=false
    volumes:
      - ./nora_data:/data
```

### Hadolint

[Hadolint](https://hadolint.github.io/hadolint/) - интеллектуальный линтер для анализа `Dockerfile` на на основе [best practices](https://docs.docker.com/build/building/best-practices). Он преобразует файл в абстрактное синтаксическое дерево `AST` и применяет правила на основе этого дерева, а также использует инструмент [Shellcheck](https://github.com/koalaman/shellcheck) для проверки кода Bash внутри `RUN` инструкций.

🔗 [Hadolint Playground](https://composetokube.com) ↗

🔗 [Shell Check Playground](https://www.shellcheck.net) ↗

`docker run --rm -i hadolint/hadolint:latest < Dockerfil`

Запуск веб-версии для оффлайн использования:

```bash
mkdir hadolint
git clone https://github.com/hadolint/hadolint hadolint-web
cd hadolint-web
git fetch origin
git checkout gh-pages
cd ..
```

Запускаем сервис в `docker-compose.yml`:

```yaml
services:
  hadolint-web:
    image: nginx:alpine
    container_name: hadolint-web
    restart: always
    volumes:
      - ./hadolint-web:/usr/share/nginx/html:ro
    ports:
      - 8040:80
```

### Dockadvisor

[Dockadvisor](https://github.com/deckrun/dockadvisor) - веб-интерфейс статического анализа `Dockerfile` на линтеры, для выявленияя распространенных проблемы.

🔗 [Dockadvisor Playground](https://github.com/zxh326/kite) ↗

```yaml
services:
  dockadvisor:
    image: deckrun/dockadvisor:latest
    container_name: dockadvisor
    restart: always
    ports:
      - 3030:80
```

### ShellCheck

[ShellCheck](https://github.com/koalaman/shellcheck) - инструмент статического анализа скриптов командной оболочки `sh` и `Bash`.

https://www.shellcheck.net

## Kubernetes Stack

### k3s

[k3s](https://github.com/k3s-io/k3s) - легковесный Kubernetes от Rancher/SUSE. Позволяет установить кластер в контейнере Docker или одной командой с помощью скрипта, занимает в два раза меньше памяти, и все это в двоичном файле размером менее 100 МБ.

```yaml
services:
  k3s-control-plane:
    image: rancher/k3s:latest
    container_name: k3s-control-plane
    hostname: k3s-control-plane
    restart: always
    command: server --node-ip=172.31.250.100 --node-external-ip=192.168.3.101 --tls-san=192.168.3.101 --disable servicelb
    privileged: true
    tmpfs:
      - /run
      - /var/run
    ulimits:
      nproc: 65535
      nofile:
        soft: 65535
        hard: 65535
    environment:
      - K3S_TOKEN=${K3S_TOKEN:?err}
      - K3S_KUBECONFIG_OUTPUT=/cfg/kubeconfig.yaml
      - K3S_KUBECONFIG_MODE=666
    # network_mode: host
    ports:
    # Kubernetes API Server
    - 6443:6443
    # Ingress controller
    - 6480:80
    - 6444:443
    # Node ports
    - 30000-30100:30000-30100
    volumes:
      - ./k3s_server_data:/var/lib/rancher/k3s
      # Get kubeconfig
      - .:/cfg
    networks:
      k3s_net:
        ipv4_address: 172.31.250.100

  k3s-worker-local:
    image: rancher/k3s:latest
    container_name: k3s-worker-local
    hostname: k3s-worker-local
    restart: always
    command: agent --node-ip=172.31.250.101
    privileged: true
    tmpfs:
      - /run
      - /var/run
    ulimits:
      nproc: 65535
      nofile:
        soft: 65535
        hard: 65535
    environment:
      - K3S_URL=https://k3s-control-plane:6443
      # - K3S_URL=https://192.168.3.101:6443
      - K3S_TOKEN=${K3S_TOKEN:?err}
    volumes:
      - ./k3s_agent_data:/var/lib/rancher/k3s
    networks:
      k3s_net:
        ipv4_address: 172.31.250.101

networks:
  k3s_net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.31.250.0/24
```

Подключение:

```bash
# Запуск стека
echo K3S_TOKEN=${RANDOM}${RANDOM}${RANDOM} > .env
docker-compose up -d
docker exec -it k3s-control-plane kubectl get nodes

# Экспортируем путь к конфигурации kubeconfig и копируем исполняемый файл kubectl в хостовую систему
echo 'export KUBECONFIG=/home/lifailon/docker/k3s-stack/kubeconfig.yaml' >> ~/.bashrc && source ~/.bashrc
sudo docker cp k3s-control-plane:/bin/k3s /bin/kubectl
kubectl get nodes

# Создаем SA с правами администратора кластера и выпускаем токен доступа
kubectl create serviceaccount devops -n kube-system
kubectl create clusterrolebinding devops-role --clusterrole=cluster-admin --serviceaccount=kube-system:devops
kubectl create token devops -n kube-system --duration=999999h
```

### Rancher

[Rancher](https://github.com/rancher/rancher) - инструмент для быстрого запуска и управления кластерами Kubernetes через Веб-интерфейс.

```yaml
services:
  rancher:
    image: rancher/rancher:latest
    container_name: rancher
    restart: unless-stopped
    privileged: true
    volumes:
    - ./rancher_data:/var/lib/rancher
    ports:
    - 3080:80
    - 3443:443
```

Получить пароль: `docker logs rancher 2>&1 | grep "Bootstrap Password:" | sed -E "s/.+\: //"`

### Kompose UI

[Kompose UI](https://github.com/HaddadJoe/komposeui) - веб-интерфейс для [kompose](https://github.com/kubernetes/kompose) (конвертирует docker-compose файлы в манифесты Kubernetes).

🔗 [Kompose UI Playground](https://composetokube.com) ↗

```yaml
services:
  kompose-ui:
    image: jadcham/komposeui
    container_name: kompose-ui
    restart: unless-stopped
    ports:
      - 3500:8000
```

Альтернативные решения:

[Compose Bridge Transformer](https://github.com/docker/compose-bridge-transformer) - официальный шаблон, который используется в команде `docker-compose bridge convert`

[Katenary](https://github.com/Katenary/katenary) - инструмент для преобразования файлов `docker-compose` в рабочий Helm Chart для Kubernetes, с помощью одной команды `katenary convert -c docker-compose.yml -o ./charts`.

### Web kubectl

[Web kubectl](https://github.com/1Panel-dev/webkubectl) - веб-интерфейс для `kubectl` и [k9s](https://github.com/derailed/k9s) на базе [gotty](https://github.com/yudai/gotty) от создателей [1panel](https://github.com/1Panel-dev/1Panel). Загружаете собственные конфигурации и переключаетесь между ними в интерфейсе.

```yaml
services:
  webkubectl:
    image: kubeoperator/webkubectl
    container_name: webkubectl
    restart: unless-stopped
    privileged: true
    ports:
      - 3501:8080
    environment:
      - SESSION_STORAGE_SIZE=10M
      - KUBECTL_INSECURE_SKIP_TLS_VERIFY=true
      - GOTTY_OPTIONS=--port 8080 --permit-write --permit-arguments
```

### KubePi

[KubePi](https://github.com/1Panel-dev/KubePi) — это современная панель управления Kubernetes (like [Kubernetes/Dashboard](https://github.com/kubernetes/dashboard)), а также Helm Charts (like [Helm Dashboard](https://github.com/komodorio/helm-dashboard)) от создателей [1panel](https://github.com/1Panel-dev/1Panel). Единый интерфейс предоставляет командный доступ управления кластерами, с поддержкой разграничения прав доступа, LDAP, SSO, а также логирует операции управления и авторизации.

```yaml
  kubepi:
    image: 1panel/kubepi
    container_name: kubepi
    restart: unless-stopped
    privileged: true
    ports:
      - 8181:80 # admin:kubepi
```

### Kubewall

[Kubewall](https://github.com/kubewall/kubewall) - панель управления Kubernetes, с возможностью управления несколькими кластерами (импорт конфигурации через веб-интерфейс) и интеграцией ИИ (OpenAI, Claude, Gemini, DeepSeek, OpenRouter, Ollama, Qwen, LM Studio).

```yaml
services:
  kubewall:
    image: ghcr.io/kubewall/kubewall:latest
    container_name: kubewall
    restart: unless-stopped
    volumes:
      - ./kubewall_data:/.kubewall
    ports:
      - 7080:7080
```

### Kite

[Kite](https://github.com/zxh326/kite) - легкая и современная панель управления Kubernetes, с поддержкой переключения между разными кластерами, указанными в `kubeconfig`.

🔗 [Kite Demo](https://github.com/zxh326/kite) ↗

```yaml
services:
  kite:
    image: ghcr.io/zxh326/kite:latest
    container_name: kite
    restart: unless-stopped
    volumes:
      - ~/.kube/config:/root/.kube/config:ro
    ports:
      - 6060:8080
```

### Headlamp

[Headlamp](https://github.com/kubernetes-sigs/headlamp) - интерфейс для управления и мониторинга кластеров Kubernetes (like [Kubernetes/Dashboard](https://github.com/kubernetes/dashboard)) от команды сообщества SIG (Special Interest Groups).

```yaml
services:
  headlamp:
    image: ghcr.io/headlamp-k8s/headlamp:v0.33.0
    container_name: headlamp
    restart: unless-stopped
    command: [
      "--kubeconfig", "/headlamp/.kube/config",
      "--port","64446",
      "--enable-dynamic-clusters"
    ]
    volumes:
      - ~/.kube/config:/headlamp/.kube/config:ro
    ports:
      - 64446:64446
```

### Helm Dashboard

[Helm Dashboard](https://github.com/komodorio/helm-dashboard) - веб-интерфейс для просмотра установленных Helm чартов, истории их изменений и соответствующих ресурсов Kubernetes.

```yaml
services:
  helm-dashboard:
    image: komodorio/helm-dashboard:latest
    container_name: helm-dashboard
    restart: unless-stopped
    volumes:
      - ~/.kube/config:/root/.kube/config:ro
    ports:
      - 3502:8080
```

### Kube Ops View

[Kube Ops View](https://codeberg.org/hjacobs/kube-ops-view) (Kubernetes Operational View) - read-only системная панель, которая позволяет удобно перемещаться между кластерами, отслеживать ноды и состояние подов (визуализирует ряд процессов, таких как создание и уничтожение подов).

```yaml
services:
  kube-ops-view:
    image: hjacobs/kube-ops-view:latest
    container_name: kube-ops-view
    restart: unless-stopped
    ports:
      - 3503:3503
    environment:
      - SERVER_PORT=3503
      - CLUSTERS=http://192.168.3.101:6443
      - KUBECONFIG_PATH=/root/.kube/config
    volumes:
      - ~/.kube/config:/root/.kube/config:ro
```

### Kubetail Dashboard

[Kubetail Dashboard](https://github.com/kubetail-org/kubetail) - веб-интерфейс и инструмент командной строки для отображения логов из разных подов в одном потоке (поддерживает фильтрацию по содержимому сообщений при установки в кластер).

🔗 [Kubetail Dashboard Demo](https://www.kubetail.com/demo) ↗

```yaml
services:
  kubetail-dashboard:
    image: kubetail/kubetail-cli # https://github.com/kubetail-org/kubetail/issues/770
    container_name: kubetail-dashboard
    restart: unless-stopped
    command: serve --host 0.0.0.0 --skip-open
    ports:
      - 7500:7500
    volumes:
      - ~/.kube/config:/root/.kube/config:ro
```

### Velero UI

[Velero UI](https://github.com/otwld/velero-ui) - веб-интерфейс для управления [Velero](https://github.com/vmware-tanzu/velero) и мониторинга резервного копирования ресурсов в кластерах Kubernetes.

```yaml
services:
  velero-ui:
    image: otwld/velero-ui:latest
    container_name: velero-ui
    restart: unless-stopped
    volumes:
      - ~/.kube/config:/app/.kube/config:ro
      # - /etc/rancher/k3s/k3s.yaml:/app/.kube/config:ro
    environment:
      - PORT=3504
      - KUBE_CONFIG_PATH=/app/.kube/config
    # network_mode: host # use for k3s cluster config on localhost
    ports:
      - 3504:3504 # admin:admin
```

### VUI

[VUI](https://github.com/seriohub/vui-ui) (Velero UI) - еще один интерфей для управления и мониторинга [Velero](https://github.com/vmware-tanzu/velero), который состоит из трех компонентов.

```yaml
services:
  api:
    image: dserio83/velero-api:0.2.7
    container_name: 
    restart: unless-stopped
    working_dir: /app
    environment:
      API_ENDPOINT_URL: "0.0.0.0"
      API_ENDPOINT_PORT: "8001"
      API_RATE_LIMITER_L1: "60:200"
      API_RATE_LIMITER_CUSTOM_1: "Security:xxx:60:20"
      AUTH_ENABLED: "true"
      DEFAULT_ADMIN_USERNAME: "admin"
      DEFAULT_ADMIN_PASSWORD: "admin"
      API_TOKEN_EXPIRATION_MIN: "180"
      API_TOKEN_REFRESH_EXPIRATION_DAYS: "7"
      K8S_IN_CLUSTER_MODE: "False"
      K8S_VELERO_NAMESPACE: "velero"
      KUBE_CONFIG_FILE: "/root/.kube/config"
      ORIGINS_1: "http://127.0.0.1:8003"
      ORIGINS_2: "http://localhost:8003"
      CLUSTER_ID: "local-develop-cluster"
      DOWNLOAD_INSPECT_FOLDER: "/tmp/velero-inspect-backups"
      RESTIC_PASSWORD: "static-passw0rd"
      WATCHDOG_URL: "vui-watchdog"
      WATCHDOG_PORT: "8002"
    volumes:
      - ~/.kube/config:/root/.kube/config
    ports:
      - 8001:8001

  vui-watchdog:
    image: dserio83/velero-watchdog:0.1.8
    container_name: 
    restart: unless-stopped
    working_dir: /app
    environment:
      API_ENDPOINT_URL: "0.0.0.0"
      API_ENDPOINT_PORT: "8002"
      K8S_IN_CLUSTER_MODE: "false"
      K8S_VELERO_NAMESPACE: "velero"
      PROCESS_LOAD_KUBE_CONFIG: "true"
      PROCESS_KUBE_CONFIG: "/root/.kube/config"
      CLUSTER_ID: "cluster-backend-name"
      PROCESS_CYCLE_SEC: "1800"
      APPRISE: ""
    volumes:
      - ~/.kube/config:/root/.kube/config
    ports:
      - 8002:8002
      
  ui:
    image: dserio83/velero-ui:0.2.7
    container_name: 
    restart: unless-stopped
    working_dir: /app
    depends_on:
      - api
    environment:
      NEXT_PUBLIC_REFRESH_DATATABLE_AFTER: "1500"
      NEXT_PUBLIC_REFRESH_RECENT: "5000"
      NEXT_PUBLIC_VELERO_API_NAME: "cluster-backend-name"
      NEXT_PUBLIC_VELERO_API_URL: "http://127.0.0.1:8001/api"
      NEXT_PUBLIC_VELERO_API_WS: "ws://127.0.0.1:8001"
      NEXT_PUBLIC_AUTH_ENABLED: "true"
      NEXT_PUBLIC_INSPECT_BACKUP_ENABLED: "true"
    ports:
      - 8003:3000
```

## Proxmox Stack

### Pulse

[Pulse](https://github.com/rcourtman/Pulse) - панель мониторинга инфраструктуры всех продуктов Proxmox (`PVE`, `PBS`, `PMG`), Docker и Kubernetes, которая объединяет метрики, оповещения и аналитические данные, полученные с помощью ИИ, из всех систем в единый интерфейс.

```yaml
services:
  pulse:
    image: rcourtman/pulse:latest
    container_name: pulse
    restart: unless-stopped
    ports:
      - 7655:7655
    volumes:
      - ./pulse_data:/data
```

Получить токен: `docker exec pulse cat /data/.bootstrap_token`

Подключение агентов: `curl -sSL http://192.168.3.101:7655/install.sh | bash -s -- --url "http://192.168.3.101:7655" --token "c276d05d260e7dbdb6840d0942de4413b91a6e8ede9515ed"`

### Proxmox Backup Server

[PBS (Proxmox Backup Server)](https://github.com/ayufan/pve-backup-server-dockerfiles) - неофициальная сборка Proxmox Backup Server для запуска в контейнере на разных платформах.

```yaml
services:
  proxmox-backup-server:
    image: ayufan/proxmox-ve:latest
    container_name: proxmox-backup-server
    restart: unless-stopped
    stop_signal: SIGHUP
    ports:
      - 8007:8007
    volumes:
      - ./pbs_etc:/etc/proxmox-backup
      - ./pbs_logs:/var/log/proxmox-backup
      - ./pbs_lib:/var/lib/proxmox-backup
    mem_limit: 2G
    tmpfs:
      - /run
    # smartctl support
    cap_add:
      - SYS_RAWIO
    devices:
      - /dev/sda
```

## CI/CD Stack

### Jenkins

[Jenkins](https://github.com/jenkinsci/jenkins) - CI/CD платформа на базе Java, которая использует свой декларативный синтаксис описания конвееров с поддержкой скриптового языка Groovy, гибкой параметрорезацией и большого числа плагинов.

🔗 [Jenkins Jack VSCode Extension](https://github.com/tabeyti/jenkins-jack) ↗

> [!NOTE]
> Используется неофициальный образ [lifailon/jenkins-agent](https://hub.docker.com/r/lifailon/jenkins-agent), собранный в репозитории [ruDocs](https://github.com/Lifailon/rudocs), в котором предустановленны некоторые DevOps утилиты.

```yaml
services:
  # volume-permissions-update:
  #   image: alpine
  #   container_name: volume-permissions-update
  #   restart: no
  #   user: 1000:1000
  #   volumes:
  #     - ./jenkins_home:/var/jenkins_home
  #     - ./jenkins_agent:/home/jenkins
  #   command: sh -c "chown -R 1000:1000 /var/jenkins_home /home/jenkins && echo 'Volume permissions updated successfully.'"

  jenkins-server:
    image: jenkins/jenkins:latest
    container_name: jenkins-server
    restart: always
    user: 1000:1000
    environment:
      # Отключаем Content Security Policy (CSP) для отображения CSS стилей в отчетах HTML Publisher
      - JAVA_OPTS=-Dhudson.model.DirectoryBrowserSupport.CSP=""
    volumes:
      - ./jenkins_home:/var/jenkins_home
    ports:
      - 8010:8080
      - 50000:50000
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8080/login || exit 1"]
      start_period: 30s
      interval: 10s
      timeout: 5s
      retries: 5
    # depends_on:
    #   volume-permissions-update:
    #     condition: service_completed_successfully

  jenkins-agent:
    # build:
    #   context: .
    #   dockerfile: Dockerfile
    image: lifailon/jenkins-agent:latest
    container_name: jenkins-agent
    restart: always
    user: 1000:1000
    environment:
      - JENKINS_URL=${JENKINS_SERVER_URL}
      - JENKINS_AGENT_NAME=${JENKINS_AGENT_NAME}
      - JENKINS_SECRET=${JENKINS_SECRET}
    volumes:
      - ./jenkins_agent:/home/jenkins
      # Пробрасываем сокет для доступа к Docker на агенте
      - /var/run/docker.sock:/var/run/docker.sock
    # Добавляем в группу Docker на хосте для доступа к сокету: getent group docker | cut -d: -f3
    group_add:
        - 110
    depends_on:
      jenkins-server:
        condition: service_healthy
```

### GitLab

```yaml
services:
  gitlab:
    image: gitlab/gitlab-ce:latest
    container_name: gitlab
    restart: unless-stopped
    hostname: gitlab.local
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://localhost'
        nginx['listen_port'] = 80
        nginx['listen_https'] = false
        gitlab_rails['gitlab_shell_ssh_port'] = 2222
    ports:
      - 8888:80 # Web
      - 2222:22 # SSH
    volumes:
      - ./gitlab/config:/etc/gitlab
      - ./gitlab/logs:/var/log/gitlab
      - ./gitlab/data:/var/opt/gitlab
    depends_on:
      - postgres
      - redis

  postgres:
    image: postgres:13
    container_name: gitlab_postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: gitlab
      POSTGRES_PASSWORD: gitlab
      POSTGRES_DB: gitlabhq_production
    volumes:
      - ./postgres/data:/var/lib/postgresql/data

  redis:
    image: redis:latest
    container_name: gitlab_redis
    restart: unless-stopped
    command: redis-server --appendonly yes
    volumes:
      - ./redis/data:/data

# Login: root
# Password:
# docker exec -it gitlab cat /etc/gitlab/initial_root_password | grep -E ^Pass | sed "s/Password:\s//g"
```

### Gitea

[Gitea](https://github.com/go-gitea/gitea) - легковесный локальный аналог GitLab/GitHub (самостоятельный хостинг Git), API (с поддержкой Swagger Docs) и системой CI/CD на базе GitHub Actions (поддерживает обратную совместимость) с использованием [act](https://github.com/nektos/act).

🔗 [Git Gitea](https://gitea.com/explore/repos) ↗

🔗 [Actions VSCode Extension](https://github.com/github/vscode-github-actions) ↗

```yaml
services:
  gitea:
    image: gitea/gitea:latest
    container_name: gitea
    restart: unless-stopped
    environment:
      - USER=git
      - USER_UID=1000
      - USER_GID=1000
      - GITEA__server__DOMAIN=localhost
      - GITEA__server__SSH_PORT=222
      - GITEA__server__HTTP_PORT=3000
      # SQLite
      - GITEA__database__DB_TYPE=sqlite3
      - GITEA__database__PATH=/data/gitea/gitea.db
      # PostgreSQL
      # - GITEA__database__DB_TYPE=postgres
      # - GITEA__database__HOST=gitea-db:5432
      # - GITEA__database__NAME=gitea
      # - GITEA__database__USER=gitea
      # - GITEA__database__PASSWD=gitea
    volumes:
      - ./gitea_data/server:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    ports:
      - 222:222   # SSH
      - 3000:3000 # HTTP
    labels:
      - traefik.enable=true
      - traefik.http.routers.gitea.rule=Host(`git.docker.local`)
      - traefik.http.services.gitea.loadbalancer.server.port=3000
    # depends_on:
    #   - gitea-db

  # gitea-db:
  #   image: docker.io/library/postgres:14
  #   container_name: gitea-db
  #   restart: unless-stopped
  #   environment:
  #     - POSTGRES_USER=gitea
  #     - POSTGRES_PASSWORD=gitea
  #     - POSTGRES_DB=gitea
  #   networks:
  #     - gitea
  #   volumes:
  #     - ./gitea_postgres_data:/var/lib/postgresql/data

  gitea-act-runner:
    image: docker.io/gitea/act_runner:nightly
    container_name: gitea-act-runner
    restart: unless-stopped
    environment:
      CONFIG_FILE: /config.yaml
      GITEA_INSTANCE_URL: http://192.168.3.101:3000
      # http://192.168.3.101:3000/-/admin/actions/runners
      # or
      # docker exec -it gitea gitea --config /data/gitea/conf/app.ini actions generate-runner-token
      GITEA_RUNNER_REGISTRATION_TOKEN: JY1uWsuNiexmvdleG0cbftgOvuHesKlnpZeCxbQA
    volumes:
      - ./config.yaml:/config.yaml
      - ./gitea_data/runner:/data
      - /var/run/docker.sock:/var/run/docker.sock
    network_mode: host
    depends_on:
      - gitea
```

### GoCD

[GoCD](https://github.com/gocd/gocd) - система CI/CD с поддержкой настройки всех этапов (stage, jobs, tasks, exec commands, artifacts, env и params) через пользовательский интерфейс или в формате `XML`.

```yaml
services:
  gocd-server:
    image: gocd/gocd-server:v24.3.0
    container_name: gocd-server
    restart: unless-stopped
    ports:
      - 8153:8153
    user: 0:0
    volumes:
      - ./godata_server:/godata
      - ./godata_server_home:/home/go

  gocd-agent:
    image: gocd/gocd-agent-alpine:v25.3.0
    container_name: gocd-agent
    restart: unless-stopped
    environment:
      - GO_SERVER_URL=http://gocd-server:8153/go
      - AGENT_AUTO_REGISTER_KEY=d4a80630-99de-4bc4-a89b-95a9884d43a3 # cat ./godata_server/config/cruise-config.xml
      - AGENT_AUTO_REGISTER_HOSTNAME=hv-us-101
    user: 0:0
    volumes:
      - ./godata_agent:/godata
      - ./godata_agent_home:/home/go
    depends_on:
      - gocd-server
```

### Drone CI

[Drone CI](https://github.com/drone) - CI/CD платформа, построенная на технологии DinD (Docker in Docker)

```yaml
services:
  drone-server:
    image: drone/drone:2
    container_name: drone-server
    restart: unless-stopped
    volumes:
      - /var/lib/drone:/data
    environment:
      - DRONE_GITEA_SERVER=http://gitea.docker.local
      - DRONE_GITEA_CLIENT_ID=
      - DRONE_GITEA_CLIENT_SECRET=
      - DRONE_RPC_SECRET=droneRpcSecret
      - DRONE_SERVER_HOST=drone.docker.local
      - DRONE_SERVER_PROTO=http
    ports:
      - 80:80
      - 443:443

  drone-runner:
    image: drone/drone-runner-docker:1
    container_name: runner-runner
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - DRONE_RPC_PROTO=http
      - DRONE_RPC_HOST=drone.docker.local
      - DRONE_RPC_SECRET=droneRpcSecret
      - DRONE_RUNNER_CAPACITY=2
      - DRONE_RUNNER_NAME=runner-local
    ports:
      - 3000:3000
```

### Harness

[Harness](https://github.com/harness/harness) - система CI/CD на базе Drone, хостинг исходного кода (gitness) и реестр артефактов с открытым исходным кодом.

```yaml
services:
  harness:
    image: harness/harness
    container_name: harness
    restart: unless-stopped
    ports:
      - 3021:3000
      - 3022:3022
    volumes:
      - ./harness_data:/data
      - /var/run/docker.sock:/var/run/docker.sock
```

### Woodpecker

[Woodpecker](https://github.com/woodpecker-ci/woodpecker) - еще одна платформа CI/CD на базе Drone.

```yaml
services:
  woodpecker-server:
    image: woodpeckerci/woodpecker-server:v3
    container_name: woodpecker-server
    restart: unless-stopped
    ports:
      - 8000:8000
    environment:
      - WOODPECKER_OPEN=true
      - WOODPECKER_HOST=${WOODPECKER_HOST}
      - WOODPECKER_GITHUB=true
      - WOODPECKER_GITHUB_CLIENT=${WOODPECKER_GITHUB_CLIENT}
      - WOODPECKER_GITHUB_SECRET=${WOODPECKER_GITHUB_SECRET}
      - WOODPECKER_AGENT_SECRET=${WOODPECKER_AGENT_SECRET}
    volumes:
      - ./woodpecker_server_data:/var/lib/woodpecker/

  woodpecker-agent:
    image: woodpeckerci/woodpecker-agent:v3
    container_name: woodpecker-agent
    restart: unless-stopped
    command: agent
    environment:
      - WOODPECKER_SERVER=woodpecker-server:9000
      - WOODPECKER_AGENT_SECRET=${WOODPECKER_AGENT_SECRET}
    volumes:
      - ./woodpecker_agent_config:/etc/woodpecker
      - /var/run/docker.sock:/var/run/docker.sock
    depends_on:
      - woodpecker-server
```

### Semaphore

Semaphore - графический интерфейс для Ansible, Terraform, OpenTofu, Bash, Pulumi, Docker и PowerShell, с поддержкой [API](https://semaphoreui.com/api-docs) и [LDAP](https://docs.semaphoreui.com/administration-guide/ldap) авторизацией.

```yaml
services:
  semaphore:
    image: public.ecr.aws/semaphore/pro/server:v2.13.12
    container_name: semaphore
    restart: unless-stopped
    environment:
      - SEMAPHORE_ADMIN=admin
      - SEMAPHORE_ADMIN_NAME=admin
      - SEMAPHORE_ADMIN_EMAIL=admin@localhost
      - SEMAPHORE_ADMIN_PASSWORD=admin
      # Database
      - SEMAPHORE_DB_DIALECT=postgres
      - SEMAPHORE_DB_HOST=semaphore-db
      - SEMAPHORE_DB_NAME=semaphore_db
      - SEMAPHORE_DB_USER=semaphore
      - SEMAPHORE_DB_PASS=semaphore
      - SEMAPHORE_DB_OPTIONS={"sslmode":"disable"}
      # Telegram
      - SEMAPHORE_TELEGRAM_CHAT=
      - SEMAPHORE_TELEGRAM_TOKEN=
      # LDAP
      # - SEMAPHORE_LDAP_ENABLE=yes
      # - SEMAPHORE_LDAP_SERVER=semaphore-ldap:1389
      # - SEMAPHORE_LDAP_BIND_DN=cn=semaphore,dc=docker,dc=local
      # - SEMAPHORE_LDAP_BIND_PASSWORD=semaphore
      # - SEMAPHORE_LDAP_SEARCH_DN=dc=docker,dc=local
      # - SEMAPHORE_LDAP_SEARCH_FILTER=(&(objectClass=inetOrgPerson)(uid=%s))
      # - SEMAPHORE_LDAP_MAPPING_MAIL={{ .cn }}@docker.local
      # - SEMAPHORE_LDAP_MAPPING_UID=|
      # - SEMAPHORE_LDAP_MAPPING_CN=cn
    volumes:
      - ./semaphore/app_data:/var/lib/semaphore
      - ./semaphore/app_conf:/etc/semaphore
    ports:
      - 3030:3000

  semaphore-db:
    image: postgres
    container_name: semaphore-db
    restart: unless-stopped
    environment:
      - POSTGRES_USER=semaphore
      - POSTGRES_PASSWORD=semaphore
      - POSTGRES_DB=semaphore_db
    volumes:
      - ./semaphore/db_data:/var/lib/postgresql/data

  # semaphore-ldap:
  #   image: bitnami/openldap:latest
  #   container_name: semaphore-ldap
  #   environment:
  #     - LDAP_ADMIN_USERNAME=admin
  #     - LDAP_ADMIN_PASSWORD=LdapAdmin
  #     - LDAP_USERS=semaphore
  #     - LDAP_PASSWORDS=semaphore
  #     - LDAP_ROOT=dc=docker,dc=local
  #     - LDAP_ADMIN_DN=cn=semaphore,dc=docker,dc=local
  #   volumes:
  #     - ./semaphore/ldap_data:/var/lib/ldap
  #   ports:
  #     - 1389:1389
  #     - 1636:1636
```

### Gaia

[Gaia](https://github.com/gaia-app/gaia) - пользовательский интерфейс для импорта и запуска модулей Terraform. Поддерживает импорт модулей из исходного кода (Github/Gitlab), проверку значений переменных Terraform (обязательные переменные, проверка на основе регулярных выражений), настройка значений по умолчанию или маскирование переменных для пользователей, запуск модулей (планирование/применение/уничтожение) и управление состоянием.

```yaml
services:
  gaia:
    image: gaiaapp/gaia
    container_name: gaia
    restart: unless-stopped
    ports: 
      - 8877:8877 # admin:admin123 and user:user123
    environment:
      - GAIA_MONGODB_URI=mongodb://gaia-mongo/gaia
      - GAIA_RUNNER_API_PASSWORD=GaiaPassword
      - GAIA_EXTERNAL_URL=http://gaia:8877

  gaia-runner:
    image: gaiaapp/runner
    container_name: gaia-runner
    restart: unless-stopped
    environment:
      - GAIA_URL=http://gaia:8877
      - GAIA_RUNNER_API_PASSWORD=GaiaPassword
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

  gaia-mongo:
    image: mongo:4.4
    container_name: gaia-mongo
    restart: unless-stopped
```

### Wexflow

[Wexflow](https://github.com/aelassas/wexflow) - движок автоматизации процессов, который используется для перемещение или преобразование файлов, загрузка на FTP/SFTP, отправка электронных писем, запуск скриптов (PowerShell, Bash, Python и т. д.), планирование и объединение задач в цепочку, запуск рабочих процессов по событиям, cron или watchfolders, визуальное проектирование процессов (интерфейс Designer), интеграция с API и базами данных (поддерживается более 6 баз данных), поддерживает условную логики (if/else, switch, while), более 100 встроенных заданий и мобильное приложение для Android.

```yaml
services:
  wexflow:
    image: aelassas/wexflow:latest
    container_name: wexflow
    restart: unless-stopped
    # SSL (optionals)
    volumes:
      - ./wexflow_data/Database:/opt/wexflow/Wexflow/Database
      # - ./wexflow_data/appsettings.json:/opt/wexflow/Wexflow.Server/appsettings.json:ro
      # - ./wexflow_data/wexflow.pfx:/opt/wexflow/Wexflow.Server/wexflow.pfx:ro
    ports:
      - 8000:8000 # admin:wexflow2018
    # depends_on:
    #  - mongo

  # mongo:
  #   image: mongo:latest
  #   container_name: mongo
  #   restart: unless-stopped
  #   ports:
  #     - 27017:27017
```

### n8n

[n8n](https://github.com/n8n-io/n8n) - платформа автоматизации рабочих процессов с встроенными возможностями ИИ. Сочетание визуального создания кода с пользовательским кодом и более 400 интеграций.

```yaml
services:
  n8n:
    image: docker.n8n.io/n8nio/n8n
    restart: always
    ports:
      - 5678:5678
    labels:
      - traefik.enable=true
      - traefik.http.routers.n8n.rule=Host(`n8n.docker.local`)
      - traefik.http.routers.n8n.tls=true
      - traefik.http.routers.n8n.entrypoints=web,websecure
      - traefik.http.routers.n8n.tls.certresolver=mytlschallenge
      - traefik.http.middlewares.n8n.headers.SSLRedirect=true
      - traefik.http.middlewares.n8n.headers.STSSeconds=315360000
      - traefik.http.middlewares.n8n.headers.browserXSSFilter=true
      - traefik.http.middlewares.n8n.headers.contentTypeNosniff=true
      - traefik.http.middlewares.n8n.headers.forceSTSHeader=true
      - traefik.http.middlewares.n8n.headers.SSLHost=docker.local
      - traefik.http.middlewares.n8n.headers.STSIncludeSubdomains=true
      - traefik.http.middlewares.n8n.headers.STSPreload=true
      - traefik.http.routers.n8n.middlewares=n8n@docker
    environment:
      - N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
      - N8N_HOST=n8n.docker.local
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - N8N_RUNNERS_ENABLED=true
      - NODE_ENV=production
      - WEBHOOK_URL=https://n8n.docker.local/
      - GENERIC_TIMEZONE=Etc/UTC+3
      - TZ=Etc/UTC+3
    volumes:
      - ./n8n_data:/home/node/.n8n
      - ./n8n_files:/files
```

### Cronicle

[Cronicle](https://github.com/jhuckaby/Cronicle) - улучшенная замена Cron, написанная на Node.js для выполнения запланированных, повторяющиехся и задач по запросу с отображением статистики и просмотром логов в реальном времени.

```yaml
services:
  cronicle:
    image: soulteary/cronicle:0.9.80
    container_name: cronicle
    restart: always
    ports:
      - 3012:3012
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - ./cronicle_data/data:/opt/cronicle/data
      - ./cronicle_data/logs:/opt/cronicle/logs
      - ./cronicle_data/plugins:/opt/cronicle/plugins
      - /home/lifailon/docker:/backup
    environment:
      - TZ=Etc/UTC+3
```

### xyOps

[xyOps](https://github.com/pixlcore/xyops) - это форк [Cronicle](https://github.com/jhuckaby/Cronicle), которая объеденяет в себе систему создания и планирования заданий с передачей параметров (переменных), рабочих процессов (workflow, выполнения нескольких упорядоченных заданий), мониторинга серверов, оповещений и реагирования на инциденты.

```yaml
services:
  xyops:
    image: ghcr.io/pixlcore/xyops:latest
    container_name: xyops
    restart: unless-stopped
    init: true
    ports:
      - 5522:5522
      - 5523:5523
    environment:
      - TZ=Etc/UTC+3
      - XYOPS_xysat_local=true
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./xyops_data:/opt/xyops/data
      - /home/lifailon/docker:/backup

  # Agent
  # xyops-worker:
  #   image: ghcr.io/pixlcore/xysat:latest
  #   container_name: xyops-worker
  #   restart: unless-stopped
  #   init: true
  #   volumes:
  #     - /var/run/docker.sock:/var/run/docker.sock
  #   environment:
  #     - XYOPS_setup=http://dc1466de402c:5522/api/app/satellite/config?t=ad0ad632c7ef064215f5a70990c1e45b3bb004a3d420aed9eb85660ac1734b48
```

### Cron Master

[Cron Master](https://github.com/fccview/cronmaster) - веб-интерфейс для управления заданиями Cron (настройка и мониторинг). Позволяет настроить расписание, поддерживает сниппеты и отображает историю выполнения заданий.

```yaml
services:
  cron-master:
    image: ghcr.io/fccview/cronmaster:latest
    container_name: cron-master
    restart: always
    user: root
    privileged: true
    init: true
    pid: host
    ports:
      - 40123:3000
    environment:
      - AUTH_PASSWORD=CronMaster
      - HOST_CRONTAB_USER=root
      - NODE_ENV=production
      - DOCKER=true
      - NEXT_PUBLIC_CLOCK_UPDATE_INTERVAL=30000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./cron_data/scripts:/app/scripts
      - ./cron_data/data:/app/data
      - ./cron_data/snippets:/app/snippets
```

### Crontab UI

[Crontab UI](https://github.com/alseambusher/crontab-ui) - веб-интерфейс для настройки и управления заданиями Cron с поддержкой импорта текущих заданий из crontab.

```yaml
services:
  crontab-ui:
    image: alseambusher/crontab-ui:latest
    container_name: crontab-ui
    restart: unless-stopped
    user: root
    privileged: true
    environment:
      - BASIC_AUTH_USER=admin
      - BASIC_AUTH_PWD=CronTabAdmin
    ports:
      - 40044:8000
```

## Vault Stack

### HashiCorp Vault

[HashiCorp Vault](https://github.com/hashicorp/vault) - инструмент хранения и управления секретами (например, API ключи, пароли, сертификаты и многое другое).

[HashiCorp Consul](https://github.com/hashicorp/consul) - распределенное и высокодоступное (HA) решение для подключения и настройки приложений в динамической распределенной инфраструктуре, например, для отказоустойчивости `Vault` в качестве backend хранилища.

[VaultUI](https://github.com/miladbeigi/vaultui) - интерфейс терминала (TUI) для HashiCorp Vault, вдохновленный k9s. Позволяет получить доступ к секретам, методам аутентификации и политикам.

```bash
docker run --rm -it -e VAULT_ADDR -e VAULT_TOKEN ghcr.io/miladbeigi/vaultui:latest
```

```yaml
services:
  consul-master:
    image: hashicorp/consul:latest
    container_name: consul-master
    restart: unless-stopped
    ports:
      - 8500:8500
    volumes:
      - ./consul_config:/consul/config
      - ./consul_data_master:/consul/data
    command: "agent -server -bootstrap-expect=1 -node=consul-master -client=0.0.0.0 -data-dir=/consul/data"
    # command: "agent -server -bootstrap-expect=3 -node=consul-master -client=0.0.0.0 -data-dir=/consul/data"

  # consul-slave:
  #   image: hashicorp/consul:latest
  #   container_name: consul-slave
  #   restart: unless-stopped
  #   volumes:
  #     - ./consul_data_slave:/consul/data
  #   command: "agent -server -retry-join=consul-master -node=consul-slave -client=0.0.0.0 -data-dir=/consul/data"

  # consul-arbiter:
  #   image: hashicorp/consul:latest
  #   container_name: consul-arbiter
  #   restart: unless-stopped
  #   volumes:
  #     - ./consul_data_arbiter:/consul/data
  #   command: "agent -server -retry-join=consul-master -node=consul-arbiter -client=0.0.0.0 -data-dir=/consul/data"

  vault:
    image: hashicorp/vault:latest
    container_name: vault
    restart: unless-stopped
    cap_add:
      - IPC_LOCK
    environment:
      - VAULT_ADDR=http://127.0.0.1:8200
      - SKIP_SETCAP=true
      - SKIP_CHOWN=true
    ports:
      - 8200:8200
    volumes:
      - ./vault_config:/vault/config
      # Использовать локальное хранилище (если отключен Consul)
      - ./vault_data:/vault/file
    command: vault server -config=/vault/config/vault.hcl
```

### VaultWarden

[VaultWarden](https://github.com/dani-garcia/vaultwarden) - неофициальный легковесный и обратно совместимый сервер современного менеджера паролей [Bitwarden](https://github.com/bitwarden), написанный на Rust.

```yaml
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    environment:
      - DOMAIN=http://vaultwarden.docker.local
      # - ROCKET_ADDRESS=0.0.0.0
      # - ROCKET_PORT=1338
    labels:
      - traefik.enable=true
      - traefik.http.routers.myapp.rule=Host(`vaultwarden.docker.local`)
    # Access via proxy
    # ports:
    #   - 1338:1338
    volumes:
      - ./vw_data/:/data/
```

### PassBolt

[PassBolt](https://github.com/passbolt/passbolt_api) - менеджер паролей для совместного использования в командах (поддерживает веб-интерфейс, [мобильное](https://play.google.com/store/apps/details?id=com.passbolt.mobile.android) и [desktop](https://github.com/passbolt/passbolt-windows) приложение, расширение браузера и интсрумент командной строки). 

🔗 [Passbolt Chrome Extension](https://chromewebstore.google.com/detail/passbolt-open-source-pass/didegimhafipceonhjepacocaffmoppf) ↗

```yaml
# sudo mkdir -p passbolt_data/gpg
# sudo chown -R 33:33 ./passbolt_data/gpg
# sudo chmod 755 ./passbolt_data/gpg
# sudo chmod 644 ./passbolt_data/gpg/*.asc 2>/dev/null || true

services:
  passbolt:
    image: passbolt/passbolt:latest
    # image: passbolt/passbolt:latest-ce-non-root
    container_name: passbolt
    restart: unless-stopped
    tty: true
    command: >
      bash -c "/usr/bin/wait-for.sh -t 0 passbolt-db:5432 -- /docker-entrypoint.sh"
    environment:
      - APP_FULL_BASE_URL=https://passbolt.docker.local
      - DATASOURCES_DEFAULT_DRIVER=Cake\Database\Driver\Postgres
      - DATASOURCES_DEFAULT_ENCODING=utf8
      - DATASOURCES_DEFAULT_URL=postgres://passbolt:PassB0lt@passbolt-db:5432/passbolt?schema=passbolt
      - EMAIL_DEFAULT_FROM_NAME=passbolt
      - EMAIL_DEFAULT_FROM=admin@docker.local
      - EMAIL_TRANSPORT_DEFAULT_HOST=localhost
      - EMAIL_TRANSPORT_DEFAULT_PORT=25
      - EMAIL_TRANSPORT_DEFAULT_USERNAME=null
      - EMAIL_TRANSPORT_DEFAULT_PASSWORD=null
      - EMAIL_TRANSPORT_DEFAULT_TLS=null
    volumes:
      - ./passbolt_data/gpg:/etc/passbolt/gpg
      - ./passbolt_data/jwt:/etc/passbolt/jwt
    # ports:
    #   - 80:80
    #   - 443:443
    labels:
      - traefik.enable=true
      - traefik.http.routers.myapp.rule=Host(`passbolt.docker.local`)
    depends_on:
      - passbolt-db

  passbolt-db:
    image: postgres:latest
    container_name: passbolt-db
    restart: unless-stopped
    environment:
      - POSTGRES_DB=passbolt
      - POSTGRES_USER=passbolt
      - POSTGRES_PASSWORD=PassB0lt
    volumes:
      - ./passbolt_data/db:/var/lib/postgresql
    # ports:
    #   - 5433:5432

# Creat new user
# docker exec -it passbolt bash
# su -s /bin/bash -c "/usr/share/php/passbolt/bin/cake passbolt register_user -u admin@docker.local -f Admin -l Admin -r admin" www-data
```

### KeeWeb

[KeeWeb](https://github.com/keeweb/keeweb) - веб-интефрейс и интерфейс рабочего стола для баз данных `kdbx`.

🔗 [KeeWeb Playground](https://app.keeweb.info) ↗

🔗 [KeeWeb Chrome Extension](https://chromewebstore.google.com/detail/keeweb-connect/pikpfmjfkekaeinceagbebpfkmkdlcjk) ↗

```yaml
services:
  keeweb:
    container_name: keeweb
    image: ghcr.io/keeweb/keeweb:latest
    # image: keeweb/keeweb:latest
    restart: unless-stopped
    volumes:
      - ./cert.crt:/config/keys/cert.crt:ro
      - ./cert.key:/config/keys/cert.key:ro
      - ./keeweb_data:/config
    ports:
      - 4343:443
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
```

### KeePassXC

[KeePassXC](https://github.com/keepassxreboot/keepassxc) - современный и кроссплатформенный интерфейс [KeePass](https://keepass.info) с открытым исходным кодом, а также собранный [образ](https://docs.linuxserver.io/images/docker-keepassxc/#strict-reverse-proxies) с веб-интерфейсом на базе [Selkies](https://github.com/selkies-project/selkies).

```yaml
services:
  keepassxc:
    # Base image: https://github.com/linuxserver/docker-baseimage-selkies
    image: lscr.io/linuxserver/keepassxc:latest
    container_name: keepassxc
    restart: unless-stopped
    security_opt:
      - seccomp:unconfined # optional
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/GMT+3
      - LC_ALL=ru_RU.UTF-8
      # Creds for auth
      # - CUSTOM_USER=admin
      # - PASSWORD=admin
    volumes:
      - ./keepassxc_data:/config # dir for ssl and kdbx files
    ports:
      - 3000:3000 # HTTP Selkies (https://github.com/selkies-project/selkies)
      - 3001:3001 # HTTPS
```

### Repo Manager

[Repo Manager](https://github.com/lbr38/repomanager) - веб-интерфейс для зеркалирования и управления репозиториями `rpm` и `deb`, от создателя [Motion UI](https://github.com/lbr38/motion-UI).

```yaml
services:
  repomanager:
    image: lbr38/repomanager:latest
    container_name: repomanager
    restart: unless-stopped
    # network_mode: host
    ports:
      - 8080:8080
    environment:
      FQDN: repomanager.docker.local
      MAX_UPLOAD_SIZE: 32M
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./repomanager_data:/var/lib/repomanager
      - ./repomanager_repo:/home/repo
```

## Monitoring Stack

### Grafana Stack

- [Grafana](https://github.com/grafana/grafana) - система для визуализации метрик из более чем 100 источников данных.

- [Loki](https://github.com/grafana/loki) - сервер для хранения и агрегации логов из удаленных систем (как Prometheus, но для логов).

- [Promtail](https://grafana.com/docs/loki/latest/send-data/promtail) - агент для сбора логов из файловой системы и контейнеров через сокет Docker с поддержкой фильтрации по `node`, `container`, `level` и `tag`.

- [Tempo](https://github.com/grafana/tempo) - хранилище для данных трассировок.

- [Pyroscope](https://github.com/grafana/pyroscope) - хранилище для данных профилирования.

- [Alloy](https://github.com/grafana/alloy) - агент для сбора и пересылки данных профилирования контейнеров Docker из сокета с помощью eBPF и трассировок с помощью встроенного в агент Beyla.

- [Beyla](https://github.com/grafana/beyla) - экспортер RED метрик (RPS, ошибок и продолжительности времени запросов) для HTTP и gRPC трафика.

```yaml
services:
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: always
    user: 472:472
    ports:
      - 9089:3000
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      # docker exec -it grafana grafana cli admin reset-admin-password GrafanaAdminNew
      - GF_SECURITY_ADMIN_PASSWORD=GrafanaAdmin
      # - GF_DATABASE_TYPE=postgres
      # - GF_DATABASE_HOST=grafana-db:5432
      # - GF_DATABASE_NAME=grafana
      # - GF_DATABASE_USER=grafana
      # - GF_DATABASE_PASSWORD=grafana
      # - GF_DATABASE_SSL_MODE=disable
    volumes:
      - ./grafana_data:/var/lib/grafana
      - ./grafana_dashboards:/var/lib/grafana/dashboards
      - ./grafana-provider.yaml:/etc/grafana/provisioning/dashboards/provider.yaml
      - ./grafana-datasources.yaml:/etc/grafana/provisioning/datasources/datasources.yaml

  # grafana-db:
  #   image: postgres:latest
  #   container_name: grafana-db
  #   restart: always
  #   environment:
  #     POSTGRES_DB: grafana
  #     POSTGRES_USER: grafana
  #     POSTGRES_PASSWORD: grafana
  #   volumes:
  #     - ./postgres_data:/var/lib/postgresql/data
  #   ports:
  #     - 5432:5432

  beyla-exporter:
    image: grafana/beyla:latest
    container_name: beyla-exporter
    restart: always
    privileged: true
    pid: host
    environment:
      - BEYLA_OPEN_PORT=1-65535
      - BEYLA_PROMETHEUS_PORT=8080
    # ports:
    #   - 9876:8080

  loki:
    image: grafana/loki:latest
    container_name: loki
    restart: always
    user: root
    volumes:
      - ./loki.yml:/etc/loki/loki-config.yaml
      - ./loki_data:/loki
    ports:
      - 3100:3100

  promtail:
    image: grafana/promtail:latest
    container_name: promtail
    restart: always
    volumes:
      - /var/log:/var/log:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./promtail.yml:/etc/promtail/promtail.yml
      - /etc/hostname:/etc/hostname:ro
    command: -config.file=/etc/promtail/promtail.yml
    # ports:
    #   - 9080:9080

  tempo:
    image: grafana/tempo:latest
    container_name: tempo
    restart: always
    volumes:
      - ./tempo.yaml:/etc/tempo.yaml:ro
    command: -config.file=/etc/tempo.yaml
    ports:
      - 3200:3200
      # - 4317:4317
      # - 4318:4318

  pyroscope:
    image: grafana/pyroscope:latest
    container_name: pyroscope
    restart: always
    ports:
      - 4040:4040

  alloy:
    image: grafana/alloy:latest
    container_name: alloy
    restart: always
    privileged: true
    pid: host
    init: true
    volumes:
      - ./alloy.hcl:/etc/alloy/config.alloy:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /sys/kernel/debug:/sys/kernel/debug
      - /sys/kernel/tracing:/sys/kernel/tracing
    command: run --storage.path=/var/lib/alloy/data /etc/alloy/config.alloy
```

### Prometheus Stack

- [Prometheus](https://github.com/prometheus/prometheus) - система мониторинга и оповещения с открытым исходным кодом, которая собирает и анализирует метрики работы серверов и приложений в реальном времени. Она хранит данные в виде временных рядов (значений с метками времени и ключами/меткам/тегами для идентификации). Веб-интефрейс поддерживает браузер запросов с визуализацией на графиках, отображение ролей из Alertmanager, их статусы и валидность, а также статус работы экспортеров, базы данных TSDB, доступные метки (labels в Service discovery), текущие флаги запуска сервера и итоговая конфигурация для экспорта.

- [Alertmanager](https://github.com/prometheus/alertmanager) - система оповещений для экосистемы Prometheus (например, в Telegram, при превышение заданных порого в конфигурации), а также поддерживает свой веб-интерфейс.

- [PromLens](https://github.com/prometheus/promlens) – веб-конструктор для анализа и визуализации запросов `PromQL` (уже встроен в интерфейс Prometheus).

- [Push Gateway](https://github.com/prometheus/pushgateway) - автономный шлюз-экспорт для сбора метрик через API (выступает в роли listener для приема метрик из скриптов, как в InfluxDB).

- [Blackbox Exporter](https://github.com/prometheus/blackbox_exporter) - мониторинг ICMP, TCP, DNS, HTTP/HTTPS и gRPC для предоставления метрик в формате Prometheus (похож на [Gatus](https://github.com/TwiN/gatus)).

- [Node Exporter](https://github.com/prometheus/node_exporter) - основной экспортер Prometheus для сбора системных метрик Linux.

- [Process Exporter](https://github.com/ncabatoff/process-exporter) - экспортер Prometheus для сбора метрик запущенных процессов.

- [cAdvisor](https://github.com/google/cadvisor) (Container Advisor) - экспортер метрик для всех запущенных контейнеров Docker с собственным веб-интерфейсом от Google.

- [LogPorter](https://github.com/Lifailon/logporter) - простая и легковесная альтернатива cAdvisor для получения всех основных метрик из контейнеров Docker.

```yaml
services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: always
    user: 65534:65534
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - ./alert-rules.yml:/etc/prometheus/alert.yml
      - ./prometheus_data:/prometheus
    ports:
      - 9090:9090

  pushgateway:
    image: prom/pushgateway:latest
    container_name: pushgateway
    restart: always
    ports:
      - 9091:9091

  alertmanager:
    image: prom/alertmanager
    container_name: alertmanager
    restart: always
    volumes:
      - ./alertmanager.yml:/etc/alertmanager/alertmanager.yml
      - ./telegram.tmpl:/etc/alertmanager/telegram.tmpl
    ports:
      - 9093:9093
    command:
      - --config.file=/etc/alertmanager/alertmanager.yml

  blackbox-exporter:
    image: prom/blackbox-exporter:latest
    container_name: blackbox-exporter
    restart: always
    volumes:
      - ./blackbox.yml:/etc/blackbox_exporter/config.yml
    ports:
      - 9115:9115
    command:
      - --config.file=/etc/blackbox_exporter/config.yml

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: always
    # ports:
    #   - 9100:9100

  process-exporter:
    image: ncabatoff/process-exporter
    container_name: process-exporter
    restart: always
    privileged: true
    volumes:
      - /proc:/host/proc
      - ./proc-conf.yml:/conf.yml
    # ports:
    #   - 9256:9256
    command:
      - -procfs
      - /host/proc
      - -config.path
      - /conf.yml

  # cadvisor:
  #   image: gcr.io/cadvisor/cadvisor:latest
  #   container_name: cadvisor
  #   restart: always
  #   volumes:
  #     - /:/rootfs:ro
  #     - /var/run:/var/run:rw
  #     - /sys:/sys:ro
  #     - /var/lib/docker/:/var/lib/docker:ro
  #   # ports:
  #   #   - 8080:8080

  logporter:
    image: lifailon/logporter:latest
    container_name: logporter
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    # ports:
    #   - 9333:9333
```

### VictoriaMetrics/vmagent

[VictoriaMetrics](https://github.com/VictoriaMetrics/VictoriaMetrics) - быстрое и масштабируемое решение для мониторинга и управления данными временных рядов (форк Prometheus).

`vmagent` - облегченная альтернатива Prometheus, использующая только роль сборщика метрик (`scrape`) для пересылки на сервер.

```yaml
services:
  # VictoriaMetrics server
  victoriametrics:
    image: victoriametrics/victoria-metrics:latest
    container_name: victoriametrics
    restart: always
    ports:
      - 8428:8428
      - 8089:8089
      - 8089:8089/udp
      - 2003:2003
      - 2003:2003/udp
      - 4242:4242
    volumes:
      - ./vmagent_data:/storage
    command:
      - "--storageDataPath=/storage"
      - "--graphiteListenAddr=:2003"
      - "--opentsdbListenAddr=:4242"
      - "--httpListenAddr=:8428"
      - "--influxListenAddr=:8089"

  # Metrics collector
  vmagent:
    image: victoriametrics/vmagent:latest
    container_name: vmagent
    restart: always
    ports:
      - 8429:8429
    volumes:
      - ./vmagent_data:/vmagentdata
      - ./prometheus-vm-single.yml:/etc/prometheus/prometheus.yml
    command:
      - "--promscrape.config=/etc/prometheus/prometheus.yml"
      - "--remoteWrite.url=http://victoriametrics:8428/api/v1/write"
    depends_on:
      - victoriametrics
```

### Jaeger

[Jaeger](https://github.com/jaegertracing/jaeger) - распределенная система трассировки для анализа времени обработки запросов и ответов к веб-приложениям (например, используется в Traefik), созданная компанией Uber Technologies и переданная в дар Cloud Native Computing Foundation.

🔗 [Jaeger Demo](https://demo.jaegertracing.io/jaeger) ↗

```yaml
services:
  jaeger:
    image: jaegertracing/all-in-one:1.55
    container_name: jaeger
    restart: always
    ports:
      - 16686:16686 # UI
      - 4317:4317   # Collector
```

### Parca

[Parca](https://github.com/parca-dev/parca) - система непрерывного профилирования для анализа использования процессора и памяти приложениями, вплоть до номера строки. Использует единый профилировщик eBPF, который автоматически обнаруживает цели из Docker, Kubernetes или systemd, поддерживая C, C++, Rust, Go и другие языки.

🔗 [Parca Demo](https://demo.parca.dev) ↗

```yaml
services:
  # Интерфейс для анализа профилирования
  parca-server:
    image: ghcr.io/parca-dev/parca:v0.24.2
    container_name: parca-server
    restart: unless-stopped
    command: /parca
    ports:
      - 7070:7070

  # Агент непрерывного профилирования 
  parca-agent:
    image: ghcr.io/parca-dev/parca-agent:v0.42.0
    container_name: parca-agent
    restart: unless-stopped
    command: --remote-store-address=parca-server:7070 --remote-store-insecure
    stdin_open: true
    tty: true
    privileged: true
    pid: host
    ports:
      - 7071:7071
    volumes:
      - /run:/run
      - /boot:/boot
      - /lib/modules:/lib/modules
      - /sys/kernel/debug:/sys/kernel/debug
      - /sys/fs/cgroup:/sys/fs/cgroup
      - /sys/fs/bpf:/sys/fs/bpf
      - /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket
```


### Gatus

[Gatus](https://github.com/TwiN/gatus) - современная и ориентированная на разработчиков (IaC подход для управления через конфигурацию) панель мониторинга состояние API и веб-сервисов с помощью HTTP, ICMP, TCP и DNS-запросов, с проверкой результатов тестирования в запросах (используются списки условий, проверка кода ответа, времени ответа, срок действия сертификата, тела запроса, парсинг json и другие функции). Поддерживает экспорт метрик Prometheus и динамическая панель инструментов Grafana.

🔗 [Gatus Web Playground](https://gatus.io/demo) ↗ - используется для составления запросов через веб-интерфейс без генерации конфигурации (код закрыт)

В демо-версии присутствует интерфейс (конструктор) для настройки и проверки правил мониторинга (без экспорта в формате конфигурации).

```yaml
services:
  gatus:
    image: twinproduction/gatus:latest
    container_name: gatus
    restart: unless-stopped
    volumes:
      - ./config:/config  # yaml configuration
      - ./data:/data      # SQLite
    ports:
      - 8180:8080
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080"]
      interval: 10s
      timeout: 5s
      retries: 3
```

### Uptime Kuma

[Uptime Kuma](https://github.com/louislam/uptime-kuma) - инструмент для мониторинга веб-приложений, поддерживающий настройку добавления хостов и правил с помощью веб-интерфейса.

[Uptime Kuma API](https://github.com/MedAziz11/Uptime-Kuma-Web-API) - Swagger документация для Uptime Kuma API.

🔗 [Uptime Kuma Demo](https://demo.kuma.pet/start-demo) ↗

```yaml
services:
  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime-kuma
    restart: unless-stopped
    ports:
      - 3001:3001
    volumes:
      - ./kuma_data:/app/data

  uptime-kuma-api:
    image: medaziz11/uptimekuma_restapi
    container_name: uptime-kuma-api
    restart: unless-stopped
    environment:
      - KUMA_SERVER=http://uptime-kuma:3001
      - KUMA_USERNAME=admin
      - KUMA_PASSWORD=KumaAdmin
      - ADMIN_PASSWORD=KumaApiAdmin
    ports:
      - 3002:8000
    volumes:
      - ./kuma_api:/db
    depends_on:
      - uptime-kuma
```

### StatPing

[StatPing](https://github.com/statping/statping) - страница статуса для проверки доступности веб-сайтов с настройкой в веб-интерфейсе, автоматическим построением графиков и оповещениями в Telegram. Поддерживает хранение данных в MySQL, PostgreSQL или SQLite.

🔗 [StatPing Android](https://play.google.com/store/apps/details?id=com.statping) ↗

```yaml
services:
  statping:
    image: statping/statping:latest
    container_name: statping
    restart: unless-stopped
    volumes:
      - ./statping_data:/app
    ports:
      - 8001:8080
    # environment:
    #   VIRTUAL_HOST: localhost
    #   VIRTUAL_PORT: 8080
    #   DB_CONN: statping-postgres
    #   DB_HOST: statping-postgres
    #   DB_DATABASE: statping
    #   DB_USER: statping
    #   DB_PASS: statping
```

[Форк statping](https://github.com/dockur/statping) от ветки [statping-ng](https://github.com/statping-ng/statping-ng).

```yaml
services:
  statping:
    image: dockurr/statping
    container_name: statping
    restart: unless-stopped
    stop_grace_period: 1m
    ports:
      - 8001:8080
    volumes:
      - ./statping_data:/app
```

### Checkmate

[Checkmate](https://github.com/bluewave-labs/Checkmate) - инструмент для мониторинга серверного оборудования, времени безотказной работы и времени отклика в реальном времени. Поддерживает мониторинг веб-сайтов, памяти, диска, процессора, температуры, пинга, Docker-контейнеров, скорости загрузки страниц и отслеживание инцидентов.

```yaml
services:
  checkmate:
    image: ghcr.io/bluewave-labs/checkmate-backend-mono-multiarch:latest
    container_name: checkmate
    restart: unless-stopped
    ports:
      - 52345:52345
    environment:
      - UPTIME_APP_CLIENT_HOST=http://localhost:52345
      - UPTIME_APP_API_BASE_URL=http://localhost:52345/api/v1
      - CLIENT_HOST=http://localhost:52345
      - DB_CONNECTION_STRING=mongodb://checkmate-db:27017/uptime_db
      - JWT_SECRET=ChangeThisToAStrongRandomSecretKey123!
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    depends_on:
      - checkmate-db

  checkmate-db:
    image: mongo:6.0
    container_name: checkmate-db
    restart: unless-stopped
    volumes:
      - ./mongo_data:/data/db
```

### Change Detection

[Change Detection](https://github.com/dgtlmoon/changedetection.io) - следите за обновлениями на веб-сайтах, с поддержкой новостной RSS ленты, REST API, а также уведомлениями в Telegram, Discord, Slack, Webhook и другие каналы.

```yaml
services:
  changedetection:
    image: ghcr.io/dgtlmoon/changedetection.io
    container_name: changedetection
    restart: unless-stopped
    volumes:
      - ./changedetection_data:/datastore
    ports:
      - 5000:5000
```

### Graphite

[Graphite](https://github.com/graphite-project) - система хранения метрик временных рядов, которая принимает данные по TCP или UDP (например, для отправки данных с помощью `netcat`) протоколам и состоит из трех основных компонентов:

- [Graphite Web](https://github.com/graphite-project/graphite-web) - веб-интерфейс на [django](https://github.com/django/django) для визуализации метрик на графиках.
- [Whisper](https://github.com/graphite-project/whisper) - файловая БД для временных рядов (хранит данные в `.wsp` файлах).
- [Carbon](https://github.com/graphite-project/carbon) (TCP) и `StatsD` (UDP) - агенты для приема метрик по сети (кэширует и записывает данные в БД).

[OhmGraphite](https://github.com/nickbabcock/OhmGraphite) - экспортер метрик из [LibreHardwareMonitor](https://github.com/LibreHardwareMonitor/LibreHardwareMonitor), который работает как служба Windows для отправки данных в Graphite, InfluxdDB, Prometheus или [TimescaleDB](https://github.com/timescale/timescaledb) (база данных временных рядов, упакованная как расширение Postgres).

```yaml
services:
  graphite:
    image: graphiteapp/graphite-statsd
    container_name: graphite
    restart: unless-stopped
    ports:
      - 2025:80
      - 2003-2004:2003-2004
      - 2023-2024:2023-2024
      - 8125:8125/udp
      - 8126:8126

# StatsD (UDP)
# Формат: метрика:значение|type
# Хранятся в stats и stats_counts по указанном пути через точку
# while true; do echo "test.dev.random:$(($RANDOM % 100))|c" | nc -u 127.0.0.1 8125; sleep 1; done

# Carbon (TCP) Plain Text Protocol
# Формат: метрика значение timestamp
# while true; do echo "test.dev.random $(($RANDOM % 100)) $(date +%s)" | nc -w 1 127.0.0.1 2003; sleep 1; done
```

### InfluxDB

Система мониторинга (экосистема Influx) состоит из следующих компонентов:

- [InfluxDB](https://github.com/influxdata/influxdb) - база данных времянных рядов, для хранения метрик.
- [Telegraf](https://github.com/influxdata/telegraf) - агент для сбора, обработки, агрегации и записи метрик, логов и других произвольных данных (поддерживает более 300 плагинов, которые позволяют мониторить системы из коробки, например, `inputs.docker`).
- [Chronograf](https://github.com/influxdata/chronograf) - веб-интерфейс на базе [React](https://github.com/facebook/react), который позволяет динамически  визуализировать метрики на графиках (похоже на Grafana и Zabbix), даже без настройки.

1-я версия InfluxDB поддерживает управление базой и отправку данных, используя API (например, с помощью `curl`).

[InfluxDB Studio](https://github.com/meverett/InfluxDBStudio) - инструмент рабочего стола для управления базами данных InfluxDB `1.8` на базе [InfluxData.Net](https://github.com/tihomir-kit/InfluxData.Net) (как [MS SSMS](https://en.wikipedia.org/wiki/SQL_Server_Management_Studio)).

[Flux](https://github.com/influxdata/flux) - скриптовый язык для запросов к базам данных InfluxDB версии `2.0` и выше.

```yaml
services:
  # Database
  influxdb:
    image: influxdb:1.8
    container_name: influxdb
    restart: unless-stopped
    ports:
      - 8086:8086
    volumes:
      - ./influxdb_data:/var/lib/influxdb
      # - ./ssl_cert:/etc/ssl/
    environment:
      - INFLUXDB_DB=ohm
      # Auth
      - INFLUXDB_HTTP_AUTH_ENABLED=true
      - INFLUXDB_ADMIN_USER=admin
      - INFLUXDB_ADMIN_PASSWORD=admin
      # SSL (optionals)
      # - INFLUXDB_HTTP_HTTPS_ENABLED=true
      # - INFLUXDB_HTTP_HTTPS_CERTIFICATE=/etc/ssl/ohm.crt
      # - INFLUXDB_HTTP_HTTPS_PRIVATE_KEY=/etc/ssl/ohm.key

  # Web interface (like Grafana)
  chronograf:
    image: chronograf:1.8
    container_name: chronograf
    restart: unless-stopped
    ports:
      - 8888:8888
    environment:
      - INFLUXDB_URL=http://influxdb:8086
      - INFLUXDB_USERNAME=admin
      - INFLUXDB_PASSWORD=admin
    depends_on:
      - influxdb

  # Agent
  telegraf:
    image: telegraf
    container_name: telegraf
    restart: unless-stopped
    user: :109 # grep docker /etc/group
    volumes:
      - ./telegraf.conf:/etc/telegraf/telegraf.conf
      - /var/run/docker.sock:/var/run/docker.sock
    depends_on:
      - influxdb
```

### Zabbix

```yaml
services:
  zabbix-database:
    image: postgres:15
    restart: unless-stopped
    environment:
      POSTGRES_DB: zabbix_dn
      POSTGRES_USER: zabbix_user
      POSTGRES_PASSWORD: ZabbixAdmin
    volumes:
      - ./zabbix/database:/var/lib/postgresql/data
    healthcheck:
      test: [ "CMD", "pg_isready", "-q", "-d", "zabbix_dn", "-U", "zabbix_user" ]
      interval: 10s
      timeout: 5s
      retries: 3
      start_period: 60s

  zabbix-server:
    image: zabbix/zabbix-server-pgsql:6.4.6-ubuntu
    restart: unless-stopped
    environment:
      DB_SERVER_HOST: zabbix-database
      DB_SERVER_PORT: 5432
      POSTGRES_DB: zabbix_dn
      POSTGRES_USER: zabbix_user
      POSTGRES_PASSWORD: ZabbixAdmin
      ZBX_CACHESIZE: 1G
    ports:
      - 10051:10051
    healthcheck:
      test: grep -qr "zabbix_server" /proc/*/status || exit 1
      interval: 10s
      timeout: 5s
      retries: 3
      start_period: 90s
    depends_on:
      zabbix-database:
        condition: service_healthy

  zabbix-dashboard:
    image: zabbix/zabbix-web-nginx-pgsql:6.4.6-ubuntu
    restart: unless-stopped
    environment:
      DB_SERVER_HOST: zabbix-database
      DB_SERVER_PORT: 5432
      POSTGRES_DB: zabbix_dn
      POSTGRES_USER: zabbix_user
      POSTGRES_PASSWORD: ZabbixAdmin
      ZBX_SERVER_HOST: zabbix-server
      PHP_TZ: Etc/UTC+3
    ports:
      - 80:8080
      - 443:8443
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/"]
      interval: 10s
      timeout: 5s
      retries: 3
      start_period: 90s
    depends_on:
      zabbix-database:
        condition: service_healthy
      zabbix-server:
        condition: service_healthy

  zabbix-agent:
    image: zabbix/zabbix-agent2:6.4.6-ubuntu
    restart: unless-stopped
    environment:
      ZBX_HOSTNAME: Zabbix server
      ZBX_SERVER_HOST: zabbix-server
    depends_on:
      - zabbix-database
      - zabbix-server
```

### Netdata

[Netdata](https://github.com/netdata/netdata) - платформа мониторинга инфраструктуры с нулевой настройкой. Поддерживает отображение всех возможных метрик из коробки, TOP процессов, просмотр логов с гистограммой (like Loki), настройка пользовательских Dashboards, оповещений (Alers), а также отображение событий и аномалий.

🔗 [Netdata Demo](https://learn.netdata.cloud/docs/live-demo) ↗

```yaml
services:
  netdata:
    image: netdata/netdata
    container_name: netdata
    restart: unless-stopped
    pid: host
    network_mode: host
    # ports:
    #   - 19999:19999 # Web UI
    cap_add:
      - SYS_PTRACE
      - SYS_ADMIN
    security_opt:
      - apparmor:unconfined
    volumes:
      - ./netdata_config:/etc/netdata
      - ./netdata_lib:/var/lib/netdata
      - ./netdata_cache:/var/cache/netdata
      - /:/host/root:ro,rslave
      - /etc/passwd:/host/etc/passwd:ro
      - /etc/group:/host/etc/group:ro
      - /etc/localtime:/etc/localtime:ro
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /etc/os-release:/host/etc/os-release:ro
      - /var/log:/host/var/log:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /run/dbus:/run/dbus:ro
```

### OpenObserve

[Open Observe](https://github.com/openobserve/openobserve) (O2) — централизованная система наблюдения для логов (like Loki), метрик (like Prometheus), трассировок (like Jaeger), аналитики, RUM (мониторинг реальных пользователей — производительность, ошибки, воспроизведение сеансов), предназначенная для работы в масштабах петабайт. Он прост и удобен в использовании, в отличие от Elasticsearch, который требует понимания и настройки множества параметров, позволяет запустить его менее чем за 2 минуты. OpenObserve имеет свой встроенный пользовательский интерфейс, что устраняет необходимость в отдельной установке сторонних инструментов, таких как Kibana.

Поддерживает большое количество источников данных, например, [otel-collector](https://github.com/open-telemetry/opentelemetry-collector) на базе протокола [OTLP](https://github.com/open-telemetry/opentelemetry-proto) (OpenTelemetry protocol), а также curl, FluentBit, Filebeat, Logstash, Syslog-ng, Prometheus и Telegraf.

```yaml
services:
  openobserve:
    image: public.ecr.aws/zinclabs/openobserve:latest
    container_name: openobserve
    restart: unless-stopped
    environment:
      - ZO_DATA_DIR=/data
      - ZO_ROOT_USER_EMAIL=root@example.com
      - ZO_ROOT_USER_PASSWORD=Complexpass#123
    ports:
      - 514:514/tcp   # Syslog TCP
      - 514:514/udp   # Syslog UDP
      - 5080:5080/tcp # Web UI
    volumes:
      - ./openobserve_data:/data

# Установка агента на системе Linux:
# curl -O https://raw.githubusercontent.com/openobserve/agents/main/linux/install.sh && chmod +x install.sh && sudo ./install.sh http://192.168.3.101:5080/api/default/ cm9vdEBleGFtcGxlLmNvbTo2SUtjaTZMOVhmYXEwRGlC
# Windows:
# Invoke-WebRequest -Uri https://raw.githubusercontent.com/openobserve/agents/main/windows/install.ps1 -OutFile install.ps1 ; .\install.ps1 -URL http://192.168.3.101:5080/api/default/ -AUTH_KEY cm9vdEBleGFtcGxlLmNvbTo2SUtjaTZMOVhmYXEwRGlC
# Отправка логов из curl:
# curl -u root@example.com:6IKci6L9Xfaq0DiB -k http://192.168.3.101:5080/api/default/default/_json -d "[{\"level\":\"info\",\"job\":\"test\",\"log\":\"test message for openobserve\"}]"
```

### HighLight

[HighLight](https://github.com/highlight/highlight) - инструмент мониторинга нового поколения для разработчиков. В отличие от других (устаревших...) инструментов, отличается целостностью. Поддерживает мониторинг ошибок, логов и сессий.

```yaml
services:
  backend:
    image: ghcr.io/highlight/highlight-backend:latest
    container_name: backend
    restart: unless-stopped
    volumes:
      - ./highlight_data:/highlight-data
      - ../backend/env.enc:/build/env.enc
      - ../backend/env.enc.dgst:/build/env.enc.dgst
      - ../backend/localhostssl/server.key:/build/localhostssl/server.key
      - ../backend/localhostssl/server.crt:/build/localhostssl/server.crt
    ports:
      - 8082:8082
    # env_file: .env

  frontend:
    image: ghcr.io/highlight/highlight-frontend:latest
    container_name: frontend
    restart: unless-stopped
    volumes:
      - ../backend/localhostssl/server.key:/etc/ssl/private/ssl-cert.key
      - ../backend/localhostssl/server.pem:/etc/ssl/certs/ssl-cert.pem
    ports:
      - 3000:3000
      - 6006:6006
      - 8080:8080
    # env_file: .env
```

### ELK Stack

[Elasticsearch](https://github.com/elastic/elasticsearch) - распределенная поисковая и аналитическая система, основанная на библиотеке Apache Lucene. Она используется для быстрого поиска и анализа больших объемов данных в реальном времени, например, для полнотекстового поиска. Стек состоит из трех приложений:

- [Logstash](https://github.com/elastic/logstash) - система для сбора логов из различных источников, преобразования их в нужный формат и отправляет в Elasticsearch.
- [Kibana](https://github.com/elastic/kibana) - веб интерфейс для отображения данных.
- [Beats](https://github.com/elastic/beats) - агент для сбора операционных метрик и логов.

[elastop](https://github.com/acidvegas/elastop) - TUI интерфейс для мониторинга кластеров Elasticsearch в режиме реального времени.

```yaml
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.13.4
    container_name: elasticsearch
    restart: unless-stopped
    environment:
      - node.name=elasticsearch
      - cluster.initial_master_nodes=elasticsearch
      - discovery.type=single-node
      - bootstrap.memory_lock=true
      - ES_JAVA_OPTS=-Xms512m -Xmx512m
      - ELASTIC_PASSWORD=ElasticSearchAdmin
    volumes:
      - ./es_data:/usr/share/elasticsearch/data
      # - ./elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml:ro,Z
    ports:
      - 9200:9200
      - 9300:9300
    ulimits:
      memlock:
        soft: -1
        hard: -1

  logstash:
    image: docker.elastic.co/logstash/logstash:8.13.4
    container_name: logstash
    restart: unless-stopped
    environment:
      - LS_JAVA_OPTS=-Xms256m -Xmx256m
      - LOGSTASH_INTERNAL_PASSWORD=logStashPassword
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - ELASTIC_PASSWORD=ElasticSearchAdmin
    volumes:
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
      # - ./logstash.yml:/usr/share/logstash/config/logstash.yml:ro,Z
      # - ./logstash_pipeline:/usr/share/logstash/pipeline:ro,Z
    ports:
      - 5044:5044
      - 5000:5000/tcp
      - 5000:5000/udp
      - 9600:9600
    depends_on:
      - elasticsearch

  kibana:
    image: docker.elastic.co/kibana/kibana:8.13.4
    container_name: kibana
    restart: unless-stopped
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - ELASTICSEARCH_USERNAME=kibana
      - ELASTICSEARCH_PASSWORD=ElasticSearchAdmin
    volumes:
      - ./kibana.yml:/usr/share/kibana/config/kibana.yml:ro,Z
    ports:
      - 5601:5601
    depends_on:
      - elasticsearch

# curl -u elastic:ElasticSearchAdmin http://localhost:9200/_cat/indices
# echo '{"message":"Test log"}' | nc localhost 5000
```

### Graylog

[Graylog](https://github.com/Graylog2/graylog2-server) - централизованная система сбора, индексации и анализа логов или других данных из удаленных систем (например, с помощью `rsyslog` или beats агентов), которая может использовать Elasticsearch или [Graylog Data Node](https://hub.docker.com/r/graylog/graylog-datanode) для хранения данных.

```yaml
services:
  mongodb:
    image: mongo:4.2
    container_name: mongodb
    restart: unless-stopped

  elasticsearch:
    image: secureimages/elasticsearch-oss:7.10.2-alpine-3.13.2
    container_name: elasticsearch
    restart: unless-stopped
    environment:
      - discovery.type=single-node

  graylog:
    image: graylog/graylog:4.0
    container_name: graylog
    restart: unless-stopped
    environment:
      # head -c 96 /dev/urandom | base64
      - GRAYLOG_PASSWORD_SECRET=somesecret123
      # echo -n "admin" | sha256sum | tr -d ' -'
      - GRAYLOG_ROOT_PASSWORD_SHA2=8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
      - GRAYLOG_HTTP_BIND_ADDRESS=0.0.0.0:9000
      - GRAYLOG_HTTP_EXTERNAL_URI=http://127.0.0.1:9000/
      - GRAYLOG_MONGODB_URI=mongodb://mongodb:27017/graylog
      - GRAYLOG_ELASTICSEARCH_HOSTS=http://127.0.0.1:9200
    ports:
      - 9000:9000         # Web UI
      - 514:514/tcp       # Syslog TCP Server input
      - 514:514/udp       # Syslog UDP Server input
      - 5044:5044/tcp     # Beats input
      - 12201:12201/tcp   # GELF TCP
      - 12201:12201/udp   # GELF UDP
    volumes:
      - ./graylog_data:/usr/share/graylog/data
    depends_on:
      - mongodb
      - elasticsearch
```

### Log Bull

[Log Bull](https://github.com/logbull/logbull) - простая альтернатива ELK и Loki, которая размещается на собственном сервере, не требует настройки и открытый исходный код. Для отправки логов используются библиотеки на разных языка, в т.ч. с помощью [curl](https://logbull.com/?language_example=curl#how-to-use-in-code).

```yaml
services:
  logbull:
    image: logbull/logbull:latest
    container_name: logbull
    restart: unless-stopped
    ports:
      - 4005:4005
    volumes:
      - ./logbull_data:/logbull-data
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:4005/api/v1/system/health"]
      interval: 5s
      timeout: 5s
      retries: 30
```

### Telescope

[Telescope](https://github.com/iamtelescope/telescope) - интерфейс для анализа логов, который из коробки поддерживает источники логов из ClickHouse, StarRocks, Docker и Kubernetes. 

```yaml
# mkdir -p ~/docker/telescope/telescope_data/
# cd ~/docker/telescope
# wget https://raw.githubusercontent.com/iamtelescope/telescope/refs/heads/main/dev/db.sqlite3 -O ./telescope_data/db.sqlite3
# wget https://raw.githubusercontent.com/iamtelescope/telescope/refs/heads/main/dev/config.yaml -O ./telescope_data/config.yaml

services:
  telescope:
    image: ghcr.io/iamtelescope/telescope:latest
    container_name: telescope
    restart: always
    ports:
      - 9898:9898
    environment:
      - TELESCOPE_CONFIG_FILE=/config.yaml
    volumes:
      - ./telescope_data/db.sqlite3:/db.sqlite3
      - ./telescope_data/config.yaml:/config.yaml
      - /var/run/docker.sock:/var/run/docker.sock:ro
```

### Rsyslog Collector

[Rsyslog Collector](https://github.com/rsyslog/rsyslog) - централизованная система для сбора логов, который поддерживает сбор как системных логов (подключение к серверу через конфигурацию `/etc/rsyslog.conf`), так и контейнеров Docker с помощью драйвера логирования syslog. Контейнер собирает все логи в файл `/var/log/all.log` и не требует настройки конфигурации.

```yaml
services:
  rsyslog-collector:
    image: rsyslog/rsyslog-collector:latest
    container_name: rsyslog-collector
    restart: unless-stopped
    volumes:
      - ./log_data:/var/log
      - /etc/hostname:/etc/hostname:ro
    environment:
      - ENABLE_UDP=on
      - ENABLE_TCP=on
      - ENABLE_RELP=off
      - WRITE_ALL_FILE=on   # write all messages to /var/log/all.log
      - WRITE_JSON_FILE=off # write JSON formatted messages to /var/log/all-json.log
      - RSYSLOG_HOSTNAME=/etc/hostname
      - RSYSLOG_ROLE=collector
    ports:
      - 10514:514/udp    # Syslog UDP
      - 10514:514/tcp    # Syslog TCP
      # - 20514:2514/tcp   # RELP
```

### Rsyslog Dockerlogs

[Rsyslog Dockerlogs](https://www.rsyslog.com/doc/containers/dockerlogs.html) - запускает контейнер rsyslog для чтения журналов из демона Docker с помощью модуля [imdocker](https://www.rsyslog.com/doc/configuration/modules/imdocker.html) для переадресации в `rsyslog` сервер.

```yaml
services:
  rsyslog-dockerlogs:
    image: rsyslog/rsyslog-dockerlogs:latest
    container_name: rsyslog-dockerlogs
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /etc/hostname:/etc/hostname:ro
    environment:
      - REMOTE_SERVER_NAME=rsyslog-collector
      # - REMOTE_SERVER_NAME=rsyslog-gui
      - REMOTE_SERVER_PORT=514
      - RSYSLOG_HOSTNAME=/etc/hostname
      - RSYSLOG_ROLE=docker
```

### Rsyslog GUI

[Rsyslog GUI](https://github.com/aguyonp/rsyslog-gui) - [Rsyslog](https://github.com/aguyonp/rsyslog-gui) сервер и веб-интерфейс на базе [PimpMyLog](https://github.com/potsky/PimpMyLog) для анализа логов (чтения, сортировки и фильтрации по содержимому сообщений).

```yaml
services:
  rsyslog-gui:
    image: aguyonnet/rsyslog-gui
    container_name: rsyslog-gui
    restart: unless-stopped
    volumes:
      - ./rsyslog_data:/var/log/net
      - ./rsyslog.conf:/etc/rsyslog.conf # to enable TCP
    ports:
      - 10080:80
      - 10514:514/udp
      - 10514:514/tcp
    environment:
      - SYSLOG_USERNAME=admin
      - SYSLOG_PASSWORD=admin
    # healthcheck:
    #   test:
    #     - CMD-SHELL
    #     - logger -n localhost -t rsyslog-gui -p user.info "healthcheck"
    #   start_period: 30s
    #   interval: 5s
    #   timeout: 3s
    #   retries: 3
```

### Sloggo

[Sloggo](https://github.com/phare/sloggo) - легковесный сборщик логов по стандарту RFC 5424 (протокол Syslog) на базе библиотеки [go-syslog](https://github.com/leodido/go-syslog). Для хранения данных использует встроенную базу данных [DuckDB](https://github.com/duckdb/duckdb) (like SQLite), а также предоставляет интерфейс на базе [data-table-filters](https://github.com/openstatusHQ/data-table-filters) для поиска и фильтрации.

```yaml
services:
  sloggo:
    image: ghcr.io/phare/sloggo:latest
    container_name: sloggo
    restart: unless-stopped
    volumes:
      - ./sloggo_data:/app/.duckdb
    environment:
      - SLOGGO_LISTENERS=tcp,udp
      - SLOGGO_UDP_PORT=1514
      - SLOGGO_TCP_PORT=2514
      - SLOGGO_API_PORT=3080
      - SLOGGO_LOG_RETENTION_MINUTES=43200 # 30 days (60*24*30)
    ports:
      - 1514:1514/udp
      - 1514:2514/tcp
      - 1080:3080/tcp
    logging:
      driver: syslog
      options:
        syslog-address: udp://localhost:1514
        tag: "{{.Name}}"
        syslog-format: rfc5424
```

### Logspout

[Logspout](https://github.com/gliderlabs/logspout) - маршрутизатор журналов для контейнеров Docker, работающий внутри Docker. Он подключается ко всем контейнерам на хосте и перенаправляет их логи на указанный сервер Syslog.

```yaml
services:
  logspout:
    image: gliderlabs/logspout:latest
    container_name: logspout
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    command: syslog://sloggo:1514
```

### Fluent Bit

[Fluent Bit](https://github.com/fluent/fluent-bit) - быстрый и легковесный агент для сбора логов, метрик и трассировок в системах Linux, BSD, OSX и Windows.

Пример пересылки логов из контейнера [Zerobyte](https://github.com/nicotsx/zerobyte) в сервис AWS CloudWatch (может быть запущен в [localstack](https://github.com/localstack/localstack)) через fluent-bit агента:

```yaml
services:
  zerobyte:
    image: ghcr.io/nicotsx/zerobyte:v0.19
    container_name: zerobyte
    restart: always
    ports:
      - 4096:4096
    cap_add:
      - SYS_ADMIN
    devices:
      - /dev/fuse:/dev/fuse
    environment:
      - TZ=Etc/UTC+3
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/lib/zerobyte:/var/lib/zerobyte
      - /home/lifailon/docker/gitea/gitea_data:/backup_src_volume
    logging:
      driver: fluentd
      options:
        fluentd-address: localhost:24224
        tag: zerobyte

  fluent-bit:
    image: fluent/fluent-bit:latest
    container_name: fluent-bit
    ports:
      - 24224:24224
    environment:
      - AWS_ENDPOINT_URL=http://192.168.3.101:4566
      - AWS_ACCESS_KEY_ID=test
      - AWS_SECRET_ACCESS_KEY=test
      - AWS_REGION=us-east-1
    volumes:
      - ./fluent-bit.conf:/fluent-bit/etc/fluent-bit.conf
```

### Vector

[Vector](https://github.com/vectordotdev/vector) - сквозной агент и агрегатор данных для сбора метрик и логов и перенаправления их в любые поставщики данных (заявлено, что работает до 10 раз быстрее любого альтернативного решения в этой области).

```yaml
services:
  vector:
    image: timberio/vector:nightly-alpine
    container_name: vector
    restart: unless-stopped
    volumes:
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./vector.toml:/etc/vector/vector.toml:ro
```

### Docker Logger

[Docker Logger](https://github.com/umputun/docker-logger) - сборщик логов из других контейнеров на хосте, запущенных без `-t` опции и настроенных с драйвером логирования `json-file` или `journald`. Оно может перенаправлять как стандартный поток вывода и ошибки контейнеров в локальные и ротируемые файлы или в удаленный `syslog` сервер.

```yaml
services:
  docker-logger:
    image: umputun/docker-logger
    container_name: docker-logger
    restart: always
    environment:
      - LOG_FILES=true
      - EXCLUDE=docker-logger
      # - INCLUDE=
      - MAX_FILES=10
      - MAX_SIZE=50
      - MAX_AGE=20
      - DEBUG=true
      - LOG_SYSLOG=false
      - SYSLOG_HOST=127.0.0.1:514
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./logs:/srv/logs
    logging:
      driver: json-file
      options:
        max-size: 10m
        max-file: 5
```

### Toolong

[Toolong](https://github.com/Textualize/toolong) - терминальное приложение (TUI) для просмотра, отслеживания, объединения и поиска по содержимому файловых журналов, а также собранный [образ](https://hub.docker.com/r/lifailon/toolong-web) с веб-интерфейсом на базе [ttyd](https://github.com/tsl0922/ttyd).

> [!NOTE]
> Используется неофициальный образ [lifailon/toolong-web](https://hub.docker.com/r/lifailon/toolong-web), собранный в репозитории [ruDocs](https://github.com/Lifailon/rudocs) для публичного использования.

```yaml
services:
  toolong-web:
    image: lifailon/toolong-web:latest
    # build:
    #   context: .
    #   dockerfile: Dockerfile
    container_name: toolong-web
    restart: unless-stopped
    environment:
      - PORT=4444
      - USERNAME=
      - PASSWORD=
      # - LOGPATH=/var/log/syslog*
      - LOGPATH=/var/log/*log*
    ports:
      - 4444:4444
    volumes:
      - /var/log:/var/log:ro
```

### WebTail

[WebTail](https://github.com/LeKovr/webtail) - веб-интерфейс и пакет Go для непрерывного стрименга файлов (приемущественно логов) через веб-сокет в браузер (русский разработчик).

```yaml
services:
  webtail:
    image: ghcr.io/lekovr/webtail:latest
    container_name: webtail
    restart: unless-stopped
    user: 0:0
    ports:
      - 8060:8080
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      - /var/log:/log:ro
```

### PatchMon

[PatchMon](https://github.com/PatchMon/PatchMon) - централизованное управление обновлениями в различных серверных средах. Агенты обмениваются данными с сервером PatchMon только по исходящим каналам, исключая входящие порты на контролируемых хостах, обеспечивая при этом всестороннюю видимость и безопасную автоматизацию.

```yaml
services:
  patchmon:
    image: ghcr.io/patchmon/patchmon-backend:latest
    container_name: patchmon
    restart: unless-stopped
    environment:
      LOG_LEVEL: info
      DATABASE_URL: postgresql://patchmon_user:patchmon_pass@patchmon-db:5432/patchmon_db
      JWT_SECRET: # CREATE A STRONG SECRET AND PUT IT HERE
      SERVER_PROTOCOL: http
      SERVER_HOST: localhost
      SERVER_PORT: 3000
      CORS_ORIGIN: http://localhost:3000
      # Database Connection Pool Configuration (Prisma)
      DB_CONNECTION_LIMIT: 30
      DB_POOL_TIMEOUT: 20
      DB_CONNECT_TIMEOUT: 10
      DB_IDLE_TIMEOUT: 300
      DB_MAX_LIFETIME: 1800
      # Rate Limiting (times in milliseconds)
      RATE_LIMIT_WINDOW_MS: 900000
      RATE_LIMIT_MAX: 5000
      AUTH_RATE_LIMIT_WINDOW_MS: 600000
      AUTH_RATE_LIMIT_MAX: 500
      AGENT_RATE_LIMIT_WINDOW_MS: 60000
      AGENT_RATE_LIMIT_MAX: 1000
      # Redis Configuration
      REDIS_HOST: patchmon-redis
      REDIS_PORT: 6379
      REDIS_PASSWORD: redis_pass
      REDIS_DB: 0
    volumes:
      - ./agent_files:/app/agents
    depends_on:
      patchmon-db:
        condition: service_healthy
      patchmon-redis:
        condition: service_healthy

  frontend:
    image: ghcr.io/patchmon/patchmon-frontend:latest
    restart: unless-stopped
    ports:
      - 3000:3000
    depends_on:
      backend:
        condition: service_healthy

  patchmon-db:
    image: postgres:17-alpine
    restart: unless-stopped
    environment:
      POSTGRES_DB: patchmon_db
      POSTGRES_USER: patchmon_user
      POSTGRES_PASSWORD: patchmon_pass
    volumes:
      - ./postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U patchmon_user -d patchmon_db"]
      interval: 3s
      timeout: 5s
      retries: 7

  patchmon-redis:
    image: redis:7-alpine
    restart: unless-stopped
    command: redis-server --requirepass redis_pass
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "--no-auth-warning", "-a", "redis_pass", "ping"]
      interval: 3s
      timeout: 5s
      retries: 7
```

### Scrutiny

[Scrutiny](https://github.com/AnalogJ/scrutiny) - решение для мониторинга и управления состоянием жесткого диска, объединяющее предоставленные производителем показатели SMART с реальными показателями отказов. Встроенная интеграция со `smartd`, автоматическое определение всех подключенных жестких дисков и настройка уведомлений через web-hook.

```yaml
services:
  scrutiny:
    container_name: scrutiny
    image: ghcr.io/analogj/scrutiny:master-omnibus
    cap_add:
      - SYS_RAWIO
    ports:
      - 8085:8080 # Web UI
      - 8086:8086 # influxDB admin
    volumes:
      - /run/udev:/run/udev:ro
      - ./config:/opt/scrutiny/config
      - ./influxdb:/opt/scrutiny/influxdb
    devices:
      - /dev/sda
      # Raspberry Pi
      # - /dev/mmcblk0
      # - /dev/mmcblk0p1
      # - /dev/mmcblk0p2
```

### QDirStat

[QDirStat](https://github.com/shundhammer/qdirstat) - графическое приложение для анализа дискового пространства в стиле [WizTree](https://diskanalyzer.com) и [SpaceSniffer](https://sourceforge.net/projects/spacesniffer), которое предоставляет визуализацию размера папок и файлов в древовидном и цветном формате.


```yaml
services:
  qdirstat:
    image: jlesage/qdirstat
    container_name: qdirstat
    restart: unless-stopped
    ports:
      - 5800:5800
    volumes:
      - ./qdirstat_conf:/config:rw
      - ./qdirstat_data:/storage:ro
```

### GPU Hot

[GPU Hot](https://github.com/psalias2006/gpu-hot) - панель мониторинга графических процессоров Nvidia в режиме реального времени.

```yaml
services:
  gpu-hot:
    image: ghcr.io/psalias2006/gpu-hot:latest
    container_name: gpu-hot
    restart: unless-stopped
    init: true
    pid: host
    ports:
      - 1312:1312
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - NVIDIA_DRIVER_CAPABILITIES=all
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:1312/api/gpu-data"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

## Homelab Stack

### Home Assistant

[Home Assistant](https://github.com/home-assistant/core) - система домашней автоматизации для управления умными устройствами.

🔗 [Home Assistant Demo](https://demo.home-assistant.io/#/lovelace/home) ↗

```yaml
services:
  home-assistant:
    image: ghcr.io/home-assistant/home-assistant:stable
    container_name: home-assistant
    restart: unless-stopped
    privileged: true
    network_mode: host
    # ports:
    #   - 8123:8123
    volumes:
      - ./config:/config
      - /etc/localtime:/etc/localtime:ro
      - /run/dbus:/run/dbus:ro
```

### Bluehood

[Bluehood](https://github.com/dannymcc/bluehood) - отслеживает Bluetooth-устройства поблизости, позволяя определять присутствия и отсутствия клиента на основе наличия устройств, например, прихода домой.

```yaml
services:
  bluehood:
    image: ghcr.io/dannymcc/bluehood:latest
    container_name: bluehood
    restart: unless-stopped
    privileged: true
    # http://localhost:8080
    network_mode: host
    volumes:
      - /var/run/dbus:/var/run/dbus:ro
      - ./bluehood_data:/data
    # environment:
    #   - PUID=1000            # id -u
    #   - PGID=1000            # id -g
    #   - TZ=Europe/London     # timezone
    #   - BLUEHOOD_ADAPTER=hci0
    #   - BLUEHOOD_CLASSIC_ADAPTER=hci1
    #   - BLUEHOOD_HEARTBEAT_URL=https://hc-ping.com/your-uuid
    #   - BLUEHOOD_HEARTBEAT_INTERVAL=300
    #   - BLUEHOOD_PRUNE_DAYS=90
    healthcheck:
      test: >
        sh -c 'dbus-send --system --dest=org.freedesktop.DBus
        --type=method_call --print-reply /org/freedesktop/DBus
        org.freedesktop.DBus.ListNames 2>/dev/null | grep -q org.bluez
        || (echo "ERROR: BlueZ (org.bluez) not found on host. Install it with: sudo apt install bluez && sudo systemctl enable --now bluetooth" && exit 1)'
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 10s
```

### Home Page

[Home Page](https://github.com/gethomepage/homepage) - быстрая и полностью статическая панель управления для быстрого доступа к веб-приложениям в формате закладок. Поддерживает мониторинг доступности веб-сервисов с помощью ICMP и HTTP, нагрузки CPU, памяти и сетевого трафика контейнеров Docker через сокет, автоматическое обнаружение приложений с помощь labels, подключение через конфигурацию к приложениям в кластерах Kubernetes и мониторинг сервисов через API (поддерживает более 100 интеграций с помощью [виджетов](https://gethomepage.dev/widgets)).

```yaml
services:
  homepage:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: homepage
    restart: always
    environment:
      HOMEPAGE_ALLOWED_HOSTS: "*"
      PUID: 0
      PGID: 0
    ports:
      - 5005:3000
    volumes:
      - ./homepage_config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - $HOME/.kube/config:/root/.kube/config:ro
    labels:
      - traefik.enable=true
      - traefik.http.routers.homepage.rule=Host(`home.docker.local`)
      - traefik.http.routers.homepage.middlewares=authentik@file
```

### Glances

[Glances](https://github.com/nicolargo/glances) - TUI интерфейс мониторинга системы, процессов (как top или htop) и контейнеров (как [ctop](https://github.com/bcicen/ctop)), а также Web режим с адаптивным дизайном для смартфонов. Используется для интеграции показателей в Homepage через виджеты, а также поддерживает экспорт метрик в InfluxDB, Prometheus, PostgreSQL/TimeScaleDB, Graphite и другие базы данных.

```yaml
services:
  glances:
    image: nicolargo/glances:latest-full
    container_name: glances
    restart: always
    pid: host
    # stdin_open: true
    # tty: true
    # network_mode: host
    environment:
      - GLANCES_OPT=-w # --export prometheus
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      # - /run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock:ro
      # - ./glances.conf:/glances/conf/glances.conf
    ports:
      - 61208-61209:61208-61209
      # - 9091:9091
    labels:
      - homepage.group=Docker Containers
      - homepage.name=Glances
      - homepage.icon=glances.png
      - homepage.href=http://glances.docker.local
```

### Cosmos Server

Cosmos Server - система самостоятельного размещения домашнего сервера, в качестве защищенного шлюза для приложений. Поддерживает установку приложений в контейнерах из магазина и мониторинг сервисов.

🔗 [Cosmos Demo](https://cosmos-cloud.io/cosmos-ui) ↗

```yaml
services:
  cosmos-server:
    image: azukaar/cosmos-server:latest
    container_name: cosmos-server
    restart: always
    privileged: true
    ports:
      - 8808:80
      - 4433:443
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket
      - /:/mnt/host
      - /var/lib/cosmos:/config
```


### Glance

[Glance](https://github.com/glanceapp/glance) - панель управления, которая объединяет все RSS каналы в одном месте, с встроенной поддержкой Hacker News posts, subreddit, YouTube channel, Twitch channels, релизы GitHub, статусы контейнеров Docker и другие возможности [конфигурации](https://github.com/glanceapp/glance/blob/main/docs/configuration.md#configuring-glance).

```yaml
services:
  glance:
    image: glanceapp/glance:latest
    container_name: glance
    restart: unless-stopped
    volumes:
      - ./glance_config:/app/config
    ports:
      - 9111:8080
```

### Linkwarden

[Linkwarden](https://github.com/linkwarden/linkwarden) - самостоятельный менеджер закладок с открытым исходным кодом для совместной работы, позволяющий собирать, читать, комментировать и полностью сохранять все важное в одном месте.

```yaml
services:
  linkwarden-db:
    image: postgres:16-alpine
    restart: always
    environment:
      - POSTGRES_DB=linkwarden
      - POSTGRES_USER=linkwarden
      - POSTGRES_PASSWORD=linkwarden
    volumes:
      - ./db_data:/var/lib/postgresql/data

  linkwarden:
    image: ghcr.io/linkwarden/linkwarden:latest
    restart: always
    environment:
      - DATABASE_URL=postgresql://linkwarden:linkwarden@linkwarden-db:5432/linkwarden
    ports:
      - 3000:3000
    volumes:
      - ./linkwarden_data:/data/data
    depends_on:
      - linkwarden-db
      - meilisearch

  meilisearch:
    image: getmeili/meilisearch:v1.12.8
    restart: always
    volumes:
      - ./meili_data:/meili_data
```

### Dashy

[Dashy](https://github.com/Lissy93/dashy) - панель управления, которая поддерживает мониторинг статуса, виджеты для отображения информации и динамического контента из собственных сервисов, темы, наборы значков, редактор пользовательского интерфейса, SSO, конфигурация на основе одного yaml файла, а также возможность настройки через веб-интерфейс

🔗 [Dashy Demo](https://demo.dashy.to) ↗

```yaml
services:
  dashy:
    image: lissy93/dashy:latest
    container_name: dashy
    restart: unless-stopped
    ports:
      - 5005:8080
    environment:
      - NODE_ENV=production
```

### Heimdall

[Heimdall](https://github.com/linuxserver/Heimdall) - панель управления для любых ссылок на веб-приложения, от создателей проекта [Linuxserver](https://www.linuxserver.io/).

```yaml
services:
  heimdall:
    image: lscr.io/linuxserver/heimdall:latest
    container_name: heimdall
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/GMT+3
      - ALLOW_INTERNAL_REQUESTS=true
    volumes:
      - ./heimdall_config:/config
    ports:
      - 5005:443
```

### Flame

[Flame](https://github.com/pawelmalak/flame) - стартовая страница для вашего сервера, размещаемая на собственном сервере. Дизайн вдохновлен [SUI](https://github.com/jeroenpardon/sui), поддерживает аутентификацию, встроенный редактор для добавления и обновления закладок, а также интеграция с Docker и Kubernetes для автоматического добавления приложений на основе labels.

```yaml
services:
  flame:
    image: pawelmalak/flame
    container_name: flame
    restart: unless-stopped
    volumes:
      - ./flame_data:/app/data
      - /var/run/docker.sock:/var/run/docker.sock:ro # for Docker integration
    ports:
      - 5005:5005
    environment:
      - PASSWORD=FlamePassword
      # - PASSWORD_FILE=/run/secrets/password
    secrets:
      - flame_password
    labels:
      - flame.type=application
      - flame.name=Flame
      - flame.url=https://flame.docker.local
      - flame.icon=flame # optional, default is "docker"

# secrets:
#   password:
#     file: ./flame_password

# echo "FlamePassword" > ./flame_password
```

### ThinkDashboard

[ThinkDashboard](https://github.com/MatiasDesuu/ThinkDashboard) - легковесная, размещаемая на собственном сервере панель закладок, созданная на Go и чистом JavaScript.

```yaml
services:
  thinkdashboard:
    image: ghcr.io/matiasdesuu/thinkdashboard:latest
    container_name: thinkdashboard
    restart: unless-stopped
    environment:
      - PORT=8080
    ports:
      - 8080:8080
    volumes:
      - ./thinkdashboard_data:/app/data
```

### Memos

[Memos](https://github.com/usememos/memos) - сервис заметок (like Google Keep) с поддержкой синтаксиса Merkdown и интеграцией с Telegram (запись теста и файлов через бота).

🔗 [Memos Demo](https://demo.usememos.com/explore) ↗

> [!NOTE]
> Для бота используется неофициальный образ [lifailon/memogram](https://hub.docker.com/r/lifailon/memogram), собранный в репозитории [ruDocs](https://github.com/Lifailon/rudocs) для публичного использования.

```yaml
services:
  memos:
    image: neosmemo/memos:stable
    container_name: memos
    restart: unless-stopped
    ports:
      - 5230:5230
    volumes:
      - ./memos_data:/var/opt/memos

  memogram:
    image: lifailon/memogram:0.3.0-amd64
    # build:
    #   context: .
    #   dockerfile: Dockerfile
    container_name: memogram
    restart: unless-stopped
    environment:
      - SERVER_ADDR=memos:5230
      - BOT_TOKEN=
      - ALLOWED_USERNAMES=
```

### Luna

[Luna](https://github.com/Opisek/luna) - веб-интерфейс и агрегатор календарей, с поддержкой протоколов CalDAV , iCal и Google Calendar.

```yaml
services:
  luna-frontend:
    build:
      context: frontend
      dockerfile: Dockerfile
    container_name: luna-frontend
    restart: unless-stopped
    ports:
      - 8080:8080
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    environment:
      PORT: 8080
      PUBLIC_URL: https://cal.example.com
      API_URL: http://luna-backend:3000

  luna-backend:
    build:
      context: backend
      dockerfile: Dockerfile
    container_name: luna-backend
    restart: unless-stopped
    volumes:
      - ./luna_data:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    environment:
      PUBLIC_URL: https://cal.example.com
      DB_HOST: luna-postgres
      DB_PORT: 5432
      DB_USERNAME: luna
      DB_PASSWORD: luna
      DB_DATABASE: luna
    depends_on:
      - luna-postgres

  luna-postgres:
    image: postgres:16-alpine
    restart: unless-stopped
    container_name: luna-postgres
    volumes:
      - ./luna_postgres:/var/lib/postgresql/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    environment:
      POSTGRES_USER: luna
      POSTGRES_PASSWORD: luna
      POSTGRES_DB: luna
```

### Immich (Google Photo)

[Immich](https://github.com/immich-app/immich) - система хранения и просмотра фото и видео (клон Google Photo).

🔗 [Immich Demo](https://demo.immich.app) ↗

```yaml
services:
  immich-server:
    image: ghcr.io/immich-app/immich-server:release
    container_name: immich-server
    restart: unless-stopped
    volumes:
      - ./upload_data:/data
      - /etc/localtime:/etc/localtime:ro
    environment:
      - UPLOAD_LOCATION=./data
      - DB_DATA_LOCATION=./postgres
      - TZ=Etc/UTC+3
      - IMMICH_VERSION=v2
      - DB_DATABASE_NAME=immich
      - DB_USERNAME=immich
      - DB_PASSWORD=immich
    ports:
      - 2283:2283
    healthcheck:
      disable: false
    depends_on:
      - redis
      - database

  immich-machine-learning:
    image: ghcr.io/immich-app/immich-machine-learning:release
    container_name: immich-machine-learning
    restart: unless-stopped
    volumes:
      - ./model_cache:/cache
    environment:
      - UPLOAD_LOCATION=./data
      - DB_DATA_LOCATION=./postgres
      - TZ=Etc/UTC+3
      - IMMICH_VERSION=v2
      - DB_DATABASE_NAME=immich
      - DB_USERNAME=immich
      - DB_PASSWORD=immich
    healthcheck:
      disable: false

  redis:
    image: docker.io/valkey/valkey:8-bookworm@sha256:fea8b3e67b15729d4bb70589eb03367bab9ad1ee89c876f54327fc7c6e618571
    container_name: immich-redis
    restart: unless-stopped
    healthcheck:
      test: redis-cli ping || exit 1

  database:
    image: ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:41eacbe83eca995561fe43814fd4891e16e39632806253848efaf04d3c8a8b84
    container_name: immich-database
    restart: unless-stopped
    environment:
      POSTGRES_DB: immich
      POSTGRES_USER: immich
      POSTGRES_PASSWORD: immich
      POSTGRES_INITDB_ARGS: '--data-checksums'
    volumes:
      - ./db_data:/var/lib/postgresql/data
    shm_size: 128mb
```

### PhotoPrism

[PhotoPrism](https://github.com/photoprism/photoprism) - приложение для работы с фотографиями на базе искусственного интеллекта, используя современные технологии для автоматического добавления тегов и поиска изображений.

🔗 [PhotoPrism Demo](https://demo.photoprism.app/library/browse) ↗

```yaml
services:
  photoprism:
    image: photoprism/photoprism:latest
    container_name: photoprism
    restart: unless-stopped
    stop_grace_period: 15s
    security_opt:
      - seccomp:unconfined
      - apparmor:unconfined
    ports:
      - 2342:2342
    environment:
      PHOTOPRISM_ADMIN_USER: "admin"                 # admin login username
      PHOTOPRISM_ADMIN_PASSWORD: "insecure"          # initial admin password (8-72 characters)
      PHOTOPRISM_AUTH_MODE: "password"               # authentication mode (public, password)
      PHOTOPRISM_DISABLE_TLS: "false"                # disables HTTPS/TLS even if the site URL starts with https:// and a certificate is available
      PHOTOPRISM_DEFAULT_TLS: "true"                 # defaults to a self-signed HTTPS/TLS certificate if no other certificate is available
      PHOTOPRISM_DEFAULT_LOCALE: "en"                # default user interface language, e.g. "en" or "de"
      PHOTOPRISM_PLACES_LOCALE: "local"              # location details language, e.g. "local", "en", or "de"
      PHOTOPRISM_SITE_URL: "http://localhost:2342/"  # server URL in the format "http(s)://domain.name(:port)/(path)"
      PHOTOPRISM_SITE_TITLE: "PhotoPrism"
      PHOTOPRISM_SITE_CAPTION: "AI-Powered Photos App"
      PHOTOPRISM_SITE_DESCRIPTION: ""                # meta site description
      PHOTOPRISM_SITE_AUTHOR: ""                     # meta site author
      PHOTOPRISM_LOG_LEVEL: "info"                   # log level: trace, debug, info, warning, or error
      PHOTOPRISM_READONLY: "false"                   # do not modify originals directory (reduced functionality)
      PHOTOPRISM_EXPERIMENTAL: "false"               # enables experimental features
      PHOTOPRISM_DISABLE_CHOWN: "false"              # disables updating storage permissions via chmod and chown on startup
      PHOTOPRISM_DISABLE_WEBDAV: "false"             # disables built-in WebDAV server
      PHOTOPRISM_DISABLE_SETTINGS: "false"           # disables settings UI and API
      PHOTOPRISM_DISABLE_TENSORFLOW: "false"         # disables all features depending on TensorFlow
      PHOTOPRISM_DISABLE_FACES: "false"              # disables face detection and recognition (requires TensorFlow)
      PHOTOPRISM_DISABLE_CLASSIFICATION: "false"     # disables image classification (requires TensorFlow)
      PHOTOPRISM_DISABLE_VECTORS: "false"            # disables vector graphics support
      PHOTOPRISM_DISABLE_RAW: "false"                # disables indexing and conversion of RAW images
      PHOTOPRISM_RAW_PRESETS: "false"                # enables applying user presets when converting RAW images (reduces performance)
      PHOTOPRISM_SIDECAR_YAML: "true"                # creates YAML sidecar files to back up picture metadata
      PHOTOPRISM_BACKUP_ALBUMS: "true"               # creates YAML files to back up album metadata
      PHOTOPRISM_BACKUP_DATABASE: "true"             # creates regular backups based on the configured schedule
      PHOTOPRISM_BACKUP_SCHEDULE: "daily"            # backup SCHEDULE in cron format (e.g. "0 12 * * *" for daily at noon) or at a random time (daily, weekly)
      PHOTOPRISM_INDEX_SCHEDULE: ""                  # indexing SCHEDULE in cron format (e.g. "@every 3h" for every 3 hours; "" to disable)
      PHOTOPRISM_AUTO_INDEX: 300                     # delay before automatically indexing files in SECONDS when uploading via WebDAV (-1 to disable)
      PHOTOPRISM_AUTO_IMPORT: -1                     # delay before automatically importing files in SECONDS when uploading via WebDAV (-1 to disable)
      PHOTOPRISM_DETECT_NSFW: "false"                # automatically flags photos as private that MAY be offensive (requires TensorFlow)
      PHOTOPRISM_UPLOAD_NSFW: "true"                 # allows uploads that MAY be offensive (no effect without TensorFlow)
      PHOTOPRISM_UPLOAD_ALLOW: ""                    # restricts uploads to these file types (comma-separated list of EXTENSIONS; leave blank to allow all)
      PHOTOPRISM_UPLOAD_ARCHIVES: "true"             # allows upload of zip archives (will be extracted before import)
      PHOTOPRISM_UPLOAD_LIMIT: 5000                  # maximum size of uploaded files and uncompressed archive contents in MB
      PHOTOPRISM_ORIGINALS_LIMIT: 5000               # maximum size of original media files in MB (larger files are skipped)
      PHOTOPRISM_HTTP_COMPRESSION: "gzip"            # improves transfer speed and bandwidth utilization (none or gzip)
      # PHOTOPRISM_DATABASE_DRIVER: "sqlite"         # SQLite is an embedded database that does not require a separate database server
      PHOTOPRISM_DATABASE_DRIVER: "mysql"            # MariaDB 10.5.12+ (MySQL successor) offers significantly better performance compared to SQLite
      PHOTOPRISM_DATABASE_SERVER: "mariadb:3306"     # MariaDB database server (hostname:port)
      PHOTOPRISM_DATABASE_NAME: "photoprism"         # MariaDB database, see MARIADB_DATABASE in the mariadb service
      PHOTOPRISM_DATABASE_USER: "photoprism"         # MariaDB database username, must be the same as MARIADB_USER
      PHOTOPRISM_DATABASE_PASSWORD: "insecure"       # MariaDB database password, must be the same as MARIADB_PASSWORD
      PHOTOPRISM_INIT: "https tensorflow"            # options: update https tensorflow tensorflow-gpu intel gpu davfs yt-dlp
      PHOTOPRISM_VISION_API: "false"                 # server: enables service API endpoints under /api/v1/vision (requires access token)
      PHOTOPRISM_VISION_URI: ""                      # client: service URI, e.g. http://hostname/api/v1/vision (leave blank to disable)
      PHOTOPRISM_VISION_KEY: ""                      # client: service access token (for authentication)
      # PHOTOPRISM_FFMPEG_ENCODER: "software"        # H.264/AVC encoder (software, intel, nvidia, apple, raspberry, or vaapi)
      # PHOTOPRISM_FFMPEG_SIZE: "1920"               # video size limit in pixels (720-7680) (default: 3840)
      # PHOTOPRISM_FFMPEG_BITRATE: "64"              # video bitrate limit in Mbps (default: 60)
      # NVIDIA_VISIBLE_DEVICES: "all"
      # NVIDIA_DRIVER_CAPABILITIES: "all"
      PHOTOPRISM_UID: 0
      PHOTOPRISM_GID: 0
    user: 0:0
    working_dir: /photoprism
    volumes:
      - ./photoprism_content:/photoprism/originals   # Media files
      - ./photoprism_data:/photoprism/storage        # Cache, database (sqlite) and sidecar files
    # devices:
    #  - /dev/dri:/dev/dri                            # Required Intel QSV or VAAPI hardware transcoding
    #  - /dev/video11:/dev/video11                    # Video4Linux Video Encode Device (h264_v4l2m2m)
    # deploy:
    #  resources:
    #    reservations:
    #      devices:
    #        - driver: "nvidia"
    #          capabilities: [ gpu ]
    #          count: "all"
    depends_on:
      - mariadb

  mariadb:
    image: mariadb:11
    container_name: mariadb
    restart: unless-stopped
    stop_grace_period: 15s
    security_opt:
      - seccomp:unconfined
      - apparmor:unconfined
    command: --innodb-buffer-pool-size=512M --transaction-isolation=READ-COMMITTED --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --max-connections=512 --innodb-rollback-on-timeout=OFF --innodb-lock-wait-timeout=120
    volumes:
      - ./database_data:/var/lib/mysql
    # https://link.photoprism.app/mariadb-enviconment-variables
    environment:
      MARIADB_AUTO_UPGRADE: "1"
      MARIADB_INITDB_SKIP_TZINFO: "1"
      MARIADB_DATABASE: "photoprism"
      MARIADB_USER: "photoprism"
      MARIADB_PASSWORD: "insecure"
      MARIADB_ROOT_PASSWORD: "insecure"
      # Replicate
      # MARIADB_MASTER_HOST: ""
      # MARIADB_REPLICATION_USER: ""
      # MARIADB_REPLICATION_PASSWORD: ""

  ollama:
    image: ollama/ollama:latest
    restart: unless-stopped
    stop_grace_period: 15s
    profiles: ["ollama"]
    environment:
      ## Ollama Configuration Options:
      OLLAMA_HOST: "0.0.0.0:11434"
      OLLAMA_MODELS: "/root/.ollama"   # model storage path (see volumes section below)
      OLLAMA_MAX_QUEUE: "100"          # maximum number of queued requests
      OLLAMA_NUM_PARALLEL: "1"         # maximum number of parallel requests
      OLLAMA_MAX_LOADED_MODELS: "1"    # maximum number of loaded models per GPU
      OLLAMA_LOAD_TIMEOUT: "5m"        # maximum time for loading models (default "5m")
      OLLAMA_KEEP_ALIVE: "5m"          # duration that models stay loaded in memory (default "5m")
      OLLAMA_CONTEXT_LENGTH: "4096"    # maximum input context length
      OLLAMA_MULTIUSER_CACHE: "false"  # optimize prompt caching for multi-user scenarios
      OLLAMA_NOPRUNE: "false"          # disables pruning of model blobs at startup
      OLLAMA_NOHISTORY: "true"         # disables readline history
      OLLAMA_FLASH_ATTENTION: "false"  # enables the experimental flash attention feature
      OLLAMA_KV_CACHE_TYPE: "f16"      # cache quantization (f16, q8_0, or q4_0)
      OLLAMA_SCHED_SPREAD: "false"     # allows scheduling models across all GPUs.
      OLLAMA_NEW_ENGINE: "true"        # enables the new Ollama engine
      # OLLAMA_DEBUG: "true"           # shows additional debug information
      # OLLAMA_INTEL_GPU: "true"       # enables experimental Intel GPU detection
      # NVIDIA_VISIBLE_DEVICES: "all"
      # NVIDIA_DRIVER_CAPABILITIES: "compute,utility"
    volumes:
      - "./ollama_data:/root/.ollama"
    ports:
     - 11434:11434
    # deploy:
    #  resources:
    #    reservations:
    #      devices:
    #        - driver: "nvidia"
    #          capabilities: [ gpu ]
    #          count: "all"

  # docker compose up -d
  # or
  # docker compose --profile ollama up -d
  # Download LLM model:
  # docker compose exec ollama ollama pull gemma3:latest
```

### Jitsi Meet

[Jitsi Meet](https://github.com/jitsi/jitsi-meet) - система видео-конференц связи (ВКС/VCS), с выделенными комнатами и управлением доступа (поддерживает демонстрацию экрана и запись разговоров).

```yaml
services:
  # Frontend
  web:
    image: jitsi/web:unstable
    restart: unless-stopped
    ports:
      - 10080:80
      - 10443:443
    volumes:
      - ./jitsi_data/web:/config:Z
      - ./jitsi_data/web/crontabs:/var/spool/cron/crontabs:Z
      - ./jitsi_data/transcripts:/usr/share/jitsi-meet/transcripts:Z
      - ./jitsi_data/web/load-test:/usr/share/jitsi-meet/load-test:Z
    labels:
      service: jitsi-web
    depends_on:
      - jvb

  # XMPP server
  prosody:
    image: jitsi/prosody:unstable
    restart: unless-stopped
    expose:
      - 5222
      - 5269
      - 5347
      - 5280
    labels:
      service: jitsi-prosody
    volumes:
      - ./jitsi_data/prosody/config:/config:Z
      - ./jitsi_data/prosody/prosody-plugins-custom:/prosody-plugins-custom:Z

  # Focus component
  jicofo:
    image: jitsi/jicofo:unstable
    restart: unless-stopped
    ports:
      - 18888:8888
    volumes:
      - ./jitsi_data/jicofo:/config:Z
    labels:
      service: jitsi-jicofo
    depends_on:
      - prosody

  # Video bridge
  jvb:
    image: jitsi/jvb:unstable
    restart: unless-stopped
    ports:
      - 10000:10000/udp
      - 10080:8080
    volumes:
      - ./jitsi_data/jvb:/config:Z
    labels:
      service: jitsi-jvb
    depends_on:
      - prosody
```

### Grist (Excel)

[Grist](https://github.com/gristlabs/grist-core) (like MS Excel) - современный реляционный редактор электронных таблиц в вебе и приложением рабочего стола, как достойная замена Microsoft Excel.

🔗 [Grist Playground](https://docs.getgrist.com) ↗

🔗 [Grist Static Playground](https://gristlabs.github.io/grist-static) ↗

🔗 [Grist Desktop](https://github.com/gristlabs/grist-desktop/releases/tag/v0.3.6) ↗

```yaml
services:
  grist:
    image: gristlabs/grist:latest
    container_name: grist
    restart: unless-stopped
    environment:
      APP_HOME_URL: https://grist.docker.local
      GRIST_DEFAULT_EMAIL: admin@docker.local
      GRIST_FORCE_LOGIN: false
    volumes:
      - ./grist_data:/persist
    ports:
      - 8484:8484
    labels:
      - traefik.http.services.grist.loadbalancer.server.port=8484
      - traefik.http.routers.grist.rule=Host(`grist.docker.local`)
      # - traefik.http.routers.grist-auth.rule=Host(`grist.docker.local`) && (PathPrefix(`/auth/login`) || PathPrefix(`/_oauth`))
      # - traefik.http.routers.grist-auth.middlewares=grist-basic-auth@file
      # - traefik.http.middlewares.grist-basic-auth.basicauth.users=admin:$$2y$$05$$c0r5A6SCKX4R6FjuCgRqrufbIE5tmXw2sDPq1vZ8zNrrwNZIH9jgW # admin:admin
```

### Paperless-NGX

[Paperless-NGX](https://github.com/paperless-ngx/paperless-ngx) - веб-интерфейс для хранения и просмотра документов. Поддерживает распознавание текста на документах с помощью Tesseract, что позволяет индексировать содержимое для быстрого поиска документов по содержимому.

```yaml
services:
  paperless-ngx:
    image: lscr.io/linuxserver/paperless-ngx:latest
    container_name: paperless-ngx
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
    ports:
      - 8000:8000
    volumes:
      - ./paperless_config:/config
      - ./paperless_data:/data
```

### ArchiveBox

[ArchiveBox](https://github.com/ArchiveBox/ArchiveBox) - веб-приложение для сохранения контент с веб-сайтов в форматах `HTML`, `PNG`, `PDF`, `TXT`, `JSON`, `WARC` и `SQLite`. Предлагает cli, `REST API` и Webhooks для интеграции с другими сервисами. Позволяет автоматически сохранять копии веб-страниц, видео и другого контента на личном сервере, чтобы информация оставалась доступной, даже если оригинал будет удален из сети Интернет.

🔗 [ArchiveBox Demo](https://demo.archivebox.io/public) ↗

```yaml
services:
  archivebox:
    image: archivebox/archivebox:latest
    container_name: archivebox
    restart: unless-stopped
    ports:
      - 7733:8000
    volumes:
      - ./archivebox_data:/data
    environment:
      - ADMIN_USERNAME=admin
      - ADMIN_PASSWORD=admin
      - ALLOWED_HOSTS=*
      - CSRF_TRUSTED_ORIGINS=http://archivebox.docker.local
      - PUBLIC_INDEX=True
      - PUBLIC_SNAPSHOTS=True
      - PUBLIC_ADD_VIEW=False
      - SEARCH_BACKEND_ENGINE=sonic
      - SEARCH_BACKEND_HOST_NAME=sonic
      - SEARCH_BACKEND_PASSWORD=AdminSecret
      - PUID=911
      - PGID=911

  archivebox_scheduler:
    image: archivebox/archivebox:latest
    container_name: archivebox_scheduler
    restart: unless-stopped
    command: schedule --foreground --update --every=day
    volumes:
      - ./archivebox_scheduler_data:/data
    environment:
      - PUID=911
      - PGID=911
      - TIMEOUT=120
      - SEARCH_BACKEND_ENGINE=sonic
      - SEARCH_BACKEND_HOST_NAME=sonic
      - SEARCH_BACKEND_PASSWORD=AdminSecret

  archivebox_sonic:
    image: archivebox/sonic:latest
    container_name: archivebox_sonic
    restart: unless-stopped
    expose:
      - 1491
    volumes:
      - ./archivebox_sonic:/var/lib/sonic/store
      #- ./sonic.cfg:/etc/sonic.cfg:ro    # https://raw.githubusercontent.com/ArchiveBox/ArchiveBox/stable/etc/sonic.cfg
    environment:
      - SEARCH_BACKEND_PASSWORD=AdminSecret

  novnc:
    image: theasp/novnc:latest
    container_name: novnc
    restart: unless-stopped
    ports:
      - 8080:8080
    environment:
      - DISPLAY_WIDTH=1920
      - DISPLAY_HEIGHT=1080
      - RUN_XTERM=no
```

### MeTube

[MeTube](https://github.com/alexta69/metube) - Веб-интерфейс для загрузки видео из YouTube с помощь [yt-dlp](https://github.com/yt-dlp/yt-dlp).

```yaml
services:
  metube:
    image: ghcr.io/alexta69/metube
    container_name: metube
    restart: unless-stopped
    ports:
      - "8090:8081"
    volumes:
      # Директория для хранения видео в хостовой системе : контейнере
      - ./downloads:/downloads
```

### Invidious

[Invidious](https://github.com/iv-org/invidious) - альтернативный интерфейс YouTube с открытым исходным кодом.

```yaml
services:
  invidious:
    # docker run quay.io/invidious/youtube-trusted-session-generator
    image: quay.io/invidious/invidious:latest
    build:
      context: .
      dockerfile: docker/Dockerfile
    container_name: invidious
    restart: unless-stopped
    ports:
      - 3000:3000
    environment:
      # Gen password for hmac_key: pwgen 20 1
      INVIDIOUS_CONFIG: |
        db:
          dbname: invidious
          user: kemal
          password: kemal
          host: invidious-db
          port: 5432
        check_tables: true
        # external_port:
        # domain:
        # https_only: false
        # statistics_enabled: false
        hmac_key: "aiph2EeShu6ohng0ohqu"
    healthcheck:
      test: wget -nv --tries=1 --spider http://127.0.0.1:3000/api/v1/trending || exit 1
      interval: 30s
      timeout: 5s
      retries: 2

  invidious-db:
    image: docker.io/library/postgres:14
    container_name: invidious-db
    restart: unless-stopped
    volumes:
      - ./invidious_db:/var/lib/postgresql/data
      - ./invidious_data/config/sql:/config/sql
      - ./invidious_data/docker/init-invidious-db.sh:/docker-entrypoint-initdb.d/init-invidious-db.sh
    environment:
      POSTGRES_DB: invidious
      POSTGRES_USER: kemal
      POSTGRES_PASSWORD: kemal
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $$POSTGRES_USER -d $$POSTGRES_DB"]
```

### ReClip

[ReClip](https://github.com/averygan/reclip) - веб-интерфейс для загрузки видео и аудио с YouTube, TikTok, Instagram, Twitter/X и более чем 1000 других сайтов через [yt-dlp](https://github.com/yt-dlp/yt-dlp) в формате MP4 или MP3, с поддержкой выбора качества и разрешения. Фронтенд без фреймворков и этапа сборки на чистом HTML и бэкенд в одном файле Python на 150 строк.

> [!NOTE]
> Используется неофициальный образ [lifailon/reclip](https://hub.docker.com/r/lifailon/reclip), собранный в репозитории [ruDocs](https://github.com/Lifailon/rudocs) для публичного использования.

```yaml
services:
  reclip:
    image: lifailon/reclip:latest
    container_name: reclip
    restart: unless-stopped
    ports:
      - 8899:8899
```

### VidBee

[VidBee](https://github.com/nexmoe/VidBee) - открытый видеозагрузчик, позволяющий скачивать видео и аудио с более чем 1000 платформ по всему миру, например, YouTube, TikTok, Twitter и другие.

```yaml
services:
  vidbee-api:
    image: ghcr.io/nexmoe/vidbee-api:latest
    container_name: vidbee-api
    restart: unless-stopped
    environment:
      VIDBEE_API_HOST: 0.0.0.0
      VIDBEE_API_PORT: 3100
      VIDBEE_DOWNLOAD_DIR: /data/downloads
      VIDBEE_HISTORY_STORE_PATH: /data/vidbee/vidbee.db
    ports:
      - 3100:3100
    volumes:
      - ./vidbee_downloads:/data/downloads
      - ./vidbee_data:/data/vidbee

  vidbee-web:
    image: ghcr.io/nexmoe/vidbee-web:latest
    container_name: vidbee-web
    restart: unless-stopped
    ports:
      - 3000:3000
    depends_on:
      - vidbee-api
```

### EternalVows

[EternalVows](https://github.com/jacoknapp/EternalVows) - легковесный шаблон свадебного сайта для самостоятельного размещений. Позволяет настроить имена, дату, место проведения, историю, расписание, детали площадки (с картой), ссылки на подарочные реестры, часто задаваемые вопросы и опциональные ссылки для обмена фотографиями через YAML файл без необходимости пересборки.

```yaml
services:
  eternalvows:
    image: ghcr.io/jacoknapp/eternalvows:latest
    container_name: eternalvows
    restart: unless-stopped
    environment:
      - PORT=5500
    ports:
      - 5500:5500
    volumes:
      - ./config:/app/config
```

### It's MyTabs

[It's MyTabs](https://github.com/louislam/its-mytabs) - веб-интерфейс для просмотра и проигрывания табулатуры гитары, похожий на [Songsterr](https://www.songsterr.com), от создателя [Uptime-Kuma](https://github.com/louislam/uptime-kuma) и [Dockge](https://github.com/louislam/dockge).

🔗 [It's MyTabs Playground](https://its-mytabs.kuma.pet/tab/1?audio=youtube-VuKSlOT__9s&track=2) ↗

```yaml
services:
  its-mytabs:
    image: louislam/its-mytabs:1
    container_name: its-mytabs
    restart: unless-stopped
    ports:
      - 47777:47777
    volumes:
      - ./data:/app/data # db and tabs
```

### Guacamole

[Apache Guacamole](https://github.com/apache/guacamole-server) — это клиент-серверное веб-приложение для централизованного удаленного доступа к серверам и рабочим столам на основе протоколов RDP, VNC и SSH через веб-браузер и управления доступом.

```yaml
services:
  guacd:
    image: guacamole/guacd
    container_name: gua-cd
    restart: unless-stopped
    volumes:
    - ./drive:/drive:rw
    - ./record:/record:rw

  guacamole-db:
    image: postgres:15.2-alpine
    container_name: guacamole-db
    restart: unless-stopped
    environment:
      PGDATA: /var/lib/postgresql/data/guacamole
      POSTGRES_DB: guacamole_db
      POSTGRES_USER: guacamole_user
      POSTGRES_PASSWORD: PgAdmin
    volumes:
    - ./init:/docker-entrypoint-initdb.d:z
    - ./data:/var/lib/postgresql/data:Z
 
  guacamole:
    image: guacamole/guacamole
    container_name: guacamole
    restart: unless-stopped
    environment:
      GUACD_HOSTNAME: guacd
      POSTGRES_HOSTNAME: guacamole-db
      POSTGRES_DATABASE: guacamole_db
      POSTGRES_USER: guacamole_user
      POSTGRES_PASSWORD: PgAdmin
    volumes:
      - ./record:/record:rw
    ports:
      - 8080:8080/tcp
    depends_on:
    - guacd
    - guacamole-db
```

### MeshCentral

[MeshCentral](https://github.com/Ylianst/MeshCentral) - сервер для управления множеством компьютеров в локальной сети через веб-интерфейс.

```yaml
services:
  meshcentral:
    image: ghcr.io/ylianst/meshcentral:latest
    container_name: meshcentral
    restart: unless-stopped
    ports:
      - 8086:443
    env_file:
      - .env
    volumes:
      - ./meshcentral/data:/opt/meshcentral/meshcentral-data
      - ./meshcentral/user_files:/opt/meshcentral/meshcentral-files
      - ./meshcentral/backup:/opt/meshcentral/meshcentral-backups
      - ./meshcentral/web:/opt/meshcentral/meshcentral-web
```

env:

```ini
NODE_ENV=production
HOSTNAME=meshcentral.docker.local

REVERSE_PROXY=false
REVERSE_PROXY_TLS_PORT=

USE_MONGODB=false
MONGO_URL=
MONGO_INITDB_ROOT_USERNAME=mongodbadmin
MONGO_INITDB_ROOT_PASSWORD=mongodbpasswd
 
IFRAME=false
ALLOW_NEW_ACCOUNTS=true
WEBRTC=false
ALLOWPLUGINS=false
LOCALSESSIONRECORDING=false
MINIFY=true
ARGS=
```

### Warracker

[Warracker](https://github.com/sassanix/warracker) - веб-интерфейс для инвентаризации и отслеживания гарантий оборудования и программного обеспечения, позволяет отслеживать срок их действия и хранить чеки или другие связанные с ними документы (like [it-invent](https://it-invent.ru)). Поддерживает быстрый поиск по названию продукта, серийному номеру, производителю, тегам и другим параметрам, а также отправку оповещений через Apprise.

```yaml
services:
  warracker:
    image: ghcr.io/sassanix/warracker/main:latest
    container_name: warracker
    restart: unless-stopped
    ports:
      - 8005:80
    environment:
      - DB_HOST=warracker-db
      - DB_PORT=${DB_PORT:-5432}
      - DB_NAME=warranty_db
      - DB_USER=warranty_user
      - DB_PASSWORD=${DB_PASSWORD:-warranty_password}
      - SECRET_KEY=${APP_SECRET_KEY:-your_strong_default_secret_key_here} 
      - MAX_UPLOAD_MB=32
      - NGINX_MAX_BODY_SIZE_VALUE=32M
      - FRONTEND_URL=${FRONTEND_URL:-http://localhost:8005} 
      - APP_BASE_URL=${APP_BASE_URL:-http://localhost:8005}
      - WARRACKER_MEMORY_MODE=${WARRACKER_MEMORY_MODE:-optimized}
      - PYTHONUNBUFFERED=1
    volumes:
      - ./warracker_data/uploads:/data/uploads
    depends_on:
      warracker-db:
        condition: service_healthy
  warracker-db:
    image: postgres:15-alpine
    container_name: warracker-db
    restart: unless-stopped
    volumes:
      - ./warracker_data/postgres:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=warranty_db
      - POSTGRES_USER=warranty_user
      - POSTGRES_PASSWORD=${DB_PASSWORD:-warranty_password}
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $$POSTGRES_USER -d $$POSTGRES_DB"]
      interval: 5s
      timeout: 5s
      retries: 5
```

### IncidentRelay

[IncidentRelay](https://github.com/roxy-wi/IncidentRelay) - система планирования дежурств, маршрутизации и доставки оповещений, напоминаний и эскалации для команд SRE и DevOps с целью контроля и обработки инцидентов от создателей [Roxy-Wi](https://github.com/roxy-wi/roxy-wi).

```yaml
services:
  incidentrelay:
    image: roxywi/incidentrelay:latest
    container_name: incidentrelay
    restart: unless-stopped
    ports:
      - 8080:8080
    environment:
      INCEDENTRELAY_CONFIG_FILE: /etc/incidentrelay/incidentrelay.conf
      INCIDENTRELAY_SERVICE: web
      INCIDENTRELAY_RUN_MIGRATIONS: "1"
      INCIDENTRELAY_PORT: "8080"
      INCIDENTRELAY_WEB_WORKERS: "1"
      INCIDENTRELAY_WEB_THREADS: "4"
      INCIDENTRELAY_WEB_TIMEOUT: "120"
    volumes:
      - ./incidentrelay_data:/var/lib/incidentrelay
      - ./incidentrelay_logs:/var/log/incidentrelay
      - ./custom_voice_providers:/usr/local/lib/incidentrelay/voice_providers:ro
    healthcheck:
      test: ["CMD-SHELL", "curl -fsS http://127.0.0.1:8080/api/health || curl -fsS http://127.0.0.1:8080/login >/dev/null"]
      interval: 30s
      timeout: 5s
      retries: 5
      start_period: 30s

  incidentrelay-scheduler:
    image: roxywi/incidentrelay:latest
    container_name: incidentrelay-scheduler
    restart: unless-stopped
    environment:
      INCEDENTRELAY_CONFIG_FILE: /etc/incidentrelay/incidentrelay.conf
      INCIDENTRELAY_SERVICE: scheduler
      INCIDENTRELAY_RUN_MIGRATIONS: "0"
    volumes:
      - ./incidentrelay_data:/var/lib/incidentrelay
      - ./incidentrelay_logs:/var/log/incidentrelay
      - ./custom_voice_providers:/usr/local/lib/incidentrelay/voice_providers:ro
    depends_on:
      incidentrelay:
        condition: service_healthy

  incidentrelay-telegram:
    image: roxywi/incidentrelay:latest
    container_name: incidentrelay-telegram
    restart: unless-stopped
    environment:
      INCEDENTRELAY_CONFIG_FILE: /etc/incidentrelay/incidentrelay.conf
      INCIDENTRELAY_SERVICE: telegram
      INCIDENTRELAY_RUN_MIGRATIONS: "0"
      PYTHONUNBUFFERED: "1"
    volumes:
      - ./incidentrelay_data:/var/lib/incidentrelay
      - ./incidentrelay_logs:/var/log/incidentrelay
      - ./custom_voice_providers:/usr/local/lib/incidentrelay/voice_providers:ro
    depends_on:
      incidentrelay:
        condition: service_healthy
```

## Kanban

### Focalboard

[Focalboard](https://github.com/mattermost-community/focalboard) - инструмент управления проектами с открытым исходным кодом, который является альтернативой Trello, Notion и Asana (разработка и поддержка прекращена в 2024 году).

```yaml
services:
  focalboard:
    image: mattermost/focalboard:latest
    container_name: focalboard
    restart: unless-stopped
    volumes:
      - ./fb_data:/opt/focalboard/data
    environment:
      - VIRTUAL_HOST=focalboard.docker.local
      - VIRTUAL_PORT=8000
    labels:
      - traefik.enable=true
      - traefik.http.routers.focalboard.rule=Host(`focalboard.docker.local`)
      - traefik.http.services.focalboard.loadbalancer.server.port=8000
    # ports:
    #   - 8000:8000
```

### Wekan

[Wekan](https://github.com/wekan/wekan) - полностью открытое решение для совместной работы с Kanban досками, развивающиеся с 2015 года.

```yaml
services:
  wekan:
    image: ghcr.io/wekan/wekan:latest
    container_name: wekan-app
    restart: unless-stopped
    environment:
      - ROOT_URL=https://wekan.docker.local
      - WRITABLE_PATH=/data
      - MONGO_URL=mongodb://wekan-db:27017/wekan
      - WITH_API=true
      - RICHER_CARD_COMMENT_EDITOR=false
      - CARD_OPENED_WEBHOOK_ENABLED=false
      - BIGEVENTS_PATTERN=NONE
      - BROWSER_POLICY_ENABLED=true
      - LDAP_BACKGROUND_SYNC_INTERVAL=''
    depends_on:
      - wekan-db
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./wekan_data:/data
    labels:
      - traefik.enable=true
      - traefik.http.routers.wekan.rule=Host(`wekan.docker.local`)
      - traefik.http.services.wekan.loadbalancer.server.port=8080
    # ports:
    #   - 8080:8080

  wekan-db:
    image: mongo:7
    container_name: wekan-db
    restart: unless-stopped
    command: mongod --logpath /dev/null --oplogSize 128 --quiet
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./wekan_db:/data/db
      - ./wekan_dump:/dump
    expose:
      - 27017
    # ports:
    #   - 27017:27017
```

### Planka

[Planka](https://github.com/plankanban/planka) - инструмент управления проектами в стиле Kanban для команды.

🔗 [Planka Demo](https://plankanban.github.io/planka/#/) ↗

```yaml
services:
  planka:
    image: ghcr.io/plankanban/planka:2.0.0-rc.3
    container_name: planka-web
    # https://github.com/RARgames/4gaBoards
    # image: ghcr.io/rargames/4gaboards:latest
    # container_name: 4gaBoards
    restart: unless-stopped
    environment:
      - BASE_URL=https://planka.docker.local
      # Web credentials
      - DEFAULT_ADMIN_EMAIL=admin@admin.com
      - DEFAULT_ADMIN_PASSWORD=admin
      - DEFAULT_ADMIN_NAME=Admin
      - DEFAULT_ADMIN_USERNAME=admin
      # Database connection
      - DATABASE_URL=postgresql://planka:postgresPlankaPassword@planka-db:5432/planka
      # WPA Key (openssl rand -hex 64)
      - SECRET_KEY=c74fd30800bc3c742ba368e396b87409edc7613e3ee58deee00992c3c4b98ec9eb154d441f143e28b4716287ba31d3699ee09f7e101cfe6c98872102ea622a76
    volumes:
      - ./planka_data/favicons:/app/public/favicons
      - ./planka_data/user-avatars:/app/public/user-avatars
      - ./planka_data/background-images:/app/public/background-images
      - ./planka_data/attachments:/app/private/attachments
    depends_on:
      planka-db:
        condition: service_healthy
    labels:
      - traefik.enable=true
      - traefik.http.routers.planka.rule=Host(`planka.docker.local`)
      - traefik.http.services.planka.loadbalancer.server.port=1337
    # ports:
    #   - 1337:1337

  planka-db:
    image: postgres:16-alpine
    container_name: planka-db
    restart: unless-stopped
    environment:
      - POSTGRES_DB=planka
      - POSTGRES_USER=planka
      - POSTGRES_PASSWORD=postgresPlankaPassword
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U planka -d planka"]
      interval: 5s
      timeout: 5s
      retries: 10
    volumes:
      - ./planka_db:/var/lib/postgresql/data
    # ports:
    #   - 5432:5432
```

### Kanboard

[Kanboard](https://github.com/kanboard/kanboard) - программное обеспечение для управления проектами, ориентированное на методологию Kanban. Поддерживает хранение данных в SQLite или PostgreSQL.

```yaml
services:
  kanboard:
    image: kanboard/kanboard:latest
    container_name: kanboard
    restart: unless-stopped
    ports:
     - 8080:80
     - 4343:443
    volumes:
     - ./kanboard_data:/var/www/app/data
     - ./kanboard_plugins:/var/www/app/plugins
    #  - ./kanboard_certs:/etc/nginx/ssl
    # environment:
    #   DATABASE_URL: postgres://kanboard:KanboardAdmin@kanboard-db/kanboard
    # depends_on:
    #   db:
    #     condition: service_healthy

  # kanboard-db:
  #   image: postgres:latest
  #   restart: always
  #   environment:
  #     POSTGRES_DB: kanboard
  #     POSTGRES_USER: kanboard
  #     POSTGRES_PASSWORD: KanboardAdmin
  #   volumes:
  #     - ./kanboard_database:/var/lib/postgresql/data
  #   healthcheck:
  #     test: ["CMD", "pg_isready", "-U", "kanboard"]
  #     start_period: 15s
  #     interval: 10s
  #     timeout: 5s
```

### Kan

[Kan](https://github.com/kanbn/kan) - современное решение Kanban, как льтернатива Trello.

```yaml
services:
  kan:
    image: ghcr.io/kanbn/kan:latest
    container_name: kan
    restart: unless-stopped
    environment:
      # Авторизация доступна только через доменное имя
      - NEXT_PUBLIC_BASE_URL=http://kan.docker.local
      - BETTER_AUTH_SECRET=KanBanAdminSecret
      - POSTGRES_URL=postgresql://kan:KanBanAdminSecret@kan-db:5432/kan_db
      - NEXT_PUBLIC_ALLOW_CREDENTIALS=true
    depends_on:
      kan-db:
        condition: service_healthy
    labels:
      - traefik.enable=true
      - traefik.http.routers.kan.rule=Host(`kan.docker.local`)
      - traefik.http.services.kan.loadbalancer.server.port=3000
    # ports:
    #   - 3000:3000

  kan-db:
    image: postgres:15
    container_name: kan-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: kan_db
      POSTGRES_USER: kan
      POSTGRES_PASSWORD: KanBanAdminSecret
    volumes:
      - ./kanban_db:/var/lib/postgresql/data
    ports:
      - 5432:5432
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U planka -d planka"]
      interval: 5s
      timeout: 5s
      retries: 10
```

### Plane

[Plane](https://github.com/makeplane/plane) - платформа для управления проектами (задачами и спринтами) как альтернатива Jira, Linear, Monday и ClickUp с открытым исходным кодом.

```yaml
services:
  web:
    container_name: web
    build:
      context: .
      dockerfile: ./apps/web/Dockerfile.web
      args:
        DOCKER_BUILDKIT: 1
    restart: always
    depends_on:
      - api

  admin:
    container_name: admin
    build:
      context: .
      dockerfile: ./apps/admin/Dockerfile.admin
      args:
        DOCKER_BUILDKIT: 1
    restart: always
    depends_on:
      - api
      - web

  space:
    container_name: space
    build:
      context: .
      dockerfile: ./apps/space/Dockerfile.space
      args:
        DOCKER_BUILDKIT: 1
    restart: always
    depends_on:
      - api
      - web

  api:
    container_name: api
    build:
      context: ./apps/api
      dockerfile: Dockerfile.api
      args:
        DOCKER_BUILDKIT: 1
    restart: always
    command: ./bin/docker-entrypoint-api.sh
    env_file:
      - ./apps/api/.env
    depends_on:
      - plane-db
      - plane-redis

  worker:
    container_name: bgworker
    build:
      context: ./apps/api
      dockerfile: Dockerfile.api
      args:
        DOCKER_BUILDKIT: 1
    restart: always
    command: ./bin/docker-entrypoint-worker.sh
    env_file:
      - ./apps/api/.env
    depends_on:
      - api
      - plane-db
      - plane-redis

  beat-worker:
    container_name: beatworker
    build:
      context: ./apps/api
      dockerfile: Dockerfile.api
      args:
        DOCKER_BUILDKIT: 1
    restart: always
    command: ./bin/docker-entrypoint-beat.sh
    env_file:
      - ./apps/api/.env
    depends_on:
      - api
      - plane-db
      - plane-redis

  migrator:
    container_name: plane-migrator
    build:
      context: ./apps/api
      dockerfile: Dockerfile.api
      args:
        DOCKER_BUILDKIT: 1
    restart: no
    command: ./bin/docker-entrypoint-migrator.sh
    env_file:
      - ./apps/api/.env
    depends_on:
      - plane-db
      - plane-redis

  live:
    container_name: plane-live
    build:
      context: .
      dockerfile: ./apps/live/Dockerfile.live
      args:
        DOCKER_BUILDKIT: 1
    restart: always

  plane-db:
    container_name: plane-db
    image: postgres:15.7-alpine
    restart: always
    command: postgres -c 'max_connections=1000'
    volumes:
      - pgdata:/var/lib/postgresql/data
    env_file:
      - .env
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      PGDATA: /var/lib/postgresql/data

  plane-redis:
    container_name: plane-redis
    image: valkey/valkey:7.2.11-alpine
    restart: always
    volumes:
      - redisdata:/data

  plane-mq:
    container_name: plane-mq
    image: rabbitmq:3.13.6-management-alpine
    restart: always
    env_file:
      - .env
    environment:
      RABBITMQ_DEFAULT_USER: ${RABBITMQ_USER}
      RABBITMQ_DEFAULT_PASS: ${RABBITMQ_PASSWORD}
      RABBITMQ_DEFAULT_VHOST: ${RABBITMQ_VHOST}
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq

  plane-minio:
    container_name: plane-minio
    image: minio/minio
    restart: always
    command: server /export --console-address ":9090"
    volumes:
      - uploads:/export
    environment:
      MINIO_ROOT_USER: ${AWS_ACCESS_KEY_ID}
      MINIO_ROOT_PASSWORD: ${AWS_SECRET_ACCESS_KEY}

  proxy:
    container_name: proxy
    build:
      context: ./apps/proxy
      dockerfile: Dockerfile.ce
    restart: always
    ports:
      - ${LISTEN_HTTP_PORT}:80
      - ${LISTEN_HTTPS_PORT}:443
    environment:
      FILE_SIZE_LIMIT: ${FILE_SIZE_LIMIT:-5242880}
      BUCKET_NAME: ${AWS_S3_BUCKET_NAME:-uploads}
    depends_on:
      - web
      - api
      - space
      - admin

volumes:
  pgdata:
  redisdata:
  uploads:
  rabbitmq_data:
```

## NVR

### ZoneMinder

[ZoneMinder](https://github.com/ZoneMinder/zoneminder) - самостоятельная систем видеонаблюдения, которое поддерживает IP, USB и аналоговые камеры, позволяющее осуществлять захват, анализ, запись и мониторинг любых камер видеонаблюдения или систем безопасности, подключенных к компьютеру на базе Linux. Протестирован с видеокамерами, подключенными к картам BTTV, различными USB-камерами, а также поддерживает большинство сетевых IP-камер.

```yaml
services:
  zoneminder:
    image: zoneminderhq/zoneminder:latest-ubuntu18.04
    container_name: zoneminder
    restart: unless-stopped
    tty: true
    shm_size: 512m
    ports:
      - 1080:80
    environment:
      - TZ=Etc/UTC+3
      - ZM_DB_HOST=zoneminder-db
      - ZM_DB_NAME=zm
      - ZM_DB_USER=zm
      - ZM_DB_PASS=zmPassword
    volumes:
      - ./zoneminder/mysql:/var/lib/mysql
      - ./zoneminder/images:/var/cache/zoneminder/images
      - ./zoneminder/events:/var/cache/zoneminder/events
      - ./zoneminder/logs:/var/log/zm
    depends_on:
      zoneminder-db:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/zm/"]
      interval: 30s
      timeout: 10s
      retries: 3

  zoneminder-db:
    image: mariadb:latest
    container_name: zm-mariadb
    restart: always
    environment:
      - MYSQL_DATABASE=zm
      - MYSQL_USER=zm
      - MYSQL_PASSWORD=zmPassword
      - MYSQL_ROOT_PASSWORD=rootPassword
    volumes:
      - ./zoneminder/db:/var/lib/mysql
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      start_period: 10s
      interval: 10s
      timeout: 5s
      retries: 3
```

### Scrypted

[Scrypted](https://github.com/koush/scrypted) - высокопроизводительная платформа для интеграции сетевого видеорегистратора с интеллектуальными функциями обнаружения. Мгновенная потоковая передача с низкой задержкой для интеграции с HomeKit, Google Home и Alexa.

```yaml
services:
  scrypted:
    image: ghcr.io/koush/scrypted
    container_name: scrypted
    restart: unless-stopped
    volumes:
      - ./scrypted_volume:/server/volume
    devices: []
    network_mode: host # http://ip:11080 or https://ip:10443
    dns:
      - 1.1.1.1
      - 8.8.8.8
    logging:
      driver: json-file
      options:
          max-size: 10m
          max-file: 5
```

### SentryShot

[SentryShot](https://github.com/SentryShot/sentryshot) - система видеонаблюдения для просмотра в реальном времени с задержкой менее 2 секунд, поддержкой круглосуточной записи в пользовательскую базу данных, обнаружение объектов с помощью TensorFlow Lite (TFLite) и [пользовательской модели](https://codeberg.org/Curid/TF-CCTV), а также адаптивный и уобный веб-интерфейс для мобильных устройств.

```yaml
services:
  sentryshot:
    image: codeberg.org/sentryshot/sentryshot:v0.3.8
    container_name: sentryshot
    restart: unless-stopped
    ports:
      - 2020:2020   # http://ip:2020/live
      # - 1883:1883 # API
    environment:
      - TZ=Etc/UTC+3
    volumes:
      - ./sentryshot_conf:/app/configs
      - ./sentryshot_data:/app/storage
    # devices:
    #   - "/sys/bus/usb/devices/x"
```

### Motion UI

Motion UI - веб-интерфейс для управления системой видеонаблюдения [Motion](https://github.com/Motion-Project/motion) от создателя [RepoManager](https://github.com/lbr38/repomanager).

```yaml
services:
  motion:
    image: lbr38/motionui:latest
    container_name: motion
    restart: unless-stopped
    privileged: true
    environment:
      FQDN: motion.docker.local
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./motionui_data:/var/lib/motionui
      - ./motionui_captures:/var/lib/motion
      # - ./motion.conf:/etc/motion/motion.conf
      # - ./camera01.conf:/etc/motion/camera01.conf
      # - ./cam01_data:/etc/motion/cam01
    ports:
      - 8181:8080
      - 8182:8081

# Username: admin
# Password: motionui
```

### Kerberos Agent

[Kerberos Agent](https://github.com/kerberos-io/agent) - изолированный и масштабируемый агент видеонаблюдения, который поддерживает многопотоковую обработку, потоковую передачу и детекцию движения, а также работу с различными типами камер.

```yaml
x-common-variables: &common-variables
  AGENT_HUB_KEY: "xxxxx"
  AGENT_HUB_PRIVATE_KEY: "xxxxx"

services:
  kerberos-agent-01:
    image: "kerberos/agent:latest"
    container_name: kerberos-agent-01
    restart: unless-stopped
    ports:
      - 8181:80
    environment:
      <<: *common-variables
      AGENT_NAME: agent1
      AGENT_CAPTURE_IPCAMERA_RTSP: rtsp://username:password@x.x.x.x/Streaming/Channels/101
      AGENT_KEY: "1"
```

## Torrent Stack

Удаленный SMB каталог для хранения медиа-контента:

```yaml
volumes:
  smb_volume:
    driver_opts:
      type: cifs
      o: username=guest,password=,uid=1000,gid=1000
      device: //192.168.3.100/plex-content
```

### Jackett

[Jackett](https://github.com/Jackett/Jackett) - сервер API и веб-интерфейс для поиска и загрузки торрент файлов из любых индексеров (торрент-трекеров).

```yaml
services:
  jackett:
    image: lscr.io/linuxserver/jackett:latest
    container_name: jackett
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
    volumes:
      - ./jackett_conf:/config
    ports:
      - 9117:9117
```

### Prowlarr

[Prowlarr](https://github.com/Prowlarr/Prowlarr) - менеджер и прокси-сервер для индексаторов (интерфейс поиска и добавления идентичен `Jackett`), созданный на основе популярного базового стека `*arr` для интеграции с различными приложениями `PVR`. Prowlarr поддерживает управление торрент-трекерами, Usenet индексаторами, а также легко интегрируется с [Radarr](https://github.com/Radarr/Radarr), [Sonarr](https://github.com/Sonarr/Sonarr), [Lidarr](https://github.com/Lidarr/Lidarr) и [Readarr](https://github.com/Readarr/Readarr), без необходимости настройки индексатора для каждого приложения.

🔗 [Prowlarr API Docs](https://prowlarr.com/docs/api) ↗

```yaml
services:
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
    volumes:
      - ./prowlarr_conf:/config
    ports:
      - 9696:9696
```

### Fresh RSS

[Fresh RSS](https://github.com/FreshRSS/FreshRSS) - агрегатор RSS-каналов с поддержкой хранения данных в SQLite, PostgreSQL и MySQL/MariaDB, а также предоставляет единую точку всех добавленных RSS лент, API и виджет [Homepage](https://gethomepage.dev/widgets/services/freshrss).

🔗 [FreshRSS Demo](https://demo.freshrss.org) ↗

🔗 [RSS Feed Reader Playground](https://georapbox.github.io/rss-feed-reader) ↗ с открытым кодом на [GitHub](https://github.com/georapbox/rss-feed-reader).

```yaml
services:
  freshrss:
    image: lscr.io/linuxserver/freshrss:latest
    container_name: freshrss
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - ./freshrss_config:/config
    ports:
      - 9111:80
```

### RSS Bridge

[RSS Bridge](https://github.com/RSS-Bridge/rss-bridge) - генерирует RSS-каналы в форматах `Atom`/`XML` и `JSON` с поддержкой `HTML` разметки для веб-сайтов, у которых их нет. Поддерживает более 400 мостов, например, из Telegram каналов, фильтрацию по заголовкам или содержимому RSS каланов (например, предварительно сгенерированных).

🔗 [RSS Bridge Playground](https://rss-bridge.org/bridge01) ↗

🔗 [Public Hosts](https://rss-bridge.github.io/rss-bridge/General/Public_Hosts.html) ↗

```yaml
services:
  rss-bridge:
    image: rssbridge/rss-bridge:latest
    container_name: rss-bridge
    restart: unless-stopped
    volumes:
      - ./rss_bridge_config:/config
    ports:
      - 9112:80
```

### RSS Proxy

[RSS Proxy](https://github.com/damoeb/rss-proxy) - позволяет создавать `ATOM` или `JSON` ленты из любого статического сайта или ленты (Web to Feed), анализирует HTML страницы и преобразует в RSS ленту с поддержкой фильтрации.

[RSS Proxy Playground](https://rssproxy.migor.org)

```yaml
services:
  rich-puppeteer:
    image: damoeb/rich-rss:puppeteer-0.1
    container_name: rich-puppeteer
    restart: unless-stopped
    security_opt:
      - seccomp=chrome.json
    networks:
      - puppeteer

  rss-proxy:
    image: damoeb/rss-proxy:2.0.0-beta
    container_name: rss-proxy
    restart: unless-stopped
    ports:
      - 8080:8080
    environment:
      - LOG_LEVEL=info
      - APP_PUBLIC_URL=http://localhost:8080
      - TOKEN_SECRET=TokenSecret
      - PUPPETEER_HOST=http://rich-puppeteer:3000
    depends_on:
      - rich-puppeteer
```

### qBittorrent

[qBittorrent](https://github.com/qbittorrent/qBittorrent) - кросплатформенный торрент-клиент с поддержкой современного веб-интерфейса и адаптивного API. Поддерживает подписку на RSS ленты новостей и поиск торрентов через [плагины](https://github.com/qbittorrent/search-plugins/wiki/unofficial-search-plugins).

[qBt_SE](https://github.com/imDMG/qBt_SE) - плагины поисковой системы qBittorrent для торрент трекеров Kinozal, RuTracker, Rutor и NNM-Club.

[qBitController](https://github.com/Bartuzen/qBitController) - приложение с открытым исходным кодом на Kotlin для удаленного управления qBittorrent с устройств Android, iOS, Windows, Linux и macOS.

[Electorrent](https://github.com/tympanix/Electorrent) - rлиент удаленного управления для qBittorrent, Transmission, Deluge, uTorrent, rTorrent и Synology.

🔗 [qBittorrent OpenAPI Docs](https://qbittorrent-ecosystem.github.io/webui-api-openapi) ↗

```yaml
services:
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    # Official Docker Image
    # image: qbittorrentofficial/qbittorrent-nox:latest
    container_name: qbittorrent
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
      - WEBUI_PORT=3240
      - TORRENTING_PORT=6881
    volumes:
      - ./qbittorrent_conf:/config
      - smb_volume:/downloads
    ports:
      - 3240:3240
      - 6881:6881
      - 6881:6881/udp

  qbittoreent-swagger:
    image: docker.swagger.io/swaggerapi/swagger-ui
    container_name: qbittoreent-swagger
    restart: unless-stopped
    ports:
      - 3241:8080
    environment:
      - SWAGGER_JSON_URL=https://raw.githubusercontent.com/qbittorrent-ecosystem/webui-api-openapi/refs/heads/master/specs/v2.8.3/build/openapi.yaml
    depends_on:
      - qbittorrent
```

### qUI

[qUI](https://github.com/autobrr/qui) - современный веб-интерфейс для qBittorrent, который поддерживает управление несколькими экземплярами.

```yaml
services:
  qui:
    image: ghcr.io/autobrr/qui:latest
    container_name: qui
    restart: unless-stopped
    ports:
      - 7476:7476
      # - 9074:9074
    volumes:
      - ./qui_conf:/config
    environment:
      # Server
      - QUI__HOST=0.0.0.0
      - QUI__PORT=7476
      # Metrics
      # - QUI__METRICS_ENABLED=true
      # - QUI__METRICS_HOST=127.0.0.1
      # - QUI__METRICS_PORT=9074
      # - QUI__METRICS_BASIC_AUTH_USERS=user:hash
```

### Transmission

[Transmission](https://github.com/transmission/transmission) - кросплатформенный торрент-клиент с поддержкой веб-интерфейса, API и каталога автоматического обнаружения torrent-файлов для загрузки (возможно интегрировать с Jackett). Поддерживает нативное GUI для macOS, Linux на базе GTK и Windows на базе QT.

[Transmission Remote GUI](https://github.com/transmission-remote-gui/transgui) (TransGUI) - кроссплатформенный desktop интерфейс для удаленного управления демоном Transmission через протокол RPC. Он быстрее и функциональнее встроенного веб-интерфейса Transmission, который визуально похож на qBittorrent и uTorrent.

[Transmission Remote](https://github.com/y-polek/TransmissionRemote) - приложение Android для удаленного управления клиентом Transmission с мобильного телефона.

```yaml
services:
  transmission:
    image: lscr.io/linuxserver/transmission:latest
    container_name: transmission
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
      - USER=
      - PASS=
    volumes:
      - ./transmission_conf:/config
      - smb_volume:/downloads
      - ./torrent_watch:/watch
    ports:
      - 9118:9091
      - 51413:51413
      - 51413:51413/udp
```

### Nefarious

[Nefarious](https://github.com/lardbit/nefarious) - веб-приложение для автоматической загрузки фильмов и сериалов. Под капотом используется Jackett для поиска торрентов и Transmission для управления загрузкой.

```yaml
services:
  nefarious:
    image: lardbit/nefarious:latest
    container_name: transmission
    restart: unless-stopped
    ports:
      - 9119:80
    environment:
      - DATABASE_URL=sqlite:////nefarious-db/db.sqlite3
      - REDIS_HOST=nefarious-redis
      - NEFARIOUS_USER=admin
      - NEFARIOUS_PASS=admin
      - HOST_DOWNLOAD_PATH=/tmp/
      - CONFIG_PATH=/nefarious-db
    volumes:
      - ./nefarious_data:/nefarious-db

  nefarious-redis:
    image: redis
    container_name: nefarious-redis
    restart: unless-stopped
    mem_limit: 200m
    expose:
      - 6379
    # ports:
    #  - 6379:6379
```

### Deluge

[Deluge](https://github.com/deluge-torrent/deluge) - торрент-клиент, использующий модель демон-клиент на базе библиотеки [libtorrent](https://libtorrent.org), который поддерживает пользовательские веб-интерфейс, интерфейс рабочего стола на базе GTK и интерфейс командной строки.

```yaml
services:
  deluge:
    image: lscr.io/linuxserver/deluge:latest
    container_name: deluge
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
      - DELUGE_LOGLEVEL=error
    volumes:
      - ./deluge_config:/config
      - smb_volume:/downloads
    ports:
      - 8112:8112
      - 6881:6881
      - 6881:6881/udp
      - 58846:58846
```

### Cloud Torrent

[Cloud Torrent](https://github.com/jpillora/cloud-torrent) - торрент клиент с поддержкой поиска раздач и просмотра медиа-контента в браузере, от создателя [Chisel](https://github.com/jpillora/chisel) (быстрый TCP/UDP-туннель, работающий по протоколу HTTP и защищенный через SSH).

```yaml
services:
  cloud-torrent:
    image: jpillora/cloud-torrent:latest
    container_name: cloud-torrent
    restart: unless-stopped
    ports:
      - 3010:3000
    volumes:
      - smb_volume:/downloads
```

### rQbit

[rQbit](https://github.com/ikatson/rqbit) - современный торрент-клиент, с поддержкой веб-интерфейса, API, Desktop и cli, а также может использоваться как библиотека на Rust. Поддерживает стриминг видео, включая трансляцию на плееры, например, [VLC](https://github.com/videolan/vlc).

```yaml
  rqbit:
    image: ikatson/rqbit:main
    network_mode: host
    ports:
      - 3030:3030 # API
      - 4240:4240 # BitTorrent
    environment:
      RQBIT_UPNP_SERVER_ENABLE: "true"
      RQBIT_UPNP_SERVER_FRIENDLY_NAME: rqbit-docker
      RQBIT_HTTP_API_LISTEN_ADDR: 0.0.0.0:3030
    volumes:
      - ./rqbit_db:/home/rqbit/db
      - ./rqbit_cache:/home/rqbit/cache
      - smb_volume:/home/rqbit/downloads
```

### Plex

[Plex](https://github.com/plexinc) - медиа-сервер (система потоковой передачи медиаконтента), которая позволяет смотреть фильмы, сериалы, фото и прослушивать музыку на различных устройствах, а также поддерживает API для удаленного управления (без документации, ключ API можно получить только вечер DevTool).

```yaml
services:
  plex:
    image: lscr.io/linuxserver/plex:latest
    # Official Docker Image
    # image: plexinc/pms-docker
    container_name: plex
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
      - VERSION=docker
      - PLEX_CLAIM= # from https://plex.tv/claim
    volumes:
      - ./plex_conf:/config
      - smb_volume:/tv
      - smb_volume:/movies
      # use Official Docker Image
      # - ./plex_conf:/config
      # - ./plex_transcode:/transcode
      # - smb_volume:/data
    ports:
      - 32400:32400
      - 1900:1900/udp
      - 5353:5353/udp
      - 8324:8324
      - 32410:32410/udp
      - 32412:32412/udp
      - 32413:32413/udp
      - 32414:32414/udp
      - 32469:32469
```

### Tautulli

[Tautulli](https://github.com/Tautulli/Tautulli) - система мониторинга, аналитики и уведомлений для Plex Media Server с адаптивным дизайном для мобильных устройств.

```yaml
services:
  tautulli:
    image: lscr.io/linuxserver/tautulli:latest
    container_name: tautulli
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
    volumes:
      - ./tautulli_conf:/config
    ports:
      - 8181:8181
```

### Overseerr

[Overseerr](https://github.com/sct/overseerr) - веб-приложение с собственным интерфейсом для управления запросами к медиа-библиотеки Plex а также интегрируется с Sonarr и Radarr.

```yaml
services:
  overseerr:
    image: lscr.io/linuxserver/overseerr:latest
    container_name: overseerr
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
    volumes:
      - ./overseerr_conf:/config
    ports:
      - 5055:5055
```

### Jellyfin

[Jellyfin](https://github.com/jellyfin/jellyfin) - медиа-сервер с открытым исходным кодом, который является ответвлением проприетарного [Emby](https://github.com/MediaBrowser/Emby) с версии `3.5.2` и портированный на платформу `.NET` для обеспечения полной кроссплатформенной поддержки (API совместим с Emby).

```yaml
services:
  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
    volumes:
      - ./jellyfin_conf/jellyfin:/config
      - ./jellyfin-content/tvshows:/data/tvshows
      - ./jellyfin-content/movies:/data/movies
    ports:
      - 8096:8096
      - 7359:7359/udp
      - 1900:1900/udp
```

### Jellyseerr

[Jellyseerr](https://github.com/seerr-team/seerr) - fork Overseerr для Jellyfin. Поддерживает полную интеграцию с Jellyfin, Emby и Plex (включая Sonarr и Radarr), включая аутентификацию с импортом и управлением пользователями, а также базы данных SQLite и PostgreSQL.

```yaml
services:
  jellyseerr:
    image: fallenbagel/jellyseerr:latest
    container_name: jellyseerr
    restart: unless-stopped
    environment:
      - LOG_LEVEL=debug
      - TZ=Asia/Tashkent
    volumes:
      - ./jellyseerr_config:/app/config
    ports:
      - 5055:5055
```

### Universal Media Server

[UMS](https://github.com/UniversalMediaServer/UniversalMediaServer) (Universal Media Server) - медиасервер, поддерживающий протоколы DLNA, UPnP и HTTP/S. Он способен передавать видео, аудио и изображения между большинством современных устройств. Изначально он был основан на PS3 Media Server от shagrath для обеспечения большей стабильности и совместимости файлов.

```yaml
services:
  ums:
    image: universalmediaserver/ums
    container_name: ums
    restart: unless-stopped
    environment:
      - TZ=Etc/UTC+3
      - UMS_PROFILE=/profile
    volumes:
      - ./ums_conf:/profile
      - ./ums-content:/media:ro
    ports:
      - 1044:1044
      - 5001:5001
      - 9001:9001
      - 1900:1900/udp
      - 2869:2869
      - 8000-8010:8000-8010
```

### Navidrome (Music Server)

[NMS](https://github.com/navidrome/navidrome/) (Navidrome Music Server) - музыкальный веб-сервер для хранения и стриминга аудио.

🔗 [Navidrome Demo](https://demo.navidrome.org) ↗

```yaml
services:
  navidrome:
    image: deluan/navidrome:latest
    container_name: navidrome
    restart: unless-stopped
    user: 1000:1000
    ports:
      - 4533:4533
    volumes:
      - ./navidrome_data:/data
      - ./navidrome_music:/music:ro
```

### Black Candy

[Black Candy](https://github.com/blackcandy-org/blackcandy) - сервер потоковой передачи музыки, который предоставляет веб-интерфейс и мобильные приложение для воспроизвденеия музыки. Поддерживает использование баз данных SQLite и PostgreSQL, а также интеграцию с API Discogs для получения изображений исполнителей и альбомов.

```yaml
services:
  blackcandy:
    image: blackcandy/blackcandy:latest
    container_name: blackcandy
    restart: unless-stopped
    ports:
      - 4033:80
    environment:
      - MEDIA_PATH=/media_data
      # - DB_ADAPTER=postgresql
      # - DB_URL=postgresql://db_url
    volumes:
      - ./blackcandy_data:/media_data
      - ./navidrome_music:/music:ro
```

### Kavita (Book Server)

[Kavita](https://github.com/Kareadita/Kavita) - это оффлай ридер для книг в форматах EPUB и PDF как альтернатива Kindle от Amazon. Сервер самостоятельно сканирует каталог с книгами и формирует библиотеку для чтения через веб-интерфейс.

🔗 [Kavita Demo](https://demo.kavitareader.com/home) ↗

```yaml
services:
  kavita:
    image: lscr.io/linuxserver/kavita:latest
    container_name: kavita
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
    ports:
      - 5000:5000
    volumes:
      - ./kavita_config:/config
      - ./kavita_data:/data
```

### Koodo Reader

[Koodo Reader](https://github.com/koodo-reader/koodo-reader) - программа для чтения электронных книг с возможностями синхронизации и резервного копирования для Windows, macOS, Linux, Android, iOS и веб-версией.

```yaml
services:
  koodo-reader:
    image: liwangsheng/koodo-reader:latest
    container_name: koodo-reader
    restart: unless-stopped
    ports:
      - 80:80
      - 8080:8080
    environment:
      - SERVER_USERNAME=admin
      - SERVER_PASSWORD=admin
      - ENABLE_HTTP_SERVER=false
    volumes:
      - ./koodo_data:/app/uploads
```

### Audio Books Helf

[Audio Books Helf](https://github.com/advplyr/audiobookshelf) - сервер для самостоятельного размещения аудиокниг и подкастов.

```yaml
services:
  audiobookshelf:
    image: ghcr.io/advplyr/audiobookshelf:latest
    container_name: audiobookshelf
    restart: unless-stopped
    user: 1000:1000
    ports:
      - 13378:80
    volumes:
      - ./audiobookshelf_data/audiobooks:/audiobooks
      - ./audiobookshelf_data/podcasts:/podcasts
      - ./audiobookshelf_data/metadata:/metadata
      - ./audiobookshelf_data/config:/config
```

### Storyteller

[Storyteller](https://gitlab.com/storyteller-platform/storyteller) - хранилище для аудиокниг с веб интерфейсом и поддержкой мобильного приложения.

```yaml
services:
  storyteller:
    image: registry.gitlab.com/storyteller-platform/storyteller:latest
    container_name: storyteller
    restart: unless-stopped
    environment:
      - STORYTELLER_SECRET_KEY=changemechangemechangeme
    ports:
      - 8001:8001
    volumes:
      - ./storyteller_data:/data:rw
```

### Sonarr

[Sonarr](https://github.com/Sonarr/Sonarr) - PVR (Personal Video Recorder) для пользователей Usenet и BitTorrent. Он позволяет отслеживать несколько RSS-каналов на предмет новых серий и захватывать, сортировать и переименовывать их. Его также можно настроить на автоматическое повышение качества уже загруженных файлов, когда становится доступен более качественный формат.

```yaml
services:
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
    volumes:
      - ./sonnar_conf:/config
      - smb_volume:/tv
      - ./sonarr_downloads:/downloads
    ports:
      - 8989:8989
```

### Radarr

[Radarr](https://github.com/Radarr/Radarr) - fork Sonarr для работы с фильмами.

```yaml
services:
  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
    volumes:
      - ./radarr_conf:/config
      - smb_volume:/movies
      - ./sonarr_downloads:/downloads
    ports:
      - 7878:7878
```

### Posterizarr

[Posterizarr](https://github.com/fscorrupt/posterizarr) - автоматизированный конструктор постеров для Plex и Jellyfin/Emby. Представляет из себя PowerShell скрипт с полноценным веб-интерфейсом, который автоматизирует генерацию изображений для медиатеки. Он загружает обложки с Fanart.tv, TMDB, TVDB, Plex и IMDb, уделяя особое внимание изображениям без текста и применяя собственные пользовательские наложения и текст.

```yaml
services:
  posterizarr:
    image: ghcr.io/fscorrupt/posterizarr:latest
    container_name: posterizarr
    hostname: posterizarr
    restart: unless-stopped
    environment:
      - TZ=Etc/UTC+3
      - TERM=xterm
      - RUN_TIME=disabled
    user: 1000:1000
    ports:
      - 8000:8000
    volumes:
      - ./posterizarr/config:/config
      - ./posterizarr/assets:/assets
      - ./posterizarr/assetsbackup:/assetsbackup
      - ./posterizarr/manualassets:/manualassets
```

### Flexget

[Flexget](https://github.com/Flexget/Flexget) - автоматизирует процесс загрузки медиафайлов с фильтрацией из RSS-каналов.

```yaml
services:
  flexget:
    image: flexget/flexget
    container_name: flexget
    restart: unless-stopped
    command:
      - daemon
      - start
      - --autoreload-config
    ports:
      - 5050:5050
    environment:
      - TZ=Etc/UTC+3
    volumes:
      - ./config:/config
      - ./downloads:/downloads
```

### Autobrr

[Autobrr](https://github.com/autobrr/autobrr) - система автоматизации загрузки торрентов и Usenet, вдохновленная [trackarr](https://github.com/florianjs/trackarr), autodl-irssi и [flexget](https://github.com/Flexget/Flexget), от создателя [qUI](https://github.com/autobrr/qui). Этот инструмент объеденяет лучшее из этих миров в один универсальный инструмент, который может делать все и даже больше.

```yaml
services:
  autobrr:
    image: ghcr.io/autobrr/autobrr:develop
    container_name: autobrr
    restart: unless-stopped
    volumes:
      - ./config:/config
    ports:
      - 7474:7474
    # environment:
    #   AUTOBRR__POSTGRES_PASSWORD_FILE: /run/secrets/db_password
    # secrets:
    #   - db_password

  autobrr-postgres:
    image: postgres:12.10
    container_name: autobrr-postgres
    restart: unless-stopped
    volumes:
      - ./postgres_data:/var/lib/postgresql/data
    ports:
      - 5432:5432
    environment:
      - POSTGRES_DB=autobrr
      - POSTGRES_USER=autobrr
      - POSTGRES_PASSWORD=postgres

# secrets:
#   db_password:
#     file: db_password.txt
```

## Game Stack

### Sunshine

[Sunshine](https://github.com/LizardByte/Sunshine) - самостоятельный хостинг-сервер игровых трансляций (like NVIDIA GameStream и Parsec) для клиента [Moonlight](https://github.com/moonlight-stream/moonlight-qt).

```yaml
services:
  sunshine:
    image: lizardbyte/sunshine:latest-ubuntu-24.04
    container_name: sunshine
    restart: unless-stopped
    volumes:
      - ./sunshine_config:/config
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=Etc/GMT+3
    ports:
      - 47984-47990:47984-47990/tcp
      - 47998-48000:47998-48000/udp
      - 48010:48010
    ipc: host
```

### VDD

[VDD](https://github.com/VirtualDrivers/Virtual-Display-Driver) (Virtual Display Driver) - драйвер для создания виртуального монитора в Windows, который функционирует точно так же, как физический. Он используется в связке с приложениями для потоковой передачи видео, например, [Sunshine](ttps://github.com/LizardByte/Sunshine).

После установки драйвера в интерфейсе Sunshine идем в Troubleshooting и ищем по содержимому логов идентификатор виртуального монитора. 

```json
[
  {
    "device_id": "{d54a4360-26df-5f1a-b161-298c03c03b66}",
    "display_name": "\\\\.\\DISPLAY8",
    "edid": {
      "manufacturer_id": "MTT",
      "product_code": "1337",
      "serial_number": 518463207
    },
    "friendly_name": "VDD by MTT",
    "info": {
      "hdr_state": null,
      "origin_point": {
        "x": 3840,
        "y": 1468
      },
      "primary": false,
      "refresh_rate": {
        "type": "rational",
        "value": {
          "denominator": 1,
          "numerator": 60
        }
      },
      "resolution": {
        "height": 1080,
        "width": 1920
      },
      "resolution_scale": {
        "type": "rational",
        "value": {
          "denominator": 100,
          "numerator": 150
        }
      }
    }
  }
]
```

Переходим в `Configuration` => `Audio/Video` и в после `config.output_name_windows` всталяем содержимое из `device_id`: `{d54a4360-26df-5f1a-b161-298c03c03b66}` для захвата изображения с виртуального дисплея при подключение.

### Wolf

[Wolf](https://github.com/games-on-whales/wolf) - потоковый сервер для [Moonlight](https://github.com/moonlight-stream/moonlight-qt), который позволяет нескольким удаленным пользователям совместно использовать один сервер для игр. Особенности включают поддержку многопользовательского режима, создание виртуальных столов с возможностью настройки разрешения и FPS, а также одновременное использование различных графических процессоров для задач, таких как кодирование и игры. Сервер обеспечивает низкую задержку в стриминге видео и аудио, совместим с игровыми контроллерами и ориентирован на Linux и Docker, что обеспечивает безопасность в низкопривилегированных контейнерах.

```yaml
services:
  wolf:
    image: ghcr.io/games-on-whales/wolf:stable
    container_name: wolf
    restart: unless-stopped
    device_cgroup_rules:
      - 'c 13:* rmw'
    volumes:
      - /etc/wolf/:/etc/wolf
      - /var/run/docker.sock:/var/run/docker.sock:rw
      - /dev/:/dev/:rw
      - /run/udev:/run/udev:rw
    devices:
      - /dev/dri
      - /dev/uinput
      - /dev/uhid
    network_mode: host
```

### Dolphin

[Dolphin](https://github.com/dolphin-emu/dolphin) - эмулятор GameCube и Wii собранный в [Docker образе](https://github.com/linuxserver/docker-dolphin) для запуска в браузере на базе [Selkies](https://github.com/selkies-project/selkies).

```yaml
services:
  dolphin:
    image: lscr.io/linuxserver/dolphin:latest
    container_name: dolphin
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/GMT+3
    volumes:
      - ./dolphin_config:/config
      - ./dolphin_games:/games
    ports:
      - 3001:3001
      - 3002:3000
    shm_size: 1gb
```

### DuckStation 

[DuckStation](https://github.com/stenzek/duckstation) - эмулятор PlayStation 1, собранный в [Docker образе](https://docs.linuxserver.io/images/docker-duckstation/).

```yaml
services:
  duckstation:
    image: lscr.io/linuxserver/duckstation:latest
    container_name: duckstation
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
    volumes:
      - ./duckstation_config:/config
      - ./duckstation_games:/games
    ports:
      - 3001:3001
      - 3002:3000
    shm_size: 1gb
```

### RomM

[RomM](https://github.com/rommapp/romm) - менеджер и проигрыватель ROM-файлов, предназначенный для организации и запуска коллекций игр через эмуляторы.

[Argosy Launcher](https://github.com/rommapp/argosy-launcher) - лаунчер Android с нативной интеграцией ROMM.

```yaml
services:
  romm-ui:
    image: rommapp/romm:latest
    container_name: romm-ui
    restart: always
    ports:
      - 8000:8080
    environment:
      - DB_HOST=romm-db
      - DB_NAME=romm
      - DB_USER=romm-user
      - DB_PASSWD=romm-password
      # openssl rand -hex 32
      - ROMM_AUTH_SECRET_KEY=202dda04a25382fc49e6cd360d3b579d5ac86ea2c781ab5a61b8964266b0b67c
    volumes:
      # Redis data
      - ./romm_data/redis:/redis-data
      # ROMs data (e.g. library/roms/n64)
      - ./romm_data/library:/romm/library
      - ./romm_data/config:/romm/config
      - ./romm_data/resources:/romm/resources
      - ./romm_data/assets:/romm/assets
    networks:
      - romm_network
    depends_on:
      romm-db:
        condition: service_healthy
        restart: true

  # docker exec -it romm-db mariadb -u romm-user -promm-password romm
  # SHOW TABLES;
  romm-db:
    image: mariadb:latest
    container_name: romm-db
    restart: always
    ports:
      - 3306:3306
    environment:
      - MARIADB_ROOT_PASSWORD=admin
      - MARIADB_DATABASE=romm
      - MARIADB_USER=romm-user
      - MARIADB_PASSWORD=romm-password
    volumes:
      - ./romm_data/db:/var/lib/mysql
    networks:
      - romm_network
    healthcheck:
      test: [CMD, healthcheck.sh, --connect, --innodb_initialized]
      start_period: 30s
      start_interval: 10s
      interval: 5s
      timeout: 5s
      retries: 5

networks:
  romm_network:
    driver: bridge
```

### RetroAssembly

[RetroAssembly](https://github.com/arianrhodsandlot/retroassembly) - библиотека ретро-игры в браузере, с поддержку виртуального контроллера.

```yaml
services:
  retroassembly:
    image: arianrhodsandlot/retroassembly
    container_name: retroassembly
    restart: unless-stopped
    volumes:
      - ./game_data:/app/data # ROMs and save states
    ports:
      - 8000:8000
```

### Emulator.js

[Emulator.js](https://github.com/EmulatorJS/EmulatorJS) - веб-интерфейс для [RetroArch](https://github.com/libretro/RetroArch).

🔗 [Emulator.js Playground](https://demo.emulatorjs.org) ↗

```yaml
services:
  emulator-js:
    image: lscr.io/linuxserver/emulatorjs:1.9.2
    container_name: emulator-js
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC+3
      - SUBFOLDER=/
    volumes:
      - ./emulatorjs_config:/config
      - ./roms:/data
    ports:
      - 80:80
      - 3000:3000
      # - 4001:4001
```

### Junie

[Junie](https://github.com/Namaneo/Junie) - интерфейс [Libretro](https://github.com/libretro), работающий в браузере.

🔗 [Junie Playground](https://namaneo.github.io/Junie) ↗

```yaml
services:
  junie:
    image: namaneo/junie
    container_name: junie
    restart: unless-stopped
    volumes:
      - ./games:/junie/games
    ports:
      - 8008:8000
```

### Quizzle

[Quizzle](https://github.com/gnmyt/Quizzle) - платформа проведения викторин для школ от создателя [Nexterm](https://github.com/gnmyt/Nexterm) и [MySpeed](https://github.com/gnmyt/MySpeed).

```yaml
services:
  quizzle:
    image: germannewsmaker/quizzle:latest
    container_name: quizzle
    restart: unless-stopped
    environment:
      - TZ=Etc/UTC+3
    volumes:
      - ./quizzle_data:/quizzle/data
    ports:
      - 6412:6412
```