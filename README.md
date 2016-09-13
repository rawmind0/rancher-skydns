[![](https://images.microbadger.com/badges/image/rawmind/rancher-skydns.svg)](https://microbadger.com/images/rawmind/rancher-skydns "Get your own image badge on microbadger.com")

rancher-skydns
==============

This image is the skydns dynamic conf for rancher. It comes from [rancher-tools][rancher-tools].

## Build

```
docker build -t rawmind/rancher-skydns:<version> .
```

## Versions

- `2.5.3-1` [(Dockerfile)](https://github.com/rawmind0/rancher-skydns/blob/2.5.3-1/README.md)


## Usage

This image has to be run as a sidekick of [alpine-skydns][alpine-skydns], and makes available /opt/tools volume. It scans from rancher-metadata, for a etcd stack and service, and generates etcd connection string dynamicly.


[alpine-skydns]: https://github.com/rawmind0/alpine-kafka
[rancher-tools]: https://github.com/rawmind0/rancher-tools