#!/system/bin/sh
# 请不要硬编码 /magisk/modname/... ; 请使用 $MODDIR/...
# 这将使你的脚本更加兼容，即使Magisk在未来改变了它的挂载点
MODDIR=${0%/*}
cpu_watermark=95
mem_watermark=100000
free=0
total_cache=0
sleep 30
echo "initialized" > log.txt
while true
do
    last_free=$free
    free=$(vmstat 1 1 | tail -1 | awk '{print $4}')
    CPU_idle=$(vmstat 2 2 | tail -1 | awk '{print $15}')
    total_cache=$(($total_cache+$free-$last_free))
    if [ $total_cache -lt 0 ]
    then
        total_cache=0
    fi
    #echo $CPU_idle >> log.txt
    #echo $free >> log.txt
    #echo $total_cache >> log.txt
    if [ $total_cache -gt $mem_watermark ]
    then
        #echo "unreleased cache detected" >> log.txt
        if [ $CPU_idle -gt $cpu_watermark ]
        then
            echo 1 > /proc/sys/vm/drop_caches
            total_cache=0
            sleep 5
            free=$(vmstat 1 1 | tail -1 | awk '{print $4}')
            #echo "cache dropped" >> log.txt
            sleep 165
        fi
        sleep 10
    else
        sleep 30
    fi
#    
done
# 这个脚本将以 late_start service 模式执行
# 更多信息请访问 Magisk 主题
