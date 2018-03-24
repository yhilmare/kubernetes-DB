#!/bin/bash

volumeDir="/initdir/"
volumeFile="hosts.data"

#检查挂载文件卷的位置是否存在，若不存在则创建目录

if [ ! -e ${volumeDir} ]; then
  mkdir -p ${volumeDir}
  echo `date` "[INFO] - volume dir has been created, dir is "${volumeDir}"."
fi

#检测目标主机文件是否存在，若不存在则创建该文件

if [ ! -e ${volumeDir}${volumeFile} ]; then
  touch ${volumeDir}${volumeFile}
  echo `date` "[INFO] - volume file has been created, file is "${volumeDir}${volumeFile}"."
fi

#根据主机名检索hosts文件，找到该主机的ip地址，并将ip地址写入到hosts.data文件中

hostname=`hostname`
for line in `cat /etc/hosts`; do
  if [ ${line} == ${hostname} ]; then
    break
  fi
  ipAddress=${line}
done

if [ ${#NEO4J_causal__clustering_expected__core__cluster__size} != 0 ]; then
  echo "${ipAddress}" >> ${volumeDir}${volumeFile}
  echo `date` "[INFO] - the host named \"${hostname}\"'s ip \"${ipAddress}\" has been written into hosts.data."
fi

#根据环境变量NEO4J_causal__clustering_expected__core__cluster__size找出全部需要的目标ip地址

#解析文件获取hosts.data文件中的全部集群ip地址
parseFile(){
  if [ ${#1} == 0 ]; then
    echo `date` "[ERROR] - shell error!"
    exit 1
  elif [ ! -e ${1} ]; then
    echo `date` "[ERROR] - no such a file ${1}!"
    exit 1
  fi
  index=0
  for line in `cat ${1}`; do
    ip_array[${index}]=${line}
    let index++
  done
}

while :; do
  sleep 2
  echo `date` "[INFO] - searching file ${volumeDir}${volumeFile} to fetch cluster members..."
  parseFile ${volumeDir}${volumeFile}
  if [ ${#NEO4J_causal__clustering_expected__core__cluster__size} == 0 ]; then
    echo `date` "[WARNING] - env \"NEO4J_causal__clustering_expected__core__cluster__size\" has not been set."
    if [ ${#MY_NEO4J_INIT_MEMBER_LIST} == 0 ]; then
      echo `date` "[ERROR] - leaking parameters."
      exit 1
    elif [ ${#ip_array[@]} -ge ${MY_NEO4J_INIT_MEMBER_LIST} ]; then
      echo `date` "[INFO] - fetching cluster member list for slave node..."
      count=${#ip_array[@]}
      for ((i=0;i<${MY_NEO4J_INIT_MEMBER_LIST};i++)); do
        tmp_array[${i}]=${ip_array[$[count-i-1]]}
      done
      unset ip_array
      ip_array=${tmp_array[*]}
      break
    fi
  elif [ ${#ip_array[@]} == ${NEO4J_causal__clustering_expected__core__cluster__size} ]; then
    echo `date` "[INFO] - fetched the initial cluster members."
    break
  elif [ ${#ip_array[@]} -gt ${NEO4J_causal__clustering_expected__core__cluster__size} ]; then
    echo `date` "[WARNING] - too many items, fetch the latest items!"
    count=${#ip_array[@]}
    for ((i=0;i<${NEO4J_causal__clustering_expected__core__cluster__size};i++)); do
      tmp_array[${i}]=${ip_array[$[count-i-1]]}
    done
    unset ip_array
    ip_array=${tmp_array[*]}
    break
  fi
done

#拼接字符串
for ip in ${ip_array[@]}; do
  if [ ${#result} == 0 ]; then
    result=${ip}":5000"
  else
    result=${result}","${ip}":5000"
  fi
done

#将解析完成的环境变量赋值
export NEO4J_causal__clustering_initial__discovery__members=${result}
export NEO4J_causal__clustering_discovery__advertised__address=${ipAddress}:5000
export NEO4J_causal__clustering_transaction__advertised__address=${ipAddress}:6000
export NEO4J_causal__clustering_raft__advertised__address=${ipAddress}:7000
export NEO4J_dbms_connectors_default__advertised__address=${ipAddress}

echo `date` "[INFO] - \"run.sh\" completed."
/docker-entrypoint.sh ${1}
