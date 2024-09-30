#!/bin/sh                                                                                                                                                               
                                                                                                                                                                        
# Script to check the changes in the dynamic IPv6 of OpenVPN router                                                                                                     
# If changes occur, the reconnection process will start
                                                                                                                                                                    
# Take the stored IPs                                                                                                                                                   
ip_server=$(cat /etc/flags/remote_wan.conf)                                                                                                                             
ip_wan=$(cat /etc/flags/local_wan.conf)                                                                                                                                 
                                                                                                                                                                        
# Verify the IPv6 in WAN                                                                                                                                                
new_ip=$(ip -br addr show eth0 | awk '{print $4}' | cut -d '/' -f 1)                                                                                                    

sub_ip=${new_ip:0:4}

# Check that the IPs are the same
if [ "$ip_wan" = "$new_ip" -o "$sub_ip" = "fe80" ]
then
        exit 0
fi                                                                                                                                                               
                                                                                                                                                                        
echo "$(date +'%D %H:%M:%S') - IP Changed [Old IP: '$ip_wan' | New IP: '$new_ip']"                                                                                      
                                                                                                                                                                        
# Save the new IP in the file                                                                                                                                           
echo "$new_ip" > /etc/flags/local_wan.conf                                                                                                                              
                                                                                                                                                                        
# Send the new IP to the server via scp                                                                                                                                 
while true                                                                                                                                                              
do                                                                                                                                                                      
        scp /etc/flags/local_wan.conf root@xxx.xxx.xxx.xxx:/etc/flags/remote_wan.conf                                                                                    
                                                                                                                                                                        
        if [ $? -eq 0 ]                                                                                                                                                 
        then                                                                                                                                                            
                echo "$(date +'%D %H:%M:%S') -  New IP sended for server" >> /var/log/recon.log                                                                         
                chmod +x /etc/scripts/verify_IP.sh                                                                                                                      
                break                                                                                                                                                   
        else                                                                                                                                 
                echo "$(date +'%D %H:%M:%S') - Error to send new IP to server. Trying again in 5 seconds..." >> /var/log/recon.log
                chmod -x /etc/scripts/verify_IP.sh                                                                                                                      
                sleep 5                                                                                                                                                 
        fi                                                                                                                                                              
done                                                                                                                                                                    
                                                                                                                                                                        
echo "$(date +'%D %H:%M:%S') - Script deleteConfigs start" >> /var/log/recon.log                                                                                        
ip link delete gretap1                                                                                                                                                  
gretap_con=$(ifconfig | grep gretap1 | awk '{print $1}')                                                                                                                
                                                                                                                                                                        
if [ "$gretap_con" != "" ]                                                                                                                                              
then                                                                                                                                                                    
        echo "$(date +'%D %H:%M:%S') - Gretap tunnel not deleted" >> /var/log/recon.log                                                                                 
        echo "$(date +'%D %H:%M:%S') - Reconnection failed\n\n" >> /var/log/recon.log                                                                                   
        return 0                                                                                                                                                        
fi                                                                                                                                                                      
                                                                                                                                                                        
echo "$(date +'%D %H:%M:%S') - Gretap tunnel successfully deleted" >> /var/log/recon.log                                                                                
                                                                                                                                                                        
echo "$(date +'%D %H:%M:%S') - Start configCon script" >> /var/log/recon.log                                                                                            
# Create and enable ip6gretap tunnel                                                                                                                                    
ip link add name gretap1 type ip6gretap local "$new_ip" remote xxxx::xxxx                                                                                       
ip addr add 10.0.0.2/30 dev gretap1                                                                                                                                     
ip link set gretap1 up                                                                                                                                                  
                                                                                                                                                                        
echo "$(date +'%D %H:%M:%S') - new gretap tunnel created with local "$new_ip" remote xxxx::xxxx" >> /var/log/recon.log                                          
                                                                                                                                                                        
# Create routes Router -> Server                                                                                                                                        
ip route add 10.37.94.16/30 via 10.0.0.1                                                                                                                                
ip route add 10.37.122.76/30 via 10.0.0.1                                                                                                                               
ip route add 10.37.77.208/30 via 10.0.0.1                                                                                                                               
ip route add 10.100.100.100/30 via 10.0.0.1                                                                                                                             
                                                                                                                                                                        
# Create routes Router -> Core                                                                                                                                          
ip route add 10.160.168.73/32 via 10.0.0.1                                                                                                                              
ip route add 10.160.184.73/32 via 10.0.0.1                                                                                                                              
ip route add 10.160.163.190/32 via 10.0.0.1                                                                                                                             
ip route add 10.160.179.132/32 via 10.0.0.1
                                                                                                                           
echo "$(date +'%D %H:%M:%S')- Routes create successfull" >> /var/log/recon.log                                                                                          
echo "$(date +'%D %H:%M:%S') - Reconnection successful\n\n" >> /var/log/recon.log                                                                                       
                                                                                                                                                                        
return 0     
