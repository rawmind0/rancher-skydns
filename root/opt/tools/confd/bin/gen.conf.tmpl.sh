#!/usr/bin/env bash

ETCD_PORT=${ETCD_PORT:-"2379"}

cat << EOF > ${SERVICE_VOLUME}/confd/etc/conf.d/server.properties.toml
[template]
src = "skydns-source.tmpl"
dest = "${SERVICE_HOME}/etc/skydns-source"
owner = "${SERVICE_USER}"
mode = "0644"
keys = [
  "/stacks",
]
EOF

cat << EOF > ${SERVICE_VOLUME}/confd/etc/templates/skydns-source.tmpl
#!/usr/bin/env bash

export ETCD_MACHINES="
{{- \$etcd_link := split (getenv "ETCD_SERVICE") "/" -}}
{{- \$etcd_stack := index \$etcd_link 0 -}}
{{- \$etcd_service := index \$etcd_link 1 -}} 
{{- range \$i, \$e := ls (printf "/stacks/%s/services/%s/containers" \$etcd_stack \$etcd_service) -}}
  {{- if \$i -}},{{- end -}}
  http://{{getv (printf "/stacks/%s/services/%s/containers/%s/primary_ip" \$etcd_stack \$etcd_service \$e)}}:${ETCD_PORT}
{{- end }}"
export ETCD_MACHINES=${ETCD_MACHINES:-"http://etcd:2379"}
export SKYDNS_ADDR=${SKYDNS_ADDR:-"0.0.0.0:5353"}
export SKYDNS_DOMAIN=${SKYDNS_DOMAIN:-"dev.local"}
export SKYDNS_PATH_PREFIX=${SKYDNS_PATH_PREFIX:-"skydns"}
export SKYDNS_NDOTS=${SKYDNS_NDOTS:-"1"}
export SKYDNS_NO_REC=${SKYDNS_NO_REC:-"true"}
if [ "${SKYDNS_NO_REC}" == "true" ]; then
	export SKYDNS_NAMESERVERS=${SKYDNS_NAMESERVERS:-""} 
else
   	export SKYDNS_NAMESERVERS=${SKYDNS_NAMESERVERS:-"8.8.8.8:53,8.8.4.4:53"} 
fi
EOF