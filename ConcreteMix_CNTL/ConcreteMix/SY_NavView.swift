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

class SY_NavView: UIView, UITableViewDataSource, UITableViewDelegate, CalendarSelectDelegate,KSRefreshViewDelegate {

    //组织机构ID
    var departId_Old = ""
    //步长
    var n:Int = 19
    
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
    var ShiYanShi:SFlatButton!
    var BanHeZhan:SFlatButton!
    //日期控件
    var clv = CalendarSSView(frame: CGRect(x: 5, y: 30, width: 300, height: 320))
    let date = NSDate()
    let formatter:NSDateFormatter = NSDateFormatter()
    var datetime = ""
    var dateFlg = "From"
    //屏幕宽度,高度
    var width:Int!
    var height:Int!
    //导航
    var nv:UINavigationController?
    
    //Json Url & 参数 Begin##############################################################################################################################
    var url = con.sysHomeURL
    var userGroupId = "userGroupId="
    //Json Url & 参数 End################################################################################################################################
    
    //数据接收部 Begin+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var array:[String] = []
    var array_departId:[String] = []
    //数据接收部 End+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    init(frame: CGRect, nav:UINavigationController) {
        super.init(frame: frame)
        width = Int(frame.width)
        height = Int(frame.height)
        nv = nav

        //scrollview
        uiscrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: con.width, height: con.height+500))
        self.addSubview(uiscrollview)
        
        //创建日期控件
        createDate()
        //创建TableView
        createTableView()
        //加载list
        tableviewRefresh()
    }
    
    func tableviewRefresh(){
        //-------------------数据刷新--------------------------------------------------------------------------------------------------------------------------
        self.array = []
        self.tableview!.reloadData()
        self.tableview!.header = KSDefaultHeadRefreshView(delegate: self)
        self.tableview!.footer  = KSDefaultFootRefreshView(delegate: self)
        self.tableview.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.tableview.header.state = RefreshViewStateLoading
        //----------------------------------------------------------------------------------------------------------------------------------------------------
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
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
        search = SFlatButton(frame: CGRect(x: btnLeft + 15 + btnWidthDate*2, y: btnTop, width:70, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        search.backgroundColor = con.bkcolor1
        search.setTitleColor(UIColor.whiteColor(),forState: .Normal)
        search.setTitle("重新加载", forState:UIControlState.Normal)
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
        self.addSubview(clv)
        dateFlg = "From"
        clv.delegate = self
        
    }
    
    func dateTo_onClickBtn(sender: UIButton){
        print("点击了dateTo_onClickBtn");
        self.addSubview(clv)
        dateFlg = "To"
        clv.delegate = self
    }
    
    func search_onClickBtn(sender: UIButton){
        print("点击了search_onClickBtn");
    }
    
    
    func createTableView(){
        tableview = UITableView(frame: CGRect(x: 5, y: btnTop*5 + 10, width: con.width-20, height: con.height - btnTop*5 - 200))
        tableview.backgroundColor = con.bkcolor
        tableview.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.uiscrollview.addSubview(tableview)
    }
    
    func DateOK(str_date:String){
        if(dateFlg == "From"){
            dateFrom.setTitle("  " + str_date, forState:UIControlState.Normal )
        }else{
            dateTo.setTitle("  " + str_date, forState:UIControlState.Normal )
        }
        clv.removeFromSuperview()
    }
    
    func DateCancel(){
        clv.removeFromSuperview()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count/self.n
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 160
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell1") as UITableViewCell!
        if (cell == nil) {
            let nibs:NSArray = NSBundle.mainBundle().loadNibNamed("SY_NavCell", owner: self, options: nil)
            cell = nibs.lastObject as! SY_NavCell
            
            let lb99  = cell!.viewWithTag(99) as! UILabel
            lb99.layer.backgroundColor = con.bkcolor.CGColor
            lb99.layer.cornerRadius = 10
            
            let lb1  = cell!.viewWithTag(1) as! UILabel
            let lb2  = cell!.viewWithTag(2) as! UILabel
            let lb3  = cell!.viewWithTag(3) as! UILabel
            
            let lb11  = cell!.viewWithTag(11) as! UILabel
            let lb12  = cell!.viewWithTag(12) as! UILabel
            let lb13  = cell!.viewWithTag(13) as! UILabel
            let lb14  = cell!.viewWithTag(14) as! UILabel
            
            let lb21  = cell!.viewWithTag(21) as! UILabel
            let lb22  = cell!.viewWithTag(22) as! UILabel
            let lb23  = cell!.viewWithTag(23) as! UILabel
            let lb24  = cell!.viewWithTag(24) as! UILabel
            
            let lb31  = cell!.viewWithTag(31) as! UILabel
            let lb32  = cell!.viewWithTag(32) as! UILabel
            let lb33  = cell!.viewWithTag(33) as! UILabel
            let lb34  = cell!.viewWithTag(34) as! UILabel
            
            let lb41  = cell!.viewWithTag(41) as! UILabel
            let lb42  = cell!.viewWithTag(42) as! UILabel
            let lb43  = cell!.viewWithTag(43) as! UILabel
            let lb44  = cell!.viewWithTag(44) as! UILabel
            
            //title
            let lb91  = cell!.viewWithTag(91) as! UILabel
            let lb92  = cell!.viewWithTag(92) as! UILabel
            let lb93  = cell!.viewWithTag(93) as! UILabel
            let lb94  = cell!.viewWithTag(94) as! UILabel
            let lb95  = cell!.viewWithTag(95) as! UILabel
            
            lb1.text  = array[indexPath.row*n+0]
            
            lb2.layer.backgroundColor = con.bkcolor1.CGColor
            lb2.layer.cornerRadius = 12
            lb2.text  = array[indexPath.row*n+1]
            
            lb3.layer.backgroundColor = con.bkcolor1.CGColor
            lb3.layer.cornerRadius = 12
            lb3.text  = array[indexPath.row*n+2]
            
            lb11.text = array[indexPath.row*n+3]
            lb12.text = array[indexPath.row*n+4]
            lb13.text = array[indexPath.row*n+5]
            lb14.text = array[indexPath.row*n+6] + "%"
            
            lb21.text = array[indexPath.row*n+7]
            lb22.text = array[indexPath.row*n+8]
            lb23.text = array[indexPath.row*n+9]
            lb24.text = array[indexPath.row*n+10] + "%"
            
            lb31.text = array[indexPath.row*n+11]
            lb32.text = array[indexPath.row*n+12]
            lb33.text = array[indexPath.row*n+13]
            lb34.text = array[indexPath.row*n+14] + "%"
            
            lb41.text = array[indexPath.row*n+15]
            lb42.text = array[indexPath.row*n+16]
            lb43.text = array[indexPath.row*n+17]
            lb44.text = array[indexPath.row*n+18] + "%"
            
            //添加label事件(混凝土强度)
            let tap91:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_hntqdClickBtn:")
            lb91.userInteractionEnabled = true
            lb91.tag = indexPath.row
            lb91.addGestureRecognizer(tap91)
            
            let tap11:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_hntqdClickBtn:")
            lb11.userInteractionEnabled = true
            lb11.tag = indexPath.row
            lb11.addGestureRecognizer(tap11)
            
            let tap12:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_hntqdClickBtn:")
            lb12.tag = indexPath.row
            lb12.userInteractionEnabled = true
            lb12.addGestureRecognizer(tap12)
            
            let tap13:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_hntqdClickBtn:")
            lb13.userInteractionEnabled = true
            lb13.tag = indexPath.row
            lb13.addGestureRecognizer(tap13)
            
            let tap14:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_hntqdClickBtn:")
            lb14.tag = indexPath.row
            lb14.userInteractionEnabled = true
            lb14.addGestureRecognizer(tap14)
            
            //添加label事件(钢筋拉力)
            let tap92:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjllClickBtn:")
            lb92.userInteractionEnabled = true
            lb92.tag = indexPath.row
            lb92.addGestureRecognizer(tap92)
            
            let tap21:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjllClickBtn:")
            lb21.userInteractionEnabled = true
            lb21.tag = indexPath.row
            lb21.addGestureRecognizer(tap21)
            
            let tap22:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjllClickBtn:")
            lb22.tag = indexPath.row
            lb22.userInteractionEnabled = true
            lb22.addGestureRecognizer(tap22)
            
            let tap23:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjllClickBtn:")
            lb23.userInteractionEnabled = true
            lb23.tag = indexPath.row
            lb23.addGestureRecognizer(tap23)
            
            let tap24:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjllClickBtn:")
            lb24.tag = indexPath.row
            lb24.userInteractionEnabled = true
            lb24.addGestureRecognizer(tap24)
            
            //添加label事件(钢筋焊接接头)
            let tap93:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjhjjtClickBtn:")
            lb93.userInteractionEnabled = true
            lb93.tag = indexPath.row
            lb93.addGestureRecognizer(tap93)
            
            let tap31:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjhjjtClickBtn:")
            lb31.userInteractionEnabled = true
            lb31.tag = indexPath.row
            lb31.addGestureRecognizer(tap31)
            
            let tap32:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjhjjtClickBtn:")
            lb32.tag = indexPath.row
            lb32.userInteractionEnabled = true
            lb32.addGestureRecognizer(tap32)
            
            let tap33:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjhjjtClickBtn:")
            lb33.userInteractionEnabled = true
            lb33.tag = indexPath.row
            lb33.addGestureRecognizer(tap33)
            
            let tap34:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjhjjtClickBtn:")
            lb34.tag = indexPath.row
            lb34.userInteractionEnabled = true
            lb34.addGestureRecognizer(tap34)
            
            //添加label事件(钢筋机械连接接头)
            let tap94:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjhjjtClickBtn:")
            lb94.userInteractionEnabled = true
            lb94.tag = indexPath.row
            lb94.addGestureRecognizer(tap94)
            
            let tap95:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjhjjtClickBtn:")
            lb95.userInteractionEnabled = true
            lb95.tag = indexPath.row
            lb95.addGestureRecognizer(tap95)
            
            let tap41:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjhjjtClickBtn:")
            lb41.userInteractionEnabled = true
            lb41.tag = indexPath.row
            lb41.addGestureRecognizer(tap41)
            
            let tap42:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjhjjtClickBtn:")
            lb42.tag = indexPath.row
            lb42.userInteractionEnabled = true
            lb42.addGestureRecognizer(tap42)
            
            let tap43:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjhjjtClickBtn:")
            lb43.userInteractionEnabled = true
            lb43.tag = indexPath.row
            lb43.addGestureRecognizer(tap43)
            
            let tap44:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_gjhjjtClickBtn:")
            lb44.tag = indexPath.row
            lb44.userInteractionEnabled = true
            lb44.addGestureRecognizer(tap44)
        }
        
        cell.layer.cornerRadius = 10;
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
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
        self.array = []
        self.array_departId = []
        print(self.url + userGroupId + con.departId)
        //比较用
        departId_Old = ""

        Alamofire.request(.GET, url + userGroupId + con.departId).responseJSON{ response in
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    let cnt = (JSON.valueForKey("data"))!.count
                    var index = 0
                    var count = 0
                    for(var i:Int=0; i<cnt; i++){
                        //第一条数据，直接加上
                        if(i==0)
                        {
                            self.array_departId.append((JSON.valueForKey("data"))![i].valueForKey("userGroupId")! as! String)
                            self.resetArray((JSON.valueForKey("data"))![i].valueForKey("departName")! as! String)
                            //试验室COUNT
                            self.array[i*self.n + 1] = (JSON.valueForKey("data"))![i].valueForKey("sysCount")! as! String
                            //试验机COUNT
                            self.array[i*self.n + 2] = (JSON.valueForKey("data"))![i].valueForKey("syjCount")! as! String
                            self.setArrayData(0,
                                type: (JSON.valueForKey("data"))![i].valueForKey("testtype")! as! String,
                                testCount: (JSON.valueForKey("data"))![i].valueForKey("testCount")! as! String,
                                notQualifiedCount: (JSON.valueForKey("data"))![i].valueForKey("notQualifiedCount")! as! String,
                                realCount: (JSON.valueForKey("data"))![i].valueForKey("realCount")! as! String,
                                realPer: (JSON.valueForKey("data"))![i].valueForKey("realPer")! as! String)
                        }
                        //先和旧数据比较
                        else
                        {
                            count = self.array_departId.count
                            index = self.findIdByIndex((JSON.valueForKey("data"))![i].valueForKey("userGroupId")! as! String)
                            if(index >= count)
                            {
                                self.array_departId.append((JSON.valueForKey("data"))![i].valueForKey("userGroupId")! as! String)
                                //添加新一组数据
                                self.resetArray((JSON.valueForKey("data"))![i].valueForKey("departName")! as! String)
                                //试验室COUNT
                                self.array[i*self.n + 1] = (JSON.valueForKey("data"))![i].valueForKey("sysCount")! as! String
                                //试验机COUNT
                                self.array[i*self.n + 2] = (JSON.valueForKey("data"))![i].valueForKey("syjCount")! as! String
                            }
                            self.setArrayData(index,
                                type: (JSON.valueForKey("data"))![i].valueForKey("testtype")! as! String,
                                testCount: (JSON.valueForKey("data"))![i].valueForKey("testCount")! as! String,
                                notQualifiedCount: (JSON.valueForKey("data"))![i].valueForKey("notQualifiedCount")! as! String,
                                realCount: (JSON.valueForKey("data"))![i].valueForKey("realCount")! as! String,
                                realPer: (JSON.valueForKey("data"))![i].valueForKey("realPer")! as! String)
                            
                        }
                    }
                }
            }
            
            //TableView的footer处理
            if (self.tableview.footer != nil) {
                //不在底部刷新了
                if ((self.array.count/self.n) >= 1000) {
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
    }
    
    //初期化List数据
    func resetArray(departName:String)
    {
        for(var i=0; i<19; i++)
        {
            if(i==0)
            {
                self.array.append(departName)
            }
            else
            {
                self.array.append("");
            }
        }
    }
    
    //找出ID的Index
    func findIdByIndex(departId:String) ->Int
    {
        for(var i=0; i<self.array_departId.count; i++)
        {
            if(departId == self.array_departId[i])
            {
                return i;
            }
        }
        return self.array_departId.count
    }
    
    //设置数据
    func setArrayData(n:Int,type:String,testCount:String,notQualifiedCount:String,realCount:String,realPer:String)
    {
        switch (type)
        {
        case "100014":
            self.array[n*19+2+1] = testCount
            self.array[n*19+2+2] = notQualifiedCount
            self.array[n*19+2+3] = realCount
            self.array[n*19+2+4] = realPer
            break;
        case "100047":
            self.array[n*19+2+5] = testCount
            self.array[n*19+2+6] = notQualifiedCount
            self.array[n*19+2+7] = realCount
            self.array[n*19+2+8] = realPer
            break;
        case "100048":
            self.array[n*19+2+9] = testCount
            self.array[n*19+2+10] = notQualifiedCount
            self.array[n*19+2+11] = realCount
            self.array[n*19+2+12] = realPer
            break;
        default:
            self.array[n*19+2+13] = testCount
            self.array[n*19+2+14] = notQualifiedCount
            self.array[n*19+2+15] = realCount
            self.array[n*19+2+16] = realPer
            break;
        }
    }

    //混凝土强度
    func btn_hntqdClickBtn(sender:AnyObject){
        print(sender.view!?.tag)
        let sub: SY_HntqdVC = SY_HntqdVC(nibName: "SY_HntqdVC", bundle: nil)
        nv?.pushViewController(sub, animated: true)
    }
    
    //钢筋拉力
    func btn_gjllClickBtn(sender: AnyObject){
        print(sender.view!?.tag)
        let sub: SY_GjVC = SY_GjVC(nibName: "SY_GjVC", bundle: nil)
        sub.titleVC = "钢筋拉力"
        nv?.pushViewController(sub, animated: true)
    }
    
    //钢筋焊接接头
    func btn_gjhjjtClickBtn(sender: AnyObject){
        print(sender.view!?.tag)
        let sub: SY_GjVC = SY_GjVC(nibName: "SY_GjVC", bundle: nil)
        sub.titleVC = "钢筋焊接接头"
        nv?.pushViewController(sub, animated: true)
    }
    
    //钢筋机械连接接头
    func btn_gjjxljjtClickBtn(sender: AnyObject){
        print(sender.view!?.tag)
        let sub: SY_GjVC = SY_GjVC(nibName: "SY_GjVC", bundle: nil)
        sub.titleVC = "钢筋机械连接接头"
        nv?.pushViewController(sub, animated: true)
    }
}