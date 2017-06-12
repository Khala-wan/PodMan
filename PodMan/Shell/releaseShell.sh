#!/bin/sh

#  updateShell.sh
#  PodMan
#
#  Created by 万圣 on 2017/5/26.
#  Copyright © 2017年 万圣. All rights reserved.

#$2:isPrivate
#$3:specsRepo
#$4:allowWarning
#$5:useLibraries

export LANG=en_US.UTF-8

echo "************************PodMan启动**************************"
echo "Pod repo release: 开始 🚀🚀🚀🚀"
cd $1

if [ $2 == "YES" ]
then
    /usr/local/bin/pod repo push $3 $4 $5
else
    /usr/local/bin/pod trunk push $3 $4 $5
fi

if [ $? -eq 0 ]
then
echo "PodProcessSuccessed"
echo "完成"
echo "**************************************************************"
else
echo "PodProcessFailed"
echo "完成"
echo "**************************************************************"
fi
