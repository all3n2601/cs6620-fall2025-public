FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

ARG BUILD_DATE=local
ARG BUILD_REVISION=local
ARG BUILD_RUN_ID=local
ENV BUILD_DATE=$BUILD_DATE \
    BUILD_REVISION=$BUILD_REVISION \
    BUILD_RUN_ID=$BUILD_RUN_ID

WORKDIR /app

# pydub uses FFmpeg to decode and convert audio files.
RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "-m", "flask", "--app", "app", "run", "--host=0.0.0.0", "--port=5000"]
