//
//  ZYPLine.swift
//  testCode
//
//  Created by yunpeng zhang on 2017/4/15.
//  Copyright © 2017年 yunpeng zhang. All rights reserved.
//

import Foundation
import UIKit
//import SnapKit

func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor { return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a) }

struct SuperConstraint {
    
    var centerX : NSLayoutConstraint! = nil
    var centerY : NSLayoutConstraint! = nil
    var top : NSLayoutConstraint! = nil
    var bottom : NSLayoutConstraint! = nil
    var left : NSLayoutConstraint! = nil
    var right : NSLayoutConstraint! = nil
    var height : NSLayoutConstraint! = nil
    var width : NSLayoutConstraint! = nil
}
enum ZYPPosition {
    case leading
    case trailing
    case center
}
extension UIViewContentMode {
    
}

extension UIView {
    
    public class Line : UIView {
        
        //线条默认值
        private var color : UIColor = RGBA (r: 210, g: 210, b: 210, a: 1)
        private var width : CGFloat = 1
        
        //方法接受的值
        private var position: UIViewContentMode! = nil
        private var space :CGFloat = 0 {
            didSet{
                if position == .right || position == .bottom {
                    space = -space
                }
            }
        }
        private var toView: UIView?
        private var dashWidth : CGFloat = 0 //初始化的值不要换

        var superConstraint = SuperConstraint()
      
        
        private var leadInset : CGFloat = 0
        private var trailInset : CGFloat = 0{
            didSet{
                trailInset = -trailInset
            }
        }
        private var leadOrTrail : ZYPPosition! = nil
        private var leadOrTrailView : UIView?
        private var length :CGFloat? = nil
        private var inset :CGFloat = 0{
            didSet {
                leadInset = inset
                trailInset = inset
            }
        }
        
        
        public func color (color:UIColor) -> Line{
            self.backgroundColor = color
            self.color = color
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
        public func width(width: CGFloat) -> Line {
            self.width = width
            superConstraint.height.constant = width
            superConstraint.width.constant = width
            return self
        }
        public func space(space: CGFloat) -> Line {
            self.space = space
            self.constraintsUpdate()
            return self
        }
        public func spaceToView( view:UIView ,space: CGFloat) -> Line {
            self.toView = view
            self.space = space
            self.constraintsChange()
            return self
        }
        public func inset (inset:CGFloat) -> Line {
            self.inset = inset
            self.constraintsUpdate()
            return self
        }
        func leadInset(inset:CGFloat) -> Line {
            leadOrTrail = .leading
            leadInset = space
            self.constraintsUpdate()
            return self
        }
        func trailInset(inset:CGFloat) -> Line {
            leadOrTrail = .trailing
            trailInset = inset
            self.constraintsUpdate()
            return self
        }
        func leadToView(view:UIView,inset:CGFloat) -> Line {
            leadOrTrail = .leading
            leadOrTrailView = view
            leadInset = inset
            self.constraintsChange()
            return self
        }
        
        func trailToView(view:UIView,inset:CGFloat) -> Line {
            leadOrTrail = .trailing
            leadOrTrailView = view
            trailInset = inset
            self.constraintsChange()
            return self
        }
        func length(ZYPPosition:ZYPPosition,length:CGFloat) -> Line {
            leadOrTrail = ZYPPosition
            self.length = length
            switch ZYPPosition {
            case .leading:
                switch (position!){
                case .top ,.bottom:
                    self.superview?.removeConstraint(superConstraint.right)
                    let width = NSLayoutConstraint (item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: length)
                    self.superview?.addConstraint(width)
                case .left , .right:
                    self.superview?.removeConstraint(superConstraint.bottom)
                    let height = NSLayoutConstraint (item: self, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .notAnAttribute, multiplier: 0 , constant: length)
                    self.superview?.addConstraint(height)
                default:
                    break
                }
            case .trailing:
                switch (position!){
                case .top ,.bottom:
                    self.superview?.removeConstraint(superConstraint.left)
                    let width = NSLayoutConstraint (item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: length)
                    self.superview?.addConstraint(width)
                case .left , .right:
                    self.superview?.removeConstraint(superConstraint.top)
                    let height = NSLayoutConstraint (item: self, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .notAnAttribute, multiplier: 0 , constant: length)
                    self.superview?.addConstraint(height)
                default:
                    break
                }
            case .center:
                switch (position!){
                case .top ,.bottom:
                    self.superview?.removeConstraint(superConstraint.left)
                    self.superview?.removeConstraint(superConstraint.right)
                    let width = NSLayoutConstraint (item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: length)
                    self.superview?.addConstraint(width)
                    self.superview?.addConstraint(superConstraint.centerX)
                case .left , .right:
                    self.superview?.removeConstraint(superConstraint.top)
                    self.superview?.removeConstraint(superConstraint.bottom)
                    let height = NSLayoutConstraint (item: self, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .notAnAttribute, multiplier: 0 , constant: length)
                    self.superview?.addConstraint(height)
                    self.superview?.addConstraint(superConstraint.centerY)
                default:
                    break
                }
            }
            
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
                switch position! {
                case .top,.bottom:
                    context.move(to: CGPoint(x: 0, y: self.frame.height/2))
                    context.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height/2))
                    context.strokePath()
                case .left, .right:
                    context.move(to: CGPoint(x: self.frame.width/2, y: 0))
                    context.addLine(to: CGPoint(x:self.frame.width/2 , y: self.frame.height))
                    context.strokePath()
                default:
                    break
                }
                
            }
        }
        private func constraintsChange() {
            
            if let view = toView {
                
                switch (position!){
                    
                case .top:
                    self.superview?.removeConstraint(superConstraint.top)
                    superConstraint.top = NSLayoutConstraint (item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: space)
                    self.superview?.addConstraint(superConstraint.top)
                case .bottom:
                    self.superview?.removeConstraint(superConstraint.top)
                    superConstraint.bottom = NSLayoutConstraint (item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: space)
                    self.superview?.addConstraint(superConstraint.top)
                case .left:
                    self.superview?.removeConstraint(superConstraint.left)
                    superConstraint.left = NSLayoutConstraint (item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: space)
                    self.superview?.addConstraint(superConstraint.left)
                case .right:
        
                    self.superview?.removeConstraint(superConstraint.right)
                    superConstraint.right = NSLayoutConstraint (item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: space)
                    self.superview?.addConstraint(superConstraint.right)
                default:
                    break
                }
            }
            if let view = leadOrTrailView {
                switch (position!){
                    
                case .top ,.bottom:
                    if leadOrTrail == .leading {
                        self.superview?.removeConstraint(superConstraint.left)
                        superConstraint.left = NSLayoutConstraint (item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: leadInset)
                        self.superview?.addConstraint(superConstraint.left)
                        
                    }else{
                        self.superview?.removeConstraint(superConstraint.right)
                        superConstraint.right = NSLayoutConstraint (item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: trailInset)
                        self.superview?.addConstraint(superConstraint.right)
                    }
                    
                case .left , .right:
                    if leadOrTrail == .leading {
                        self.superview?.removeConstraint(superConstraint.top)
                        superConstraint.top = NSLayoutConstraint (item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: leadInset)
                        self.superview?.addConstraint(superConstraint.top)
                    }else{
                        self.superview?.removeConstraint(superConstraint.bottom)
                        superConstraint.bottom = NSLayoutConstraint (item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: trailInset)
                        self.superview?.addConstraint(superConstraint.bottom)
                    }
                default:
                    break
                }
            }
        }
        private func constraintsUpdate() {
            
            
            switch position! {
            case .top:
                superConstraint.top.constant = space
                superConstraint.left.constant = leadInset
                superConstraint.right.constant = trailInset
            case .bottom:
                superConstraint.bottom.constant = space
                superConstraint.left.constant = leadInset
                superConstraint.right.constant = trailInset
            case .left:
                superConstraint.left.constant = space
                superConstraint.top.constant = leadInset
                superConstraint.bottom.constant = trailInset
            case .right:
                superConstraint.right.constant = space
                superConstraint.top.constant = leadInset
                superConstraint.bottom.constant = trailInset
            default:
                break
            }
            
        }
        public init( superView: UIView, position: UIViewContentMode) {
            super.init(frame: CGRect.zero)
            superView.addSubview(self)
            self.translatesAutoresizingMaskIntoConstraints = false
            backgroundColor = color
            self.position = position

            superConstraint.top = NSLayoutConstraint (item: self, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: 0)
            superConstraint.bottom = NSLayoutConstraint (item: self, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1, constant: 0)
            
            superConstraint.left = NSLayoutConstraint (item: self, attribute: .left, relatedBy: .equal, toItem: superView, attribute: .left, multiplier: 1, constant: 0)
            superConstraint.right = NSLayoutConstraint (item: self, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1, constant: 0)
            
            superConstraint.height = NSLayoutConstraint (item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: width)
            superConstraint.width = NSLayoutConstraint (item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0, constant: width)
            
            superConstraint.centerX = NSLayoutConstraint (item: self, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1, constant: 0)
            superConstraint.centerY = NSLayoutConstraint (item: self, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1, constant: 0)
            
            
            
            switch (position){
            case .top:
                self.superview?.addConstraints([superConstraint.right,superConstraint.left,superConstraint.top,superConstraint.height])
            case .bottom:
                self.superview?.addConstraints([superConstraint.right,superConstraint.left,superConstraint.bottom,superConstraint.height])
            case .left:
                self.superview?.addConstraints([superConstraint.top,superConstraint.left,superConstraint.bottom,superConstraint.width])
            case .right:
                self.superview?.addConstraints([superConstraint.right,superConstraint.bottom,superConstraint.top,superConstraint.width])
            default:
                break
            }
        }
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    public func separator(position: UIViewContentMode ) -> UIView.Line {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let line = Line (superView: self, position: position)
        return line
    }

}
