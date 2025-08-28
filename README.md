# ssh-tunnel

```bash
# install script
sudo install -m 0755 ssh-tunnel.sh /usr/local/bin/ssh-tunnel.sh
sudo install -m 0644 ssh-tunnel.service /etc/systemd/system/ssh-tunnel.service

# create env
sudo install -m 0644 ssh-tunnel.env /etc/default/ssh-tunnel
sudoedit /etc/default/ssh-tunnel

# start and enable service
sudo systemctl daemon-reload
sudo systemctl enable --now ssh-tunnel.service
```

## Troubleshooting

Edit `/etc/default/ssh-tunnel`:

```ini
UNIMAS_HOST=tsdb01.dnsvault.net
UNIMAS_USER=system
UNIMAS_PORT=6996
REMOTE_PORT=5432
USE_SSHPASS=1
UNIMAS_PASS=password # change to proper password
```

The script runs `ssh` in the foreground with:
- `-L "${UNIMAS_PORT}:127.0.0.1:${REMOTE_PORT}"`
- `-o ExitOnForwardFailure=yes`, keepalives, and `StrictHostKeyChecking=accept-new`.

Check Listenser
```bash
ss -ltnp | grep :6996 || sudo ss -ltnp | grep :6996
```

Connect to unimas timescaleDB
```bash
psql -h 127.0.0.1 -p 6996 -U collector -d dnsvault_timeseries_db_unimas;
```
