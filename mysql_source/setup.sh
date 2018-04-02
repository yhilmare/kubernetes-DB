#!/bin/bash
rc=${PWD}/mysql_rc.yaml
svc=${PWD}/mysql_svc.yaml
param_rc=${1}
param_svc=${2}
#----------------------------------------------------------
#运行run.sh时传递三个参数。第一个参数说明pv的名称，第二个参数
#说明pvc的名称，第三个参数说明rc的名称。若不传递则三个变量自动
#赋值mysql
#---------------------------------------------------------
if [ -z ${param_rc} ]; then
  param_rc="mysql-rc"
fi
if [ -z ${param_svc} ]; then
  param_svc="mysql-svc"
fi
#--------------------------------------------------------------------
#以下自动检测kubernetes中是否存在相应的svc和rc，若不存在则主动创建
#---------------------------------------------------------------------
#NAME           DESIRED   CURRENT   READY     AGE
#************   1         1         1        
#----------------------------------------------------------------------
if [ -e ${svc} -a -e ${rc} ]; then
  var=`kubectl get rc | grep ${param_rc}`
  if [ ${#var[0]} == 0 ]; then
    echo `date`"[INFO] - there is no replicationcontroller like "\"${param_rc}\"", need to create new one;"
    echo `date`"[INFO] - "`kubectl create -f ${rc}`
  else
    echo `date`"[WARNING] - there is already a replicationcontroller, no need to create a new one;"
    echo `date`"[WARNING] - "${var[0]}
  fi
  var=`kubectl get svc | grep ${param_svc}`
  if [ ${#var[0]} == 0 ]; then
    echo `date`"[INFO] - there is no service like" \"${param_svc}\"", need to create new one;"
    echo `date`"[INFO] - "`kubectl create -f ${svc}`
  else
    echo `date`"[WARNING] - there is already a service , no need to create a new one;"
    echo `date`"[WARNING] - "${var[0]}
  fi
  unset var
else
  echo `date`"[ERROR] - can not find enough yaml files!"
fi
unset rc svc param_rc param_svc
