# docker go2_robot_sdk

clone Dockerfile and docker-compose.yaml to your folder

```
cd <your_folder>

docker-compose up --build

docker exec -it <your_container> /bin/bash

colcon build

source install/setup.bash

ros2 launch go2_robot_sdk robot.launch.py

```
## we can change ip and type in the container 
```
export ROBOT_IP="robot_ip"
export CONN_TYPE="webrtc"
```
## open a new terminal to launch the container
```
ros2 topic list
```
Now, eg: /point_cloud2, /tf ......
common msgs can be read by using:
```
ros2 topic echo /topic_name
```

## To be continue......(2025.03)

## Update beta0.2 (2025.04.08)

the docker-compose.yaml has been changed. Add a share space between the host and container. 

In the docker-compose.yaml:

My folder is "/home/silco/data_share_container", change it by yours. And in the docker the folder name is "/data_share", you change it by you like.

"
volumes:
      - /home/silco/data_share_container:/data_share
"

So you can get the file directly by using:

```
ros2 bag record -o /data_share/data01 /camera/image_raw
```
