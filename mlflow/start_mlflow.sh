#!/bin/sh
# Запускать из директории ./mlflow
# Порт 5001: на macOS 5000 часто занят Control Center (AirPlay)
mlflow server \
  --backend-store-uri sqlite:///mlruns.db \
  --default-artifact-root ./mlartifacts \
  --host 127.0.0.1 \
  --port 5001
