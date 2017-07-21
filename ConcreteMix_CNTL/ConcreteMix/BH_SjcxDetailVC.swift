//
//  BH_SjcxDetailVC.swift
//  ConcreteMix
//
//  Created by user on 15/10/5.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit
import Alamofire

class BH_SjcxDetailVC: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var id = "-1"
    var name = ""
    
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_project: UILabel!
    @IBOutlet weak var uiscrollview: UIScrollView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lb_mc: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_projectNm: UILabel!
    @IBOutlet weak var lb_mixTime: UILabel!
    @IBOutlet weak var lb_gongdanNo: UILabel!
    @IBOutlet weak var lb_caozuoren: UILabel!
    @IBOutlet weak var lb_didian: UILabel!
    @IBOutlet weak var lb_buwei: UILabel!
    @IBOutlet weak var lb_waijiaPz: UILabel!
    @IBOutlet weak var lb_shuiniPz: UILabel!
    @IBOutlet weak var lb_shigongBh: UILabel!
    @IBOutlet weak var lb_qiangduDj: UILabel!

    //Json Url & 参数 Begin##############################################################################################################################
    var url = con.AppHntXiangxiListDetailURL
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
        lb_project.text = con.departName_BH_sel + ">拌和站管理>生产数据详情"
        lb_project.adjustsFontSizeToFitWidth  = true
        lb_project.font = UIFont.systemFontOfSize(17)
        
        //Label
        let btn_lb01 = UILabel(frame: CGRect(x: 5, y: 5, width: con.width - 20, height: 30))
        btn_lb01.layer.backgroundColor = con.bkcolor.CGColor
        btn_lb01.textColor = con.bkcolor1
        btn_lb01.font = UIFont.systemFontOfSize(15)
        btn_lb01.text = "   生产详情"
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
        uiscrollview.contentSize = CGSize(width: con.width - 10, height: 900)
        
        //加载数据
        SVProgressHUD.show()
        getJsonData()
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
        return 60
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
    
    func getJsonData(){
        print(url + bianhao + id)
        Alamofire.request(.GET, url + bianhao + id).responseJSON{ response in
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    self.lb_mc.text = self.name
                    self.lb_time.text = (JSON.valueForKey("data"))!.valueForKey("chuliaoshijian")! as? String
                    self.lb_projectNm.text = (JSON.valueForKey("data"))!.valueForKey("gongchengmingcheng")! as? String
                    self.lb_mixTime.text = (JSON.valueForKey("data"))!.valueForKey("jiaobanshijian")! as? String
                    self.lb_gongdanNo.text = (JSON.valueForKey("data"))!.valueForKey("gongdanhao")! as? String
                    self.lb_caozuoren.text = (JSON.valueForKey("data"))!.valueForKey("chaozuozhe")! as? String
                    self.lb_didian.text = (JSON.valueForKey("data"))!.valueForKey("sigongdidian")! as? String
                    //方量
                    self.lb_waijiaPz.text = (JSON.valueForKey("data"))!.valueForKey("gujifangshu")! as? String
                    self.lb_buwei.text = (JSON.valueForKey("data"))!.valueForKey("jiaozuobuwei")! as? String
                    self.lb_shuiniPz.text = (JSON.valueForKey("data"))!.valueForKey("shuinipingzhong")! as? String
                    self.lb_shigongBh.text = (JSON.valueForKey("data"))!.valueForKey("peifanghao")! as? String
                    self.lb_qiangduDj.text = (JSON.valueForKey("data"))!.valueForKey("qiangdudengji")! as? String
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


}
