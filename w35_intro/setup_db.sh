#!/bin/bash

cd "$(dirname "$0")"

NAME="company_db"
PASSWORD="password123ABC"
SETUP_DB="/tmp/setupdb.sql"
DB="Company"

docker stop $NAME

echo "docker run mssqlserver with name $NAME"
docker run --rm -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=$PASSWORD" -e "MSSQL_PID=Evaluation" -p 1433:1433  --name $NAME --hostname $NAME -d mcr.microsoft.com/mssql/server:2022-latest

until [ "`docker inspect -f {{.State.Running}} $NAME`"=="true" ]; do
    echo "waiting for docker container $NAME to be running..."
	sleep 3;
done;
echo "$NAME is up and running"

echo "Creating file $SETUP_DB"
docker exec "$NAME" /bin/bash -c "touch $SETUP_DB"

echo "Copying file to docker container"
docker cp setupdb.sql $NAME:/tmp/setupdb.sql

sleep 10
echo "Executing $SETUP_DB"
# TODO following cmd not working, for some reason "/t" is stripped from $SETUP_DB having sqlcmd looking for a file in "mp/setupdb.sql".
# Also note that setupdb.sql is named WITHOUT underscore, as sqlcmd deems "setup_db.sql" as an "Invalid filename".
#docker exec -it $NAME /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P $SPASSWORD -d $DB -i $SETUP_DB -C
docker exec -it $NAME /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P password123ABC -C -i /tmp/setupdb.sql

echo "all done. Now, connect to db using
	* host=localhost
	* port=1433
	* user=sa
	* password=password123ABC
	* database=master
	* ie. url=Server=localhost,1433;Database=master
	* if using datagrip in Jetbrains IDE, hit ctrl shift alt U to open diagram
	-- or --
	
	debug
	in bash
       	'docker exec -it company_db /bin/bash'
	in docker
	'/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P password123ABC -C'
	in sqlcmd
	'sp_databases
	go'
	etc.
"	












