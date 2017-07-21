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

class BH_MenuNavVC: UIViewController, UITableViewDataSource, UITableViewDelegate,KSRefreshViewDelegate,BH_GLMenuVCrDelegate {
    
    @IBOutlet weak var barBtn: UITabBarItem!
    //步长
    var n:Int = 17
    //导航按钮常数
    var btnMenuValue = 1
    //选中的组织机构Index
    var i = 0
    
    var a = 0
    var btnLeft:Int = 5
    var btnTop:Int = 10
    var step:Int = 10
    var btnWidth:Int = 90
    var btnWidthDate:Int = 110
    let lbHegiht = 120
    
    var uiscrollview: UIScrollView!
    
    var dateFrom:UIButton!
    var dateTo:UIButton!
    var search:SFlatButton!
    var tableview:UITableView!
    var ShiYanShi:SFlatButton!
    var BanHeZhan:SFlatButton!
    //日期控件
    let date = NSDate()
    let formatter:NSDateFormatter = NSDateFormatter()
    var datetime = ""
    //屏幕宽度,高度
    var width:Int!
    var height:Int!
    //导航
    var nv:UINavigationController?
    
    //Json Url & 参数 Begin##############################################################################################################################
    var url = con.AppHntMainURL
    var departId = "departId="
    var startTime = "&startTime="
    var endTime = "&endTime="
    //Json Url & 参数 End################################################################################################################################
    
    //数据接收部 Begin+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var array:[String] = []
    var array_departId:[String] = []
    var array_departName:[String] = []
    //数据接收部 End+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        width = con.width
        height = con.height
        //scrollview
        uiscrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: con.width, height: con.height+500))
        self.view.addSubview(uiscrollview)
        
        //创建日期控件
        createDate()
        //创建TableView
        createTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        dateFrom = SFlatButton(frame: CGRect(x: btnLeft, y: btnTop + lbHegiht, width:btnWidthDate, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
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
        dateTo = SFlatButton(frame: CGRect(x: btnLeft + 10 + btnWidthDate, y: btnTop + lbHegiht, width:btnWidthDate, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
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
        search = SFlatButton(frame: CGRect(x: btnLeft + 15 + btnWidthDate*2, y: btnTop + lbHegiht, width:70, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
        search.backgroundColor = con.bkcolor1
        search.setTitleColor(UIColor.whiteColor(),forState: .Normal)
        search.setTitle("查询", forState:UIControlState.Normal)
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
        tableview = UITableView(frame: CGRect(x: 5, y: btnTop*5 + 10 + lbHegiht, width: con.width-20, height: con.height - btnTop*5 - 130))
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
        return array.count/self.n
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 150
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("array.count=\(array.count)")
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell1") as UITableViewCell!
        if (cell == nil) {
            let nibs:NSArray = NSBundle.mainBundle().loadNibNamed("BH_NavCell", owner: self, options: nil)
            cell = nibs.lastObject as! BH_NavCell
            
            if(indexPath.row >= array.count/n){
                return cell
            }
            
            let lb99  = cell!.viewWithTag(99) as! UILabel
            lb99.layer.backgroundColor = con.bkcolor.CGColor
            lb99.layer.cornerRadius = 5
            
            let lb1  = cell!.viewWithTag(1) as! UILabel
            let lb2  = cell!.viewWithTag(2) as! UILabel
            let lb3  = cell!.viewWithTag(3) as! UILabel
            let lb4  = cell!.viewWithTag(4) as! UILabel
            let lb5  = cell!.viewWithTag(5) as! UILabel
            
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
            lb2.text  = con.tranferStrToZero(array[indexPath.row*n+1])
            
            lb3.layer.backgroundColor = con.bkcolor1.CGColor
            lb3.layer.cornerRadius = 12
            lb3.text  = con.tranferStrToZero(array[indexPath.row*n+2])
            
            lb4.text  = con.tranferStrToZero(array[indexPath.row*n+3]) + " 盘"
            lb5.text  = con.tranferStrToZero(array[indexPath.row*n+4]) + " m³"
            
            lb11.text = con.tranferStrToZero(array[indexPath.row*n+5])
            lb12.text = con.tranferStrToZero(array[indexPath.row*n+6],addValue:true) + "%"
            lb13.text = con.tranferStrToZero(array[indexPath.row*n+7])
            lb14.text = con.tranferStrToZero(array[indexPath.row*n+8],addValue:true) + "%"
            
            lb21.text = con.tranferStrToZero(array[indexPath.row*n+9])
            lb22.text = con.tranferStrToZero(array[indexPath.row*n+10],addValue:true) + "%"
            lb23.text = con.tranferStrToZero(array[indexPath.row*n+11])
            lb24.text = con.tranferStrToZero(array[indexPath.row*n+12],addValue:true) + "%"
            
            lb31.text = con.tranferStrToZero(array[indexPath.row*n+13])
            lb32.text = con.tranferStrToZero(array[indexPath.row*n+14],addValue:true) + "%"
            lb33.text = con.tranferStrToZero(array[indexPath.row*n+15])
            lb34.text = con.tranferStrToZero(array[indexPath.row*n+16],addValue:true) + "%"
            
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "btn_menu:")
            lb1.tag = indexPath.row
            lb1.userInteractionEnabled = true
            lb1.addGestureRecognizer(tap)
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
        self.array_departName = []
        
        let long_starttime = con.getLongTime(dateFrom.titleLabel!.text!,flg:0)
        let long_endtime = con.getLongTime(dateTo.titleLabel!.text!,flg:1)
        let sttime = startTime + String(long_starttime)
        let ettime = endTime + String(long_endtime)
        
        print(url + departId + con.departId_Nav_BH_sel + sttime + ettime)
        Alamofire.request(.GET, url + departId + con.departId_Nav_BH_sel + sttime + ettime).responseJSON{ response in
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    let cnt = (JSON.valueForKey("data"))!.count
                    for(var i:Int=0; i<cnt; i++){
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("departName")! as! String)
                        
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("bhzCount")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("bhjCount")! as! String)
                        
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("totalPanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("totalFangliang")! as! String)
                        //初级
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("cbpanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("cblv")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("cczpanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("czlv")! as! String)
                        //中级
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("mcbpanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("mcblv")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("mczpanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("mczlv")! as! String)
                        //高级
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("hcbpanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("hcblv")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("hczpanshu")! as! String)
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("hczlv")! as! String)
                        
                        self.array_departId.append((JSON.valueForKey("data"))![i].valueForKey("departId")! as! String)
                        self.array_departName.append((JSON.valueForKey("data"))![i].valueForKey("departName")! as! String)
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
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let sub: BH_CbczVC = BH_CbczVC(nibName: "BH_CbczVC", bundle: nil)
//        self.navigationController?.pushViewController(sub, animated: true)
//    }
    
    //菜单导航
    func btn_menu(sender:AnyObject){
        let iStr = sender.view!?.tag
        i = Int(iStr!)
        self.displayViewController(.TopTop)
    }
    
    func displayViewController(animationType: SLpopupViewAnimationType) {
        let myPopupViewController:BH_GLMenuVC = BH_GLMenuVC(nibName:"BH_GLMenuVC", bundle: nil)
        myPopupViewController.delegate = self
        self.presentpopupViewController(myPopupViewController, animationType: animationType, completion: { () -> Void in
        })
    }
    
    func pressOK(value:Int) {
        print("press OK", terminator: "\n")
        btnMenuValue = value
        self.dismissPopupViewController(.Fade)
        print("已选中组织机构:" + self.array_departId[i])
        con.departId_BH_sel = self.array_departId[i]
        con.departName_BH_sel = self.array_departName[i]
        switch (self.btnMenuValue)
        {
        case 1://生产数据查询
            let sub: BH_SjcxVC = BH_SjcxVC(nibName: "BH_SjcxVC", bundle: nil)
            self.navigationController?.pushViewController(sub, animated: true)
            break;
        case 2://超标处置与查询
            let sub: BH_CbczVC = BH_CbczVC(nibName: "BH_CbczVC", bundle: nil)
            self.navigationController?.pushViewController(sub, animated: true)
            break;
        case 3://综合统计分析
            let sub: BH_Zhtf = BH_Zhtf(nibName: "BH_Zhtf", bundle: nil)
            self.navigationController?.pushViewController(sub, animated: true)
            break;
        default:
            let sub: BH_YltjVC = BH_YltjVC(nibName: "BH_YltjVC", bundle: nil)
            self.navigationController?.pushViewController(sub, animated: true)
            break;
        }
    }
    
}