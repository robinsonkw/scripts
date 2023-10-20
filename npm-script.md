# NGINX Reverse Proxy script for hosts

This script specifically focuses on NPM routing traffic to Proxmox

```bash
server {
    listen 80;
    server_name pve.domain.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name pve.domain.com;
    ssl on;
    ssl_certificate /etc/nginx/certs/*.domain.com/fullchain;
    ssl_certificate_key /etc/nginx/certs/*.domain.com/key;

    add_header Allow "GET, POST, HEAD, PUT, DELETE" always;
    if ($request_method !~ ^(GET|POST|HEAD|PUT|DELETE)$) {
        return 405;
    }

    location / {
        proxy_pass https://10.10.10.5:8006;

        # Disable buffering to serve data immediately to clients.
        # Increase timeouts from default 60 seconds to 5 minutes for the console not to close when no data is transferred.
        # Additionally the max_body_size was increased to 5 GB to allow uploads of huge ISOs via the Web UI.
        proxy_buffering off;
        proxy_buffer_size 4k;
        client_max_body_size 5g;
        proxy_connect_timeout 300s;
        proxy_read_timeout 300s;
        proxy_send_timeout 300s;
        send_timeout 300s;

        # Enable proxy websockets for the noVNC console to work
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        # Standard proxying headers
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Host $server_name;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      
        # SSL proxying headers
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Ssl on;
    }
}
```

