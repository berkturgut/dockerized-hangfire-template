# Base image
FROM mcr.microsoft.com/mssql/server:2022-latest

EXPOSE 1433

# ENTRYPOINT ["/opt/mssql/bin/sqlservr"]
USER root
# Shell script dosyasını kopyala

COPY ./entrypoint.sh /usr/src/app/entrypoint.sh

# Shell script'e çalıştırılabilir izinleri ver
RUN chmod +x /usr/src/app/entrypoint.sh

USER mssql

# Başlatılacak script (SQL Server ve init.sql'in başlatılması)
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]



