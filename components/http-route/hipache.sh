#!/bin/bash
#http route service:hipache

npm install hipache -g
cat > /etc/hipache.json<EOF
{
    "server": {
        "accessLog": "/var/log/hipache_access.log",
        "port": 80,
        "workers": 5,
        "maxSockets": 100,
        "deadBackendTTL": 30,
        "address": ["127.0.0.1", "::1"],
    },
    "driver": "redis://127.0.0.1:6379"
}
EOF
sudo hipache --config /etc/hipache.json





