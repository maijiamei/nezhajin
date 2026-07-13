bash <(curl -Ls ssh_tool.eooce.com)
curl -L https://raw.githubusercontent.com/nezhahq/scripts/main/agent/install.sh -o agent.sh && chmod +x agent.sh && env NZ_SERVER=nezha.tebus.xyz:443 NZ_TLS=true NZ_CLIENT_SECRET=QwKY9D2A5iDpmdNJhTUxQV4hWLUYIgt1 ./agent.sh
systemctl stop nezha-agent
systemctl disable nezha-agent
rm -rf /etc/systemd/system/nezha-agent.service
systemctl daemon-reload
rm -rf /opt/nezha/agent
ps aux | grep nezha-agent | grep -v grep
export LANG="en_US";export LANGUAGE="en_US";export LC_ALL="en_US";top
curl -L https://raw.githubusercontent.com/nezhahq/scripts/main/agent/install.sh -o agent.sh && chmod +x agent.sh && env NZ_SERVER=nezha.tebus.xyz:443 NZ_TLS=true NZ_CLIENT_SECRET=QwKY9D2A5iDpmdNJhTUxQV4hWLUYIgt1 NZ_UUID=9e2e9c0e-b1fd-4510-2fce-e9e8385efda8 ./agent.sh
curl -fsSL https://raw.githubusercontent.com/zhenzhenjunzilu/nezhawebssh/main/nzsecurity.sh -o nzsecurity.sh
nano nzsecurity.sh
