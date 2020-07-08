#！/bin/bash
##author by lijian
##用于在网上批量下载麒麟操作系统的安装包

set -x
set -e

echo "---开始下载deb包---"

line1="http://archive.kylinos.cn/kylin/KYLIN-ALL/pool/"

if [ ! -d ./kylin/KYLIN-ALL ] 
then
    mkdir -p ./kylin/KYLIN-ALL
fi

if [ X$1 = X ]
then
    inputPath=$line1
else
    inputPath=$1
fi

echo "开始深度遍历"
function dfs 
{
    local now_dir now_file
    now_dir=$1
    for now_file in `curl $now_dir | awk -Fhref= '{print $2}' | awk -F\> '{print $1}' | grep \"|awk -F\" '{print $2}'| sed '1,1d' | grep -v /kylin/KYLIN-ALL/pool/main/`
     do
      if [[ $now_file == *.deb ]]
       then
       echo $now_file
       dir_name=`echo "$now_dir" | awk -Farchive.kylinos.cn '{print $2}'`
        if [ ! -d ./${dir_name} ]
        then
          mkdir -p ./${dir_name}
        fi
       wget -P ./${dir_name} ${now_dir}${now_file}
      fi
     done
    for now_file in `curl $now_dir | awk -Fhref= '{print $2}' | awk -F\> '{print $1}' | grep \"|awk -F\" '{print $2}'| sed '1,1d' | grep -v /kylin/KYLIN-ALL/pool/main/`
      do
        if [[ $now_file != *.deb ]]
         then
          dfs ${now_dir}${now_file}
        fi
      done
}

dfs $inputPath
