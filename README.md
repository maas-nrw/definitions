# Public definitions and documentation for MaaS NRW (WIP = Work in progress)
This public repository contains initial information about standards, config etc. for MaaS NRW 2.0. 
It is not complete, just a starting point..

## Usefull Docker Configs

Folder [maas-docker-config](maas-docker-config) contains docker compose file and necessary config files for setting up
some of the tools used within the MaaS NRW Project.

### Installing the intermodal router prototype

1. Cloning this repository 

```
git clone git@github.com:maas-nrw/definitions.git

```
2. Installation of `docker` and `docker-compose-plugin` 
   Precondition is to have the latest docker version and the docker-compose plugin installed - on Ubuntu this can be achieved via `apt`:

```
sudo apt update
sudo apt install docker.io --fix-missing
sudo apt install docker-compose-plugin
```
Note: On Ubuntu 22.04 LTS `docker-compose-plugin` is not part of the default repository. In that case use https://docs.docker.com/engine/install/ubuntu/#set-up-the-repository to add the docker repository to Ubuntu.

Note: On Win10, follow the instructions given by [docker](https://docs.docker.com/desktop/install/windows-install/). If you want to circumvent the usage of docker-desktop see [Felipe Santos post](https://dev.to/felipecrs/simply-run-docker-on-wsl2-3o8), not tested yet.

2. Configuration
The router can be started and configured using a public docker image which is installed automatically by the docker compose using [docker-compose-maas-router.yml](maas-docker-config/router/docker-compose.yml).


The router embeds the MaaS specific fork of the [openpoiservice](https://github.com/maas-nrw/openpoiservice) project as a python module - many thanks and credits to the original creators!

The openpoiservice is used to lookup stations and other interesting features for choosing important points to be considered by the router.

The router and all dependencies can be started using  
```
cd definitions/maas-docker-config/router/
docker compose up -d  api
```
For using the (experimental) Python 3.11 version (much faster!) the following override config will start it at port 5011:
```
docker compose -f docker-compose.yml -f docker-compose-python311.yml up -d  api
```
Afterwards the database has to be initialised because otherwise no POIs will be found. 
The following sample downloads NRW or Cologne map data and loads all POIs configured within the ops_setting_maas.yml:

```
# Create database
docker exec -it router-api python manage.py create-db
# Download map data from geofabrik.de
# E.g. whole of Nordrhein Westfalen..
docker exec -it router-api python manage.py add-map "europe/germany/nordrhein-westfalen"
# .. or just Cologne (-regbez has to be added to the name of the city, multiple files can be downloaded and imported) 
docker exec -it router-api python manage.py add-map "europe/germany/nordrhein-westfalen/koeln-regbez"
# Parse map data and import POI data into Database according to the configuration
docker exec -it router-api python manage.py import-data
```

The OpenTripPanner also requires one of the downloaded maps from previous step.
Therefore, it is configured to use the same path. An addition the GTFS-feeds has to be downloaded.

```
docker exec -it router-api python manage.py add-gtfs
```

The OpenTripPlanner can be started by using the following command:
(This will also start the dependent service: otp-graph-builder)

#### Please make sure you have allocated enough resources to your docker environment. The service is very greedy and configured to use up to 15GB of memory

```
docker compose up -d otp
```

NOTE:  When you use this command for the first time, the opt-app image crashes as long as the graph file does not exist.
Building the graph file takes a while, please be patient.

If you like to track the progress, type:

```
docker logs --follow graph
```

Afterwards the API can be used, e.g.

http://localhost:5001/route?from=6.866623:51.145449&to=7.033931230978567:51.34241436794224&modal=intermodal&output_format=html

http://localhost:5001/route?from=6.866623:51.145449&to=7.033931230978567:51.34241436794224&modal=intermodal&output_format=geojson

http://localhost:5001/route?from=6.866623:51.145449&to=7.033931230978567:51.34241436794224&modal=bicycle&output_format=html

Parameters are:
- from,to=WGS84 coordinates,  longitude:latitude
- modal=[delfi|intermodal|bicycle] selects the routers which will be used in the background

Optional:
- output_format=[html|geojson]
### AWS Deployment
The [ecs-cli](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Copilot.html) now supports sending docker compose configs in Amazon ECS:

1. Download and install AWS Copilot CLI using the above link or the provided setup scripts [setup.sh for Linux](aws-deploy/setup.sh) or [setup.ps for Linux](aws-deploy/setup.ps1)
- Precondition for the script is the [installation of Gnu GPG](https://www.gnupg.org/download/index.html)
2. 
## Relevant standards

### GeoJson - Standard and default geo coordinate system specification

The [GeoJSON - Format](https://www.rfc-editor.org/rfc/rfc7946) is widely used within the community and relevant projects around MaaS (e.g. by both GTFS / GBFS, TOMP-API).

As an implication this project uses WS (longitude,latitude,[altitude]) as format for specifying coordinates, using the 
World Geodetic System 1984 (WGS 84) [WGS84] as a geographic coordinate reference system, with longitude and latitude units
of decimal degrees - if not otherwise stated

**Helpful tools and links**

1. https://geojson.io/ provides an editor for creating GeoJson - Data by drawing on a map 