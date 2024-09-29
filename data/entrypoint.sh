#!/bin/bash

# SQL Server'ı arka planda başlat
/opt/mssql/bin/sqlservr &

# SQL Server'ın tam olarak başlaması için bekle (30 saniye yeterli olabilir)
sleep 30

# Veritabanı adını ve kullanıcı bilgilerini dinamik olarak al
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${SA_PASSWORD}


# Veritabanının var olup olmadığını kontrol et ve oluştur
if ! /opt/mssql-tools18/bin/sqlcmd -S localhost -U ${DB_USER} -P ${DB_PASSWORD} -d master -Q "IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = '$DB_NAME') BEGIN CREATE DATABASE [$DB_NAME]; END" -C; then
    echo "Veritabanı oluşturma işlemi başarısız oldu!"
    exit 1
fi
# SQL Server'ı arka planda çalıştırmaya devam et
wait
