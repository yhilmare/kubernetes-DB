#!/bin/sh

mountPath="/mountDir" #gluterfs挂载卷所在位置

data="/volumeDir/data" #data目录所在位置

logs="/volumeDir/logs" #日志目录所在位置

conf="/volumeDir/conf" #配置文件目录所在位置

if [ -e ${mountPath} -a -e ${data} -a -e ${logs} -a -e ${conf} ]; then
  echo `date` "[INFO] - all dirs exist."
else
  echo `date` "[ERROR] - error happened!"
  exit 1
fi

uuid=`cat /proc/sys/kernel/random/uuid`

mkdir -p "/mountDir/${uuid}"
echo `date` "[INFO] - mount path has been created, \"${uuid}\""

ln -s ${data} /mountDir/${uuid}/data
ln -s ${logs} /mountDir/${uuid}/logs
ln -s ${conf} /mountDir/${uuid}/conf

hostpath="/mountDir/initdir"

#if [ -e ${hostpath} ]; then
#  echo `date` "[INFO] - path \"${hostpath}\" exist."
#  while :; do
#    sleep 2
#    echo `date` "[INFO] - searching for \"hosts.data\"..."
#    tmp=`ls ${hostpath} | grep hosts`
#    if [ ${#tmp[0]} != 0 ]; then
#      break;
#    fi
#  done
#  echo `date` "[INFO] - "`ls ${hostpath}`
#  ln ${hostpath}/hosts.data /initdir/hosts.data
#else
#  echo  `date` "[INFO] - path \"${hostpath}\" does not exist, link \"/initdir\"."
#  ln -s /initdir /mountDir/initdir
#fi

echo `date` "[INFO] - all files has been mounted."

while :; do
  sleep 2
  echo `date` "[INFO] - "`ls /mountDir/`
  echo `cat /mountDir/initdir/hosts.data`
done
