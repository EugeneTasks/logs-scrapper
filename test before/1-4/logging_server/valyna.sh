#!/bin/bash

CLI_NAME="docker_cli"

show_help() {
  echo "Usage: $CLI_NAME [COMMAND] [ARGS...]"
  echo ""
  echo "Commands:"
  echo "  help               Show this help message"
  echo "  rebuild            Rebuild fluentd image and bring compose up (down -> rmi -> prune -> build -> up)"
  echo ""
}


rebuild() {
  echo "Starting rebuild sequence..."
  docker compose down
  docker rmi logging_server-fluentd
  docker system prune -f
  echo "Building fluentd image without cache..."
  docker compose build --no-cache fluentd
  docker compose up -d
  echo "Rebuild sequence finished."
}

# Основной блок обработчика команд
case "$1" in
  rebuild)
    rebuild
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    echo "Unknown command: $1"
    show_help
    ;;
esac