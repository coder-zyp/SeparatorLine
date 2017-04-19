//
//  ViewController.swift
//  ZYPLineDemo
//
//  Created by yunpeng zhang on 2017/4/19.
//  Copyright © 2017年 yunpeng zhang. All rights reserved.
//

import UIKit
import SnapKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        //self.view下面加一条宽 100 白色的view
        let whiteView = view.separator(position: .bottom).width(width: 100).color(color: .white)

        
        
        //距离顶部 20px
        let redView = whiteView.separator(position: .top).space(space: 20).color(color: .red)
        
        let label = UILabel()
        whiteView.addSubview(label)
        
//        label 的左边加默认竖线
        _ = label.separator(position: .left)
        //label 下面加虚线 空隙 5px
        _ = label.separator(position: .bottom).color(color: .black).dash(dashWidth: 5)

        //加蓝线，距离label 20px ，两端缩进 50px
        let blueView = whiteView.separator(position: .top).spaceTo(aView: label, space: 20).color(color: .blue).inset(space: 50)
        
        //蓝线 尾部加一条 绿竖线  距离 10px
        _ = whiteView.separator(position: .left).spaceTo(aView: blueView, space: 10).color(color: .green)
        
        label.text = "ZYPLine"
        label.textAlignment = .center
        label.snp.makeConstraints { (make) in
            make.top.equalTo(redView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(60)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

