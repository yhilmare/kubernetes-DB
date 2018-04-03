#!/bin/bash

#设定yaml文件的地址
host_pvc=${PWD}/neo4j-host-pvc.yaml
rc=${PWD}/neo4j-rc.yaml
#设定rc对象和pvc的名称
param_pvc_host=${1}
param_rc=${2}
#若用户没有传递这两个名称则使用默认值
if [ -z ${param_pvc_host} ]; then
  param_pvc_host=neo4j-pvc-host
fi

if [ -z ${param_rc} ]; then
  param_rc=neo4j-rc
fi

returnMat=`kubectl get pvc | grep ${param_pvc_host}`

if [ ${#returnMat[0]} != 0 ]; then
  echo `date` "[WARNING] - there is a deprecated pvc named \"${param_pvc_host}\", need to be deleted..."
  echo `date` "[WARNING] - "`kubectl delete pvc ${param_pvc_host}`
fi

if [ -e ${host_pvc} -a -e ${rc} ]; then
  returnMat=`kubectl get pvc | grep ${param_pvc_host}`
  if [ ${#returnMat[0]} == 0 ]; then
    echo `date` "[INFO] - there is not a pvc named \"${param_pvc_host}\", create a new one."
    echo `date` "[INFO] - "`kubectl create -f ${host_pvc}`
    while :; do
      sleep 2
      echo `date` "[INFO] - waiting for pvc \"${param_pvc_host}\" bounding..."
      tmp=`kubectl get pvc ${param_pvc_host} | grep Bound` 
      if [ ${#tmp[0]} != 0 ]; then
        echo `date` "[INFO] - the pvc named \"${param_pvc_host}\" has been bounded."
        break
      fi
    done
  else
    echo `date` "[ERROR] - encounter with an fatal error!"
    exit 1
  fi
  returnMat=`kubectl get rc | grep ${param_rc}`
  if [ ${#returnMat[0]} == 0 ]; then
    echo `date` "[INFO] - there is not a replicationcontroller named \"${param_rc}\", need to create one..."
    echo `date` "[INFO] - "`kubectl create -f ${rc}`
  else
    echo `date` "[WARNING] - there is a deprecated replicationcontroller named \"${param_rc}\", it may result in a invalid cluster!"
  fi
  unset returnMat
fi

unset rc host_pvc param_rc param_pvc_host 
