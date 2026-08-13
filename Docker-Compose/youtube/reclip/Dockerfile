FROM python:3.12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends git ffmpeg && \
    git clone https://github.com/averygan/reclip /app && ls -lh && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8899
ENV HOST=0.0.0.0

CMD ["python", "app.py"]