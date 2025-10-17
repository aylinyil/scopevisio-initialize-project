$LogFile = "./docker_run.log"
$NetworkName = "scope-net"

Function Write-Log {
    param([string]$Message)
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $line = "[$timestamp] $Message"
    $line | Tee-Object -FilePath $LogFile -Append
}

Function Cleanup-Container {
    param([string]$ContainerName)

    $exists = docker ps -aq -f "name=^/${ContainerName}$"
    if ($exists) {
        Write-Log "Container $ContainerName existiert, stoppe und entferne..."
        docker rm -f $ContainerName >> $LogFile 2>&1
    }
    else {
        Write-Log "Container $ContainerName existiert nicht, alles gut."
    }
}

# --- Netzwerk erstellen ---
if (-not (docker network ls -q -f "name=^$NetworkName$")) {
    Write-Log "Erstelle Docker Netzwerk $NetworkName..."
    docker network create $NetworkName >> $LogFile 2>&1
} else {
    Write-Log "Netzwerk $NetworkName existiert bereits."
}

# --- Postgres starten ---
Write-Log "Starte DB..."
Cleanup-Container "scope-db"

docker run -d `
  --name scope-db `
  --network $NetworkName `
  -e POSTGRES_USER=postgres `
  -e POSTGRES_PASSWORD=postgres `
  -e POSTGRES_DB=postgres `
  -v "$(Get-Location)\init-scripts:/docker-entrypoint-initdb.d" `
  -p 5632:5432 `
  postgres:15 >> $LogFile 2>&1

Write-Log "Warte auf Postgres readiness..."
do {
    docker exec scope-db pg_isready -U postgres >> $LogFile 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Log "Database not ready, warte 2s..."
        Start-Sleep -Seconds 2
    }
} while ($LASTEXITCODE -ne 0)
Write-Log "Postgres ist bereit ✅"

# --- Init-Container ---
Cleanup-Container "scope-init"
Write-Log "Starte Init-Container..."

docker run --rm `
  --name scope-init `
  --network $NetworkName `
  -e DB_NAME=postgres `
  -e DB_USER=postgres `
  -e DB_PASSWORD=postgres `
  -e DB_HOST=scope-db `
  -e DB_PORT=5432 `
  ghcr.io/aylinyil/scopevisio-set-initial-data:commit-061b273b0c5b926a749e3007132d4434189b3053 >> $LogFile 2>&1

Write-Log "Init-Container fertig ✅"

# --- Frontend starten ---
Cleanup-Container "scope-frontend"
Write-Log "Starte Frontend-Container auf Port 8000..."

docker run -d `
  --name scope-frontend `
  --network $NetworkName `
  -p 8000:8000 `
  -e API_HOST=scope-service-1 `
  -e API_PORT=8083 `
  ghcr.io/aylinyil/scopevisio-frontend:commit-b7d3eaa6bc1b13ad8250de022f305c5bbbffab2d >> $LogFile 2>&1

Write-Log "Frontend gestartet ✅ http://localhost:8000"

# --- Static Data starten ---
Cleanup-Container "scope-static-data"
Write-Log "Starte Static-Data-Container auf Port 8080..."

docker run -d `
  --name scope-static-data `
  --network $NetworkName `
  -p 8080:8080 `
  ghcr.io/aylinyil/scopevisio-static-data:commit-bd517d1 >> $LogFile 2>&1

Write-Log "Static-Data gestartet ✅ http://localhost:8080"

# --- Scope-Service-1 starten ---
Cleanup-Container "scope-service-1"
Write-Log "Starte Scope-Service-1-Container auf Port 8083..."

docker run -d `
  --name scope-service-1 `
  --network $NetworkName `
  -p 8083:8083 `
  -e SERVICE2_HOST=http://scope-service-2 `
  -e SERVICE2_PORT=8082 `
  ghcr.io/aylinyil/scopevisio-service-1:commit-bf688e2 >> $LogFile 2>&1

Write-Log "Scope-Service-1 gestartet ✅ http://localhost:8083"

# --- Scope-Service-2 starten ---
Cleanup-Container "scope-service-2"
Write-Log "Starte Scope-Service-2-Container auf Port 8082..."

docker run -d `
  --name scope-service-2 `
  --network $NetworkName `
  -p 8082:8082 `
  ghcr.io/aylinyil/scopevisio-service-2:commit-7d1fbf7 >> $LogFile 2>&1

Write-Log "Scope-Service-2 gestartet ✅ http://localhost:8082"
