### Usage

#### Quickly usage

```swift
// Text
self.view.showMKHUDText("Hello World!", autoHidden: 2.0)

// More options
let hud = self.view.showMKHUDText("Hello World!", detailText: "If you need to configure the HUD you can do this by using the MKHUD reference that show function.", autoHidden: 3.0, theme: MKHUDTheme(.systemYellow, .black))
hud.completionHandle = {
    print("hud did dismiss")
}

// Indicator & Text
self.view.showMKHUDIndicator("Loading...")
DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    self.view.hideMKHUD()
}

// defaults themes
let hud = MKHUDView(frame: self.view.bounds, theme: .dark)
let hud = MKHUDView(frame: self.view.bounds, theme: .light)
```



#### Text

```swift
let hud = MKHUDView(frame: self.view.bounds)
hud.mode = .text
hud.text = "Hello World!"
hud.autoHidden = 2.0
hud.animationMode = .zoomIn
hud.show(to: self.view)
```

#### Indeterminate

```swift
let hud = MKHUDView(frame: self.view.bounds)
hub.mode = .indeterminate
hub.text = "Loading..."
hub.autoHidden = 3.0
hub.animationMode = .zoomIn
hub.show(to: self.view)
```

#### Mode switching

```swift
let hud = self.view.showMKHUDIndicator("Connecting...", theme: tstyle)
DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
    hud.mode = .determinate
    hud.text = "Download..."
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
        hud.progress += Double.random(in: 0.01...0.05)
        hud.detailText = "\(Int(hud.progress*100))%"
        if hud.progress >= 1.0 {
            t.invalidate()
            let imgv = UIImageView(image: UIImage.init(named: "ic_ok"))
            imgv.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
            hud.customView = imgv
            hud.mode = .custom
            hud.text = "Download Success!"
            hud.detailText = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
              	self.view.hideMKHUD()
            }
        }
    }
}

```

#### Custom view

```swift
let hud = MKHUDView(frame: self.view.bounds, theme: tstyle)
hud.mode = .custom
let imgv = UIImageView(image: UIImage.init(named: "maya"))
imgv.frame = CGRect(x: 0, y: 0, width: 128, height: 128)
hud.customView = imgv
hud.text = "Hello World!"
hud.autoHidden = 3.0
hud.animationMode = .zoomIn
hud.show(to: self.view)
```

#### Define color style

```swift
let theme = MKHUDTheme(.systemYellow, .black)
let hud = MKHUDView(frame: self.view.bounds, theme: theme)
```

### Install

```shell
pod 'MKProgressHUD', :git => 'https://github.com/jackystd/MKHUD.git', :branch => 'main'
```





