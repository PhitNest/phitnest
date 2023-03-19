echo "[Unit]
Description=dgraph.io data server
Wants=network.target
After=network.target dgraph-zero.service
Requires=dgraph-zero.service
[Service]
Type=simple
ExecStart=/usr/local/bin/dgraph alpha --my=localhost:7080 --zero=localhost:5080
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/dgraph.service

echo "[Unit]
Description=dgraph.io zero server
Wants=network.target
After=network.target
[Service]
Type=simple
ExecStart=/usr/local/bin/dgraph zero --my=localhost:5080
StandardOutput=journal
StandardError=journal
[Install]
WantedBy=multi-user.target
RequiredBy=dgraph.service" > /etc/systemd/system/dgraph-zero.service

systemctl daemon-reload
systemctl enable --now dgraph