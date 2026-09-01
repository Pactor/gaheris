' Holds the Ubuntu WSL distro open so the OpenDAoC docker stack keeps running.
' WSL shuts a distro down seconds after its last process exits, which SIGKILLs
' the containers. This keeps one process alive with no visible window.
CreateObject("WScript.Shell").Run "wsl.exe -d Ubuntu -u root -e /bin/sleep infinity", 0, False
