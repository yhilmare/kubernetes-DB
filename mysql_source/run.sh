pv=${PWD}/mysql_pv.yaml
pvc=${PWD}/mysql_pvc.yaml
rc=${PWD}/mysql_rc.yaml
param_pv=${1}
param_pvc=${2}
param_rc=${3}
#----------------------------------------------------------
#运行run.sh时传递三个参数。第一个参数说明pv的名称，第二个参数
#说明pvc的名称，第三个参数说明rc的名称。若不传递则三个变量自动
#赋值mysql
#---------------------------------------------------------
if [ -z ${param_pv} ]; then
  param_pv="mysql"
fi
if [ -z ${param_pvc} ]; then
  param_pvc="mysql"
fi
if [ -z ${param_rc} ]; then
  param_rc="mysql"
fi
#----------------------------------------------------------
#以下自动检测kubernetes中是否存在相应的pv，pvc和rc，若不存在则主动创建
#---------------------------------------------------------
if [ -e ${pv} -a -e ${pvc} -a -e ${rc} ]; then
  var=`kubectl get pv | grep ${param_pv}`
  if [ -z ${var[0]} ]; then
    echo There is no PV like \"${param_pv}\", need to create a new PV;
    kubectl create -f ${pv}
    echo A new PV created
  else
    echo There is already a PV, no need to create a new one;
    echo ${var[0]}
  fi
  var=`kubectl get pvc | grep ${param_pvc}`
  if [ -z ${var[0]} ]; then
    echo There is no PVC like \"${param_pvc}\", need to create a new one;
    kubectl create -f ${pvc}
    echo A new PVC created
  else
    echo There is already a PV, no need to create a new one;
    echo ${var[0]}
  fi
  var=`kubectl get rc | grep ${param_rc}`
  if [ -z ${var[0]} ]; then
    echo There is no ReplicationController like \"${param_rc}\", need to create new one;
    kubectl create -f ${rc}
    echo A new ReplicationController created
  else
    echo There is already a ReplicationController, no need to create a new one
    echo ${var[0]}
  fi
  unset var
else
  echo Can not find enough yaml files
fi
unset pv pvc rc param_pv param_pvc param_rc
