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

class BH_NavView: UIView, UITableViewDataSource, UITableViewDelegate, CalendarSelectDelegate,KSRefreshViewDelegate {
    
    //步长
    var n:Int = 16
    
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
    var url = con.AppHntMainURL
    var departId = "departId="
    //Json Url & 参数 End################################################################################################################################
    
    //数据接收部 Begin+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var array:[String] = []
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
        tableview = UITableView(frame: CGRect(x: 5, y: btnTop*5 + 10, width: con.width-20, height: con.height - btnTop*5 - 130))
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
        return array.count/self.n
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 150
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell1") as UITableViewCell!
        if (cell == nil) {
            let nibs:NSArray = NSBundle.mainBundle().loadNibNamed("BH_NavCell", owner: self, options: nil)
            cell = nibs.lastObject as! BH_NavCell
            
            let lb99  = cell!.viewWithTag(99) as! UILabel
            lb99.layer.backgroundColor = con.bkcolor.CGColor
            lb99.layer.cornerRadius = 10
            
            let lb1  = cell!.viewWithTag(1) as! UILabel
            let lb2  = cell!.viewWithTag(2) as! UILabel
            let lb3  = cell!.viewWithTag(3) as! UILabel
            let lb4  = cell!.viewWithTag(4) as! UILabel
            
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
            
            lb1.text  = array[indexPath.row*n+0]
            
            lb2.layer.backgroundColor = con.bkcolor1.CGColor
            lb2.layer.cornerRadius = 12
            lb2.text  = array[indexPath.row*n+1]
            
            lb3.text  = array[indexPath.row*n+2] + " 盘"
            lb4.text  = array[indexPath.row*n+3] + " m³"
            
            lb11.text = array[indexPath.row*n+4]
            lb12.text = array[indexPath.row*n+5] + "%"
            lb13.text = array[indexPath.row*n+6]
            lb14.text = array[indexPath.row*n+7] + "%"
            
            lb21.text = array[indexPath.row*n+8]
            lb22.text = array[indexPath.row*n+9] + "%"
            lb23.text = array[indexPath.row*n+10]
            lb24.text = array[indexPath.row*n+11] + "%"
            
            lb31.text = array[indexPath.row*n+12]
            lb32.text = array[indexPath.row*n+13] + "%"
            lb33.text = array[indexPath.row*n+14]
            lb34.text = array[indexPath.row*n+15] + "%"
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
        print(url + departId + con.departId)
        
        Alamofire.request(.GET, url + departId + con.departId).responseJSON{ response in
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    let cnt = (JSON.valueForKey("data"))!.count
                    for(var i:Int=0; i<cnt; i++){
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("departName")! as! String)
                        
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("bhjCount")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("totalPanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("totalFangliang")! as! String)
                        //初级
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("cbpanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("cblv")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("czpanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("czlv")! as! String)
                        //中级
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("mcbpanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("mcblv")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("czpanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("czlv")! as! String)
                        //高级
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("hcbpanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("hcblv")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("czpanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("czlv")! as! String)
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
    
    //cell点击
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sub: BH_CbczVC = BH_CbczVC(nibName: "BH_CbczVC", bundle: nil)
        nv?.pushViewController(sub, animated: true)
    }
    
}