#!/system/bin/sh
# 请不要硬编码 /magisk/modname/... ; 请使用 $MODDIR/...
# 这将使你的脚本更加兼容，即使Magisk在未来改变了它的挂载点
MODDIR=${0%/*}
sleep 30
mem_watermark=100000
swapo_watermark=250
free=0
fork ./timely.sh
#echo "initialized" > log.txt
while true
do
    last_free=$free
    swap=$(vmstat 3 2 | tail -1 | awk '{print $8}')
    free=$(vmstat 3 1 | tail -1 | awk '{print $4}')
    #echo $free >> log.txt
    #echo $swap >> log.txt
    if [ $(($free-$last_free)) -gt $mem_watermark ] && [ $swapo_watermark -gt $swap ]
    then
        #echo "drop 1 called up" >> log.txt
        source ./drop.sh
        sleep 15
        free=$(vmstat 1 1 | tail -1 | awk '{print $4}')
    fi
    #sleep 1
done
