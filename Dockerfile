# Based on https://dev.to/stoutlabs/my-docker-setup-for-gatsbyjs-and-nextjs-5gao
FROM node:12.13.0-alpine AS gatsby

# Also exposing VSCode debug ports
EXPOSE 8000 9929 9230

RUN \
  apk add --no-cache python make g++ git && \
  apk add vips-dev fftw-dev --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community --repository http://dl-3.alpinelinux.org/alpine/edge/main && \
  rm -fR /var/cache/apk/* && \
  npm install -g gatsby-cli yarn

WORKDIR /app
ENV GATSBY_WEBPACK_PUBLICPATH=/

FROM gatsby AS builder

COPY ./package.json .
COPY ./yarn.lock .
RUN yarn install && yarn cache clean
COPY . .

#Argument so that you can run a different task (e.g. tests)
ARG COMMAND="yarn build"
RUN $COMMAND

FROM nginx:1.17.5-alpine

COPY --chown=nginx:nginx --from=builder /app/public /usr/share/nginx/html/