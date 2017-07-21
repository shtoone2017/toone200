//
//  GLTBC.swift
//  ConcreteMix
//
//  Created by user on 15/12/1.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit

class GLTBC: UITabBarController,GroupIDSelectDelegate {

    var lb_project:UILabel!
    
    override func viewDidLoad() {

        super.viewDidLoad()

        con.width = Int(self.view.frame.width)
        con.height = Int(self.view.frame.height)
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = con.bkcolor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "Heiti SC", size: 16.0)!]
        self.view.backgroundColor = con.bkcolor
        self.title="拌和站与试验室信息管理"
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        let item = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.navigationItem.hidesBackButton = true;
        //拌合机状态
        let img = UIImage(named: "sts")
        let item_btn:UIBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.Plain, target: self, action: "btn_BhjStsBtn:")
        self.navigationItem.rightBarButtonItem = item_btn
        //组织机构
        CreateTitle()
    }
    
    func CreateTitle(){
        //组织机构
        let lb_title:UILabel = UILabel(frame: CGRect(x: 0, y: 65, width: self.view.frame.width, height: 60))
        lb_title.backgroundColor = con.bkcolor1
        self.view.addSubview(lb_title)
        
        lb_project = UILabel(frame: CGRect(x: 5, y: 65 + 18, width: con.width - 60, height: 30))
        lb_project.textColor = UIColor.whiteColor()

        lb_project.adjustsFontSizeToFitWidth  = true
        lb_project.font = UIFont.systemFontOfSize(17)
        lb_project.adjustsFontSizeToFitWidth = true
        self.view.addSubview(lb_project)
        
        let img01 = UIImageView(frame: CGRect(x: con.width-40, y: 65 + 18, width:30 , height: 30))
        img01.image = UIImage(named: "plot")
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_SY_JGVC:")
        img01.userInteractionEnabled = true
        img01.addGestureRecognizer(tap)
        self.view.addSubview(img01)
        
    }

    override func viewWillAppear(animated: Bool) {
        if(self.selectedIndex == 0)
        {
            lb_project.text = con.departName_Nav_SY_sel //3.试验室
            self.selectedViewController?.viewWillAppear(animated)
        }
        else
        {
            lb_project.text = con.departName_Nav_BH_sel //1.水泥混凝土
            self.selectedViewController?.viewWillAppear(animated)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //组织机构
    func btn_SY_JGVC(sender: AnyObject){
        let sub: SY_JGVC = SY_JGVC(nibName: "SY_JGVC", bundle: nil)
        sub.delegate = self
        sub.IGroupID = con.departId
        if(self.selectedIndex == 0)
        {
            sub.IFuntype = "3" //3.试验室
        }
        else
        {
            sub.IFuntype = "1" //1.水泥混凝土
        }
    
        sub.IType = con.userRole
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //委托函数实现
    func GroupIDSelect(GroupID:String,GroupName:String, ctl:SY_JGVC){
        print(GroupID)
        if(self.selectedIndex == 0)
        {
            con.departId_Nav_SY_sel = GroupID
            con.departName_Nav_SY_sel = GroupName
            lb_project.text = con.departName_Nav_SY_sel //3.试验室
        }
        else
        {
            con.departId_Nav_BH_sel = GroupID
            con.departName_Nav_BH_sel = GroupName
            lb_project.text = con.departName_Nav_BH_sel //1.水泥混凝土
        }

//        //清空设备列表
//        btnDevice.setTitle("  选择设备", forState:UIControlState.Normal)
//        SheBei = "-1"
//        self.tableview.header.state = RefreshViewStateDefault
//        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
//        tableviewRefresh()
    }

    //拌合机状态
    func btn_BhjStsBtn(sender: UIButton){
        //消息记录
        let btn1 = KxMenuItem("消息记录",image:nil,target:self,action:"pushMenuItem:")
        //拌合机状态
        let btn2 = KxMenuItem("拌合机状态",image:nil,target:self,action:"pushMenuItem:")
        //退出
        let btn3 = KxMenuItem("重新登录",image:nil,target:self,action:"pushMenuItem:")
        //检查更新
        let btn4 = KxMenuItem("检查更新",image:nil,target:self,action:"pushMenuItem:")
        
        let menuItems = [btn1,btn2,btn3]
        btn1.alignment = NSTextAlignment.Center
        KxMenu.showMenuInView(self.view, fromRect: CGRectMake(300,-130,200,200), menuItems: menuItems)
    }
    
    func pushMenuItem(sender: AnyObject){
        if((sender as! KxMenuItem).title == "拌合机状态")
        {
            let sub: BH_Jqzt = BH_Jqzt(nibName: "BH_Jqzt", bundle: nil)
            self.navigationController!.pushViewController(sub, animated: true)
        }
        else if ((sender as! KxMenuItem).title == "消息记录")
        {
            let sub: MsgVC = MsgVC(nibName: "MsgVC", bundle: nil)
            self.navigationController!.pushViewController(sub, animated: true)
        }
        else if ((sender as! KxMenuItem).title == "检查更新")
        {
            let url = NSURL(string: "http://www.163.com")
            UIApplication.sharedApplication().openURL(url!)
        }
        else
        {
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
    }
    
    //试验室菜单
    func btn_title(sender: AnyObject){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewControllerWithIdentifier("SGTBC") as! SGTBC
        //present方式
        let item = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //tab切换事件
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        //NSNotificationCenter.defaultCenter().postNotificationName("selectedChange", object: self.selectedIndex)
        if(item.title! == "试验室")
        {
            lb_project.text = con.departName_Nav_SY_sel //3.试验室
        }
        else
        {
            lb_project.text = con.departName_Nav_BH_sel //1.水泥混凝土
        }
    }


}
