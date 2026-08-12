# FROM alpine:3.23
# RUN apk add --no-cache curl bash && \
#     curl -fsSL https://opencode.ai/install | bash

FROM node:26-alpine

RUN npm install -g npm@latest && \
    npm install -g opencode-ai@latest && \
    npm cache clean --force

RUN adduser --disabled-password --gecos "" opencode && \
    mkdir -p /home/opencode/.local/share/opencode \
             /home/opencode/.local/state/opencode \
             /home/opencode/.config/opencode && \
    chown -R opencode:opencode /home/opencode

USER opencode

EXPOSE 4096

CMD ["opencode", "serve", "--hostname", "0.0.0.0", "--port", "4096"]