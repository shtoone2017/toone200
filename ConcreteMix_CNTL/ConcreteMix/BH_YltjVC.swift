//
//  BH_YltjVC.swift
//  ConcreteMix
//
//  Created by user on 15/10/5.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit
import Alamofire

class BH_YltjVC: UIViewController, UITableViewDataSource, UITableViewDelegate,SheBeiSelectDelegate,GroupIDSelectDelegate{

    //组织机构ID
    var GroupId = ""
    //设备ID
    var SheBei = "-1"
    
    var a = 0
    var btnLeft:Int = 5
    var btnTop:Int = 10
    var step:Int = 10
    var btnWidth:Int = 90
    var btnWidthDate:Int = 110
    
    var uiscrollview: UIScrollView!

    var dateFrom:UIButton!
    var dateTo:UIButton!
    var search:SFlatButton!
    var lb_project:UILabel!
    var tableview:UITableView!
    var btnDevice:SFlatButton!
    //日期控件
    let date = NSDate()
    let formatter:NSDateFormatter = NSDateFormatter()
    var datetime = ""
    //柱状图
    var cailiaoBar:SSBarPlus!
    var wuchaBar:SSBarPlus!
    var lb:UILabel!
    
    //Json Url & 参数 Begin##############################################################################################################################
    var url = con.AppHntMaterialURL
    var departId = "departId="
    var startTime = "&startTime="
    var endTime = "&endTime="
    var shebeibianhao = "&shebeibianhao="
    var gongchengmincheng = "&gongchengmincheng"
    var jiaozhubuwei = "&jiaozhubuwei"
    var qiangdudengji = "&qiangdudengji"
    //Json Url & 参数 End################################################################################################################################
    
    //数据接收部 Begin+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var ShiYan_Mac_Id:String = ""
    var array_nm:[String] = []
    var array_sj:[String] = []
    var array_ll:[String] = []
    var array_wc:[String] = []
    var array_wp:[String] = []
    var array_jt:[String] = []
    //数据接收部 End+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "拌和站与试验室信息管理"
        let item = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.view.backgroundColor = UIColor.whiteColor()
        
        //scrollview
        uiscrollview = UIScrollView(frame: CGRect(x: 5, y: con.yValue + 60, width: con.width-10, height: con.height))
        uiscrollview.contentSize = CGSize(width: con.width - 10, height: con.height + 1000)
        uiscrollview.layer.cornerRadius = 15
        uiscrollview.backgroundColor = con.bkcolor
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(uiscrollview)

        //组织机构
        CreateTitle()
        //选择设备
        CreateBtn_ShiYan()
        //创建日期控件
        createDate()
        //创建TableView
        createTableView()
        
        //加载数据
        getJsonData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CreateTitle(){
        //组织机构
        let lb_title:UILabel = UILabel(frame: CGRect(x: 0, y: 65, width: self.view.frame.width, height: 60))
        lb_title.backgroundColor = con.bkcolor1
        self.view.addSubview(lb_title)
        
        lb_project = UILabel(frame: CGRect(x: 5, y: 65 + 18, width: con.width - 60, height: 30))
        lb_project.textColor = UIColor.whiteColor()
        lb_project.text = con.departName_BH_sel + ">拌和站管理>材料用量核算"
        lb_project.adjustsFontSizeToFitWidth  = true
        lb_project.font = UIFont.systemFontOfSize(17)
        lb_project.adjustsFontSizeToFitWidth = true
        self.view.addSubview(lb_project)
        
        //添加label事件(组织机构)
        if(con.type == "GL"){
            let img01 = UIImageView(frame: CGRect(x: con.width-40, y: 65 + 18, width:30 , height: 30))
            img01.image = UIImage(named: "plot")
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_SY_JGVC:")
            img01.userInteractionEnabled = true
            img01.addGestureRecognizer(tap)
            self.view.addSubview(img01)
        }
    }
    
    //组织机构
    func btn_SY_JGVC(sender: AnyObject){
        let sub: SY_JGVC = SY_JGVC(nibName: "SY_JGVC", bundle: nil)
        sub.delegate = self
        sub.IGroupID = con.departId
        sub.IFuntype = "1" //1.水泥混凝土
        sub.IType = con.userRole
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //委托函数实现
    func GroupIDSelect(GroupID:String,GroupName:String, ctl:SY_JGVC){
        print(GroupID)
        con.departId_BH_sel = GroupID
        con.departName_BH_sel = GroupName
        lb_project.text = con.departName_BH_sel + ">拌和站管理>材料用量核算"
        //清空设备列表
        btnDevice.setTitle("  选择设备", forState:UIControlState.Normal)
        //加载数据
        getJsonData()
    }
    
    func CreateBtn_ShiYan(){
        btnDevice = SFlatButton(frame:CGRect(x:btnLeft,y: btnTop,width:295,height:30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel);
        btnDevice.setTitleColor(UIColor.whiteColor(),forState: .Normal)
        btnDevice.setTitle("  选择设备", forState:UIControlState.Normal)
        btnDevice.titleLabel?.font = UIFont.systemFontOfSize(13)
        btnDevice.titleLabel?.adjustsFontSizeToFitWidth = true
        btnDevice.backgroundColor = con.blueMore
        btnDevice.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        //图标
        let img = UIImageView(frame: CGRect(x: 265, y: 5, width:20 , height: 20))
        img.image = UIImage(named: "square")
        btnDevice.addSubview(img)
        btnDevice.addTarget(self, action: "ShiYan_onClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(btnDevice)
    }
    
    func ShiYan_onClickBtn(sender: UIButton){
        print("点击了ShiYan_onClickBtn=\(sender.tag)");
        let sub: SY_SbList = SY_SbList(nibName: "SY_SbList", bundle: nil)
        sub.GroupId = con.departId_BH_sel
        sub.type = "1"//水泥
        sub.delegate = self
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //委托函数实现
    func SheBeiSelect(SheBei:String, SheBeiName:String, ctl:SY_SbList){
        print(SheBei)
        self.SheBei = SheBei
        btnDevice.setTitle(SheBeiName, forState:UIControlState.Normal)
        getJsonData()
    }
    
    func createDate(){
        //From
        dateFrom = SFlatButton(frame: CGRect(x: btnLeft, y: btnTop * 5, width:btnWidthDate, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        dateFrom.backgroundColor = con.blueMore
        dateFrom.setTitleColor(UIColor.whiteColor(),forState: .Normal)
        dateFrom.titleLabel?.font = UIFont.systemFontOfSize(13)
        dateFrom.titleLabel?.adjustsFontSizeToFitWidth = true
        dateFrom.addTarget(self, action: "dateForm_onClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        dateFrom.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.uiscrollview.addSubview(dateFrom)
        //图标
        let imgFrom = UIImageView(frame: CGRect(x: btnWidthDate-25, y: 5, width:20 , height: 20))
        imgFrom.image = UIImage(named: "Calendar")
        dateFrom.addSubview(imgFrom)
        //To
        dateTo = SFlatButton(frame: CGRect(x: btnLeft + 10 + btnWidthDate, y: btnTop * 5, width:btnWidthDate, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        dateTo.backgroundColor = con.blueMore
        dateTo.setTitleColor(UIColor.whiteColor(),forState: .Normal)
        dateTo.titleLabel?.font = UIFont.systemFontOfSize(13)
        dateTo.titleLabel?.adjustsFontSizeToFitWidth = true
        dateTo.addTarget(self, action: "dateTo_onClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        dateTo.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.uiscrollview.addSubview(dateTo)
        //图标
        let imgTo = UIImageView(frame: CGRect(x: btnWidthDate-25, y: 5, width:20 , height: 20))
        imgTo.image = UIImage(named: "Calendar")
        dateTo.addSubview(imgTo)
        //查询
        search = SFlatButton(frame: CGRect(x: btnLeft + 15 + btnWidthDate*2, y: btnTop * 5, width:60, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        search.backgroundColor = con.bkcolor1
        search.setTitleColor(UIColor.whiteColor(),forState: .Normal)
        search.setTitle("查 询", forState:UIControlState.Normal)
        search.titleLabel?.font = UIFont.systemFontOfSize(13)
        search.titleLabel?.adjustsFontSizeToFitWidth = true
        search.addTarget(self, action: "search_onClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(search)
        
        formatter.dateFormat = "yyyy-MM-dd"
        datetime = formatter.stringFromDate(date)
        dateTo.setTitle("  " + datetime, forState:UIControlState.Normal )
        let a_month:NSTimeInterval  = 24*60*60*30*3
        let datefrom:NSDate = NSDate(timeInterval: -a_month, sinceDate: date)
        datetime = formatter.stringFromDate(datefrom)
        dateFrom.setTitle("  " + datetime, forState:UIControlState.Normal )
    }
    
    func dateForm_onClickBtn(sender: UIButton){
        print("点击了dateForm_onClickBtn");
        DatePickerDialog().show("DatePickerDialog", doneButtonTitle: "确定", cancelButtonTitle: "取消", datePickerMode: .Date) {
            (date) -> Void in
            self.dateFrom.setTitle("  " + "\(date)", forState:UIControlState.Normal )
        }
        
    }
    
    func dateTo_onClickBtn(sender: UIButton){
        print("点击了dateTo_onClickBtn");
        DatePickerDialog().show("DatePickerDialog", doneButtonTitle: "确定", cancelButtonTitle: "取消", datePickerMode: .Date) {
            (date) -> Void in
            self.dateTo.setTitle("  " + "\(date)", forState:UIControlState.Normal )
        }
    }
    
    func search_onClickBtn(sender: UIButton){
        print("点击了search_onClickBtn");
        getJsonData()
    }
    
    func createTableView(){
        tableview = UITableView(frame: CGRect(x: 5, y: btnTop * 8 + 565, width: con.width-20, height: con.height - btnTop * 4 - 50))
        tableview.backgroundColor = con.bkcolor
        tableview.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.uiscrollview.addSubview(tableview)
    }
    
    func createBar_cailiao(){
        if(cailiaoBar != nil)
        {
            cailiaoBar.removeFromSuperview()
            lb.removeFromSuperview()
        }
        
        lb = UILabel(frame: CGRect(x: con.width/2-100, y: btnTop * 8 + 5, width: 200, height: 20))
        lb.text = "材料成本核算(单位:kg)"
        lb.textColor = con.blueMore
        lb.font = UIFont.systemFontOfSize(13)
        
        //array_dianwei = ["砂1","砂2","碎石1","碎石2","水泥1","水泥2","矿粉1","矿粉2","石料6","石料7","水"]
        //array_dianweiValue = ["100","80","50","150","90","70","30","100","80","50","150"]
        cailiaoBar = SSBarPlus(frame: CGRect(x:0,y:btnTop * 8 + 20 + 5,width:con.width,height:250), arry_nm:self.array_nm, arry_vl: self.array_sj, title:"")
        cailiaoBar.backgroundColor = con.bkcolor
        cailiaoBar.dispalyflg = 1
        self.uiscrollview.addSubview(lb)
        self.uiscrollview.addSubview(cailiaoBar)
    }
    
    func createBar_wucha(){
        if(wuchaBar != nil)
        {
            wuchaBar.removeFromSuperview()
            lb.removeFromSuperview()
        }
        
        lb = UILabel(frame: CGRect(x: con.width/2-100, y: btnTop * 8 + 5 + 270, width: 200, height: 20))
        lb.text = "误差百分比(单位:kg)"
        lb.textColor = con.blueMore
        lb.font = UIFont.systemFontOfSize(13)

        wuchaBar = SSBarPlus(frame: CGRect(x:0,y:btnTop * 8 + 20 + 5 + 270,width:con.width,height:250), arry_nm:self.array_nm, arry_vl: self.array_wc, title:"")
        wuchaBar.backgroundColor = con.bkcolor
         self.uiscrollview.addSubview(lb)
        wuchaBar.dispalyflg = 1
        self.uiscrollview.addSubview(wuchaBar)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_sj.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell1") as UITableViewCell!
        if (cell == nil) {
            let nibs:NSArray = NSBundle.mainBundle().loadNibNamed("BH_YltjCell", owner: self, options: nil)
            cell = nibs.lastObject as! BH_YltjCell
            
            let lb1  = cell!.viewWithTag(1) as! UILabel
            let lb2  = cell!.viewWithTag(2) as! UILabel
            let lb3  = cell!.viewWithTag(3) as! UILabel
            let lb4  = cell!.viewWithTag(4) as! UILabel
            
            lb1.text  = array_nm[indexPath.row]
            lb2.text  = array_sj[indexPath.row]
            lb3.text  = array_ll[indexPath.row]
            lb4.text  = array_wc[indexPath.row]
        }
        cell!.layer.cornerRadius = 10
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func getJsonData(){
        SVProgressHUD.show()
        
        let long_starttime = con.getLongTime(dateFrom.titleLabel!.text!,flg:0)
        let long_endtime = con.getLongTime(dateTo.titleLabel!.text!,flg:1)
        let sttime = startTime + String(long_starttime)
        let ettime = endTime + String(long_endtime)

        self.array_nm = []
        self.array_sj = []
        self.array_ll = []
        self.array_wc = []
        self.array_wp = []
        self.array_jt = []
        
        var requestUrl = ""
        //全部设备
        requestUrl = url + departId + con.departId_BH_sel + sttime + ettime
        //全部设备
        if(SheBei != "-1")
        {
            requestUrl = requestUrl + shebeibianhao + SheBei
        }
        
        print(requestUrl)
        Alamofire.request(.GET, requestUrl).responseJSON{ response in
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    //材料名，实际，理论，误差，误差百分比
                    var flg:String?
                    var nm:String?
                    var sj:String?
                    var ll:String?
                    var wc:String
                    var wp:String
                    for(var i:Int=0; i<con.array_title_sj.count; i++){
                        
                        flg = (JSON.valueForKey("hntbhzisShow"))!.valueForKey(con.array_title_sj[i]) as? String
                        nm = (JSON.valueForKey("hbfield"))!.valueForKey(con.array_title_sj[i]) as? String
                        sj = (JSON.valueForKey("data"))!.valueForKey(con.array_title_sj[i]) as? String
                        ll = (JSON.valueForKey("data"))!.valueForKey(con.array_title_ll[i]) as? String

                        if(sj != nil)
                        {
                            //不显示
                            if(flg! == "0")
                            {
                                continue
                            }
                            self.array_nm.append(nm!)
                            self.array_sj.append(sj!)
                            self.array_ll.append(ll!)
                            
                            let sj_float:Float = (sj! as NSString).floatValue
                            let ll_float:Float = (ll! as NSString).floatValue
                            //误差
                            let wc_float = sj_float - ll_float
                            //误差百分比
                            var wp_float:Float = 0.00
                            if(ll_float != 0)
                            {
                                wp_float = wc_float/ll_float * 100
                            }
                            wc = String(format: "%.2f", wc_float)
                            wp = String(format: "%.2f", wp_float)
                            self.array_wc.append(wc)
                            self.array_wp.append(wp)
                            
                            //箭头
                            if(wc_float > 0)
                            {
                                self.array_jt.append("↑")
                            }
                            else if (wc_float < 0)
                            {
                                self.array_jt.append("↓")
                            }
                            else
                            {
                                self.array_jt.append("")
                            }
                        }
                    }
                    self.tableview.reloadData()
                    self.createBar_cailiao()
                    self.createBar_wucha()
                }
            }
            SVProgressHUD.dismiss()
        }
    }

    
}
