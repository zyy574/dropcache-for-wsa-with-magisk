cpu_watermark=95
#echo "start dropping" >> log.txt
while true
do
    CPU_idle=$(vmstat 1 2 | tail -1 | awk '{print $15}')
    if [ $CPU_idle -gt $cpu_watermark ]
    then
        sync;echo 1 > /proc/sys/vm/drop_caches
        #echo "cache dropped" >> log.txt
        break
    fi
    sleep 1
done