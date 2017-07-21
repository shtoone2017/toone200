//
//  SY_MenuView.swift
//  ConcreteMix
//
//  Created by user on 15/9/30.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import QuartzCore
import UIKit
import Alamofire

class SY_MenuVC: UIViewController {
    

    @IBOutlet weak var barBtn: UITabBarItem!
    var shiyanCircle:CircleShowView!
    var hegeCircle:CircleShowView!
    var uiscrollview: UIScrollView!
    
    //button
    var btn_shiyan : SFlatButton!
    var btn_buhege : SFlatButton!
    
    let lbHegiht = 120
    
    //待处置委托试验数量
    var lb_num01:UILabel!
    //待处置不合格试验数量
    var lb_num02:UILabel!
    //权限icon
    var img_buhege: UIImageView!
    
    var btn_hntqd: SFlatButton!
    var lb_hntqd = UILabel(frame: CGRect(x: 20, y: 60, width: 100, height: 60))
    var btn_gjll: SFlatButton!
    var lb_gjll = UILabel(frame: CGRect(x: 20, y: 60, width: 100, height: 60))
    var btn_gjhjjt: SFlatButton!
    var lb_gjhjjt = UILabel(frame: CGRect(x: 20, y: 60, width: 100, height: 60))
    var btn_gjjxljjt: SFlatButton!
    var lb_gjjxljjt = UILabel(frame: CGRect(x: 20, y: 60, width: 100, height: 60))
    //button
    var btn_zhtjfx: SFlatButton!
    var btn_bhgcl: SFlatButton!
    //屏幕宽度,高度
    var width:Int!
    var height:Int!
    
    //Json Url & 参数 Begin##############################################################################################################################
    var url = con.shiyanshiMenuURL
    var userGroupId   = "userGroupId="
    //Json Url & 参数 End################################################################################################################################
    
    //数据接收部 Begin+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var array:[String] = []
    //数据接收部 End+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    override func viewDidLoad() {
        super.viewDidLoad()

        width = con.width
        height = con.height
        // Do any additional setup after loading the view.
        uiscrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        uiscrollview.contentSize = CGSize(width: width, height: Int(con.iphone6p_height + 250))
        self.view.addSubview(uiscrollview)
        //画圆
        createCircleBtn()
        //menu1
        createMenuBtn1()
        //menu2
        createMenuBtn2()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //加载menu数据
        getJsonData()
    }
    
    
    func createCircleBtn(){
        //按钮宽
        let btnWidth = (width) / 3
        let btnWidth01 = width / 2
        
        //您的代办事项Label
        let lb_title = UILabel(frame: CGRect(x:btnWidth ,y:lbHegiht,width:btnWidth,height:40))
        lb_title.textColor = UIColor.blackColor()
        lb_title.text = "您的代办事项"
        lb_title.font = UIFont.systemFontOfSize(18)
        lb_title.adjustsFontSizeToFitWidth  = true
        self.uiscrollview.addSubview(lb_title)
        
        
        //按钮
        btn_shiyan = SFlatButton(frame: CGRect(x: 0, y: lbHegiht + 30, width: btnWidth01, height: btnWidth01-48),sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        //数字
        lb_num01 = UILabel(frame: CGRect(x:btnWidth01/3,y:10,width:120,height:60))
        lb_num01.textColor = con.bkcolor1
        lb_num01.adjustsFontSizeToFitWidth  = true
        lb_num01.font = UIFont.systemFontOfSize(50)
        btn_shiyan.addSubview(lb_num01)
        //增加事件
        btn_shiyan.addTarget(self, action: "daichuzhi_onClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        //待处置委托试验Label
        let lb_chuzhi = UILabel(frame: CGRect(x:btnWidth01/4,y:70,width:120,height:60))
        lb_chuzhi.textColor = UIColor.blackColor()
        lb_chuzhi.text = "待处置委托试验"
        lb_chuzhi.font = UIFont.systemFontOfSize(15)
        lb_chuzhi.adjustsFontSizeToFitWidth  = true
        btn_shiyan.addSubview(lb_chuzhi)
        self.uiscrollview.addSubview(btn_shiyan)
        
        
        //按钮
        btn_buhege = SFlatButton(frame: CGRect(x: btnWidth01 + 3, y: lbHegiht + 30, width: btnWidth01, height: btnWidth01-48),sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        //数字
        lb_num02 = UILabel(frame: CGRect(x:btnWidth01/3,y:10,width:120,height:60))
        lb_num02.textColor = con.bkcolor1
        lb_num02.adjustsFontSizeToFitWidth  = true
        lb_num02.font = UIFont.systemFontOfSize(50)
        btn_buhege.addSubview(lb_num02)
        //增加事件
        btn_buhege.addTarget(self, action: "daichuzhi_onClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        //不合格试验待填报Label
        let lb_tianbao = UILabel(frame: CGRect(x:btnWidth01/4-10,y:70,width:120,height:60))
        lb_tianbao.textColor = UIColor.blackColor()
        lb_tianbao.text = "不合格试验待填报"
        lb_tianbao.font = UIFont.systemFontOfSize(15)
        lb_tianbao.adjustsFontSizeToFitWidth  = true
        btn_buhege.addSubview(lb_tianbao)
        self.uiscrollview.addSubview(btn_buhege)
        
        
        //线
        let lb_line01 = UILabel(frame: CGRect(x:3,y:lbHegiht + 150,width:width-3,height:1))
        lb_line01.backgroundColor = con.bkcolor1
        self.uiscrollview.addSubview(lb_line01)
        
    }
    
    func daichuzhi_onClickBtn(sender: UIButton){
        print("点击了daichuzhi_onClickBtn");
    }
    
    func buhege_onClickBtn(sender: UIButton){
        print("点击了buhege_onClickBtn");
    }
    
    
    func createMenuBtn1(){
        let nvHeight = 0
        let LabelHeight = 200 + lbHegiht
        let step = 5
        //按钮宽
        let btnWidth = (width - step * 3) / 2
        
        //试验记录查询Label
        let btn_lb01 = UILabel(frame: CGRect(x: step, y: LabelHeight - 33, width: width - step - 8, height: 30))
        btn_lb01.layer.backgroundColor = con.bkcolor.CGColor
        btn_lb01.textColor = con.bkcolor1
        btn_lb01.font = UIFont.systemFontOfSize(15)
        btn_lb01.text = "   试验记录查询"
        btn_lb01.textAlignment = .Left
        btn_lb01.layer.cornerRadius = 5
        self.uiscrollview.addSubview(btn_lb01)
        //图标
        let img = UIImageView(frame: CGRect(x: width-40, y: LabelHeight - 30, width:20 , height: 20))
        img.image = UIImage(named: "wrap")
        self.uiscrollview.addSubview(img)
        
        //
        //            1
        //
        //混凝土强度1-1
        btn_hntqd = SFlatButton(frame: CGRect(x: step, y: LabelHeight + nvHeight, width: btnWidth, height: btnWidth), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        btn_hntqd.setBackgroundImage(UIImage(named:"bggreen"),forState:.Normal)
        btn_hntqd.addTarget(self, action: "btn_hntqdClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(btn_hntqd)
        //(Label)
        let lbBtn1 = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 25))
        lbBtn1.text = "混凝土强度"
        lbBtn1.textColor = UIColor.whiteColor()
        lbBtn1.font = UIFont.systemFontOfSize(15)
        btn_hntqd.addSubview(lbBtn1)
        //累计(Label)
        let lb1_1 = UILabel(frame: CGRect(x: 5, y: 35, width: 100, height: 25))
        lb1_1.text = "累计"
        lb1_1.textColor = UIColor.whiteColor()
        lb1_1.font = UIFont.systemFontOfSize(14)
        btn_hntqd.addSubview(lb1_1)
        //数据
        lb_hntqd.textColor = UIColor.whiteColor()
        lb_hntqd.font = UIFont.systemFontOfSize(50)
        //lb_hntqd.text = "723"
        btn_hntqd.addSubview(lb_hntqd)
        //条(Label)
        let lb1_2 = UILabel(frame: CGRect(x: 110, y: 100, width: 100, height: 25))
        lb1_2.text = "条"
        lb1_2.textColor = UIColor.whiteColor()
        lb1_2.font = UIFont.systemFontOfSize(15)
        btn_hntqd.addSubview(lb1_2)
        
        //
        //            2
        //
        //钢筋拉力2-1
        btn_gjll = SFlatButton(frame: CGRect(x: btnWidth + step + 5, y: LabelHeight + nvHeight, width: btnWidth, height: btnWidth), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        btn_gjll.setBackgroundImage(UIImage(named:"bgblue2"),forState:.Normal)
        btn_gjll.addTarget(self, action: "btn_gjllClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(btn_gjll)
        //(Label)
        let lbBtn2 = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 25))
        lbBtn2.text = "钢筋拉力"
        lbBtn2.textColor = UIColor.whiteColor()
        lbBtn2.font = UIFont.systemFontOfSize(15)
        btn_gjll.addSubview(lbBtn2)
        //累计(Label)
        let lb2_1 = UILabel(frame: CGRect(x: 5, y: 35, width: 100, height: 25))
        lb2_1.text = "累计"
        lb2_1.textColor = UIColor.whiteColor()
        lb2_1.font = UIFont.systemFontOfSize(14)
        btn_gjll.addSubview(lb2_1)
        //数据
        lb_gjll.textColor = UIColor.whiteColor()
        lb_gjll.font = UIFont.systemFontOfSize(50)
        //lb_gjll.text = "60"
        btn_gjll.addSubview(lb_gjll)
        //条(Label)
        let lb2_2 = UILabel(frame: CGRect(x: 110, y: 100, width: 100, height: 25))
        lb2_2.text = "条"
        lb2_2.textColor = UIColor.whiteColor()
        lb2_2.font = UIFont.systemFontOfSize(15)
        btn_gjll.addSubview(lb2_2)
        
        //
        //            3
        //
        //钢筋焊接接头3-1
        btn_gjhjjt = SFlatButton(frame: CGRect(x: step, y: LabelHeight + nvHeight + (btnWidth + step), width: btnWidth, height: btnWidth), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        btn_gjhjjt.setBackgroundImage(UIImage(named:"bgblue2"),forState:.Normal)
        btn_gjhjjt.addTarget(self, action: "btn_gjhjjtClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(btn_gjhjjt)
        //(Label)
        let lbBtn3 = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 25))
        lbBtn3.text = "钢筋焊接接头"
        lbBtn3.textColor = UIColor.whiteColor()
        lbBtn3.font = UIFont.systemFontOfSize(15)
        btn_gjhjjt.addSubview(lbBtn3)
        //累计(Label)
        let lb3_1 = UILabel(frame: CGRect(x: 5, y: 35, width: 100, height: 25))
        lb3_1.text = "累计"
        lb3_1.textColor = UIColor.whiteColor()
        lb3_1.font = UIFont.systemFontOfSize(14)
        btn_gjhjjt.addSubview(lb3_1)
        //数据
        lb_gjhjjt.textColor = UIColor.whiteColor()
        lb_gjhjjt.font = UIFont.systemFontOfSize(50)
        //lb_gjhjjt.text = "724"
        btn_gjhjjt.addSubview(lb_gjhjjt)
        //条(Label)
        let lb3_2 = UILabel(frame: CGRect(x: 110, y: 100, width: 100, height: 25))
        lb3_2.text = "条"
        lb3_2.textColor = UIColor.whiteColor()
        lb3_2.font = UIFont.systemFontOfSize(15)
        btn_gjhjjt.addSubview(lb3_2)
        
        //
        //            4
        //
        //钢筋机械连接接头2-1
        btn_gjjxljjt = SFlatButton(frame: CGRect(x: btnWidth + step + 5, y: LabelHeight + nvHeight + (btnWidth + step), width: btnWidth, height: btnWidth), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        btn_gjjxljjt.setBackgroundImage(UIImage(named:"bggreen"),forState:.Normal)
        btn_gjjxljjt.addTarget(self, action: "btn_gjjxljjtClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(btn_gjjxljjt)
        //(Label)
        let lbBtn4 = UILabel(frame: CGRect(x: 5, y: 5, width: 120, height: 25))
        lbBtn4.text = "钢筋机械连接接头"
        lbBtn4.textColor = UIColor.whiteColor()
        lbBtn4.font = UIFont.systemFontOfSize(15)
        btn_gjjxljjt.addSubview(lbBtn4)
        //累计(Label)
        let lb4_1 = UILabel(frame: CGRect(x: 5, y: 35, width: 100, height: 25))
        lb4_1.text = "累计"
        lb4_1.textColor = UIColor.whiteColor()
        lb4_1.font = UIFont.systemFontOfSize(14)
        btn_gjjxljjt.addSubview(lb4_1)
        //数据
        lb_gjjxljjt.textColor = UIColor.whiteColor()
        lb_gjjxljjt.font = UIFont.systemFontOfSize(50)
        //lb_gjjxljjt.text = "61"
        btn_gjjxljjt.addSubview(lb_gjjxljjt)
        //条(Label)
        let lb4_2 = UILabel(frame: CGRect(x: 110, y: 100, width: 100, height: 25))
        lb4_2.text = "条"
        lb4_2.textColor = UIColor.whiteColor()
        lb4_2.font = UIFont.systemFontOfSize(15)
        btn_gjjxljjt.addSubview(lb4_2)
    }
    
    func createMenuBtn2(){
        let nvHeight = 0
        let step = 5
        //按钮宽
        let btnWidth = (width - step * 3) / 2
        let LabelHeight = 200 + btnWidth*2 + 50 + lbHegiht
        
        //试验记录统计Label
        let btn_lb02 = UILabel(frame: CGRect(x:step,y:LabelHeight - 33,width:  width - step - 8, height: 30))
        btn_lb02.layer.backgroundColor = con.bkcolor.CGColor
        btn_lb02.textColor = con.bkcolor1
        btn_lb02.text = "   试验记录统计"
        btn_lb02.font = UIFont.systemFontOfSize(15)
        btn_lb02.textAlignment = .Left
        btn_lb02.layer.cornerRadius = 5
        self.uiscrollview.addSubview(btn_lb02)
        //图标
        let img = UIImageView(frame: CGRect(x: width-40, y: LabelHeight - 30, width:20 , height: 20))
        img.image = UIImage(named: "bar")
        self.uiscrollview.addSubview(img)
        
        //
        //            1
        //
        //综合统计分析1-1
        btn_zhtjfx = SFlatButton(frame: CGRect(x: step, y: LabelHeight + nvHeight, width: btnWidth, height: btnWidth), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        btn_zhtjfx.setBackgroundImage(UIImage(named:"bggreen"),forState:.Normal)
        btn_zhtjfx.addTarget(self, action: "btn_zhtjfxClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(btn_zhtjfx)
        //(Label)
        let lbBtn1 = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 25))
        lbBtn1.text = "综合统计分析"
        lbBtn1.textColor = UIColor.whiteColor()
        lbBtn1.font = UIFont.systemFontOfSize(15)
        btn_zhtjfx.addSubview(lbBtn1)
        //图片(Label)
        let img1 = UIImageView(frame: CGRect(x: btnWidth/3, y: 50, width: 70, height: 70))
        img1.image = UIImage(named: "arraw2")
        btn_zhtjfx.addSubview(img1)
        
        //
        //            2
        //
        //不合格处理2-1
        btn_bhgcl = SFlatButton(frame: CGRect(x: btnWidth + step + 5, y: LabelHeight + nvHeight, width: btnWidth, height: btnWidth), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        btn_bhgcl.setBackgroundImage(UIImage(named:"bgred"),forState:.Normal)
        btn_bhgcl.addTarget(self, action: "btn_bhgclClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(btn_bhgcl)
        //(Label)
        let lbBtn2 = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 25))
        lbBtn2.text = "不合格处理"
        lbBtn2.textColor = UIColor.whiteColor()
        lbBtn2.font = UIFont.systemFontOfSize(15)
        btn_bhgcl.addSubview(lbBtn2)
        //图片(Label)
        let img2 = UIImageView(frame: CGRect(x: btnWidth/3, y: 50, width: 70, height: 70))
        img2.image = UIImage(named: "alert2")
        btn_bhgcl.addSubview(img2)
        //权限icon
        img_buhege = UIImageView(frame: CGRect(x: btnWidth - 40, y: 20, width: 30, height: 30))
        if(con.syschaobiaoReal == false)
        {
            img_buhege.image = UIImage(named: "lock")
            btn_bhgcl.addSubview(img_buhege)
            btn_bhgcl.enabled = false
        }
    }
    
    //混凝土强度
    func btn_hntqdClickBtn(sender: UIButton){
        let sub: SY_HntqdVC = SY_HntqdVC(nibName: "SY_HntqdVC", bundle: nil)
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //钢筋拉力
    func btn_gjllClickBtn(sender: UIButton){
        let sub: SY_GjVC = SY_GjVC(nibName: "SY_GjVC", bundle: nil)
        sub.titleVC = "钢筋拉力"
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //钢筋焊接接头
    func btn_gjhjjtClickBtn(sender: UIButton){
        let sub: SY_GjVC = SY_GjVC(nibName: "SY_GjVC", bundle: nil)
        sub.titleVC = "钢筋焊接接头"
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //钢筋机械连接接头
    func btn_gjjxljjtClickBtn(sender: UIButton){
        let sub: SY_GjVC = SY_GjVC(nibName: "SY_GjVC", bundle: nil)
        sub.titleVC = "钢筋机械连接接头"
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //综合统计分析
    func btn_zhtjfxClickBtn(sender: UIButton){
        let sub: SY_Zhtf = SY_Zhtf(nibName: "SY_HntqdVC", bundle: nil)
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //不合格处理
    func btn_bhgclClickBtn(sender: UIButton){
        let sub: SY_BhgclVC = SY_BhgclVC(nibName: "SY_BhgclVC", bundle: nil)
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    func getJsonData(){
        print(url + userGroupId + con.departId_SY_sel)
        Alamofire.request(.GET, url + userGroupId + con.departId_SY_sel).responseJSON{ response in
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    self.lb_num01.text = (JSON.valueForKey("data"))!.valueForKey("waitWTcount")! as! String
                    self.lb_num02.text = (JSON.valueForKey("data"))!.valueForKey("waitRealcount")! as! String
//                    let LabelAnimation01 = NumberAnimation(label: self.lb_num01, TotheValue: self.lb_num01.text!)
//                    let LabelAnimation02 = NumberAnimation(label: self.lb_num02, TotheValue: self.lb_num02.text!)
                    self.lb_hntqd.text = (JSON.valueForKey("data"))!.valueForKey("hntkangyacount")! as! String
                    self.lb_gjll.text = (JSON.valueForKey("data"))!.valueForKey("gangjincount")! as! String
                    self.lb_gjhjjt.text = (JSON.valueForKey("data"))!.valueForKey("gangjinhanjiejietoucount")! as! String
                    self.lb_gjjxljjt.text = (JSON.valueForKey("data"))!.valueForKey("gangjinlianjiejietoucount")! as! String
                }
            }
        }
    }
    
}
