//
//  BH_Cbcz.swift
//  ConcreteMix
//
//  Created by user on 15/10/5.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit
import Alamofire

class BH_CbczVC: UIViewController, UITableViewDataSource, UITableViewDelegate,IGLDropDownMenuDelegate,KSRefreshViewDelegate,GroupIDSelectDelegate,SheBeiSelectDelegate {

    //组织机构ID
    var GroupId = ""
    //报警等级
    var level = ""
    //步长
    var n:Int = 6
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
    var BuChuZi:SFlatButton!
    var ChuZi:SFlatButton!
    var ShenPi:SFlatButton!
    var BuShenPi:SFlatButton!
    var tableview:UITableView!
    var lb_project:UILabel!
    var btnDevice:SFlatButton!
    var chuzi = "0"//1:已处置 0:未处置 3:已审批 2:未审批
    //日期控件
    let date = NSDate()
    let formatter:NSDateFormatter = NSDateFormatter()
    var datetime = ""
    //页码控件
    var lb_page:UILabel!
    //加算高度
    let heightStep = 40
    //实际Y值
    var yVal = 0
    
    //Json Url & 参数 Begin##############################################################################################################################
    var url = con.AppHntChaobiaoListURL
    var maxPageItems = "maxPageItems=15"
    var pageNo = "&pageNo="
    var departId = "&departId="
    var chuzhileixing = "&chuzhileixing="
    var dengji = "&dengji="
    var startTime = "&startTime="
    var endTime = "&endTime="
    var shebeibianhao = "&shebeibianhao="
    //Json Url & 参数 End################################################################################################################################
    
    //数据接收部 Begin+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var array:[String] = []
    var array_id:[String] = []
    var array_shebeibianhao:[String] = []
    //数据接收部 End+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    //页码 Begin========================================================================================================================================
    var PageCnt = 1
    func showPage(flg:String){
        if(flg == "-"){
            if(PageCnt == 1){
                PageCnt = 1
            }else{
                PageCnt = PageCnt - 1
            }
        }else{
            PageCnt = PageCnt + 1
        }
        lb_page.text = "    第\(PageCnt)页"
    }
    //页码 End==========================================================================================================================================
    
    func dropDownMenu(dropDownMenu: IGLDropDownMenu!, selectedItemAtIndex index: Int) {
        let item:IGLDropDownItem = dropDownMenu.dropDownItems[index] as! IGLDropDownItem
        print(item.text)
        level = item.text
        self.tableview.header.state = RefreshViewStateDefault
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableviewRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "拌和站与试验室信息管理"
        let item = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        //scrollview
        uiscrollview = UIScrollView(frame: CGRect(x: 5, y: con.yValue + 60, width: con.width-10, height: con.height))
        uiscrollview.layer.cornerRadius = 15
        uiscrollview.backgroundColor = con.bkcolor
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(uiscrollview)
        
        //组织机构
        yVal = 65
        CreateTitle()
        //选择设备
        yVal = btnTop
        CreateBtn_ShiYan()
        //处置和未处置按钮
        if(con.hntchaobiaoReal == true)
        {
            yVal += heightStep
            createChuZhi()
        }
        else
        {
            chuzi = "2"
        }
        //审批和未审批按钮
        if(con.hntchaobiaoSp == true)
        {
            yVal += heightStep
            createShenPi()
        }
        else
        {
             chuzi = "0"
        }
        
        //创建日期控件
        yVal += heightStep
        createDate()
        //创建TableView
        yVal += heightStep
        //页码控件
        lb_page = UILabel(frame: CGRect(x: 5, y: yVal + 10, width: 100, height: 20))
        lb_page.font = UIFont.systemFontOfSize(13)
        self.uiscrollview.addSubview(lb_page)
        createTableView()
        //创建种类
        createCatalog()
        
        //再加上一个辅助判断
        if(chuzi == "2")
        {
            BuShenPi.backgroundColor = con.bkcolor1
        }
        
        //加载list
        tableviewRefresh()

    }
    
    func tableviewRefresh(){
        //-------------------数据刷新--------------------------------------------------------------------------------------------------------------------------
        self.array = []
        self.tableview!.reloadData()
        PageCnt = 1
        self.tableview!.header = KSDefaultHeadRefreshView(delegate: self)
        self.tableview!.footer  = KSDefaultFootRefreshView(delegate: self)
        self.tableview.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.tableview.header.state = RefreshViewStateLoading
        //----------------------------------------------------------------------------------------------------------------------------------------------------
    }
    
    func createCatalog(){
        let item01 = IGLDropDownItem();
        let item02 = IGLDropDownItem();
        let item03 = IGLDropDownItem();
        let item04 = IGLDropDownItem();
        
        item01.text = "全部"
        item02.text = "初级"
        item03.text = "中级"
        item04.text = "高级"
        
        let dropDownMenu = IGLDropDownMenu()
        dropDownMenu.frame = CGRectMake(CGFloat(btnLeft),CGFloat(btnTop),CGFloat(btnWidth+10),30)
        dropDownMenu.dropDownItems = [item01,item02,item03,item04]
        dropDownMenu.menuText = "选择报警等级"
        dropDownMenu.paddingLeft = 15
        dropDownMenu.delegate = self
        
        dropDownMenu.gutterY = 5;
        dropDownMenu.type = IGLDropDownMenuType.SlidingInBoth
        dropDownMenu.itemAnimationDelay = 0.1
        
        //dropDownMenu.backgroundColor = UIColor.lightGrayColor()
        dropDownMenu.reloadView()
        
        self.uiscrollview.addSubview(dropDownMenu)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CreateTitle(){
        //组织机构
        let lb_title:UILabel = UILabel(frame: CGRect(x: 0, y: yVal, width: Int(self.view.frame.width), height: 60))
        lb_title.backgroundColor = con.bkcolor1
        self.view.addSubview(lb_title)
        
        lb_project = UILabel(frame: CGRect(x: 5, y: 65 + 18, width: con.width - 60, height: 30))
        lb_project.textColor = UIColor.whiteColor()
        lb_project.text = con.departName_BH_sel + ">拌和站管理>超标处置与查询"
        lb_project.adjustsFontSizeToFitWidth  = true
        lb_project.font = UIFont.systemFontOfSize(17)
        lb_project.adjustsFontSizeToFitWidth = true
        self.view.addSubview(lb_project)
        
        //添加label事件(组织机构)
        if(con.type == "GL"){
            let img01 = UIImageView(frame: CGRect(x: con.width-40, y: yVal + 18, width:30 , height: 30))
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
        sub.IFuntype = "1"//1.水泥混凝土
        sub.IType = con.userRole
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //委托函数实现
    func GroupIDSelect(GroupID:String,GroupName:String, ctl:SY_JGVC){
        print(GroupID)
        con.departId_BH_sel = GroupID
        con.departName_BH_sel = GroupName
        lb_project.text = con.departName_BH_sel + ">拌和站管理>超标处置与查询"
        //清空设备列表
        btnDevice.setTitle("  选择设备", forState:UIControlState.Normal)
        SheBei = "-1"
        self.tableview.header.state = RefreshViewStateDefault
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableviewRefresh()
    }
    
    func CreateBtn_ShiYan(){
        btnDevice = SFlatButton(frame:CGRect(x:btnLeft + 110,y: btnTop,width:con.width - btnLeft - 115 - 10,height:30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel);
        btnDevice.setTitleColor(UIColor.whiteColor(),forState: .Normal)
        btnDevice.setTitle("  选择设备", forState:UIControlState.Normal)
        btnDevice.titleLabel?.font = UIFont.systemFontOfSize(13)
        btnDevice.titleLabel?.adjustsFontSizeToFitWidth = true
        btnDevice.backgroundColor = con.blueMore
        btnDevice.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        //图标
        let img = UIImageView(frame: CGRect(x: con.width-20-btnWidth-20-25, y: 5, width:20 , height: 20))
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
        self.tableview.header.state = RefreshViewStateDefault
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableviewRefresh()
    }
    
    func createChuZhi(){
        //未处置
        BuChuZi = SFlatButton(frame: CGRect(x: btnLeft, y: yVal, width:(con.width-10)/2 - btnLeft, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        BuChuZi.backgroundColor = con.bkcolor1
        BuChuZi.setTitleColor(UIColor.whiteColor(),forState: .Normal)
        BuChuZi.setTitle("未处置", forState:UIControlState.Normal)
        BuChuZi.titleLabel?.font = UIFont.systemFontOfSize(13)
        BuChuZi.titleLabel?.adjustsFontSizeToFitWidth = true
        BuChuZi.addTarget(self, action: "BuChuZi_onClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(BuChuZi)
        //已处置
        ChuZi = SFlatButton(frame: CGRect(x: (con.width-10)/2, y: yVal, width: (con.width-10)/2 - btnLeft, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        ChuZi.backgroundColor = con.blueMore
        ChuZi.setTitleColor(UIColor.whiteColor(),forState: .Normal)
        ChuZi.setTitle("已处置", forState:UIControlState.Normal)
        ChuZi.titleLabel?.font = UIFont.systemFontOfSize(13)
        ChuZi.titleLabel?.adjustsFontSizeToFitWidth = true
        ChuZi.addTarget(self, action: "ChuZi_onClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(ChuZi)
    }
    
    func createShenPi(){
        //未审批
        BuShenPi = SFlatButton(frame: CGRect(x: btnLeft, y: yVal, width:(con.width-10)/2 - btnLeft, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        BuShenPi.backgroundColor = con.blueMore
        BuShenPi.setTitleColor(UIColor.whiteColor(),forState: .Normal)
        BuShenPi.setTitle("未审批", forState:UIControlState.Normal)
        BuShenPi.titleLabel?.font = UIFont.systemFontOfSize(13)
        BuShenPi.titleLabel?.adjustsFontSizeToFitWidth = true
        BuShenPi.addTarget(self, action: "BuShenPi_onClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(BuShenPi)
        //已审批
        ShenPi = SFlatButton(frame: CGRect(x: (con.width-10)/2, y: yVal, width: (con.width-10)/2 - btnLeft, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        ShenPi.backgroundColor = con.blueMore
        ShenPi.setTitleColor(UIColor.whiteColor(),forState: .Normal)
        ShenPi.setTitle("已审批", forState:UIControlState.Normal)
        ShenPi.titleLabel?.font = UIFont.systemFontOfSize(13)
        ShenPi.titleLabel?.adjustsFontSizeToFitWidth = true
        ShenPi.addTarget(self, action: "ShenPi_onClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        self.uiscrollview.addSubview(ShenPi)
    }
    
    func setBtnColor(){
        BuChuZi.backgroundColor = con.bkcolor1
        ChuZi.backgroundColor = con.blueMore
        if(con.hntchaobiaoSp == true)
        {
            BuShenPi.backgroundColor = con.blueMore
            ShenPi.backgroundColor = con.blueMore
        }
        if(chuzi == "0"){
            BuChuZi.backgroundColor = con.bkcolor1
            ChuZi.backgroundColor = con.blueMore
            BuChuZi.setTitle("未处置", forState:UIControlState.Normal)
            ChuZi.setTitle("已处置", forState:UIControlState.Normal)
        }
        
        if(chuzi == "1"){
            ChuZi.backgroundColor = con.bkcolor1
            BuChuZi.backgroundColor = con.blueMore
            ChuZi.setTitle("已处置", forState:UIControlState.Normal)
            BuChuZi.setTitle("未处置", forState:UIControlState.Normal)
        }
        print(chuzi)
    }
    
    func setBtnShenPiColor(){
        BuShenPi.backgroundColor = con.bkcolor1
        ShenPi.backgroundColor = con.blueMore
        if(con.hntchaobiaoReal == true)
        {
            BuChuZi.backgroundColor = con.blueMore
            ChuZi.backgroundColor = con.blueMore
        }
        if(chuzi == "2"){
            BuShenPi.backgroundColor = con.bkcolor1
            ShenPi.backgroundColor = con.blueMore
            BuShenPi.setTitle("未审批", forState:UIControlState.Normal)
            ShenPi.setTitle("已审批", forState:UIControlState.Normal)
        }

        if(chuzi == "3"){
            ShenPi.backgroundColor = con.bkcolor1
            BuShenPi.backgroundColor = con.blueMore
            ShenPi.setTitle("已审批", forState:UIControlState.Normal)
            BuShenPi.setTitle("未审批", forState:UIControlState.Normal)
        }
        print(chuzi)
    }
    
    func ChuZi_onClickBtn(sender: UIButton){
        print("点击了ChuZi_onClickBtn");
        chuzi = "1"//已处置
        setBtnColor()
        self.tableview.header.state = RefreshViewStateDefault
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableviewRefresh()
    }
    
    func BuChuZi_onClickBtn(sender: UIButton){
        print("点击了BuChuZi_onClickBtn");
        chuzi = "0"//未处置
        setBtnColor()
        self.tableview.header.state = RefreshViewStateDefault
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableviewRefresh()
    }
    
    func ShenPi_onClickBtn(sender: UIButton){
        print("点击了ShenPi_onClickBtn");
        chuzi = "3"//已审批置
        setBtnShenPiColor()
        self.tableview.header.state = RefreshViewStateDefault
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableviewRefresh()
    }
    
    func BuShenPi_onClickBtn(sender: UIButton){
        print("点击了BuShenPi_onClickBtn");
        chuzi = "2"//未审批
        setBtnShenPiColor()
        self.tableview.header.state = RefreshViewStateDefault
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableviewRefresh()
    }
    
    
    func createDate(){
        //From
        dateFrom = SFlatButton(frame: CGRect(x: btnLeft, y: yVal, width:btnWidthDate, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
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
        dateTo = SFlatButton(frame: CGRect(x: btnLeft + 10 + btnWidthDate, y: yVal, width:btnWidthDate, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
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
        search = SFlatButton(frame: CGRect(x: btnLeft + 15 + btnWidthDate*2, y: yVal, width:60, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
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
        self.tableview.header.state = RefreshViewStateDefault
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableviewRefresh()
    }
    
    func createTableView(){
        tableview = UITableView(frame: CGRect(x: 5, y: yVal + 30, width: con.width-20, height: con.height - btnTop * 8 - 175))
        tableview.backgroundColor = con.bkcolor
        tableview.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.uiscrollview.addSubview(tableview)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count/self.n
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 110
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell1") as UITableViewCell!
        if (cell == nil) {
            let nibs:NSArray = NSBundle.mainBundle().loadNibNamed("BH_CbczCell", owner: self, options: nil)
            cell = nibs.lastObject as! BH_CbczCell
            
            if(indexPath.row >= array.count/n){
                return cell
            }
            let lb1  = cell!.viewWithTag(1) as! UILabel
            let lb2  = cell!.viewWithTag(2) as! UILabel
            let lb3  = cell!.viewWithTag(3) as! UILabel
            let lb4  = cell!.viewWithTag(4) as! UILabel
            let lb5  = cell!.viewWithTag(5) as! UILabel
            let lb6  = cell!.viewWithTag(6) as! UILabel
            
            lb1.text  = array[indexPath.row*n + 0]
            lb2.text  = array[indexPath.row*n + 1]
            lb3.text  = array[indexPath.row*n + 2]
            lb4.text  = array[indexPath.row*n + 3]
            lb5.text  = array[indexPath.row*n + 4]
            lb6.text  = array[indexPath.row*n + 5]
        }
        
        cell!.layer.cornerRadius = 10
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell!
    }
    
    func refreshViewDidLoading(view:AnyObject){
        if (view.isEqual(self.tableview.header)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.getJsonData_header()
            }
        }
        
        if (view.isEqual(self.tableview.footer)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.getJsonData_footer()
            }
        }
    }

    func getJsonData_header(){
        self.showPage("-")
        self.array = []
        self.array_id = []
        self.array_shebeibianhao = []
        
        let long_starttime = con.getLongTime(dateFrom.titleLabel!.text!,flg:0)
        let long_endtime = con.getLongTime(dateTo.titleLabel!.text!,flg:1)
        let sttime = startTime + String(long_starttime)
        let ettime = endTime + String(long_endtime)
        
        var requestUrl = ""
        //报警等级
        var dj = ""
        if(level == "初级")
        {
            dj = "1"
        }
        else if(level == "初级")
        {
            dj = "2"
        }
        else if(level == "初级")
        {
            dj = "3"
        }
        else
        {
            dj = "0"
        }
        requestUrl = url + maxPageItems + departId + con.departId_BH_sel + pageNo + String(self.PageCnt) + dengji + dj + chuzhileixing + chuzi + sttime + ettime
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
                    let cnt = (JSON.valueForKey("data"))!.count
                    for(var i:Int=0; i<cnt; i++){
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("chuliaoshijian")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("gongchengmingcheng")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("jiaozuobuwei")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("sigongdidian")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("qiangdudengji")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("fasongcishu")! as! String)
                        //试验室唯一主键Id

                        self.array_id.append((JSON.valueForKey("data"))![i].valueForKey("xinxibianhao")! as! String)
                        self.array_shebeibianhao.append((JSON.valueForKey("data"))![i].valueForKey("shebeibianhao")! as! String)
                    }
                }
            }
            
            //TableView的footer处理
            if (self.tableview.footer != nil) {
                if ((self.array.count/self.n) >= con.pagecnt) {
                    self.tableview.footer.isLastPage = false
                } else {
                    self.tableview.footer.isLastPage = true
                }
            }
            self.tableview.reloadData()
            self.tableview.header.state = RefreshViewStateDefault
            self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
    }
    
    func getJsonData_footer(){
        self.showPage("+")
        self.array = []
        self.array_id = []
        self.array_shebeibianhao = []

        let long_starttime = con.getLongTime(dateFrom.titleLabel!.text!,flg:0)
        let long_endtime = con.getLongTime(dateTo.titleLabel!.text!,flg:1)
        let sttime = startTime + String(long_starttime)
        let ettime = endTime + String(long_endtime)
        
        var requestUrl = ""
        //报警等级
        var dj = ""
        if(level == "初级")
        {
            dj = "1"
        }
        else if(level == "初级")
        {
            dj = "2"
        }
        else if(level == "初级")
        {
            dj = "3"
        }
        else
        {
            dj = "0"
        }
        requestUrl = url + maxPageItems + departId + con.departId_BH_sel + pageNo + String(self.PageCnt) + dengji + dj + chuzhileixing + chuzi + sttime + ettime
        //全部设备
        if(SheBei != "-1")
        {
            requestUrl = requestUrl + shebeibianhao + SheBei
        }
        
        Alamofire.request(.GET, requestUrl).responseJSON{ response in
            
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    let cnt = (JSON.valueForKey("data"))!.count
                    for(var i:Int=0; i<cnt; i++){
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("chuliaoshijian")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("gongchengmingcheng")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("jiaozuobuwei")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("sigongdidian")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("qiangdudengji")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("fasongcishu")! as! String)
                        //试验室唯一主键Id
                        self.array_id.append((JSON.valueForKey("data"))![i].valueForKey("xinxibianhao")! as! String)
                        self.array_shebeibianhao.append((JSON.valueForKey("data"))![i].valueForKey("shebeibianhao")! as! String)
                    }
                }
            }
            
            //TableView的footer处理
            if ((self.array.count/self.n) >= con.pagecnt) {
                self.tableview.footer.isLastPage = false
            } else {
                self.tableview.footer.isLastPage = true
            }
            self.tableview.reloadData()
            self.tableview.footer.state = RefreshViewStateDefault
        }
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if((chuzi == "0") || (chuzi == "1"))
        {
            let sub: BH_CbczDetailVC = BH_CbczDetailVC(nibName: "BH_CbczDetailVC", bundle: nil)
            let id = array_id[indexPath.row]
            let shebeibianhao = array_shebeibianhao[indexPath.row]
            let name = array[indexPath.row*n + 1]
            sub.id = id
            sub.sbbianhao = shebeibianhao
            sub.name = name
            sub.chuzi = chuzi
            //present方式
            self.navigationController?.pushViewController(sub, animated: true)
        }
        else
        {
            if((chuzi == "2") || (chuzi == "3"))
            {
                let sub: BH_CbspDetailVC = BH_CbspDetailVC(nibName: "BH_CbspDetailVC", bundle: nil)
                let id = array_id[indexPath.row]
                let shebeibianhao = array_shebeibianhao[indexPath.row]
                let name = array[indexPath.row*n + 1]
                sub.id = id
                sub.sbbianhao = shebeibianhao
                sub.name = name
                sub.chuzi = chuzi
                //present方式
                self.navigationController?.pushViewController(sub, animated: true)
            }
        }
    }
    
}
