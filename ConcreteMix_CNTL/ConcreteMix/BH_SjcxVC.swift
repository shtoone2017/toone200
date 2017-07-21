//
//  SC_SjcxVC.swift
//  ConcreteMix
//
//  Created by user on 15/10/5.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit
import Alamofire

class BH_SjcxVC: UIViewController, UITableViewDataSource, UITableViewDelegate,KSRefreshViewDelegate,GroupIDSelectDelegate,SheBeiSelectDelegate{

    //组织机构ID
    var GroupId = ""
    //步长
    var n:Int = 7
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
    var tableview:UITableView!
    var lb_project:UILabel!
    var btnDevice:SFlatButton!
    //日期控件
    let date = NSDate()
    let formatter:NSDateFormatter = NSDateFormatter()
    var datetime = ""
    //页码控件
    var lb_page:UILabel!
    
    //Json Url & 参数 Begin##############################################################################################################################
    var url = con.AppHntXiangxiListURL
    var maxPageItems = "maxPageItems=15"
    var pageNo = "&pageNo="
    var departId = "&departId="
    var startTime = "&startTime="
    var endTime = "&endTime="
    var shebeibianhao = "&shebeibianhao="
    //Json Url & 参数 End################################################################################################################################
    
    //数据接收部 Begin+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var array:[String] = []
    var array_id:[String] = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "拌和站与试验室信息管理"
        let item = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        self.view.backgroundColor = UIColor.whiteColor()
        
        //scrollview
        uiscrollview = UIScrollView(frame: CGRect(x: 5, y: con.yValue + 60, width: con.width-10, height: con.height))
        uiscrollview.layer.cornerRadius = 15
        uiscrollview.backgroundColor = con.bkcolor
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(uiscrollview)
        
        //页码控件
        lb_page = UILabel(frame: CGRect(x: 5, y: btnTop * 8 + 10, width: 100, height: 20))
        lb_page.font = UIFont.systemFontOfSize(13)
        self.uiscrollview.addSubview(lb_page)
        //组织机构
        CreateTitle()
        //选择设备
        CreateBtn_ShiYan()
        //创建日期控件
        createDate()
        //创建TableView
        createTableView()
        
        //加载数据
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
        lb_project.text = con.departName_BH_sel + ">拌和站管理>生产数据查询"
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
        sub.IFuntype = "1"//1.水泥混凝土
        sub.IType = con.userRole
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    //委托函数实现
    func GroupIDSelect(GroupID:String,GroupName:String, ctl:SY_JGVC){
        print(GroupID)
        con.departId_BH_sel = GroupID
        con.departName_BH_sel = GroupName
        lb_project.text = con.departName_BH_sel + ">拌和站管理>生产数据查询"
        //清空设备列表
        btnDevice.setTitle("  选择设备", forState:UIControlState.Normal)
        SheBei = "-1"
        self.tableview.header.state = RefreshViewStateDefault
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableviewRefresh()
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
        self.tableview.header.state = RefreshViewStateDefault
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableviewRefresh()
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
        //加载数据
        self.tableview.header.state = RefreshViewStateDefault
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableviewRefresh()
    }
    
    func createTableView(){
        tableview = UITableView(frame: CGRect(x: 5, y: btnTop * 8 + 30, width: con.width-20, height: con.height - btnTop * 8 - 175))
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
        return array.count/n
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell1") as UITableViewCell!
        if (cell == nil) {
            let nibs:NSArray = NSBundle.mainBundle().loadNibNamed("BH_SjcxCell", owner: self, options: nil)
            cell = nibs.lastObject as! BH_SjcxCell
            
            if(indexPath.row >= array.count/n){
                return cell
            }
            
            let lb1  = cell!.viewWithTag(1) as! UILabel
            let lb2  = cell!.viewWithTag(2) as! UILabel
            let lb3  = cell!.viewWithTag(3) as! UILabel
            let lb4  = cell!.viewWithTag(4) as! UILabel
            let lb5  = cell!.viewWithTag(5) as! UILabel
            let lb6  = cell!.viewWithTag(6) as! UILabel
            let lb7  = cell!.viewWithTag(7) as! UILabel
          
            lb1.text  = array[indexPath.row*n+0]
            lb2.text  = array[indexPath.row*n+1]
            lb3.text  = array[indexPath.row*n+2]
            lb4.text  = array[indexPath.row*n+3]
            lb5.text  = array[indexPath.row*n+4]
            lb6.text  = array[indexPath.row*n+5]
            lb7.text  = array[indexPath.row*n+6]
        }

        cell!.layer.cornerRadius = 10;
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
        
        let long_starttime = con.getLongTime(dateFrom.titleLabel!.text!,flg:0)
        let long_endtime = con.getLongTime(dateTo.titleLabel!.text!,flg:1)
        let sttime = startTime + String(long_starttime)
        let ettime = endTime + String(long_endtime)

        var requestUrl = ""
        //全部设备
        if(SheBei == "-1")
        {
            requestUrl = url + maxPageItems + departId + con.departId_BH_sel + pageNo + String(self.PageCnt) + sttime + ettime
        }
        else
        {
            requestUrl = url + maxPageItems + departId + con.departId_BH_sel + pageNo + String(self.PageCnt) + shebeibianhao + SheBei + sttime + ettime
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
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("caijishijian")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("banhezhanminchen")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("gongchengmingcheng")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("jiaozuobuwei")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("sigongdidian")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("qiangdudengji")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("gujifangshu")! as! String)
                        //试验室唯一主键Id
                        let id = (JSON.valueForKey("data"))![i].valueForKey("id") as! Int
                        let strid = String(id)
                        self.array_id.append(strid)
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
        
        let long_starttime = con.getLongTime(dateFrom.titleLabel!.text!,flg:0)
        let long_endtime = con.getLongTime(dateTo.titleLabel!.text!,flg:1)
        let sttime = startTime + String(long_starttime)
        let ettime = endTime + String(long_endtime)
        
        var requestUrl = ""
        //全部设备
        if(SheBei == "-1")
        {
            requestUrl = url + maxPageItems + departId + con.departId_BH_sel + pageNo + String(self.PageCnt) + sttime + ettime
        }
        else
        {
            requestUrl = url + maxPageItems + departId + con.departId_BH_sel + pageNo + String(self.PageCnt) + shebeibianhao + SheBei + sttime + ettime
        }

        Alamofire.request(.GET, requestUrl).responseJSON{ response in
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    let cnt = (JSON.valueForKey("data"))!.count
                    for(var i:Int=0; i<cnt; i++){
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("caijishijian")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("banhezhanminchen")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("gongchengmingcheng")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("jiaozuobuwei")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("sigongdidian")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("qiangdudengji")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("gujifangshu")! as! String)
                        //试验室唯一主键Id
                        let id = (JSON.valueForKey("data"))![i].valueForKey("id") as! Int
                        let strid = String(id)
                        self.array_id.append(strid)
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
        let sub: BH_SjcxDetailVC = BH_SjcxDetailVC(nibName: "BH_SjcxDetailVC", bundle: nil)
        let id = array_id[indexPath.row]
        let name = array[indexPath.row*n + 1]
        sub.id = id
        sub.name = name
        //present方式
        self.navigationController?.pushViewController(sub, animated: true)
    }
}
