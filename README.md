

# SeparatorLine
<img src="https://github.com/coder-zyp/SeparatorLine/raw/master/demo/SimulatorScreenShot.png" width = "300" height = "533" alt="图片名称" align=center/>     

一行代码可以让你的视图加一条分割线，减少一些繁琐的约束代码，可以是类似于tableView的separator ，也可以另做用途


## CocoaPods


```
use_frameworks!
target '<Your Target Name>' do
    pod 'SeparatorLine'
end
```

## Usage
```swift
_ = view.separator(position: .top)
```

```swift
//对应上面图片
let whiteView = view.separator(position: .bottom).width(width: 500).color(color: .white)
let greenView = whiteView.separator(position: .right).width(width: 10).color(color: .green).space(space: 10)
let redView = whiteView.separator(position: .right).color(color: .red).spaceToView(view: greenView, space: 10)
let blueView = whiteView.separator(position: .top).space(space: 50).width(width: 10).color(color: .blue).inset(inset: 70)
let purView = whiteView.separator(position: .top)
```

### Requirements
```
iOS 8.0+ 
Swift 3.0 
```

### Contact
<body>

<img src="https://github.com/coder-zyp/SeparatorLine/raw/master/demo/二维码.JPG" width = "100" height = "100" alt="图片名称" align=center/><br>从一个全局的方法写到UIView的拓展，分享出来，寻求技术交流<br>如果你有什么想法，或有什么想需要代劳的，扫码加我
</body>


