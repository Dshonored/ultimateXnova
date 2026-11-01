Nginx does not support .htaccess files, which means that by using nginx you are exposed to data leakage from your server instance.

Insert the content below into your nginx configuration file

```
    location /cache/ {
    deny all;
    }

    location /includes/ {
    deny all;
    }

    location /includes/backups/ {
    deny all;
    }

    location /styles/templates/ {
    deny all;
    }

    location /tests/ {
    deny all;
    }

    location /language/ {
    deny all;
    }

    location /install/ {
    deny all;
    }

    location /.git/ {
    deny all;
    }

    location ~ /external/ {
    deny all;
    }

    # dot files (.git, .env, .htaccess), logs, dumps and config/manifest files
    location ~ /\.(?!well-known) {
    deny all;
    }

    location ~* \.(log|sql|bak|ini|md|lock|json|ya?ml|dist|sh)$ {
    deny all;
    }

    # after installing: remove includes/ENABLE_INSTALL_TOOL and block /install/ completely
```

Also forward the original scheme/client IP when running behind a reverse proxy or a tunnel, so that
`X-Forwarded-Proto`/`X-Forwarded-For` (or `CF-Connecting-IP`) are honoured. They are only trusted when the
direct peer (`REMOTE_ADDR`) is a private/loopback address.