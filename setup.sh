file="/home/azman/Downloads/1505063.zip"
a=0

while [ $a -lt 1 ]
do
   if [ -f  $file ] ; then
   a=1
   fi

done
sleep 2
cp -f /home/azman/L3T2/1505063.zip  /home/azman/Downloads/1505063.zip
