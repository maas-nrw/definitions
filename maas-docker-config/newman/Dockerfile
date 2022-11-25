FROM node:current-slim

ENV NODE_OPTIONS="--max_old_space_size=20480"
RUN mkdir /etc/newman
WORKDIR /etc/newman

RUN npm install --global newman
RUN npm install --global newman-reporter-json-summary
RUN npm install --global newman-reporter-csv
ENTRYPOINT ["newman"]