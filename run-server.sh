#!/bin/bash

echo "Injected runtime vars are:"
echo $DW_ENV
echo $DW_HTTP_PORT
echo $DATABASE_URL
echo $DATABASE_USER
echo $DATABASE_PASSWORD

echo "Render vars to a structure suitable for saving"

INJECTED_RUNTIME_VARS=$(cat << EOF
{
  db: {
    url: "$DATABASE_URL",
    user: "$DATABASE_USER",
    password: "$DATABASE_PASSWORD"
  }
}
EOF
)

echo "Save injected variables to file, overwriting whatever was there already"
echo $INJECTED_RUNTIME_VARS > /tmp/runtime-env-vars.yml 

echo "Contents of temporary config file are:"
cat /tmp/runtime-env-vars.yml
echo "End of temp config file"

# Then run the server
java -jar target/*-service-*-jar-with-dependencies.jar mendeley-server -e $DW_ENV -L -f /tmp/runtime-env-vars.yml
