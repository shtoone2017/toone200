//
//  ViewController.swift
//  ConcreteMix
//
//  Created by user on 15/9/29.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITextFieldDelegate {
    // FIXME:  sg.1 -> 更改了ui布局

    @IBOutlet weak var v_passwordLine: UIView!
    @IBOutlet weak var v_userline: UIView!
    @IBOutlet weak var lb_version: UILabel!
    @IBOutlet weak var txt_user: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    

    @IBOutlet weak var superBgView: UIView!
    
    
    
    
    var a = UserInfo()
    
    //Json Url & 参数 Begin##############################################################################################################################
    var loginUrl = con.AppLogin
    var userName = "userName="
    var userPwd = "&userPwd="
    var OSType = "&OSType=3"
    //Json Url & 参数 End################################################################################################################################
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        //创建数据库
        let a = UserInfo()
        a.createTable_Code()
        btn_login.layer.cornerRadius = 5
        lb_version.text = con.version
        txt_user.setValue(UIColor.whiteColor(), forKeyPath: "_placeholderLabel.textColor")
        txt_password.setValue(UIColor.whiteColor(), forKeyPath: "_placeholderLabel.textColor")
        txt_user.text = a.loadUserList()
        txt_password.text = a.loadPassList()

        self.txt_user.delegate = self
        self.txt_password.delegate = self
        
         //MARK: sg.4 －> 键盘隐藏事件添加通知中心观察
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
   
    func keyboardWillHide(notification:NSNotification){
        let animationDuration:NSTimeInterval = 0.3
        UIView.beginAnimations("ResizeForKeyboard" , context: nil)
        UIView.setAnimationDuration(animationDuration)
        let rect:CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.frame = rect
        UIView.commitAnimations()
        txt_password.resignFirstResponder()
        txt_user.resignFirstResponder()
        
        
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    //FIXME: sg.2 ->
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("")
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func setNavBarVisible(visible:Bool, animated:Bool) {
        if (navBarIsVisible() == visible) { return }
        let frame = self.navigationController?.navigationBar.frame
        let offsetY = (visible ? CGFloat(0) : -64.0)
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.navigationController?.navigationBar.frame = CGRectOffset(frame!, 0, offsetY)
                return
            }
        }
    }
    
    func navBarIsVisible() ->Bool {
        print(self.navigationController?.navigationBar.frame.origin.y)
        return self.navigationController?.navigationBar.frame.origin.y > CGRectGetMinY(UIScreen.mainScreen().bounds)
    }
    //FIXME: sg.3 -> touch事件去除键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func btn_click(sender: AnyObject) {
        txt_user.resignFirstResponder()
        txt_password.resignFirstResponder()
        if(txt_user.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "")
        {
            self.btn_login.enabled = true
            let alert = UIAlertView()
            alert.title = "提示"
            alert.message = "请输入用户名"
            alert.addButtonWithTitle("取消")
            alert.addButtonWithTitle("确认")
            alert.cancelButtonIndex = 0
            alert.delegate = self
            alert.show()
            return
        }
        if(txt_password.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "")
        {
            self.btn_login.enabled = true
            let alert = UIAlertView()
            alert.title = "提示"
            alert.message = "请输入密码"
            alert.addButtonWithTitle("取消")
            alert.addButtonWithTitle("确认")
            alert.cancelButtonIndex = 0
            alert.delegate = self
            alert.show()
            return
        }
        
        a.saveUserList(txt_user.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()),password:txt_password.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
            getJsonData()
    }
    
    //隐藏导航
    func viewMove() {
        //键盘高度216
        let animationDuration:NSTimeInterval = 0.3
        UIView.beginAnimations("dropNav" , context: nil)
        UIView.setAnimationDuration(animationDuration)
        let width:CGFloat = self.view.frame.size.width
        let height:CGFloat = self.view.frame.size.height
        let rect:CGRect = CGRectMake(0.0, -70, width, height + 152)
        self.view.frame = rect
        UIView.commitAnimations()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //MARK: sg.6 view的移动
        let frame:CGRect = textField.superview!.frame
        let bgFrame:CGRect = superBgView.frame
        //键盘高度216
        let offset = frame.origin.y - 216 + bgFrame.origin.y
        print("offset=\(offset)")
        let animationDuration:NSTimeInterval = 0.3
        UIView.beginAnimations("ResizeForKeyBoard" , context: nil)
        UIView.setAnimationDuration(animationDuration)
        let width:CGFloat = self.view.frame.size.width
        let height:CGFloat = self.view.frame.size.height
        //用手机型号去判断
        if(self.view.frame.size.height <= con.iphone5_height){
            let rect:CGRect = CGRectMake(0.0, -offset, width, height)
            self.view.frame = rect
        }
        UIView.commitAnimations()
        
        //MARK:sg.7 编辑状态时line的颜色
        //设置line颜色
        if(textField == txt_user){
//            R:240 G:65 B:85  酒红色
            v_userline.backgroundColor = UIColor(red: 240/255.0, green: 65/255.0, blue: 85/255.0, alpha: 1.0)
        }else{
            v_passwordLine.backgroundColor = UIColor(red: 240/255.0, green: 65/255.0, blue: 85/255.0, alpha: 1.0)
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        //MARK:sg.8 结束编辑时line的颜色
        if(textField == txt_user){
            v_userline.backgroundColor = UIColor.whiteColor()
        }else{
            v_passwordLine.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //MARK: sg.5 修改return事件
        if (textField == txt_user){
            txt_user.resignFirstResponder()
            txt_password.becomeFirstResponder()
        }else{
            let animationDuration:NSTimeInterval = 0.3
            UIView.beginAnimations("ResizeForKeyboard" , context: nil)
            UIView.setAnimationDuration(animationDuration)
            let rect:CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
            self.view.frame = rect
            UIView.commitAnimations()
            textField.resignFirstResponder()
            self.btn_click(btn_login)
        }
        return true
    }
    
//    //颜色渐变
//    func turquoiseColor() -> CAGradientLayer {
//        let topColor = UIColor(red: 74/255.0, green: 112/255.0, blue: 139/255.0, alpha: 1.0)
//        let bottomColor = UIColor(red: 176/255.0, green: 226/255.0, blue: 255/255.0, alpha: 1.0)
//        let gradientColors: Array <AnyObject> = [topColor.CGColor, bottomColor.CGColor]
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//        
//        gradientLayer.colors = gradientColors
//        gradientLayer.locations = [0,1]
//        return gradientLayer
//    }
    
    
    //登陆
    func getJsonData(){
        SVProgressHUD.show()
        btn_login.enabled = false
        print(loginUrl + userName + txt_user.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + userPwd + txt_password.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        let urlString:String = loginUrl + userName + txt_user.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + userPwd + txt_password.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let encoding = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        Alamofire.request(.GET, encoding!).responseJSON{ response in
            
            if(response.result.isFailure == true)
            {
                SVProgressHUD.dismiss()
                self.btn_login.enabled = true
                let alert = UIAlertView()
                alert.title = "提示"
                alert.message = "无法连接服务器,请检查网络连接"
                alert.addButtonWithTitle("取消")
                alert.addButtonWithTitle("确认")
                alert.cancelButtonIndex = 0
                alert.delegate = self
                alert.show()
                return
            }
            
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){

                    con.departId = JSON.valueForKey("departId")! as! String
                    con.departName = JSON.valueForKey("departName")! as! String
                    
                    con.departId_Nav_SY_sel = JSON.valueForKey("departId")! as! String
                    con.departId_Nav_BH_sel = JSON.valueForKey("departId")! as! String
                    
                    con.departName_Nav_SY_sel = JSON.valueForKey("departName")! as! String
                    con.departName_Nav_BH_sel = JSON.valueForKey("departName")! as! String
                    
                    con.departId_SY_sel = JSON.valueForKey("departId")! as! String
                    con.departId_BH_sel = JSON.valueForKey("departId")! as! String
                    
                    con.departName_SY_sel = JSON.valueForKey("departName")! as! String
                    con.departName_BH_sel = JSON.valueForKey("departName")! as! String

                    //con.xmmc = JSON.valueForKey("xmmc")! as! String
                    con.type = JSON.valueForKey("type")! as! String
                    con.updateDepartTime = JSON.valueForKey("updateDepartTime")! as! String
                    //权限
                    con.hntchaobiaoReal = JSON.valueForKey("quanxian")!.valueForKey("hntchaobiaoReal")! as! Bool
                    con.hntchaobiaoSp = JSON.valueForKey("quanxian")!.valueForKey("hntchaobiaoSp")! as! Bool
                    con.syschaobiaoReal = JSON.valueForKey("quanxian")!.valueForKey("syschaobiaoReal")! as! Bool
                    con.userRole = JSON.valueForKey("userRole")! as! String

                    //组织机构树取得
                    //self.getJsonDataTree()
                    
                    let sb = UIStoryboard(name: "Main", bundle:nil)
                    
                    //注册TAG
                    let cnt = (JSON.valueForKey("SMSGroup"))!.count
                    for(var i:Int=0; i<cnt; i++){
                        let tag = (JSON.valueForKey("SMSGroup"))![i].valueForKey("name")! as! String
                        XGPush.setTag(tag, successCallback: { () -> Void in
                            print("设置TAG成功")
                            }, errorCallback: { () -> Void in
                                print("设置TAG失败")
                        })
                    }
                    
//                    con.userRole = "1"
//                    con.type = "SG"
//                    con.hntchaobiaoReal = false
//                    con.hntchaobiaoSp = false
                    SVProgressHUD.dismiss()
                    
                    //施工
                    if(con.type == "SG")
                    {
                        var vc:SGTBC
                        switch (con.userRole)
                        {
                        case "3":
                            vc = sb.instantiateViewControllerWithIdentifier("SGTBC_SY") as! SGTBC
                            break;
                        case "1":
                            vc = sb.instantiateViewControllerWithIdentifier("SGTBC_BH") as! SGTBC
                            break;
                        default:
                            vc = sb.instantiateViewControllerWithIdentifier("SGTBC") as! SGTBC
                            break;
                        }
                        //present方式
                        let item = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                        self.navigationItem.backBarButtonItem = item
                        self.navigationController?.pushViewController(vc, animated: true)

                    }
                    //领导
                    else
                    {
                        var vc:GLTBC
                        switch (con.userRole)
                        {
                        case "3":
                            vc = sb.instantiateViewControllerWithIdentifier("GLTBC_SY") as! GLTBC
                            break;
                        case "1":
                            vc = sb.instantiateViewControllerWithIdentifier("GLTBC_BH") as! GLTBC
                            break;
                        default:
                            vc = sb.instantiateViewControllerWithIdentifier("GLTBC") as! GLTBC
                            break;
                        }

                        //present方式
                        let item = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                        self.navigationItem.backBarButtonItem = item
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else
                {
                    SVProgressHUD.dismiss()
                    self.btn_login.enabled = true
                    let alert = UIAlertView()
                    alert.title = "提示"
                    alert.message = "用户或者密码不正确，请检查密码"
                    alert.addButtonWithTitle("取消")
                    alert.addButtonWithTitle("确认")
                    alert.cancelButtonIndex = 0
                    alert.delegate = self
                    alert.show()
                    return
                }
            }
            SVProgressHUD.dismiss()
            self.btn_login.enabled = true
        }
    }

}

