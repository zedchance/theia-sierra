#!/bin/bash

docker buildx build --no-cache --platform linux/amd64 -t zedchance/theia-cs39:dev .

