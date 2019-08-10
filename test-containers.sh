#!/bin/bash

if [[ $(sudo docker exec -it backend-app sh -c "curl -I localhost:5000" |grep -c UNAUTHORIZED) -ne 1 ]]
then
  exit 2
fi
