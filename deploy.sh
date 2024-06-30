#!/bin/bash

cd PlusOneBlogTaskServer

docker compose down  

docker volume rm -f plusoneblogtaskserver_app-dir

docker compose pull app

docker compose up --build -d