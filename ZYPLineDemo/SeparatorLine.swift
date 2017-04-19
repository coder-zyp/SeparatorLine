//
//  ZYPLine.swift
//  testCode
//
//  Created by yunpeng zhang on 2017/4/15.
//  Copyright © 2017年 yunpeng zhang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor { return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a) }

extension UIView {

    public class Line : UIView {
        
        //线条默认值
        private var color : UIColor = RGBA (r: 210, g: 210, b: 210, a: 1)
        private var width : CGFloat = 1
        
        //方法接受的值
        private var position: UIViewContentMode? = nil
        private var superView: UIView?
        private var inset :CGFloat = 0
        private var spaceToSuper :CGFloat = 0
        private var spaceToView : CGFloat = 0
        private var toView: UIView?
        private var dashWidth : CGFloat = 0 //初始化的值不要换

        
        public func color (color:UIColor) -> Line{
            self.backgroundColor = color
            self.color = color
            return self
        }
        
        public func inset (space:CGFloat) -> Line {
            self.inset  = space
            self.remakeConstraints()
            return self
        }
        public func spaceTo(aView:UIView,space:CGFloat) -> Line {
            self.spaceToView = space
            self.toView = aView
            self.remakeConstraints()
            return self
        }
        public func space (space:CGFloat) -> Line {
            self.spaceToSuper = space
            self.remakeConstraints()
            return self
        }
        public func width (width:CGFloat) -> Line{
            self.width = width
            self.remakeConstraints()
            return self
        }
        //变成虚线的方法，默认虚实10px，  改变了view的背景颜色，所以只能最后使用
        public func dash() -> Line {
            self.backgroundColor = .white
            self.dashWidth = 10
            return self
        }
        public func dash(dashWidth: CGFloat) -> Line {
            self.backgroundColor = .white
            self.dashWidth = dashWidth
            return self
        }
        
        public override func draw(_ rect: CGRect) {
            super.draw(rect)
            if dashWidth>0 {
                
                let context = UIGraphicsGetCurrentContext()!
                context.setLineCap(CGLineCap.square)
                
                let lengths:[CGFloat] = [dashWidth,dashWidth*2] // 绘制 跳过 无限循环
                
                context.setStrokeColor(self.color.cgColor)
                
                context.setLineWidth(2.0)
                
                context.setLineDash(phase: 0, lengths: lengths)
                context.move(to: CGPoint(x: 0, y: self.frame.height/2))
                context.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height/2))
                context.strokePath()
            }
        }
        private func remakeConstraints() -> Void {
            self.snp.remakeConstraints { (make) in
                
                if let position = self.position {
                    switch (position){
                    case .top:
                        if let aView = toView {
                            make.top.equalTo(aView.snp.bottom).offset(spaceToView)
                        }else{
                            make.top.equalToSuperview().inset(spaceToSuper)
                        }
                        make.left.right.equalToSuperview().inset(inset)
                        make.height.equalTo(width)
                    case .bottom:
                        if let aView = toView {
                            make.bottom.equalTo(aView.snp.top).offset(-spaceToView)
                        }else{
                            make.bottom.equalToSuperview().inset(spaceToSuper)
                        }
                        make.left.right.equalToSuperview().inset(inset)
                        make.height.equalTo(width)
                    case .left:
                        if let aView = toView {
                            make.left.equalTo(aView.snp.right).offset(spaceToView)
                            
                        }else{
                            make.left.equalToSuperview().inset(spaceToSuper)
                        }
                        make.top.bottom.equalToSuperview().inset(inset)
                        make.width.equalTo(width)
                    case .right:
                        if let aView = toView {
                            make.right.equalTo(aView.snp.left).offset(-spaceToView)
                        }else{
                            make.right.equalToSuperview().inset(spaceToSuper)
                        }
                        make.top.bottom.equalToSuperview().inset(inset)
                        make.width.equalTo(width)
                    default:
                        break
                    }
                }
            }
        }
        public init( superView: UIView, position: UIViewContentMode) {
            super.init(frame: CGRect.zero)

            backgroundColor = color
            superView.addSubview(self)
            self.position = position
            self.superView = superView
            self.snp.makeConstraints { (make) in
 
                
                switch (position){
                case .top:
                    make.top.equalToSuperview()
                    make.left.right.equalToSuperview()
                    make.height.equalTo(width)
                case .bottom:
                    make.bottom.equalToSuperview()
                    make.left.right.equalToSuperview()
                    make.height.equalTo(width)
                case .left:
                    make.left.equalToSuperview()
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(width)
                case .right:
                    make.right.equalToSuperview()
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(width)
                default:
                    break
                }
            }
        }
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    public func separator(position: UIViewContentMode ) -> UIView.Line {

        let line = Line (superView: self, position: position)
        return line
    }

}
