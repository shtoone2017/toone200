//
//  SY_GjDetailVC.swift
//  ConcreteMix
//
//  Created by user on 15/10/4.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit
import Charts
import Alamofire

class SY_GjDetailVC: UIViewController,UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,ChartViewDelegate {

    //步长
    var n:Int = 1
    
    var titleVC = ""
    var id = ""
    var name = ""
    var shebeibianhao = ""
    //处置显示FLG
    var chuzhiFlg = "0"//0不处置 1处置
    
    var url = ""
    var a = UserInfo()
    
    var xVals_array:[[String]] = []
    var yval_array:[[ChartDataEntry]] = []
    
    var xVals:[String] = []
    var yval:[ChartDataEntry] = []
    
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_project: UILabel!
    @IBOutlet weak var uiscrollview: UIScrollView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lb_mc: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_projectNm: UILabel!
    @IBOutlet weak var lb_projectBw: UILabel!
    @IBOutlet weak var lb_shijianBh: UILabel!
    @IBOutlet weak var lb_zhijing: UILabel!
    @IBOutlet weak var lb_pingzhong: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lb_hege: UILabel!
    
    //list
    @IBOutlet weak var lb_list01: UILabel!
    @IBOutlet weak var lb_list02: UILabel!
    @IBOutlet weak var lb_list03: UILabel!
    
    
    //-------处置用控件--------------
    @IBOutlet weak var lb01: UILabel!
    @IBOutlet weak var txt_yuanyin: UITextField!
    @IBOutlet weak var lb_msg: UILabel!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    //-----------------------------
    
    let _chartView = LineChartView(frame:CGRect(x: 0, y: 440, width: con.width-20, height: 300))
    
    //Json Url & 参数 Begin##############################################################################################################################
    var SYJID = "SYJID="
    //Json Url & 参数 End################################################################################################################################
    
    //数据接收部 Begin+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var array_QFLZ:[String] = []
    var array_QFQD:[String] = []
    var array_LZ:[String] = []
    var array_LZQD:[String] = []
    var array_SCL:[String] = []
    //数据接收部 End+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        //显示与不显示 处置部分
        if( chuzhiFlg == "0" )
        {
            hiddenChuZhiBtn()
        }
        else
        {
            showChuZhiBtn()
        }
        
        //项目名
        lb_project.textColor = UIColor.whiteColor()
        lb_project.text = con.departName_SY_sel + ">试验室管理>" + titleVC
        lb_project.adjustsFontSizeToFitWidth  = true
        lb_project.font = UIFont.systemFontOfSize(17)
        //list显示
        lb_list01.hidden = true
        lb_list02.hidden = true
        lb_list03.hidden = true
        
        switch titleVC
        {
        case "钢筋拉力详情":
            url = con.gangjinDetailURL
            lb_list01.hidden = false
            lb_list02.hidden = false
            lb_list03.hidden = false
            break
        case "钢筋焊接接头详情":
            url = con.gangjinhanjiejietouDetailURL
            break
        case "钢筋机械连接接头详情":
            url = con.gangjinlianjiejietouDetailURL
            break
        default:
            break
        }
        
        //Label
        let btn_lb01 = UILabel(frame: CGRect(x: 5, y: 5, width: con.width - 20, height: 30))
        btn_lb01.layer.backgroundColor = con.bkcolor.CGColor
        btn_lb01.textColor = con.bkcolor1
        btn_lb01.font = UIFont.systemFontOfSize(15)
        btn_lb01.text = "   试验详情"
        btn_lb01.textAlignment = .Left
        btn_lb01.layer.cornerRadius = 5
        self.uiscrollview.addSubview(btn_lb01)
        //图标
        let img01 = UIImageView(frame: CGRect(x: con.width-40, y: 10, width:20 , height: 20))
        img01.image = UIImage(named: "detailList")
        self.uiscrollview.addSubview(img01)
        
        
        //Label
        let btn_lb02 = UILabel(frame: CGRect(x: 5, y: 240, width: con.width - 20, height: 30))
        btn_lb02.layer.backgroundColor = con.bkcolor.CGColor
        btn_lb02.textColor = con.bkcolor1
        btn_lb02.font = UIFont.systemFontOfSize(15)
        btn_lb02.text = "   力值曲线"
        btn_lb02.textAlignment = .Left
        btn_lb02.layer.cornerRadius = 5
        self.uiscrollview.addSubview(btn_lb02)
        //图标
        let img02 = UIImageView(frame: CGRect(x: con.width-40, y: 245, width:20 , height: 20))
        img02.image = UIImage(named: "detailList")
        self.uiscrollview.addSubview(img02)
        
        
        self.view.backgroundColor = con.bkcolor
        lb_title.backgroundColor = con.bkcolor1
        
        uiscrollview.layer.cornerRadius = 15
        uiscrollview.backgroundColor = UIColor.whiteColor()
        
        self.title = "拌和站与试验室信息管理"
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.backgroundColor = UIColor.whiteColor()
        uiscrollview.contentSize = CGSize(width: con.width - 10, height: 1330)

        //加载数据
        getJsonData()
        
        // Do any additional setup after loading the view.

    }

    func getJsonData(){
        SVProgressHUD.show()
        
        print(url + SYJID + id)
        Alamofire.request(.GET, url + SYJID + id).responseJSON{ response in
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    self.lb_mc.text = self.name
                    self.lb_time.text = (JSON.valueForKey("data"))!.valueForKey("SYRQ")! as? String
                    self.lb_projectNm.text = (JSON.valueForKey("data"))!.valueForKey("GCMC")! as? String
                    self.lb_projectBw.text = (JSON.valueForKey("data"))!.valueForKey("SGBW")! as? String
                    self.lb_shijianBh.text = (JSON.valueForKey("data"))!.valueForKey("SJBH")! as? String
                    self.lb_zhijing.text = (JSON.valueForKey("data"))!.valueForKey("GGZL")! as? String
                    self.lb_pingzhong.text = (JSON.valueForKey("data"))!.valueForKey("PZBM")! as? String
                    self.lb_hege.text = (JSON.valueForKey("data"))!.valueForKey("PDJG")! as? String
                    self.txt_yuanyin.text = (JSON.valueForKey("data"))!.valueForKey("chuli")! as? String
                    
                    if(self.lb_hege.text == "合格")
                    {
                        self.img.image = UIImage(named: "good")
                    }
                    else
                    {
                        self.img.image = UIImage(named: "ng")
                    }
                    
                    //屈服力值，屈服强度，最大力值，抗拉强度，伸长率
                    let str_QFLZ = (JSON.valueForKey("data"))!.valueForKey("QFLZ")! as? String
                    let str_QFQD = (JSON.valueForKey("data"))!.valueForKey("QFQD")! as? String
                    let str_LZ = (JSON.valueForKey("data"))!.valueForKey("LZ")! as? String
                    let str_LZQD = (JSON.valueForKey("data"))!.valueForKey("LZQD")! as? String
                    let str_SCL = (JSON.valueForKey("data"))!.valueForKey("SCL")! as? String
                    self.array_QFLZ = str_QFLZ!.componentsSeparatedByString("&")
                    self.array_QFQD = str_QFQD!.componentsSeparatedByString("&")
                    self.array_LZ = str_LZ!.componentsSeparatedByString("&")
                    self.array_LZQD = str_LZQD!.componentsSeparatedByString("&")
                    self.array_SCL = str_SCL!.componentsSeparatedByString("&")
                    
                    //曲线X，Y
                    let str_YSKYLZ = (JSON.valueForKey("data"))!.valueForKey("f_LZ")! as? String
                    let str_SJGC = (JSON.valueForKey("data"))!.valueForKey("f_SJ")! as? String
                    let array_YSKYLZ = str_YSKYLZ!.componentsSeparatedByString("&")
                    let array_SJGC = str_SJGC!.componentsSeparatedByString("&")
                    
                    //y
                    for(var i:Int = 0; i < array_YSKYLZ.count; i++)
                    {
                        var yvalArray = array_YSKYLZ[i].componentsSeparatedByString(",")
                        var yvalTmp:[ChartDataEntry] = []
                        //
                        for(var j:Int = 0; j < yvalArray.count; j++)
                        {
                            let val:Double = (yvalArray[j] as NSString).doubleValue
                            yvalTmp.append(ChartDataEntry(value: val, xIndex: j))
                        }
                        self.yval_array.append(yvalTmp)
                    }
                    
                    //x
                    for(var i:Int = 0; i < array_SJGC.count; i++)
                    {
                        var xVals_array = array_SJGC[i].componentsSeparatedByString(",")
                        var xValsTmp:[String] = []
                        //
                        for(var j:Int = 0; j < xVals_array.count; j++)
                        {
                            let value:Double = (xVals_array[j] as NSString).doubleValue///1000
                            let s = String(format: "%.1f", value)
                            xValsTmp.append(s)
                        }
                        self.xVals_array.append(xValsTmp)
                    }
                    if(self.yval_array.count != 0)
                    {
                        self.xVals = self.xVals_array[0]
                        self.yval = self.yval_array[0]
                        self.createLine()
                    }
                    self.tableview.reloadData()
                }
            }
            SVProgressHUD.dismiss()
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_LZ.count/n
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 35
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell1") as UITableViewCell!
        if (cell == nil) {
            let nibs:NSArray = NSBundle.mainBundle().loadNibNamed("SY_GjDetailCell", owner: self, options: nil)
            cell = nibs.lastObject as! SY_GjDetailCell
            
            let lb1  = cell!.viewWithTag(1) as! UILabel
            let lb2  = cell!.viewWithTag(2) as! UILabel
            let lb3  = cell!.viewWithTag(3) as! UILabel
            let lb4  = cell!.viewWithTag(4) as! UILabel
            let lb5  = cell!.viewWithTag(5) as! UILabel
            let lb6  = cell!.viewWithTag(6) as! UILabel
            
            if(self.titleVC == "钢筋拉力详情")
            {
                lb1.text  = array_QFLZ[indexPath.row*n+0]
                lb2.text  = array_QFQD[indexPath.row*n+0]
                lb5.text  = array_SCL[indexPath.row*n+0]
            }
            lb3.text  = array_LZ[indexPath.row*n+0]
            lb4.text  = array_LZQD[indexPath.row*n+0]
            
            lb6.layer.backgroundColor = con.blueMore.CGColor
            lb6.layer.cornerRadius = 5
        }
        
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.xVals = self.xVals_array[indexPath.row]
        self.yval = self.yval_array[indexPath.row]
        createLine()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLine(){
        _chartView.setNeedsDisplay()
        _chartView.delegate = self
        _chartView.descriptionText = ""
        
        _chartView.highlightEnabled = true
        _chartView.data?.highlightEnabled = true
        _chartView.dragEnabled = true
        _chartView.setScaleEnabled(true)
        _chartView.pinchZoomEnabled = true
        _chartView.drawGridBackgroundEnabled = false
        _chartView.leftAxis.labelTextColor = con.blueMore
        _chartView.rightAxis.enabled = false
        
        let xAxis:ChartXAxis = _chartView.xAxis;
        xAxis.labelFont = UIFont.systemFontOfSize(12)
        xAxis.labelTextColor = con.blueMore
        xAxis.drawGridLinesEnabled = true
        xAxis.drawAxisLineEnabled = true
        xAxis.spaceBetweenLabels = 1
        //X轴显示居下面
        xAxis.labelPosition = .Bottom
        
        let yAxis:ChartYAxis = _chartView.leftAxis
        yAxis.drawLimitLinesBehindDataEnabled = true
        
        
        _chartView.legend.form = ChartLegend.ChartLegendForm.Line
        _chartView.legend.font = UIFont.systemFontOfSize(9)
        _chartView.legend.textColor = con.blueMore
        _chartView.legend.position = ChartLegend.ChartLegendPosition.BelowChartLeft
        
        //点击点，显示数字
        let marker:BalloonMarker = BalloonMarker(color: con.blueMore, font: UIFont.systemFontOfSize(9), insets: UIEdgeInsets.init(top: 8, left: 8, bottom: 20, right: 20))
        _chartView.marker = marker
        
        //设置线的属性
        let set1 = LineChartDataSet(yVals: yval, label: "力值")
        set1.setColor(con.blueMore)
        set1.setCircleColor(con.blueMore)
        set1.lineWidth = 1.0
        set1.circleRadius = 3.0
        set1.drawCircleHoleEnabled = false
        set1.valueFont = UIFont.systemFontOfSize(9)
        set1.highlightColor = con.blueMore
        set1.fillAlpha = 0.5
        set1.fillColor = con.blueMore
        set1.drawFilledEnabled = true
        set1.drawValuesEnabled = false
        //带小数设置
        let formatter  = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        set1.valueFormatter = formatter
        
        
        //曲线
        set1.drawCubicEnabled = true
        //封装
        let data = LineChartData(xVals: xVals, dataSets: [set1])
        data.setValueTextColor(con.blueMore)
        data.setValueFont(UIFont.systemFontOfSize(9))
        _chartView.data = data
        _chartView.animate(xAxisDuration: 3, yAxisDuration: 3)
        self.uiscrollview.addSubview(_chartView)
        
        yAxis.startAtZeroEnabled = true
    }
    
    //处置相关函数----------------------------------------------------
    func showChuZhiBtn()
    {
        lb01.hidden = false
        txt_yuanyin.hidden = false
        lb_msg.hidden = false
        btn_submit.hidden = false
        btn_cancel.hidden = false
        
        btn_submit.layer.cornerRadius = 3
        btn_submit.layer.backgroundColor = con.bkcolor1.CGColor
        btn_cancel.layer.cornerRadius = 3
        btn_cancel.layer.backgroundColor = con.bkcolor1.CGColor
        
        self.txt_yuanyin.delegate = self
    }
    
    func hiddenChuZhiBtn()
    {
        lb01.hidden = true
        txt_yuanyin.hidden = true
        lb_msg.hidden = true
        btn_submit.hidden = true
        btn_cancel.hidden = true
    }
    
    @IBAction func back(sender: AnyObject) {
        self.txt_yuanyin.text = ""
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let frame:CGRect = textField.frame
        //键盘高度216
        let offset = frame.origin.y - 510
        let animationDuration:NSTimeInterval = 0.3
        UIView.beginAnimations("ResizeForKeyBoard" , context: nil)
        UIView.setAnimationDuration(animationDuration)
        let width:CGFloat = self.view.frame.size.width
        let height:CGFloat = self.view.frame.size.height
        let rect:CGRect = CGRectMake(0.0, -offset, width, height)
        self.view.frame = rect
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let animationDuration:NSTimeInterval = 0.3
        UIView.beginAnimations("ResizeForKeyboard" , context: nil)
        UIView.setAnimationDuration(animationDuration)
        let rect:CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.frame = rect
        UIView.commitAnimations()
        textField.resignFirstResponder()
        return true
    }
    
    //提交处置
    @IBAction func submit(sender: AnyObject) {
        self.lb_msg.text = ""
        let alert = UIAlertView()
        alert.title = "系统提示"
        alert.message = "您确认要提交吗？"
        alert.addButtonWithTitle("取消")
        alert.addButtonWithTitle("确认")
        alert.cancelButtonIndex = 0
        alert.delegate = self
        alert.show()
    }
    
    //post图片
    func alertView(alertView:UIAlertView,clickedButtonAtIndex buttonIndex:Int){
        SVProgressHUD.show()
        print("编号=\(self.id)")
        self.lb_msg.text = ""
        
        let parameters = [
            "SYJID" : self.id,
            "chaobiaoyuanyin" : self.txt_yuanyin.text!
        ]
        
        let url = NSURL(string: con.AppChaobiaoChuzhiURL)
        var request = NSMutableURLRequest(URL: url!)
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: parameters)
        
        if(buttonIndex != alertView.cancelButtonIndex){
            request.HTTPMethod = "POST"
            Alamofire.request(request)
                //Alamofire.request(.POST, con.AppHntChaobiaoChuzhiURL,parameters: parameters, encoding: .URL)
                .responseJSON { response in
                    debugPrint(response)
                    let flg = response.result.value?.valueForKey("success") as! Bool
                    if(flg == true)
                    {
                        self.lb_msg.text = "提交成功"
                    }
                    else
                    {
                        self.lb_msg.text = "提交失败"
                    }
                    SVProgressHUD.dismiss()
            }
        }
        SVProgressHUD.dismiss()
    }

}
