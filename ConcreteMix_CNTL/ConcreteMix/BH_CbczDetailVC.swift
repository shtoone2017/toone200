//
//  BH_CbczDetailVC.swift
//  ConcreteMix
//
//  Created by user on 15/10/5.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit
import Alamofire

class BH_CbczDetailVC: UIViewController,UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    var id = "-1"
    var sbbianhao = ""
    var name = ""
    var a = UserInfo()
    var chuzi = "0"
    var jieguobianhao = ""
    
    var imagePicker:UIImagePickerController!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_project: UILabel!
    @IBOutlet weak var uiscrollview: UIScrollView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lb_mc: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_projectNm: UILabel!
    @IBOutlet weak var lb_mixTime: UILabel!
    @IBOutlet weak var lb_number: UILabel!
    @IBOutlet weak var lb_gongdanNo: UILabel!
    @IBOutlet weak var lb_caozuoren: UILabel!
    @IBOutlet weak var lb_didian: UILabel!
    @IBOutlet weak var lb_buwei: UILabel!
    @IBOutlet weak var lb_waijiaPz: UILabel!
    @IBOutlet weak var lb_shuiniPz: UILabel!
    @IBOutlet weak var lb_shigongBh: UILabel!
    @IBOutlet weak var lb_qiangduDj: UILabel!
    
    //-------处置用控件--------------
    @IBOutlet weak var lb01: UILabel!
    @IBOutlet weak var lb02: UILabel!
    @IBOutlet weak var lb03: UILabel!
    @IBOutlet weak var lb04: UILabel!
    @IBOutlet weak var txt_yuanyin: UITextField!
    @IBOutlet weak var txt_jieguo: UITextField!
    @IBOutlet weak var txt_fangshi: UITextField!
    @IBOutlet weak var btn_time: UIButton!
    @IBOutlet weak var img_pic: UIImageView!
    @IBOutlet weak var lb_msg: UILabel!
    @IBOutlet weak var btn_photo: UIButton!
    @IBOutlet weak var btn_camera: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    //-----------------------------
    
    //Json Url & 参数 Begin##############################################################################################################################
    var url = con.AppHntChaobiaoListDetailURL
    var urlPost = con.AppHntChaobiaoChuzhiURL
    var bianhao = "bianhao="
    var shebeibianhao = "&shebeibianhao="
    //Json Url & 参数 End################################################################################################################################
    
    //数据接收部 Begin+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var array_nm:[String] = []
    var array_sj:[String] = []
    var array_ll:[String] = []
    var array_wc:[String] = []
    var array_wp:[String] = []
    var array_jt:[String] = []
    //数据接收部 End+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        //项目名
        lb_project.textColor = UIColor.whiteColor()
        lb_project.text = con.departName_BH_sel + ">拌和站管理>超标处置详情"
        lb_project.adjustsFontSizeToFitWidth  = true
        lb_project.font = UIFont.systemFontOfSize(17)
        
        //Label
        let btn_lb01 = UILabel(frame: CGRect(x: 5, y: 5, width: con.width - 20, height: 30))
        btn_lb01.layer.backgroundColor = con.bkcolor.CGColor
        btn_lb01.textColor = con.bkcolor1
        btn_lb01.font = UIFont.systemFontOfSize(15)
        btn_lb01.text = "   处置详情"
        btn_lb01.textAlignment = .Left
        btn_lb01.layer.cornerRadius = 5
        self.uiscrollview.addSubview(btn_lb01)
        //图标
        let img01 = UIImageView(frame: CGRect(x: con.width-40, y: 10, width:20 , height: 20))
        img01.image = UIImage(named: "detailList")
        self.uiscrollview.addSubview(img01)
        
        
        //Label
        let btn_lb02 = UILabel(frame: CGRect(x: 5, y: 250, width: con.width - 20, height: 30))
        btn_lb02.layer.backgroundColor = con.bkcolor.CGColor
        btn_lb02.textColor = con.bkcolor1
        btn_lb02.font = UIFont.systemFontOfSize(15)
        btn_lb02.text = "   材料详情"
        btn_lb02.textAlignment = .Left
        btn_lb02.layer.cornerRadius = 5
        self.uiscrollview.addSubview(btn_lb02)
        //图标
        let img02 = UIImageView(frame: CGRect(x: con.width-40, y: 255, width:20 , height: 20))
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
        uiscrollview.contentSize = CGSize(width: con.width-10, height: 1300)

        //显示与不显示 处置部分
        //if(( chuzi == "0" ) && (con.hntchaobiaoReal == true))
        if(con.hntchaobiaoReal == true)
        {
            showChuZhiBtn()
        }
        else
        {
            hiddenChuZhiBtn()
        }
        
        //加载数据
        getJsonData()
    }

    //处置相关函数----------------------------------------------------
    func showChuZhiBtn()
    {
        lb01.hidden = false
        lb02.hidden = false
        lb03.hidden = false
        lb04.hidden = false
        
        txt_yuanyin.hidden = false
        txt_jieguo.hidden = false
        txt_fangshi.hidden = false
        btn_time.hidden = false
        
        lb_msg.hidden = false
        btn_photo.hidden = false
        btn_camera.hidden = false
        btn_submit.hidden = false
        btn_cancel.hidden = false
        
        btn_submit.layer.cornerRadius = 3
        btn_submit.layer.backgroundColor = con.bkcolor1.CGColor
        btn_cancel.layer.cornerRadius = 3
        btn_cancel.layer.backgroundColor = con.bkcolor1.CGColor
        img_pic.layer.cornerRadius = 3
        img_pic.layer.borderWidth = 1
        img_pic.layer.borderColor = con.blueMore.CGColor
        
        self.txt_yuanyin.delegate = self
        self.txt_jieguo.delegate = self
        self.txt_fangshi.delegate = self
        
        let ns = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let strtime = dateFormat.stringFromDate(ns)
        btn_time.setTitle(strtime, forState: UIControlState.Normal)
        btn_time.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
    }
    
    func hiddenChuZhiBtn()
    {
        lb01.hidden = true
        lb02.hidden = true
        lb03.hidden = true
        lb04.hidden = true
        
        txt_yuanyin.hidden = true
        txt_jieguo.hidden = true
        txt_fangshi.hidden = true
        btn_time.hidden = true
        
        lb_msg.hidden = true
        btn_photo.hidden = true
        btn_camera.hidden = true
        btn_submit.hidden = true
        btn_cancel.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_sj.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell1") as UITableViewCell!
        if (cell == nil) {
            let nibs:NSArray = NSBundle.mainBundle().loadNibNamed("BH_SjcxDetailCell", owner: self, options: nil)
            cell = nibs.lastObject as! BH_SjcxDetailCell
            
            let lb1  = cell!.viewWithTag(1) as! UILabel
            let lb2  = cell!.viewWithTag(2) as! UILabel
            let lb3  = cell!.viewWithTag(3) as! UILabel
            let lb4  = cell!.viewWithTag(4) as! UILabel
            let lb5  = cell!.viewWithTag(5) as! UILabel
            let lb6  = cell!.viewWithTag(6) as! UILabel
            
            lb1.text  = array_nm[indexPath.row]
            lb2.text  = array_sj[indexPath.row]
            lb3.text  = array_ll[indexPath.row]
            lb4.text  = array_wc[indexPath.row]
            lb5.text  = array_wp[indexPath.row]
            lb6.text  = array_jt[indexPath.row]
        }
        
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }

    @IBAction func picChoose(sender: AnyObject) {
        showpic()
    }
    
    func showpic()
    {
        imagePicker = UIImagePickerController()
        imagePicker.delegate=self
        imagePicker.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.modalTransitionStyle=UIModalTransitionStyle.CoverVertical
        imagePicker.allowsEditing=true
        self.presentViewController(imagePicker, animated:true, completion: nil)
    }
    
    //delegate方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion:nil);
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let midImage:UIImage! = self.imageWithImageSimple(gotImage,scaledToSize:CGSizeMake(80,80))//这是对图片进行缩放，因为固定了长宽，所以这个方法会变型，有需要的自已去完善吧， 这里只是粗略使用。
        img_pic.image = midImage
        //upload(midImage)//上传
    }
    
    func imageWithImageSimple(image:UIImage,scaledToSize newSize:CGSize)->UIImage
    {
        UIGraphicsBeginImageContext(newSize);
        image.drawInRect(CGRectMake(0,0,newSize.width,newSize.height))
        let newImage:UIImage=UIGraphicsGetImageFromCurrentImageContext()
        print(UIGraphicsGetImageFromCurrentImageContext())
        
        UIGraphicsEndImageContext();
        return newImage;
    }
    
    
    @IBAction func goCamera(sender: AnyObject) {
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        var sourceType = UIImagePickerControllerSourceType.Camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true//设置可编辑
        picker.sourceType = sourceType
        self.presentViewController(picker, animated: true, completion: nil)//进入照相界面
    }
    
    @IBAction func back(sender: AnyObject) {
        self.txt_yuanyin.text = ""
        self.txt_jieguo.text = ""
        self.txt_fangshi.text = ""
        self.img_pic.image = nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let frame:CGRect = textField.frame
        //键盘高度216
        let offset = frame.origin.y - 400
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

    func getJsonData(){ 
        SVProgressHUD.show()
        print(url + bianhao + id + shebeibianhao + sbbianhao)
        Alamofire.request(.GET, url + bianhao + id + shebeibianhao + sbbianhao).responseJSON{ response in
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    self.lb_mc.text = self.name
                    self.lb_time.text = (JSON.valueForKey("data"))!.valueForKey("yuanchuliaoshijian")! as? String
                    self.lb_projectNm.text = (JSON.valueForKey("data"))!.valueForKey("gongchengmingcheng")! as? String
                    self.lb_mixTime.text = (JSON.valueForKey("data"))!.valueForKey("jiaobanshijian")! as? String
                    self.lb_number.text = (JSON.valueForKey("data"))!.valueForKey("gujifangshu")! as? String
                    self.lb_gongdanNo.text = (JSON.valueForKey("data"))!.valueForKey("gongdanhao")! as? String
                    self.lb_caozuoren.text = (JSON.valueForKey("data"))!.valueForKey("chaozuozhe")! as? String
                    self.lb_didian.text = (JSON.valueForKey("data"))!.valueForKey("sigongdidian")! as? String
                    self.lb_waijiaPz.text = (JSON.valueForKey("data"))!.valueForKey("waijiajipingzhong")! as? String
                    self.lb_buwei.text = (JSON.valueForKey("data"))!.valueForKey("jiaozuobuwei")! as? String
                    self.lb_shuiniPz.text = (JSON.valueForKey("data"))!.valueForKey("shuinipingzhong")! as? String
                    self.lb_shigongBh.text = (JSON.valueForKey("data"))!.valueForKey("peifanghao")! as? String
                    self.lb_qiangduDj.text = (JSON.valueForKey("data"))!.valueForKey("qiangdudengji")! as? String
                    //监理相关
                    self.txt_yuanyin.text = (JSON.valueForKey("data"))!.valueForKey("wentiyuanyin")! as? String
                    self.txt_jieguo.text = (JSON.valueForKey("data"))!.valueForKey("chulijieguo")! as? String
                    self.txt_fangshi.text = (JSON.valueForKey("data"))!.valueForKey("chulifangshi")! as? String
                    self.jieguobianhao = ((JSON.valueForKey("data"))!.valueForKey("jieguobianhao")! as? String)!
                    
                    let time1 = (JSON.valueForKey("data"))!.valueForKey("confirmdate")! as? String

                    if(time1!.characters.count >= 19)
                    {
                        let timeStr = (time1 as NSString!).substringToIndex(19)
                        self.btn_time.setTitle(timeStr, forState: UIControlState.Normal)
                    }
                    
                    var urlstr  = (JSON.valueForKey("data"))!.valueForKey("filepath")! as? String
                    urlstr = con.baseURL + urlstr!
                    if(urlstr != "")
                    {
                        if(NSData(contentsOfURL: NSURL(string: urlstr!)!) != nil)
                        {
                            self.img_pic.image = UIImage(data: NSData(contentsOfURL: NSURL(string: urlstr!)!)!)
                        }

                    }
                    
                    //材料名，实际，理论，误差，误差百分比
                    var nm:String?
                    var sj:String?
                    var ll:String?
                    var wc:String
                    var wp:String
                    
                    for(var i:Int=0; i<con.array_title_sj.count; i++){
                        nm = (JSON.valueForKey("hbfield"))!.valueForKey(con.array_title_sj[i]) as? String
                        sj = (JSON.valueForKey("data"))!.valueForKey(con.array_title_sj[i]) as? String
                        ll = (JSON.valueForKey("data"))!.valueForKey(con.array_title_ll[i]) as? String
                        if(sj != nil)
                        {
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
                            wc = String(format: "%.3f", wc_float)
                            wp = String(format: "%.3f", wp_float)
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
                }
            }
            SVProgressHUD.dismiss()
        }
    }
    
    //处置时间
    @IBAction func btn_time_Click(sender: AnyObject) {
        DatePickerLongDialog().show("DatePickerLongDialog", doneButtonTitle: "确定", cancelButtonTitle: "取消", datePickerMode: .Date) {
            (date) -> Void in
            self.btn_time.setTitle("\(date)", forState:UIControlState.Normal )
        }
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
        print("结果编号=\(jieguobianhao)")
        self.lb_msg.text = ""

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let ns:NSDate = dateFormatter.dateFromString(self.btn_time.titleLabel!.text!)!
        let long_time = Int(ns.timeIntervalSince1970.datatypeValue)
        print(String(long_time))
        
        let parameters = [
            "jieguobianhao" : self.jieguobianhao,
            "chaobiaoyuanyin" : self.txt_yuanyin.text!,
            "chuzhifangshi" : self.txt_fangshi.text!,
            "chuzhijieguo" : self.txt_jieguo.text!,
            "chuzhiren" : self.a.loadUserList(),
            "chuzhishijian" :String(long_time)
        ]

        let url = NSURL(string: con.AppHntChaobiaoChuzhiURL)
        var request = NSMutableURLRequest(URL: url!)
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: parameters)
        
        if(buttonIndex != alertView.cancelButtonIndex){
            if(self.img_pic.image == nil){
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
            else
            {
                request.HTTPMethod = "POST"
                
                //把图片写入临时文件夹
                let data = UIImagePNGRepresentation(self.img_pic.image!)
                print(NSHomeDirectory())
                let mydir1 = NSHomeDirectory() + "/Documents/"
                data!.writeToFile(mydir1 + "/\(self.jieguobianhao).jpg", atomically: true)
                let fileUrl = NSURL(string:mydir1 + "/\(self.jieguobianhao).jpg")
                
                Alamofire.upload(.POST, request, file:fileUrl!)
                    .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                        print(totalBytesWritten)
                        
                        // This closure is NOT called on the main queue for performance
                        // reasons. To update your ui, dispatch to the main queue.
                        dispatch_async(dispatch_get_main_queue()) {
                            print("Total bytes written on main queue: \(totalBytesWritten)")
                        }
                    }
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
        }
        SVProgressHUD.dismiss()
    }
}
