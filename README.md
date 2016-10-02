# feederco/rethinkdb-cluster

This image is layer on-top of the standard rethinkdb image to make it easier to setup a cluster on swarm.

It's inspired a lot thanks to the great [walkhrough by Stefan Prodan](https://github.com/stefanprodan/aspnetcore-dockerswarm/wiki/RethinkDB-Swarm), but using this image you do not need the secondary/primary steps.

It uses the swarm DNS to request all nodes in the `rethinkdb`-namespace, and passes it on to the rethinkdb startup command.

## Usage

First create a network:

```shell
$ docker network create --driver overlay rethinkdb-network
```

Setup a service for rethinkdb:

```shell
$ docker service create \
  --name rethinkdb \
  --network rethinkdb-network \
  --mount type=volume,source=/var/lib/rethinkdb,target=/data,type=bind \
  --update-delay 10s \
  feeder/rethinkdb-cluster
```

Now you can scale up the service depending on the number of nodes available.

```shell
$ docker service scale rethinkdb=2
```

### RethinkDB admin

To simplify things it's easier to run the rethinkdb admin as a separate service. Here is how you can do that:

```shell
$ docker service create \
  --name rethinkdb-admin \
  --network rethinkdb-network \
  --publish 8080:8080 \
  --update-delay 10s \
  rethinkdb \
  rethinkdb proxy --bind all --join rethinkdb
```

Then visit `http://$IP:8080` in your browser.

## Problems to be solved.

- [ ] I'm not sure how to limit docker swarm to only run one instance of rethinkdb per node
- [ ] I'm not super sure all this is necessary...

## Building

```shell
$ docker-compose build
$ docker-compose push
```
