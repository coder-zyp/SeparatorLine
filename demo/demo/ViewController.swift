//
//  ViewController.swift
//  demo
//
//  Created by yunpeng zhang on 2017/4/21.
//  Copyright © 2017年 yunpeng zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        //self.view下面加一条宽 100 白色的view
        
        let whiteView = view.separator(position: .bottom).width(width: 500).color(color: .white)
        
        let greenView = whiteView.separator(position: .right).width(width: 10).color(color: .green).space(space: 10)
        let redView = whiteView.separator(position: .right).color(color: .red).spaceToView(view: greenView, space: 10)
        let blueView = whiteView.separator(position: .top).space(space: 50).width(width: 10).color(color: .blue).inset(inset: 70)
        let purView = whiteView.separator(position: .top)
            .spaceToView(view: blueView, space: 20)
            .color(color: .purple)
            .trailToView(view: redView, inset: 8)
            .width(width: 10)
            .leadToView(view: blueView, inset: 0)
        
        
        _ = whiteView.separator(position: .right).spaceToView(view: purView, space: 5).leadToView(view: purView, inset: 5).width(width: 5).trailInset(inset: 50)
        
        let yellowView = whiteView.separator(position: .top).spaceToView(view: purView, space: 60).color(color: .yellow).length(ZYPPosition: .center, length: 100).width(width: 100)
        
        _ = yellowView.separator(position: .left).dash(dashWidth: 5)
        _ = yellowView.separator(position: .bottom).color(color: .black).dash()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

