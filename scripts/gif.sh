#!/bin/bash
if [[ $# -eq 0 ]] ; then
	exit 0
fi

for var in "$@"
do
	sudo docker cp  `sudo docker ps | grep _ | awk '{print $NF}'`:/$var/$var.gif ../
	sudo chown -R tom:tom ../$var.gif
done

