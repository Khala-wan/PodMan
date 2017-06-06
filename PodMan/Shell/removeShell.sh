#!/bin/sh

#  removeShell.sh
#  PodMan
#
#  Created by 万圣 on 2017/5/26.
#  Copyright © 2017年 万圣. All rights reserved.

#$1:name



export LANG=en_US.UTF-8

/usr/local/bin/pod repo remove $1

if [ $? -eq 0 ]
then
    echo "PodProcessSuccessed"
else
    echo "PodProcessFailed"
fi

