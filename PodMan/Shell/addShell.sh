#!/bin/sh

#  addShell.sh
#  PodMan
#
#  Created by 万圣 on 2017/5/26.
#  Copyright © 2017年 万圣. All rights reserved.

#$1:name
#$2:repo URL


export LANG=en_US.UTF-8

/usr/local/bin/pod repo add $1 $2

if [ $? -eq 0 ]
then
    echo "PodProcessSuccessed"
else
    echo "PodProcessFailed"
fi

