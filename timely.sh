#echo "timer started" >> log.txt
while true
do
    sleep 1800
    #echo "drop 2 called up" >> log.txt
    source ./drop.sh
done