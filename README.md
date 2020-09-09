# acfundmj
AcFun直播弹幕姬（测试用），如果要使用弹幕姬推荐使用 [aclivechat](https://github.com/ShigemoriHakura/aclivechat)

### 依赖
* Qt >= 5.15

### 编译
```
go get -u -d github.com/go-qamel/qamel
go get -u github.com/go-qamel/qamel/cmd/qamel
git clone https://github.com/orzogc/acfundmj.git
cd acfundmj
qamel profile setup
qamel build
```

### 使用方法
直接运行，右键点击界面选择“输入主播uid”，然后输入主播uid。

要实现背景全透明，背景颜色设置为黑色（#000000），Alpha通道设为0即可。想要背景完全不透明将Alpha通道设为255即可。

目前窗口缩放可能会有撕裂跳跃现象。

#### OBS捕获窗口的方法
游戏捕获->捕获特定窗口->选择弹幕姬->允许透明度->确定->一般等待几分钟就能成功捕获到弹幕姬的透明背景窗口
