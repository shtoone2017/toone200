//
//  HN_MenuView.swift
//  ConcreteMix
//
//  Created by user on 15/9/30.
//  Copyright © 2015年 shtoone. All rights reserved.
//
import QuartzCore
import UIKit
import Alamofire

class BH_MenuVC: UIViewController {
    
    @IBOutlet weak var barBtn: UITabBarItem!
    var shiyanCircle:CircleShowView!
    var uiscrollview: UIScrollView!
    
    //待处置警报
    var lb_num01:UILabel!
    //累计处置
    var lb_num02:UILabel!
    //数字(率)
    var lb_num03:UILabel!
    
    //累计盘数
    var lb_LeiJiPanShu: UILabel!
    //处置率
    var lb_ChuZhiLv: UILabel!
    //权限icon
    var img_chuzhi: UIImageView!
    var img_shenpi: UIImageView!
    
    let lbHegiht = 120
    
    //button
    var btn_shiyan: SFlatButton!
    var btn_scsjcx: SFlatButton!
    var btn_bhjzt: SFlatButton!
    //日盘数
    var lb_daypansu: UILabel = UILabel(frame: CGRect(x: 65, y: 55, width: 100, height: 20))
    //累计盘数
    var lb_leijipansu: UILabel = UILabel(frame: CGRect(x: 65, y: 95, width: 100, height: 20))
    var lb_dczbj = UILabel(frame: CGRect(x: 20, y: 60, width: 100, height: 60))
    
    //button
    var btn_zhtjfx: SFlatButton!
    var btn_clylhs: SFlatButton!
    //屏幕宽度,高度
    var width:Int!
    var height:Int!
    
    //Json Url & 参数 Begin##############################################################################################################################
    var url = con.hntMainLogoURL
    var userGroupId   = "userGroupId="
    //Json Url & 参数 End################################################################################################################################
    
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
        //let btnWidth = (width) / 5
        let btnWidth01 = width / 2
        
        //您的代办事项Label
        let lb_title = UILabel(frame: CGRect(x:width/3 ,y:lbHegiht,width:width/3,height:40))
        lb_title.textColor = UIColor.blackColor()
        lb_title.text = "您的代办事项"
        lb_title.font = UIFont.systemFontOfSize(18)
        lb_title.adjustsFontSizeToFitWidth  = true
        self.uiscrollview.addSubview(lb_title)
        
        //按钮
        btn_shiyan = SFlatButton(frame: CGRect(x: 50, y: lbHegiht + 30, width: width, height: btnWidth01-48),sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        //btn_shiyan.backgroundColor = UIColor.grayColor()
        //数字(报警)
        lb_num01 = UILabel(frame: CGRect(x:10,y:10,width:120,height:60))
        lb_num01.textColor = con.btnOrange
        lb_num01.adjustsFontSizeToFitWidth  = true
        lb_num01.font = UIFont.systemFontOfSize(28)
        btn_shiyan.addSubview(lb_num01)
        //数字(累计)
        lb_num02 = UILabel(frame: CGRect(x:width/4,y:10,width:120,height:60))
        lb_num02.textColor = con.bkcolor1
        lb_num02.adjustsFontSizeToFitWidth  = true
        lb_num02.font = UIFont.systemFontOfSize(28)
        btn_shiyan.addSubview(lb_num02)
        //数字(率)
        lb_num03 = UILabel(frame: CGRect(x:width/2,y:10,width:120,height:60))
        lb_num03.textColor = con.bkcolor1
        lb_num03.adjustsFontSizeToFitWidth  = true
        lb_num03.font = UIFont.systemFontOfSize(28)
        btn_shiyan.addSubview(lb_num03)
        //线
        let lb_line01 = UILabel(frame: CGRect(x:3,y:lbHegiht + 90,width:width-3,height:1))
        lb_line01.backgroundColor = con.bkcolor1
        self.uiscrollview.addSubview(lb_line01)
        //待处置警报(label)
        let lb_num01_msg = UILabel(frame: CGRect(x:10,y:50,width:120,height:60))
        lb_num01_msg.textColor = UIColor.blackColor()
        lb_num01_msg.text = "待处置警报"
        lb_num01_msg.adjustsFontSizeToFitWidth  = true
        lb_num01_msg.font = UIFont.systemFontOfSize(13)
        btn_shiyan.addSubview(lb_num01_msg)
        //累计处置(label)
        let lb_num02_msg = UILabel(frame: CGRect(x:width/4,y:50,width:120,height:60))
        lb_num02_msg.textColor = UIColor.blackColor()
        lb_num02_msg.text = "  累计处置"
        lb_num02_msg.adjustsFontSizeToFitWidth  = true
        lb_num02_msg.font = UIFont.systemFontOfSize(13)
        btn_shiyan.addSubview(lb_num02_msg)
        //处置率(label)
        let lb_num03_msg = UILabel(frame: CGRect(x:width/2,y:50,width:120,height:60))
        lb_num03_msg.textColor = UIColor.blackColor()
        lb_num03_msg.text = "  处置率"
        lb_num03_msg.adjustsFontSizeToFitWidth  = true
        lb_num03_msg.font = UIFont.systemFontOfSize(13)
        btn_shiyan.addSubview(lb_num03_msg)
        //增加事件
        btn_shiyan.addTarget(self, action: "daichuzhi_onClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        //待处置委托试验Label
        
        self.uiscrollview.addSubview(btn_shiyan)
        
    }
    
    func daichuzhi_onClickBtn(sender: UIButton){
        print("点击了daichuzhi_onClickBtn");
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
        btn_lb01.text = "   生产管理"
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
        //生产数据查询1-1
        btn_scsjcx = SFlatButton(frame: CGRect(x: step, y: LabelHeight + nvHeight, width: btnWidth, height: btnWidth), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        btn_scsjcx.setBackgroundImage(UIImage(named:"bggreen"),forState:.Normal)
        btn_scsjcx.addTarget(self, action: "btn_scsjcxClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(btn_scsjcx)
        //(Label)
        let lbBtn1 = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 25))
        lbBtn1.text = "生产数据查询"
        lbBtn1.textColor = UIColor.whiteColor()
        lbBtn1.font = UIFont.systemFontOfSize(15)
        btn_scsjcx.addSubview(lbBtn1)
        //昨日(Label)
        let lb1_1 = UILabel(frame: CGRect(x: 15, y: 35, width: 100, height: 20))
        lb1_1.text = "今日："
        lb1_1.textColor = UIColor.whiteColor()
        lb1_1.font = UIFont.systemFontOfSize(13)
        btn_scsjcx.addSubview(lb1_1)
        //盘(Label)
        let lb1_11 = UILabel(frame: CGRect(x: 125, y: 65, width: 100, height: 25))
        lb1_11.text = "盘"
        lb1_11.textColor = UIColor.whiteColor()
        lb1_11.font = UIFont.systemFontOfSize(13)
        btn_scsjcx.addSubview(lb1_11)
        //数据1(昨日)
        lb_daypansu.textColor = UIColor.whiteColor()
        lb_daypansu.font = UIFont.systemFontOfSize(25)
        btn_scsjcx.addSubview(lb_daypansu)
        //累计(Label)
        let lb1_2 = UILabel(frame: CGRect(x: 15, y: 85, width: 100, height: 20))
        lb1_2.text = "累计："
        lb1_2.textColor = UIColor.whiteColor()
        lb1_2.font = UIFont.systemFontOfSize(13)
        btn_scsjcx.addSubview(lb1_2)
        //数据2(累计)
        lb_leijipansu.textColor = UIColor.whiteColor()
        lb_leijipansu.font = UIFont.systemFontOfSize(25)
        btn_scsjcx.addSubview(lb_leijipansu)
        //盘(Label)
        let lb1_12 = UILabel(frame: CGRect(x: 125, y: 115, width: 100, height: 25))
        lb1_12.text = "盘"
        lb1_12.textColor = UIColor.whiteColor()
        lb1_12.font = UIFont.systemFontOfSize(13)
        btn_scsjcx.addSubview(lb1_12)
        
        //
        //            2
        //
        //超标处置2-1
        btn_bhjzt = SFlatButton(frame: CGRect(x: btnWidth + step + 5, y: LabelHeight + nvHeight, width: btnWidth, height: btnWidth), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        btn_bhjzt.setBackgroundImage(UIImage(named:"bgblue2"),forState:.Normal)
        btn_bhjzt.addTarget(self, action: "btn_bhjztClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(btn_bhjzt)
        //(Label)
        let lbBtn2 = UILabel(frame: CGRect(x: 5, y: 5, width: 120, height: 25))
        lbBtn2.text = "超标处置与查询"
        lbBtn2.textColor = UIColor.whiteColor()
        lbBtn2.font = UIFont.systemFontOfSize(15)
        btn_bhjzt.addSubview(lbBtn2)
        //累计(Label)
        let lb2_1 = UILabel(frame: CGRect(x: 5, y: 35, width: 100, height: 25))
        lb2_1.text = "累计"
        lb2_1.textColor = UIColor.whiteColor()
        lb2_1.font = UIFont.systemFontOfSize(14)
        lbBtn2.addSubview(lb2_1)
        //数据
        lb_dczbj.textColor = UIColor.whiteColor()
        lb_dczbj.font = UIFont.systemFontOfSize(50)
        lbBtn2.addSubview(lb_dczbj)
        //条(Label)
        let lb2_2 = UILabel(frame: CGRect(x: 110, y: 100, width: 100, height: 25))
        lb2_2.text = "条"
        lb2_2.textColor = UIColor.whiteColor()
        lb2_2.font = UIFont.systemFontOfSize(15)
        lbBtn2.addSubview(lb2_2)
        //权限icon
        img_chuzhi = UIImageView(frame: CGRect(x: btnWidth - 40, y: 20, width: 30, height: 30))
        //超标处置和审批都没有权限时
        if((con.hntchaobiaoReal == false) && (con.hntchaobiaoSp == false))
        {
            img_chuzhi.image = UIImage(named: "lock")
            btn_bhjzt.addSubview(img_chuzhi)
            btn_bhjzt.enabled = false
        }
    }
    
    
    func createMenuBtn2(){
        let nvHeight = 0
        let step = 5
        //按钮宽
        let btnWidth = (width - step * 3) / 2
        let LabelHeight = 200 + btnWidth + 40  + lbHegiht
        
        //试验记录统计Label
        let btn_lb02 = UILabel(frame: CGRect(x:step,y:LabelHeight - 33,width:  width - step - 8, height: 30))
        btn_lb02.layer.backgroundColor = con.bkcolor.CGColor
        btn_lb02.textColor = con.bkcolor1
        btn_lb02.text = "   统计分析"
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
        //材料用量核算2-1
        btn_clylhs = SFlatButton(frame: CGRect(x: btnWidth + step + 5, y: LabelHeight + nvHeight, width: btnWidth, height: btnWidth), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        btn_clylhs.setBackgroundImage(UIImage(named:"bgblack"),forState:.Normal)
        btn_clylhs.addTarget(self, action: "btn_clylhsClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(btn_clylhs)
        //(Label)
        let lbBtn2 = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 25))
        lbBtn2.text = "材料用量核算"
        lbBtn2.textColor = UIColor.whiteColor()
        lbBtn2.font = UIFont.systemFontOfSize(15)
        btn_clylhs.addSubview(lbBtn2)
        //图片(Label)
        let img2 = UIImageView(frame: CGRect(x: btnWidth/3, y: 50, width: 70, height: 70))
        img2.image = UIImage(named: "linechart")
        btn_clylhs.addSubview(img2)
    }
    
    //生产数据查询
    func btn_scsjcxClickBtn(sender: UIButton){
        let sub: BH_SjcxVC = BH_SjcxVC(nibName: "BH_SjcxVC", bundle: nil)
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //超标处置与查询
    func btn_bhjztClickBtn(sender: UIButton){
        let sub: BH_CbczVC = BH_CbczVC(nibName: "BH_CbczVC", bundle: nil)
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //综合统计分析
    func btn_zhtjfxClickBtn(sender: UIButton){
        let sub: BH_Zhtf = BH_Zhtf(nibName: "BH_Zhtf", bundle: nil)
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //材料用量核算
    func btn_clylhsClickBtn(sender: UIButton){
        let sub: BH_YltjVC = BH_YltjVC(nibName: "BH_YltjVC", bundle: nil)
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    func getJsonData(){
        print(url + userGroupId + con.departId_BH_sel)
        Alamofire.request(.GET, url + userGroupId + con.departId_BH_sel).responseJSON{ response in
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    self.lb_num01.text = (JSON.valueForKey("data"))!.valueForKey("waitRealCount")! as! String
                    self.lb_num02.text = (JSON.valueForKey("data"))!.valueForKey("chaobiaoRealCount")! as! String
                    self.lb_num03.text = (JSON.valueForKey("data"))!.valueForKey("realPer")! as! String + " %"
//                    let LabelAnimation01 = NumberAnimation(label: self.lb_num01, TotheValue: self.lb_num01.text!)
//                    let LabelAnimation02 = NumberAnimation(label: self.lb_num02, TotheValue: self.lb_num02.text!)
                    self.lb_daypansu.text = (JSON.valueForKey("data"))!.valueForKey("todayCount")! as! String
                    self.lb_leijipansu.text = (JSON.valueForKey("data"))!.valueForKey("leijiCount")! as! String
                    self.lb_dczbj.text = (JSON.valueForKey("data"))!.valueForKey("leijiRealCount")! as! String
                }
            }
        }
    }
}