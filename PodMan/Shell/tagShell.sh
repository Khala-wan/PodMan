#!/bin/sh

#  tagShell.sh
#  PodMan
#
#  Created by 万圣 on 2017/5/26.
#  Copyright © 2017年 万圣. All rights reserved.

#$1:fileDic
#$2:tagVersion


export LANG=en_US.UTF-8

cd $1

echo "************************PodMan启动**************************"
echo "tag"$2": 开始 🚀🚀🚀🚀"

/usr/bin/git tag $2 2>> 1.txt

if [ $? -eq 0 ]
then
    /usr/bin/git push -u origin $2
    if [ $? -eq 0 ]
    then
        echo $2"tag已经完成推送!!😉"
    else
        echo $2"tag推送失败"
        cat 1.txt
    fi
else
    echo "tag"$2": 失败"
    cat 1.txt
fi
rm -rf 1.txt
