#!/bin/bash

LOGFILE="./docker_run.log"
NETWORK_NAME="scope-net"

# Funktion, um Container nach Namen zu stoppen und zu entfernen
cleanup_container() {
    local CONTAINER_NAME="$1"
    if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
        echo "[$(date)] Container ${CONTAINER_NAME} existiert, stoppe und entferne..." | tee -a $LOGFILE
        docker rm -f $CONTAINER_NAME >> $LOGFILE 2>&1
    else
        echo "[$(date)] Container ${CONTAINER_NAME} existiert nicht, alles gut." | tee -a $LOGFILE
    fi
}

# --- Netzwerk erstellen ---
if [ -z "$(docker network ls -q -f name=^${NETWORK_NAME}$)" ]; then
    echo "[$(date)] Erstelle Docker Netzwerk ${NETWORK_NAME}..." | tee -a $LOGFILE
    docker network create $NETWORK_NAME >> $LOGFILE 2>&1
else
    echo "[$(date)] Netzwerk ${NETWORK_NAME} existiert bereits." | tee -a $LOGFILE
fi

# --- Postgres starten ---
echo "[$(date)] Starte DB..." | tee -a $LOGFILE
cleanup_container "scope-db"

docker run -d \
  --name scope-db \
  --network $NETWORK_NAME \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=postgres \
  -v $(pwd)/init-scripts:/docker-entrypoint-initdb.d \
  -p 5632:5432 \
  postgres:15 >> $LOGFILE 2>&1

echo "[$(date)] Warte auf Postgres readiness..." | tee -a $LOGFILE
until docker exec scope-db pg_isready -U postgres >> $LOGFILE 2>&1; do
    echo "[$(date)] Database not ready, warte 2s..." | tee -a $LOGFILE
    sleep 2
done
echo "[$(date)] Postgres ist bereit ✅" | tee -a $LOGFILE

# --- Init-Container ---
cleanup_container "scope-init"
echo "[$(date)] Starte Init-Container..." | tee -a $LOGFILE

docker run --rm \
  --name scope-init \
  --network $NETWORK_NAME \
  -e DB_NAME=postgres \
  -e DB_USER=postgres \
  -e DB_PASSWORD=postgres \
  -e DB_HOST=scope-db \
  -e DB_PORT=5432 \
  ghcr.io/aylinyil/scopevisio-set-initial-data:commit-061b273b0c5b926a749e3007132d4434189b3053 >> $LOGFILE 2>&1

echo "[$(date)] Init-Container fertig ✅" | tee -a $LOGFILE

# --- Frontend starten ---
cleanup_container "scope-frontend"
echo "[$(date)] Starte Frontend-Container auf Port 8000..." | tee -a $LOGFILE

docker run -d \
  --name scope-frontend \
  --network $NETWORK_NAME \
  -p 8000:8000 \
  -e API_HOST=scope-service-1 \
  -e API_PORT=8083 \
  ghcr.io/aylinyil/scopevisio-frontend:commit-b7d3eaa6bc1b13ad8250de022f305c5bbbffab2d >> $LOGFILE 2>&1

echo "[$(date)] Frontend gestartet ✅ http://localhost:8000" | tee -a $LOGFILE

# --- Static Data starten ---
cleanup_container "scope-static-data"
echo "[$(date)] Starte Static-Data-Container auf Port 8080..." | tee -a $LOGFILE

docker run -d \
  --name scope-static-data \
  --network $NETWORK_NAME \
  -p 8080:8080 \
  ghcr.io/aylinyil/scopevisio-static-data:commit-a0842ab >> $LOGFILE 2>&1

echo "[$(date)] Static-Data gestartet ✅ http://localhost:8080" | tee -a $LOGFILE

# --- Scope-Service-1 starten ---
cleanup_container "scope-service-1"
echo "[$(date)] Starte Scope-Service-1-Container auf Port 8083..." | tee -a $LOGFILE

docker run -d \
  --name scope-service-1 \
  --network $NETWORK_NAME \
  -p 8083:8083 \
  -e SERVICE2_HOST=http://scope-service-2 \
  -e SERVICE2_PORT=8082 \
  ghcr.io/aylinyil/scopevisio-service-1:commit-289cc44 >> $LOGFILE 2>&1

echo "[$(date)] Scope-Service-1 gestartet ✅ http://localhost:8083" | tee -a $LOGFILE

# --- Scope-Service-2 starten ---
cleanup_container "scope-service-2"
echo "[$(date)] Starte Scope-Service-2-Container auf Port 8082..." | tee -a $LOGFILE

docker run -d \
  --name scope-service-2 \
  --network $NETWORK_NAME \
  -p 8082:8082 \
  ghcr.io/aylinyil/scopevisio-service-2:commit-26b69cc >> $LOGFILE 2>&1

echo "[$(date)] Scope-Service-2 gestartet ✅ http://localhost:8082" | tee -a $LOGFILE
