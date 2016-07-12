#!/bin/sh

#Ip=`hostname -I |cut -f1 -d " "`

HAfile=/etc/haproxy/haproxy.cfg.tmp 
SSC=master1@master1mx.gdl.mex.ibm.com 
tmpFile=/tmp/haproxy.cfg
scp -o StrictHostKeyChecking=no $SSC:$HAfile $tmpFile
echo $? -------remote cp
Ip=`ifconfig |  grep -A 1 em1 | grep "addr:" | cut -f2 -d : | cut -f1 -d " "`
if [ "$Ip" == "" ]; then
        Ip=`ifconfig |  grep -A 1 eth0 | grep "addr:" | cut -f2 -d : | cut -f1 -d " "`
fi
echo "IP $Ip"
#PORT=7015
echo "PORT $PORT"
##
exist=`cat ${tmpFile} | grep "server" | grep ":" | grep "$Ip" | grep ":$PORT "| wc -l`
echo "Exist $exist"
if [ "$exist" -eq 0 ]; then
        echo "Does not exist yet on the HAProxy.... Lets add it"
        echo "server redis_$PORT $Ip:$PORT check inter 1s" >> ${tmpFile}
        echo "tryng to copy...."
        #scp $tmpFile $SSC:/etc/haproxy
        echo "server redis_$PORT $Ip:$PORT check inter 1s" |ssh $SSC "cat >> $HAfile"
        echo $? ------- remote cat
        tail ${tmpFile}
        echo "file Copyed..."
        #ssh $SSC "service haproxy restart"
fi
echo "Done"
