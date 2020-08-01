#!/bin/bash
xhost +
sudo docker run --net=host -it --rm -e DISPLAY=$DISPLAY  -v /tmp/.X11-unix:/tmp/.X11-unix:ro dtm
