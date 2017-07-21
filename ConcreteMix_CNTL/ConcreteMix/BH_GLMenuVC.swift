//
//  BH_GLMenuVC.swift
//  ConcreteMix
//
//  Created by user on 15/12/8.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit

protocol BH_GLMenuVCrDelegate {
    func pressOK(value:Int)
}

class BH_GLMenuVC: UIViewController {

    var delegate:BH_GLMenuVCrDelegate?
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
