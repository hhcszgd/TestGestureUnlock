//
//  DDGestureView.swift
//  TestGestureUnlock
//
//  Created by WY on 2018/6/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDGestureView: UIView {
    var buttons = [UIButton]()
    var currentPoint : CGPoint = CGPoint.zero
    var handle : ((String) -> (Bool))?
    var isCorrect  = false
    var isEnd = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.setup()
    }
    func setup() {
            for i in 1...9{
                let button = UIButton()
                button.tag = i
                button.setImage(UIImage(named: "gesture_node_normal"), for: UIControlState.normal)
                button.setImage(UIImage(named: "gesture_node_highlighted"), for: UIControlState.selected)
                button.isUserInteractionEnabled = false
                self.addSubview(button)
            }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        for (index , button) in self.subviews.enumerated() {
            let btnWH : CGFloat = self.bounds.width / 7
            let margin = btnWH
            let col = index % 3
            let row = Int(index / 3)
            let btnX = margin + CGFloat(col) * (margin + btnWH)
            let btnY = (self.bounds.height - self.bounds.width ) / 2 +   margin + CGFloat(row) * (margin + btnWH)
            button.frame = CGRect(x: btnX, y: btnY, width: btnWH, height: btnWH)
        }
    }
    
    /**
     *  根据触摸点获取触摸到的按钮
     *  @return 触摸的按钮
     */
    func getCurrentBtnWithPoint(point:CGPoint) -> UIButton? {
        for btn  in self.subviews {
            if let button = btn as? UIButton ,  button.frame.contains(point){
                return button
            }
        }
        return nil
    }
    
    /**
     *  根据系统传入的UITouch集合获取当前触摸的点
     *  @return 当初触摸的点
     */
    func getCurrentTouchPoint(touches : Set<UITouch>) -> CGPoint {
        if let touch = touches.first{
            return touch.location(in: touch.view)
        }
        return CGPoint.zero
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let startPoint = self.getCurrentTouchPoint(touches: touches)
        if let button = self.getCurrentBtnWithPoint(point: startPoint){
            button.isSelected = true
            if !self.buttons.contains(button){
                self.buttons.append(button)
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let movePoint = self.getCurrentTouchPoint(touches: touches)
        if let button = self.getCurrentBtnWithPoint(point: movePoint) , !button.isSelected
        {
            button.isSelected = true 
            self.buttons.append(button)
        }
        self.currentPoint = movePoint
        self.setNeedsDisplay()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var inputString = ""
        for view  in buttons {
            inputString += "\(view.tag)"
        }
        if self.handle != nil {
            self.isCorrect = self.handle!(inputString)
        }
        self.isEnd = true
        self.setNeedsDisplay()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            for btn  in self.buttons {
                btn.isSelected = false
            }
            self.buttons.removeAll()
            self.setNeedsDisplay()
            self.currentPoint = CGPoint.zero
        }
        
    }
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.clear(rect)
        ctx?.beginPath()
        var isCurrentInButtonArea = false
        for (index , button ) in buttons.enumerated(){
            if index == 0 {
                ctx?.move(to: button.center)
            }else{
                ctx?.addLine(to: button.center)
            }
            if button.frame.contains(self.currentPoint){
                isCurrentInButtonArea = true
            }
        }
        if !isCurrentInButtonArea{
            ctx?.addLine(to: self.currentPoint)
        }
        
//        if self.buttons.count != 0 {
        if isEnd {
            isEnd = false
            if isCorrect {
                UIColor(red: 18/255.0, green: 102/255.0, blue: 72/255.0, alpha: 0.8).set()
            }else{
                UIColor(red: 255/255.0, green:0, blue: 0, alpha: 0.6).set()
            }
        }else{
            UIColor(red: 18/255.0, green: 102/255.0, blue: 72/255.0, alpha: 0.8).set()
        }
        ctx?.setLineWidth(10)
            ctx?.setLineJoin(CGLineJoin.round)
            ctx?.setLineCap(CGLineCap.round)
            ctx?.strokePath()
//        }
    }



}
