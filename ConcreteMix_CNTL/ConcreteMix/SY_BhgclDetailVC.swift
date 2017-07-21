//
//  SY_BhgclDetailVC.swift
//  ConcreteMix
//
//  Created by user on 15/10/4.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit

class SY_BhgclDetailVC: UIViewController,UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    var id = ""
    var name = ""
    
    var imagePicker:UIImagePickerController!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_project: UILabel!
    @IBOutlet weak var uiscrollview: UIScrollView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lb_mc: UILabel!
    @IBOutlet weak var lb_shiyanshiNm: UILabel!
    @IBOutlet weak var lb_shiyanNm: UILabel!
    @IBOutlet weak var lb_projectNm: UILabel!
    @IBOutlet weak var lb_shigongBw: UILabel!
    @IBOutlet weak var lb_weituoBh: UILabel!
    @IBOutlet weak var lb_shijianBh: UILabel!
    @IBOutlet weak var lb_shiyanDate: UILabel!
    @IBOutlet weak var lb_lingqi: UILabel!
    @IBOutlet weak var lb_shijianCc: UILabel!
    @IBOutlet weak var lb_shijiQd: UILabel!
    @IBOutlet weak var lb_daibiaoQd: UILabel!
    @IBOutlet weak var lb_pingzhongBm: UILabel!
    @IBOutlet weak var lb_guigeZl: UILabel!
    @IBOutlet weak var lb_gongchengZj: UILabel!
    @IBOutlet weak var lb_caozuoRy: UILabel!
    @IBOutlet weak var lb_hege: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txt_yuanyin: UITextField!
    @IBOutlet weak var txt_jieguo: UITextField!
    @IBOutlet weak var txt_fangshi: UITextField!
    @IBOutlet weak var img_pic: UIImageView!
    
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        btn_submit.layer.cornerRadius = 3
        btn_submit.layer.backgroundColor = con.bkcolor1.CGColor
        btn_cancel.layer.cornerRadius = 3
        btn_cancel.layer.backgroundColor = con.bkcolor1.CGColor
        img_pic.layer.cornerRadius = 3
        img_pic.layer.borderWidth = 1
        img_pic.layer.borderColor = con.blueMore.CGColor
        
        //Label
        let btn_lb01 = UILabel(frame: CGRect(x: 5, y: 5, width: con.width - 20, height: 30))
        btn_lb01.layer.backgroundColor = con.bkcolor.CGColor
        btn_lb01.textColor = con.bkcolor1
        btn_lb01.font = UIFont.systemFontOfSize(15)
        btn_lb01.text = "   混凝土强度试验详情"
        btn_lb01.textAlignment = .Left
        btn_lb01.layer.cornerRadius = 5
        self.uiscrollview.addSubview(btn_lb01)
        //图标
        let img01 = UIImageView(frame: CGRect(x: con.width-40, y: 10, width:20 , height: 20))
        img01.image = UIImage(named: "detailList")
        self.uiscrollview.addSubview(img01)
        
        
        //Label
        let btn_lb02 = UILabel(frame: CGRect(x: 5, y: 330, width: con.width - 20, height: 30))
        btn_lb02.layer.backgroundColor = con.bkcolor.CGColor
        btn_lb02.textColor = con.bkcolor1
        btn_lb02.font = UIFont.systemFontOfSize(15)
        btn_lb02.text = "   力值曲线查询"
        btn_lb02.textAlignment = .Left
        btn_lb02.layer.cornerRadius = 5
        self.uiscrollview.addSubview(btn_lb02)
        //图标
        let img02 = UIImageView(frame: CGRect(x: con.width-40, y: 335, width:20 , height: 20))
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
        uiscrollview.contentSize = CGSize(width: con.width-10, height: 1100)
        self.txt_yuanyin.delegate = self
        self.txt_jieguo.delegate = self
        self.txt_fangshi.delegate = self
        
        lb_mc.text = "混凝土抗压"
        lb_shiyanshiNm.text = "WT-XXXXXXXXXXXXXXXXX1"
        lb_shiyanNm.text = "NNNNNNNNNNN1"
        lb_projectNm.text = "NNNNNNNNNNN2"
        lb_shigongBw.text = "NNNNNNNNNNN3"
        lb_weituoBh.text = "NNNNNNNNNNN4"
        lb_shijianBh.text = "NNNNNNNNNNN5"
        lb_shiyanDate.text = "2015-10-05"
        lb_shijianCc.text = "100*100*1001"
        lb_shijiQd.text = "C31"
        lb_lingqi.text = "21"
        lb_daibiaoQd.text = "22"
        lb_pingzhongBm.text = "NNNNNNNNNNN6"
        lb_guigeZl.text = "NNNNNNNNNNN7"
        lb_gongchengZj.text = "23"
        lb_caozuoRy.text = "jsck"
        img.image = UIImage(named: "ng")
        lb_hege.text = "不合格"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell1") as UITableViewCell!
        if (cell == nil) {
            let nibs:NSArray = NSBundle.mainBundle().loadNibNamed("SY_BhgclDetailCell", owner: self, options: nil)
            cell = nibs.lastObject as! SY_BhgclDetailCell
            
            let lb1  = cell!.viewWithTag(1) as! UILabel
            let lb2  = cell!.viewWithTag(2) as! UILabel
            let lb3  = cell!.viewWithTag(3) as! UILabel
            let lb4  = cell!.viewWithTag(4) as! UILabel
            
            lb1.text  = "1"
            lb2.text  = "33.1"
            lb3.text  = "445.7"
            lb4.text  = "C29"
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
        let offset = frame.origin.y - 216
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
    

}
