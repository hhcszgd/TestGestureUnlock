//
//  ViewController.swift
//  TestGestureUnlock
//
//  Created by WY on 2018/6/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let v = DDGestureView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        v.handle = {para in
            print("gesture end \(para)")
            if para == "123"{
                return true
            }else{
               return  false 
            }
        }
        self.view.addSubview(v)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

