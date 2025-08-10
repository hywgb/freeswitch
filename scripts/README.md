# Scripts

- gen-fs-tls.sh: generate a self-signed CA and server cert for FreeSWITCH
  - Usage:
    ```bash
    sudo FS_TLS_DIR=/etc/freeswitch/tls FS_TLS_CN=pbx.example.com ./scripts/gen-fs-tls.sh
    ```
  - Files created: ca.key, ca.crt, server.key, server.csr, server.crt, dh.pem

- System templates (copy with sudo):
  - build/sysctl_freeswitch.conf -> /etc/sysctl.d/99-freeswitch.conf
  - build/freeswitch.limits.conf -> /etc/security/limits.d/freeswitch.conf
  - build/logrotate_freeswitch   -> /etc/logrotate.d/freeswitch