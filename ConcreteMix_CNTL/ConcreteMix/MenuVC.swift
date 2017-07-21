//
//  MenuVC.swift
//  ConcreteMix
//
//  Created by user on 15/9/29.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    var swiftPagesView : SwiftPages!
    var menu1: SY_MenuView!
    var menu2: BH_MenuView!
    var page = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = con.bkcolor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "Heiti SC", size: 16.0)!]
        self.view.backgroundColor = con.lightGrayColor
        self.title="拌和站与试验室信息管理"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let item = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        //拌合机状态
        let img = UIImage(named: "sts")
        let item_btn = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.Plain, target: self, action: "btn_BhjStsBtn:")
        self.navigationItem.rightBarButtonItem = item_btn
        
        //组织机构
        let lb_title:UILabel = UILabel(frame: CGRect(x: 0, y: 65, width: self.view.frame.width, height: 60))
        let lb_zuzhi:UILabel = UILabel(frame: CGRect(x: 3, y: 65 + 3, width: 100, height: 30))
        let lb_project:UILabel = UILabel(frame: CGRect(x: 53, y: 65 + 30, width: 100, height: 30))
        lb_zuzhi.textColor = UIColor.whiteColor()
        lb_zuzhi.text = "组织机构"
        lb_zuzhi.font = UIFont.systemFontOfSize(15)
        lb_project.textColor = UIColor.whiteColor()
        //lb_project.text = con.departName_sel
        lb_project.adjustsFontSizeToFitWidth  = true
        lb_project.font = UIFont.systemFontOfSize(17)
        lb_title.backgroundColor = con.bkcolor1
        self.view.addSubview(lb_title)
        self.view.addSubview(lb_zuzhi)
        self.view.addSubview(lb_project)
        
        //创建两个menu
        swiftPagesView = SwiftPages(frame: CGRectMake(0, 125, self.view.frame.width, self.view.frame.height))
        swiftPagesView.backgroundColor = con.bkcolor
        self.view.addSubview(swiftPagesView)
        
        con.width = Int(self.view.frame.width)
        con.height = Int(self.view.frame.height)
        //menu1 = SY_MenuView(frame: CGRect(x: 5, y: 5, width: self.view.frame.width-10, height: self.view.frame.height),nav:self.navigationController!,GroupId:con.departId_sel)
        menu1.backgroundColor = con.bkcolorview
        menu1.layer.cornerRadius = 5;//设置那个圆角的有多圆
        menu1.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
        menu1.layer.borderColor = UIColor.yellowColor().CGColor//设置边框的颜色
        menu1.layer.masksToBounds = true//设为NO去试试
        
        
        //menu2 = BH_MenuView(frame: CGRect(x: self.view.frame.width + 5, y: 5, width: self.view.frame.width-10, height: self.view.frame.height),nav:self.navigationController!,GroupId:con.departId_sel)
        menu2.backgroundColor = con.bkcolorview
        menu2.backgroundColor = con.bkcolorview
        menu2.layer.cornerRadius = 5;//设置那个圆角的有多圆
        menu2.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
        menu2.layer.borderColor = UIColor.yellowColor().CGColor//设置边框的颜色
        menu2.layer.masksToBounds = true//设为NO去试试
        
        let VCIDs : [UIView] = [menu1, menu2]
        //let buttonImages : [UIImage] = [UIImage(named:"ShiYan")!, UIImage(named:"BanHe")!]
        let buttonTitles : [String] = ["试验室管理", "拌和站管理"]
        swiftPagesView.initializeWithVCIDsArrayAndButtonTitlesArray(VCIDs, buttonTitlesArray: buttonTitles)
        swiftPagesView.showPage = page    }
    
    //拌合机状态
    func btn_BhjStsBtn(sender: UIButton){
        let sub: BH_Jqzt = BH_Jqzt(nibName: "BH_Jqzt", bundle: nil)
        self.navigationController!.pushViewController(sub, animated: true)
    }
}
