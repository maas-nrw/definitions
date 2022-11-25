#!/bin/sh -x

docker build . -t hilbigit/newman-json-summary-report:latest
docker push hilbigit/newman-json-summary-report:latest