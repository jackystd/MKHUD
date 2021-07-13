//
//  MKHUDTestViewController.swift
//  test
//
//  Created by Jacky on 2021/5/23.
//

import UIKit
//import MKHUD

class MKHUDTestViewController: UIViewController {
    
    let swt = UISwitch()
    lazy var tableView: UITableView = {
        let tbv = UITableView(frame: .zero, style: .grouped)
        tbv.delegate = self
        tbv.dataSource = self
        tbv.tableFooterView = UIView()
        tbv.backgroundColor = .white
        tbv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tbv
    }()
    
    var tstyle: MKHUDTheme {
        return swt.isOn ? .dark : .light
    }
    
    var clickLeftTopCallback: (()->Void)?

    let actions: [(String, [(String, Selector)])] = [
        ("Simple use case",
             [
                ("Indeterminate", #selector(showIndeterminate)),
                ("Simple text", #selector(showText)),
                ("Detail text", #selector(showDetailText)),
                ("Indeterminate & Text", #selector(showIndeterminateAndText)),
                ("Circle progress", #selector(showCircleProgress)),
                ("Bar progress", #selector(showBarProgress)),
                ("Text & Button", #selector(showButton)),
                ("Blur background", #selector(showBlurBackground)),
                ("Custom view", #selector(showCustomView)),
            ]
        ),
        
        ("Composite use case",
             [
                ("Quick use case", #selector(quickUseCase)),
                ("Simulate the download process", #selector(simulateTheDownloadProcess)),
             ]
        ),
        
        ("Test",
             [
                ("Unit test", #selector(unitTest)),
             ]
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MKHUD"
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        self.swt.isOn = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        var tableViewConstraints = [NSLayoutConstraint](
            [
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ]
        )
        
        if #available(iOS 11.0, *) {
            tableViewConstraints.append(tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
            tableViewConstraints.append(tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        } else {
            tableViewConstraints.append(tableView.topAnchor.constraint(equalTo: view.topAnchor))
            tableViewConstraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        }
        
        view.addConstraints(tableViewConstraints)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: swt)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(onClickPlay))
    }
    
    @objc func onClickPlay() {
        clickLeftTopCallback?()
    }
    
    @objc func showIndeterminate() {
        let hud = MKHUDView(frame: self.view.bounds, theme: tstyle)
        hud.mode = .indeterminate
        hud.autoHidden = 2.0
        hud.show(to: self.view)
    }
    
    @objc func showText() {
        let hud = MKHUDView(frame: self.view.bounds, theme: tstyle)
        hud.mode = .text
        hud.text = "Hello World!"
        hud.autoHidden = 2.0
        hud.animationMode = .zoomIn
        hud.completionHandle = {
            print("hud did dismiss")
        }
        hud.show(to: self.view)
    }
    
    @objc func showDetailText() {
        let hud = MKHUDView(frame: self.view.bounds, theme: tstyle)
        hud.mode = .text
        hud.text = "Hello World!"
        hud.detailText = "If you need to configure the HUD you can do this by using the MKHUD reference that show function."
        hud.autoHidden = 2.0
        hud.completionHandle = {
            print("text hud completionHandle")
        }
        hud.animationMode = .zoomIn
        hud.show(to: self.view)
    }
    
    @objc func showIndeterminateAndText() {
        let hud = MKHUDView(frame: self.view.bounds, theme: tstyle)
        hud.mode = .indeterminate
        hud.text = "Loading..."
        hud.autoHidden = 3.0
        hud.animationMode = .zoomIn
        hud.show(to: self.view)
    }
    
    @objc func showCircleProgress() {
        let hud = MKHUDView(frame: self.view.bounds, theme: tstyle)
        hud.mode = .determinate
        hud.text = "Downloading..."
        hud.animationMode = .zoomIn
        hud.show(to: view)
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
            hud.progress += 0.01
            if hud.progress >= 1.0 {
                t.invalidate()
                hud.mode = .text
                hud.text = "Download Success!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    hud.dismiss()
                }
            }
        }
    }
    
    @objc func showBarProgress() {
        let hud = MKHUDView(frame: self.view.bounds, theme: tstyle)
        hud.mode = .bar
        hud.text = "Downloading..."
        hud.animationMode = .zoomIn
        hud.show(to: view)
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
            hud.progress += 0.01
            if hud.progress >= 1.0 {
                t.invalidate()
                hud.mode = .text
                hud.text = "Download Success!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    hud.dismiss()
                }
            }
        }
    }
    
    @objc func showButton() {
        let hud = MKHUDView(frame: self.view.bounds, theme: tstyle)
        hud.mode = .indeterminate
        hud.text = "Loading..."
        hud.detailText = "Click the button to cancel loading."
        let btnConfig = MKHUDButtonConfig(title: "Cancel") {
            $0.dismiss()
        }
        hud.btnConfig = btnConfig
        hud.animationMode = .zoomIn
        hud.show(to: self.view)
    }
    
    @objc func showBlurBackground() {
        let hud = MKHUDView(frame: self.view.bounds, theme: tstyle)
        hud.mode = .indeterminate
        hud.backgroundStyle = .blur
        hud.text = "Hello World!"
        hud.detailText = "If you need to configure the HUD you can do this by using the MKHUD reference that show function."
        hud.autoHidden = 3.0
        hud.animationMode = .zoomIn
        hud.show(to: self.view)
    }
    
    @objc func showCustomView() {
        let hud = MKHUDView(frame: self.view.bounds, theme: tstyle)
        hud.mode = .custom
        let imgv = UIImageView(image: UIImage.init(named: "maya"))
        imgv.frame = CGRect(x: 0, y: 0, width: 128, height: 128)
        hud.customView = imgv
        hud.text = "Hello World!"
        hud.autoHidden = 3.0
        hud.animationMode = .zoomIn
        hud.show(to: self.view)
    }
    
    @objc func quickUseCase() {
        let hud = self.view.showMKHUDText("Hello World!", detailText: "If you need to configure the HUD you can do this by using the MKHUD reference that show function.", autoHidden: 3.0, theme: MKHUDTheme(.systemYellow, .black))
        hud.completionHandle = {
            print("hud did dismiss")
        }
    }
    
    @objc func simulateTheDownloadProcess() {
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
    }
}

extension MKHUDTestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions[section].1.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = actions[indexPath.section].1[indexPath.row].0
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.perform(actions[indexPath.section].1[indexPath.row].1)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return actions[section].0
    }
}

extension MKHUDTestViewController {
    
    @objc func unitTest() {
        let modes: [MKHUDMode] = [.text, .indeterminate, .determinate, .bar, .custom]
        let texts: [String] = [randomString(0), randomString(10), randomString(30)]
        let detailTexts: [String] = [randomString(0), randomString(10), randomString(50), randomString(150)]
        let buttonTexts: [String] = [randomString(0), randomString(10), randomString(30)]
        
        let hud = MKHUDView(frame: self.view.bounds, theme: tstyle)
        hud.animationMode = .zoomIn
        hud.show(to: self.view)
        
        var configs: [(MKHUDMode, String, String, String)] = []
        for mode in modes {
            for text in texts {
                for detailText in detailTexts {
                    for btnText in buttonTexts {
                        configs.append((mode, text, detailText, btnText))
                    }
                }
            }
        }
        
        var idx = 0
        
        // 手动检测
//        clickLeftTopCallback = {[weak self] in
//            guard let self = self else {
//                return
//            }
//            let config = configs[idx]
//            hud.mode = config.0
//            hud.text = config.1
//            hud.detailText = config.2
//
//            if config.3.count > 0 {
//                hud.btnConfig = MKHUDButtonConfig(title: config.3, action: { _ in
//                })
//            } else {
//                hud.btnConfig = nil
//            }
//
//            if hud.mode == .custom {
//                let imgv = UIImageView(image: UIImage.init(named: "maya"))
//                imgv.frame = CGRect(x: 0, y: 0, width: 128, height: 128)
//                hud.customView = imgv
//            } else {
//                hud.customView = nil
//            }
//
//            hud.progress = Double.random(in: 0...1)
//
//            let result = hud.checkUI()
//            print("[MKHUD] CHECK UI: ", result.compactMap{ $0.rawValue }.joined(separator: "-"))
//            if result.contains(.becovered) {
//                print("[MKHUD] item becovered")
//            }
//
//            idx += 1
//            if idx >= configs.count {
//                hud.dismiss()
//                self.clickLeftTopCallback = nil
//            }
//        }
        
        // 自动检测
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            let config = configs[idx]
            hud.mode = config.0
            hud.text = config.1
            hud.detailText = config.2

            if config.3.count > 0 {
                hud.btnConfig = MKHUDButtonConfig(title: config.3, action: { _ in
                })
            } else {
                hud.btnConfig = nil
            }

            if hud.mode == .custom {
                let imgv = UIImageView(image: UIImage.init(named: "maya"))
                imgv.frame = CGRect(x: 0, y: 0, width: 128, height: 128)
                hud.customView = imgv
            } else {
                hud.customView = nil
            }

            hud.progress = Double.random(in: 0...1)

            let result = hud.checkUI()
            print("[MKHUD] CHECK UI: ", result.compactMap{ $0.rawValue }.joined(separator: "-"))
            if result.contains(.becovered) {
                timer.invalidate()
            }

            idx += 1
            if idx >= configs.count {
                timer.invalidate()
                hud.dismiss()
            }
        }
    }
    
    func randomString(_ count: Int) -> String {
        guard count > 0 else {
            return ""
        }
        var string = ""
        for _ in 0..<count {
            string.append(Character(UnicodeScalar(Int.random(in: 65...90))!))
        }
        return string
    }
    
}
