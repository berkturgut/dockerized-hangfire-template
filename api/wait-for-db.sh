#!/bin/bash

# Bağlantı bilgileri
DB_HOST="${DB_HOST}"  
DB_PORT="${DB_PORT}"  
DB_USER="${DB_USER}"  
DB_PASSWORD="${DB_PASSWORD}"
DB_NAME="${DB_NAME}" 

# Retry configuration
RETRY_COUNT=10  # Maximum number of attempts
SLEEP_TIME=10   # Time to wait between attempts (in seconds)

# Check database connection and if the task-manager database exists
for i in $(seq 1 $RETRY_COUNT); do
    echo "Attempting to connect to the database ($i/$RETRY_COUNT)..."
    
    # Task-manager veritabanının var olup olmadığını kontrol et
    /opt/mssql-tools18/bin/sqlcmd -S $DB_HOST,$DB_PORT -U $DB_USER -P $DB_PASSWORD -d master -C -N -Q "IF DB_ID('$DB_NAME') IS NOT NULL SELECT 1 AS DBExists" | grep -q "1"
   
    if [ $? -eq 0 ]; then
        echo "Database '$DB_NAME' exists and connection successful!"
        break
    else
        echo "Database '$DB_NAME' not found or connection failed. Retrying in $SLEEP_TIME seconds..."
        sleep $SLEEP_TIME
    fi

    # Son denemede başarısız olunursa hatayla çık
    if [ $i -eq $RETRY_COUNT ]; then
         echo "Failed to connect to the database '$DB_NAME' after $RETRY_COUNT attempts. Exiting."
        exit 1
    fi
done

# Start the API after the database connection is successful
echo "Starting the API..."
exec dotnet api.dll
