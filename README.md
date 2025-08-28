# ssh-tunnel

## Install

```bash
# install the script and the template unit
sudo install -m 0755 ssh-tunnel.sh /usr/local/bin/ssh-tunnel.sh
sudo install -m 0644 ssh-tunnel@.service /etc/systemd/system/ssh-tunnel@.service
sudo systemctl daemon-reload

# create an instance environment
sudo install -m 0644 ssh-tunnel.env.example /etc/default/ssh-tunnel-foobar
sudoedit /etc/default/ssh-tunnel-foobar

# enable and start the instance
sudo systemctl enable --now ssh-tunnel@foobar.service
```

You can create more instances by creating more env files (e.g., `/etc/default/ssh-tunnel-foobar2`) and starting `ssh-tunnel@foobar2.service`.

## Troubleshooting

Edit your instance env file (e.g., `/etc/default/ssh-tunnel-foobar`):

```ini
REMOTE_HOST=tsdb01.dnsvault.net
REMOTE_USER=system
REMOTE_PORT=5432
LOCAL_PORT=6996
# optional
# USE_SSHPASS=1
# REMOTE_PASS=your_password_here
```

The script runs `ssh` in the foreground with:

- `-L "${LOCAL_PORT}:127.0.0.1:${REMOTE_PORT}"`
- `-o ExitOnForwardFailure=yes`, keepalives, and `StrictHostKeyChecking=accept-new`.

Check listener

```bash
ss -ltnp | grep :6996 || sudo ss -ltnp | grep :6996
```

Follow logs

```bash
journalctl -u ssh-tunnel@foobar -f
```

## Notes

Connect to the remote DB via the local tunnel

```bash
psql -h 127.0.0.1 -p 6996 -U postgres -d db_foobar;
```
