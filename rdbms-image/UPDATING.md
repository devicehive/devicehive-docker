# Updating to devicehive-docker 3.4.1
With release of devicehive-docker 3.4.1 we updated PostgreSQL container from version 9.4 to 10. Because of that database dump/restore procedure is required.
You can find following error in `postgres` container log, that means that dump/restore is not done yet:
```
FATAL:  database files are incompatible with server
DETAIL:  The data directory was initialized by PostgreSQL version 9.4, which is not compatible with this version 10.0.
```

1. Before updating to 3.4.1, create database backup as described in "Backup and restore" section in [README](README.md#backup-postgresql-database).
2. Stop DeviceHive and update devicehive-docker to version 3.4.1.
3. Remove docker volume for database, start only database and restore data, then start full application. Exact steps are detailed in "Backup and restore" section in [README](README.md#restore-postgresql-database).

