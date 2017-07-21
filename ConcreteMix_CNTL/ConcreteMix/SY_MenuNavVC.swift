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

class SY_MenuNavVC: UIViewController, UITableViewDataSource, UITableViewDelegate,KSRefreshViewDelegate,SY_GLMenuVCrDelegate {
    
    @IBOutlet weak var barBtn: UITabBarItem!
    //组织机构ID
    var departId_Old = ""
    //步长
    var n:Int = 19
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

    
    //Json Url & 参数 Begin##############################################################################################################################
    var url = con.sysHomeURL
    var userGroupId = "userGroupId="
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
        dateFrom = SFlatButton(frame: CGRect(x: btnLeft, y: lbHegiht + btnTop, width:btnWidthDate, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
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
        dateTo = SFlatButton(frame: CGRect(x: btnLeft + 10 + btnWidthDate, y: lbHegiht + btnTop, width:btnWidthDate, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
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
        search = SFlatButton(frame: CGRect(x: btnLeft + 15 + btnWidthDate*2, y: lbHegiht + btnTop, width:70, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBLabel)
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
        tableview = UITableView(frame: CGRect(x: 5, y: lbHegiht + btnTop*5 + 10, width: con.width-20, height: con.height - btnTop*5 - 200))
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
        return 160
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell1") as UITableViewCell!
        if (cell == nil) {
            let nibs:NSArray = NSBundle.mainBundle().loadNibNamed("SY_NavCell", owner: self, options: nil)
            cell = nibs.lastObject as! SY_NavCell
            
            if(indexPath.row >= array.count/n){
                return cell
            }
            
            let lb99  = cell!.viewWithTag(99) as! UILabel
            lb99.layer.backgroundColor = con.bkcolor.CGColor
            lb99.layer.cornerRadius = 5
            
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
//            let lb91  = cell!.viewWithTag(91) as! UILabel
//            let lb92  = cell!.viewWithTag(92) as! UILabel
//            let lb93  = cell!.viewWithTag(93) as! UILabel
//            let lb94  = cell!.viewWithTag(94) as! UILabel
            
            lb1.text  = array[indexPath.row*n+0]
            
            lb2.layer.backgroundColor = con.bkcolor1.CGColor
            lb2.layer.cornerRadius = 12
            lb2.text  = con.tranferStrToZero(array[indexPath.row*n+1])
            
            lb3.layer.backgroundColor = con.bkcolor1.CGColor
            lb3.layer.cornerRadius = 12
            lb3.text  = con.tranferStrToZero(array[indexPath.row*n+2])
            
            lb11.text = con.tranferStrToZero(array[indexPath.row*n+3])
            lb12.text = con.tranferStrToZero(array[indexPath.row*n+4])
            lb13.text = con.tranferStrToZero(array[indexPath.row*n+5])
            lb14.text = con.tranferStrToZero(array[indexPath.row*n+6],addValue:true) + "%"
            
            
            lb21.text = con.tranferStrToZero(array[indexPath.row*n+7])
            lb22.text = con.tranferStrToZero(array[indexPath.row*n+8])
            lb23.text = con.tranferStrToZero(array[indexPath.row*n+9])
            lb24.text = con.tranferStrToZero(array[indexPath.row*n+10],addValue:true) + "%"
            
            lb31.text = con.tranferStrToZero(array[indexPath.row*n+11])
            lb32.text = con.tranferStrToZero(array[indexPath.row*n+12])
            lb33.text = con.tranferStrToZero(array[indexPath.row*n+13])
            lb34.text = con.tranferStrToZero(array[indexPath.row*n+14],addValue:true) + "%"
            
            lb41.text = con.tranferStrToZero(array[indexPath.row*n+15])
            lb42.text = con.tranferStrToZero(array[indexPath.row*n+16])
            lb43.text = con.tranferStrToZero(array[indexPath.row*n+17])
            lb44.text = con.tranferStrToZero(array[indexPath.row*n+18],addValue:true) + "%"

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
        
        //比较用
        departId_Old = ""
        
        let long_starttime = con.getLongTime(dateFrom.titleLabel!.text!,flg:0)
        let long_endtime = con.getLongTime(dateTo.titleLabel!.text!,flg:1)
        let sttime = startTime + String(long_starttime)
        let ettime = endTime + String(long_endtime)
        
        print(self.url + userGroupId + con.departId_Nav_SY_sel + sttime + ettime)
        Alamofire.request(.GET, url + userGroupId + con.departId_Nav_SY_sel + sttime + ettime).responseJSON{ response in
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
                            return;
                            self.array_departId.append(((JSON.valueForKey("data"))![i].valueForKey("userGroupId"))
                                as! String)
                            self.array_departName.append((JSON.valueForKey("data"))![i].valueForKey("departName")! as! String)
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
                                self.array_departName.append((JSON.valueForKey("data"))![i].valueForKey("departName")! as! String)
                                //添加新一组数据
                                self.resetArray((JSON.valueForKey("data"))![i].valueForKey("departName")! as! String)
                                //试验室COUNT
                                self.array[index*self.n + 1] = (JSON.valueForKey("data"))![i].valueForKey("sysCount")! as! String
                                //试验机COUNT
                                self.array[index*self.n + 2] = (JSON.valueForKey("data"))![i].valueForKey("syjCount")! as! String
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
    
    //菜单导航
    func btn_menu(sender:AnyObject){
        let iStr = sender.view!?.tag
        i = Int(iStr!)
        self.displayViewController(.TopTop)
    }
    
    func displayViewController(animationType: SLpopupViewAnimationType) {
        let myPopupViewController:SY_GLMenuVC = SY_GLMenuVC(nibName:"SY_GLMenuVC", bundle: nil)
        myPopupViewController.delegate = self
        self.presentpopupViewController(myPopupViewController, animationType: animationType, completion: { () -> Void in
        })
    }
    
    func pressOK(value:Int) {
        print("press OK", terminator: "\n")
        btnMenuValue = value
        self.dismissPopupViewController(.Fade)
        print("已选中组织机构:" + self.array_departId[i])
        con.departId_SY_sel = self.array_departId[i]
        con.departName_SY_sel = self.array_departName[i]
        switch (self.btnMenuValue)
        {
        case 1://混凝土强度
            let sub: SY_HntqdVC = SY_HntqdVC(nibName: "SY_HntqdVC", bundle: nil)
            self.navigationController?.pushViewController(sub, animated: true)
            break;
        case 2://钢筋拉力
            let sub: SY_GjVC = SY_GjVC(nibName: "SY_GjVC", bundle: nil)
            sub.titleVC = "钢筋拉力"
            self.navigationController?.pushViewController(sub, animated: true)
            break;
        case 3://钢筋焊接接头
            let sub: SY_GjVC = SY_GjVC(nibName: "SY_GjVC", bundle: nil)
            sub.titleVC = "钢筋焊接接头"
            self.navigationController?.pushViewController(sub, animated: true)
            break;
        case 4://钢筋机械连接接头
            let sub: SY_GjVC = SY_GjVC(nibName: "SY_GjVC", bundle: nil)
            sub.titleVC = "钢筋机械连接接头"
            self.navigationController?.pushViewController(sub, animated: true)
            break;
        case 5://综合统计分析
            let sub: SY_Zhtf = SY_Zhtf(nibName: "SY_HntqdVC", bundle: nil)
            self.navigationController?.pushViewController(sub, animated: true)
            break;
        default:
            let sub: SY_BhgclVC = SY_BhgclVC(nibName: "SY_BhgclVC", bundle: nil)
            self.navigationController?.pushViewController(sub, animated: true)
            break;
        }
    }
}