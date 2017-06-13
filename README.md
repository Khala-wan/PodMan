<img width="150" height="150" src="https://github.com/Khala-wan/PodMan/raw/master/resource/logo.png"/>

PodMan - A Pod Tool For MacOS
=============================

![platforms](https://img.shields.io/badge/platforms-MacOS-333333.svg) ![Xcode 9.0-beta](https://img.shields.io/badge/Xcode-9.0%2B-blue.svg) ![MacOS 10.12+](https://img.shields.io/badge/MacOS-10.12%2B-blue.svg) ![Swift 4.0](https://img.shields.io/badge/Swift-4.0%2B-orange.svg)

## 介绍
PodMan是一款运行在MacOS上，基于CocoaPods的工具型应用。旨在为纯命令行操作的CocoaPods增加一个相对友好的UI入口。CocoaPods官方也提供了MacOS应用。但是功能相对单一只能针对PodFile操作，对于我们想要自己创建Pod，私有化Pod，日常维护自己Pod的开发者们需要更多定制的功能。PodMan可以帮助你完成这些工作。

## 为什么要使用PodMan?
首先，PodMan可以在任何时候修改你Pod的选项参数如：

* allow-wanrings
* use-libraries
* verbose
* sources （私有Pod，长的令人发指）

使用PodMan你可以不必在手敲这些累赘的参数，只需要轻点勾选即可。同时，也不会以为忘记加某个参数让你这好几分钟的lint白白浪费。

其次，CocoaPods的命令其实已经相对比较简单了。但是当然我们需要日常维护某一个Pod的时候，比如做了组件化的同学，每天都需要不停地lint、speclint、tag、release、repopush、等等一套全家桶命令。在这以前我是使用zsh的alias来简化工作的。但是针对不同的Pod所用的参数也不同，所以我们需要一个既方便又灵活的方法来执行这些命令，我想没有什么比一个可以勾选参数来执行的应用更方便了。

## 安装PodMan
1.clone 代码或者直接下载repo中的**PodMan.dmg**到你的本地。剩下的你懂得。
2.因为我的开发者证书过期了。我暂时还不想续费所以会弹出：
>该应用来自身份不明的开发者。balabalabala。。。。

大家放心，我真的不是黑户😂😂😂😂
为了正常进入APP，你需要在**系统偏好设置 -> 安全性与隐私 -> 点击PodMan 仍要打开**

然后...欢迎使用PodMan！

## 使用PodMan
请前去查看《PodMan使用手册》

##TODO
* 发布beta版本 (done)
* 单元测试
* 增加PodFile编辑功能
* ...

## 最后
项目正在beta测试中，如果你遇到任何问题都可以通过我博客的联系方式找到我，或者提issue给我。或者直接发个PR那就最好不过了~~。期待你的使用。


