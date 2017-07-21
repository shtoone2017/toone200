//
//  SY_GLMenuVC.swift
//  ConcreteMix
//
//  Created by user on 15/12/8.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit

protocol SY_GLMenuVCrDelegate {
    func pressOK(value:Int)
}

class SY_GLMenuVC: UIViewController {

    var delegate:SY_GLMenuVCrDelegate?
    
    @IBAction func btn_01(sender: AnyObject) {
        self.delegate?.pressOK(1)
    }
    
    @IBAction func btn_02(sender: AnyObject) {
        self.delegate?.pressOK(2)
    }
    
    @IBAction func btn_03(sender: AnyObject) {
        self.delegate?.pressOK(3)
    }
    
    @IBAction func btn_04(sender: AnyObject) {
        self.delegate?.pressOK(4)
    }
    
    @IBAction func btn_05(sender: AnyObject) {
        self.delegate?.pressOK(5)
    }
    
    @IBAction func btn_06(sender: AnyObject) {
        self.delegate?.pressOK(6)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.layer.cornerRadius = 150
        self.view.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
