# A random collection of Scripts dealing with Hacking, Linux and everything in-between!

Drop your unpolished or polished scripts here!

TCPclient.py = a Basic TCP Client that can allow you to test for services, send data, fuzz and many other tasks.

TCPserver.py = a Basic TCP Server that if used in conjunction with TCPclient.py can show you can the output of a basic server connection. You can use this when writing command shells or a proxy.

TCPproxy.py = a Basic TCP proxy that allows forwarding traffic to bounce from host to host. 

ABI & ACBI = A 'really' basic script install for Arch Linux BIOS systems
  To install, boot into Arch live ISO and:
  
  
    wget https://raw.githubusercontent.com/ChaoticHackingNetwork/Scripts/master/ABI.sh
    chmod +x ABI.sh
    ./ABI.sh
    * Some systems show a bad meterpreter if so run: sed -i -e 's/\r$//' ABI.sh 

AUI & ACUI = A 'really' basic script install for Arch Linux UEFI systems.
    To install, boot into Arch live ISO and:
    
    
    wget https://raw.githubusercontent.com/ChaoticHackingNetwork/Scripts/master/AUI.sh
    chmod +x AUI.sh
    ./AUI.sh
    * Some systems show a bad meterpreter if so run: sed -i -e 's/\r$//' AUI.sh 

