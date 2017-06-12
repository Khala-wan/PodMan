#!/bin/sh

#  updateShell.sh
#  PodMan
#
#  Created by 万圣 on 2017/5/26.
#  Copyright © 2017年 万圣. All rights reserved.

export LANG=en_US.UTF-8

echo "************************PodMan启动**************************"
echo "Pod Update: 开始 🚀🚀🚀🚀"
cd $1

/usr/local/bin/pod update

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
