# A simple Apache Hadoop 2.7.3 Docker image

This is a very simple and not optimized Docker image containing Apache Hadoop. 

The main purpose of this container is to help who wants to start using Apache Hadoop and does not want to spend too much time for the initial installation and configuration process. 
As you will notice, the container is not optimized. However, we provide the Dockerfile and strongly encourage whoever wants to improve this Docker image.


# Build the image

You can build your own image, using the Dockerfile. Just run the following command: 

```
docker build  -t matnar/hadoop:2.7.3 .
```
# Pull the image

This image is also released as an official Docker image from Docker's automated build repository - you can always pull or refer the image when launching containers.

```
docker pull matnar/hadoop
```

# Start a container

In order to use the Docker image you have just build or pulled use:

```
docker run -t -i -p 50070:50070 --name=master matnar/hadoop 
```

## Create an isolated network with several datanodes

```
docker network create --driver bridge hadoop_network

docker run -t -i -p 50075:50075 -d --network=hadoop_network --name=slave1 matnar/hadoop 
docker run -t -i -p 50076:50075 -d --network=hadoop_network --name=slave2 matnar/hadoop 
docker run -t -i -p 50077:50075 -d --network=hadoop_network --name=slave3 matnar/hadoop 
docker run -t -i -p 50070:50070 --network=hadoop_network --name=master matnar/hadoop 
```

