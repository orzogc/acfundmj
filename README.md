# acfundmj
AcFun直播弹幕姬

### 依赖
* Qt >= 5.15

### 编译
```
go get -u -d github.com/go-qamel/qamel
go get -u github.com/go-qamel/qamel/cmd/qamel
git clone https://github.com/orzogc/acfundmj.git
cd acfundmj
qamel build
```

#### 用docker交叉编译
```
go get -u -d github.com/go-qamel/qamel
go get -u github.com/go-qamel/qamel/cmd/qamel
git clone https://github.com/orzogc/acfundmj.git
cd acfundmj
qamel docker target
```
具体target看 [qamel wiki](https://github.com/go-qamel/qamel/wiki/Building-Application#using-docker-image) 。

### 使用方法
直接运行，右键点击界面选择“输入主播uid”，然后输入主播uid。

要实现背景全透明，背景颜色设置为黑色（#000000），Alpha通道设为0即可。想要背景完全不透明将Alpha通道设为255即可。
