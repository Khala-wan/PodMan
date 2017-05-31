#!/bin/sh

#  initShell.sh
#  PodMan
#
#  Created by 万圣 on 2017/5/26.
#  Copyright © 2017年 万圣. All rights reserved.

export LANG=en_US.UTF-8

echo "************************PodMan启动**************************"
echo "初始化: 开始 🚀🚀🚀🚀"
cd $1

/usr/local/bin/pod init

echo "完成"
echo "**************************************************************"
