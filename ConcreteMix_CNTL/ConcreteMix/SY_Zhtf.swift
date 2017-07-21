//
//  SY_Zhtf.swift
//  ConcreteMix
//
//  Created by user on 15/11/23.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit
import Alamofire

class SY_Zhtf: UIViewController, UITableViewDataSource, UITableViewDelegate,GroupIDSelectDelegate {

    //组织机构ID
    var GroupId = ""
    //步长
    var n:Int = 6
    var hege = "1"//1:次数 0:不合格
    
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
    
    //日期控件
    let date = NSDate()
    let formatter:NSDateFormatter = NSDateFormatter()
    var datetime = ""
    //柱状图
    var cailiaoBar:SSBarPlus!
    var lb: UILabel!
    var array_dianwei:[String] = []
    var array_dianweiValue:[String] = []
    //button
    var HeGe:SFlatButton!
    var BuHeGe:SFlatButton!
    
    //Json Url & 参数 Begin##############################################################################################################################
    var url = con.sysCountAnalyzeURL
    var userGroupId = "userGroupId="
    var startTime = "&startTime="
    var endTime = "&endTime="
    //Json Url & 参数 End################################################################################################################################
    
    //数据接收部 Begin+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var array:[String] = []
    var array_nm:[String] = []
    var array_cs:[String] = []
    var array_hg:[String] = []
    //数据接收部 End+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "拌和站与试验室信息管理"
        let item = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.view.backgroundColor = UIColor.whiteColor()
        
        //scrollview
        uiscrollview = UIScrollView(frame: CGRect(x: 5, y: con.yValue + 60, width: con.width-10, height: con.height))
        uiscrollview.contentSize = CGSize(width: con.width - 10, height: con.height)
        uiscrollview.layer.cornerRadius = 15
        uiscrollview.backgroundColor = con.bkcolor
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(uiscrollview)
        
        //组织机构
        CreateTitle()
        //创建日期控件
        createDate()
        //创建按钮
        createBtn()
        
        //创建TableView
        createTableView()
        //创建TableView的标题
        createTableViewTitle()
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
        lb_project.text = con.departName_SY_sel + ">试验室管理>综合统分"
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
        sub.IFuntype = "3" //3.试验室
        sub.IType = con.userRole
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //委托函数实现
    func GroupIDSelect(GroupID:String,GroupName:String, ctl:SY_JGVC){
        print(GroupID)
        con.departId_SY_sel = GroupID
        con.departName_SY_sel = GroupName
        lb_project.text = con.departName_SY_sel + ">试验室管理>综合统分"
        getJsonData()
    }
    
    func createDate(){
        //From
        dateFrom = SFlatButton(frame: CGRect(x: btnLeft, y: btnTop, width:btnWidthDate, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
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
        dateTo = SFlatButton(frame: CGRect(x: btnLeft + 10 + btnWidthDate, y: btnTop, width:btnWidthDate, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
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
        search = SFlatButton(frame: CGRect(x: btnLeft + 15 + btnWidthDate*2, y: btnTop, width:60, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
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
    
    func createBtn(){
        //合格
        HeGe = SFlatButton(frame: CGRect(x: btnWidth, y: btnTop + 50, width:btnWidth, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        HeGe.backgroundColor = con.bkcolor1
        HeGe.setTitleColor(UIColor.whiteColor(),forState: .Normal)
        HeGe.setTitle("按试验次数", forState:UIControlState.Normal)
        HeGe.titleLabel?.font = UIFont.systemFontOfSize(13)
        HeGe.titleLabel?.adjustsFontSizeToFitWidth = true
        HeGe.addTarget(self, action: "HeGe_onClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(HeGe)
        //不合格
        BuHeGe = SFlatButton(frame: CGRect(x: btnWidth*2, y: btnTop + 50, width: btnWidth, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        BuHeGe.backgroundColor = con.blueMore
        BuHeGe.setTitleColor(UIColor.whiteColor(),forState: .Normal)
        BuHeGe.setTitle("按不合格数", forState:UIControlState.Normal)
        BuHeGe.titleLabel?.font = UIFont.systemFontOfSize(13)
        BuHeGe.titleLabel?.adjustsFontSizeToFitWidth = true
        BuHeGe.addTarget(self, action: "BuHeGe_onClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(BuHeGe)
    }
    
    func setBtnColor(){
        HeGe.backgroundColor = con.bkcolor1
        BuHeGe.backgroundColor = con.blueMore
        //合格
        if(hege == "1"){
            HeGe.backgroundColor = con.bkcolor1
            BuHeGe.backgroundColor = con.blueMore
            HeGe.setTitle("按试验次数", forState:UIControlState.Normal)
            BuHeGe.setTitle("按不合格数", forState:UIControlState.Normal)
        }else{
            BuHeGe.backgroundColor = con.bkcolor1
            HeGe.backgroundColor = con.blueMore
            BuHeGe.setTitle("按不合格数", forState:UIControlState.Normal)
            HeGe.setTitle("按试验次数", forState:UIControlState.Normal)
        }
        print(hege)
    }
    
    
    func HeGe_onClickBtn(sender: UIButton){
        print("点击了HeGe_onClickBtn");
        //合格
        if(hege == "1"){
            hege = "0"//不合格
        }else{
            hege = "1"//合格
        }
        setBtnColor()
        createBar_shiyanCiShu()
    }
    
    func BuHeGe_onClickBtn(sender: UIButton){
        print("点击了BuHeGe_onClickBtn");
        //合格
        if(hege == "1"){
            hege = "0"//不合格
        }else{
            hege = "1"//合格
        }
        setBtnColor()
        createBar_shiyanBuHeGe()
    }
    
    
    func createTableView(){
        tableview = UITableView(frame: CGRect(x: 5, y: btnTop * 4 + 330 + 50, width: con.width-20, height: 150))
        tableview.backgroundColor = con.bkcolor
        tableview.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.uiscrollview.addSubview(tableview)
    }
    
    func createBar_shiyanCiShu(){
        if(cailiaoBar != nil)
        {
            cailiaoBar.removeFromSuperview()
            lb.removeFromSuperview()
        }
        lb = UILabel(frame: CGRect(x: con.width/2-100, y: btnTop * 4 + 5 + 50, width: 200, height: 20))
        lb.text = "累计试验次数"
        lb.textColor = con.blueMore
        lb.font = UIFont.systemFontOfSize(13)
        
        cailiaoBar = SSBarPlus(frame: CGRect(x:0,y:btnTop * 4 + 20 + 5 + 50,width:con.width,height:250), arry_nm:self.array_nm, arry_vl: self.array_cs, title:"")
        cailiaoBar.xStep = 30
        cailiaoBar.barWiddth = 40
        cailiaoBar.backgroundColor = con.bkcolor
        cailiaoBar.dispalyflg = 1
        self.uiscrollview.addSubview(lb)
        self.uiscrollview.addSubview(cailiaoBar)
    }
    
    func createBar_shiyanBuHeGe(){
        if(cailiaoBar != nil)
        {
            cailiaoBar.removeFromSuperview()
            lb.removeFromSuperview()
        }
        lb = UILabel(frame: CGRect(x: con.width/2-100, y: btnTop * 4 + 5 + 50, width: 200, height: 20))
        lb.text = "累计不合格次数"
        lb.textColor = con.blueMore
        lb.font = UIFont.systemFontOfSize(13)
        
        cailiaoBar = SSBarPlus(frame: CGRect(x:0,y:btnTop * 4 + 20 + 5 + 50,width:con.width,height:250), arry_nm:self.array_nm, arry_vl: self.array_hg, title:"")
        cailiaoBar.xStep = 30
        cailiaoBar.barWiddth = 40
        cailiaoBar.backgroundColor = con.bkcolor
        cailiaoBar.dispalyflg = 1
        self.uiscrollview.addSubview(lb)
        self.uiscrollview.addSubview(cailiaoBar)
    }
    
    func createTableViewTitle()
    {
        let lb01 = UILabel(frame: CGRect(x: 10, y: btnTop * 4 + 300 + 50, width: 80, height: 20))
        lb01.text = "试验种类"
        lb01.textColor = con.blueMore
        lb01.font = UIFont.systemFontOfSize(11)
        self.uiscrollview.addSubview(lb01)
        
        let lb02 = UILabel(frame: CGRect(x: 110, y: btnTop * 4 + 300 + 50, width: 40, height: 20))
        lb02.text = "次数"
        lb02.textColor = con.blueMore
        lb02.font = UIFont.systemFontOfSize(11)
        self.uiscrollview.addSubview(lb02)
        
        let lb03 = UILabel(frame: CGRect(x: 145, y: btnTop * 4 + 300 + 50, width: 40, height: 20))
        lb03.text = "合格"
        lb03.textColor = con.blueMore
        lb03.font = UIFont.systemFontOfSize(11)
        self.uiscrollview.addSubview(lb03)
        
        let lb04 = UILabel(frame: CGRect(x: 180, y: btnTop * 4 + 300 + 50, width: 40, height: 20))
        lb04.text = "有效"
        lb04.textColor = con.blueMore
        lb04.font = UIFont.systemFontOfSize(11)
        self.uiscrollview.addSubview(lb04)
        
        let lb05 = UILabel(frame: CGRect(x: 215, y: btnTop * 4 + 300 + 50, width: 40, height: 20))
        lb05.text = "不合格"
        lb05.textColor = con.blueMore
        lb05.font = UIFont.systemFontOfSize(11)
        self.uiscrollview.addSubview(lb05)
        
        let lb06 = UILabel(frame: CGRect(x: 260, y: btnTop * 4 + 300 + 50, width: 40, height: 20))
        lb06.text = "合格率"
        lb06.textColor = con.blueMore
        lb06.font = UIFont.systemFontOfSize(11)
        self.uiscrollview.addSubview(lb06)

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count/self.n
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell1") as UITableViewCell!
        if (cell == nil) {
            let nibs:NSArray = NSBundle.mainBundle().loadNibNamed("SY_ZhtfCell", owner: self, options: nil)
            cell = nibs.lastObject as! SY_ZhtfCell
            
            if(indexPath.row >= array.count/n){
                return cell
            }

            let lb1  = cell!.viewWithTag(1) as! UILabel
            let lb2  = cell!.viewWithTag(2) as! UILabel
            let lb3  = cell!.viewWithTag(3) as! UILabel
            let lb4  = cell!.viewWithTag(4) as! UILabel
            let lb5  = cell!.viewWithTag(5) as! UILabel
            let lb6  = cell!.viewWithTag(6) as! UILabel

            lb1.text = self.array[indexPath.row*n + 0]
            lb2.text = self.array[indexPath.row*n + 1]
            lb3.text = self.array[indexPath.row*n + 2]
            lb4.text = self.array[indexPath.row*n + 3]
            lb5.text = self.array[indexPath.row*n + 4]
            lb6.text = self.array[indexPath.row*n + 5] + "%"

        }
        //cell!.layer.cornerRadius = 10
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func getJsonData(){
        SVProgressHUD.show()
        
        self.array = []
        self.array_nm = []
        self.array_cs = []
        self.array_hg = []
        
        let long_starttime = con.getLongTime(dateFrom.titleLabel!.text!,flg:0)
        let long_endtime = con.getLongTime(dateTo.titleLabel!.text!,flg:1)
        let sttime = startTime + String(long_starttime)
        let ettime = endTime + String(long_endtime)
        
        print(self.url + userGroupId + con.departId_SY_sel + sttime + ettime)
        
        Alamofire.request(.GET, url + userGroupId + con.departId_SY_sel + sttime + ettime).responseJSON{ response in
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    let cnt = (JSON.valueForKey("data"))!.count
                    var nm = ""
                    for(var i:Int=0; i<cnt; i++){
                        nm = (JSON.valueForKey("data"))![i].valueForKey("testType")! as! String
                        nm = self.getTypeName(nm)
                        self.array.append(nm)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("testCount")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("qualifiedCount")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("validCount")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("notqualifiedCount")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("qualifiedPer")! as! String)
                        
                        self.array_nm.append(nm)
                        self.array_cs.append((JSON.valueForKey("data"))![i].valueForKey("testCount")! as! String)
                        self.array_hg.append((JSON.valueForKey("data"))![i].valueForKey("notqualifiedCount")! as! String)
                    }
                    if(self.hege == "1"){
                        self.createBar_shiyanCiShu()
                    }
                    else
                    {
                        self.createBar_shiyanBuHeGe()
                    }
                    self.tableview.reloadData()
                }
            }
            SVProgressHUD.dismiss()
        }
    }
    
    //设置数据
    func getTypeName(type:String)->String
    {
        switch (type)
        {
        case "100014":
            return "混凝土强度"
        case "100047":
            return "钢筋拉力"
        case "100048":
            return "钢筋焊接接头"
        default:
            return "钢筋机械连接接头"
        }
    }
}
