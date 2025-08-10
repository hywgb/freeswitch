#!/usr/bin/env bash
set -euo pipefail

TLS_DIR=${FS_TLS_DIR:-/etc/freeswitch/tls}
DAYS=${FS_TLS_DAYS:-825}
CN=${FS_TLS_CN:-freeswitch.local}
KEY_BITS=${FS_TLS_KEY_BITS:-2048}

umask 077
mkdir -p "${TLS_DIR}"
cd "${TLS_DIR}"

# Generate CA key and cert if absent
if [[ ! -f ca.key ]]; then
  openssl genrsa -out ca.key "${KEY_BITS}"
fi
if [[ ! -f ca.crt ]]; then
  openssl req -x509 -new -nodes -key ca.key -sha256 -days "${DAYS}" \
    -subj "/CN=${CN} CA" -out ca.crt
fi

# Generate server key and CSR
openssl genrsa -out server.key "${KEY_BITS}"
openssl req -new -key server.key -subj "/CN=${CN}" -out server.csr

# Create minimal v3 ext for SAN
cat > server.ext <<'EOF'
subjectAltName=DNS:freeswitch.local,DNS:localhost,IP:127.0.0.1
extendedKeyUsage=serverAuth
basicConstraints=CA:FALSE
EOF

# Sign server certificate with our CA
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out server.crt -days "${DAYS}" -sha256 -extfile server.ext

# Generate DH params
openssl dhparam -out dh.pem 2048

# Fix permissions
chmod 600 server.key ca.key
chmod 644 server.crt ca.crt dh.pem

printf "TLS materials created in %s\n" "${TLS_DIR}"