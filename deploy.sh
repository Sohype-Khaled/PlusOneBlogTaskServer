#!/bin/bash

cd PlusOneBlogTaskServer

docker volume rm plusoneblogtaskserver_app-dir

docker compose pull app

docker compose up --build -d