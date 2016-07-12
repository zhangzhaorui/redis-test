#!/bin/sh

IP=${IP}
M1_PORT=${M1_PORT}
M2_PORT=${M2_PORT}
M3_PORT=${M3_PORT}
R1_PORT=${R1_PORT}
R2_PORT=${R2_PORT}
R3_PORT=${R3_PORT}
LOG_FILE=/redis-cluster.log

tmpFile=/tmp/haproxy.cfg
HAfile=/etc/haproxy/haproxy.cfg.tmp
SSH="master1@master1mx.gdl.mex.ibm.com"
scp -o StrictHostKeyChecking=no $SSH:$HAfile $tmpFile
result=`cat $tmpFile | grep "^server" | cut -f3 -d " "`
toCluster=""
for i in $result; do
        Ip=`echo $i | cut -f1 -d:`
        Port=`echo $i | cut -f2 -d:`
        echo  -e " i = $i "
        echo IP $Ip
        echo Port $Port
        toCluster="$toCluster $Ip:$Port"
done

echo toCluster $toCluster


#echo "yes" | ruby redis-trib.rb create --replicas 1 ${IP}:${M1_PORT} ${IP}:${M2_PORT} ${IP}:${M3_PORT} ${IP}:${R1_PORT} ${IP}:${R2_PORT} ${IP}:${R3_PORT} >> ${LOG_FILE} 
echo "yes" | ruby redis-trib.rb create --replicas 1 ${toCluster} >> ${LOG_FILE} 
tail -f ${LOG_FILE}
