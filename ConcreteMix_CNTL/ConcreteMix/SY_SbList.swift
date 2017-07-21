//
//  SY_SbList.swift
//  ConcreteMix
//
//  Created by user on 15/11/23.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit
import Alamofire

class SY_SbList: UITableViewController {
    
    //组织机构ID
    var GroupId = ""
    //设备类型
    var type = ""
    //步长
    var n:Int = 1
    var delegate : SheBeiSelectDelegate?
    //设备ID
    var strDeviceID = ""
    var strDeviceName = ""

    
    @IBOutlet var tableview: UITableView!
    
    //Json Url & 参数 Begin##############################################################################################################################
    var url = ""
    var userGroupId   = "userGroupId="
    //Json Url & 参数 End################################################################################################################################
    
    //数据接收部 Begin+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var array:[String] = ["全部设备"]
    var array_id:[String] = ["-1"]
    //数据接收部 End+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //判断调用的URL
        if(type == "1")//水泥
        {
            url = con.getShebeiListURL + "shebeiType=1&"
        }
        else//试验室
        {
            url = con.getSysShebeiList
        }
        self.navigationController?.navigationBar.barTintColor = con.bkcolor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "Heiti SC", size: 20.0)!]
        self.view.backgroundColor = con.bkcolor
        self.title="请选择设备"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        getJsonData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count/n
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mycell1") as UITableViewCell!
        if (cell == nil) {
            let nibs:NSArray = NSBundle.mainBundle().loadNibNamed("SY_SbListCell", owner: self, options: nil)
            cell = nibs.lastObject as! SY_SbListCell
            
            if(indexPath.row >= array.count/n){
                return cell
            }
            
            let lb1  = cell!.viewWithTag(1) as! UILabel
            lb1.text  = array[indexPath.row*n+0]
            
        }
        
        cell.layer.cornerRadius = 5;
        cell!.selectionStyle = UITableViewCellSelectionStyle.Blue
        cell!.accessoryType = UITableViewCellAccessoryType.None
        return cell!
    }
    
    func getJsonData(){
        SVProgressHUD.show()
        print(url + userGroupId + GroupId)
        print("设备件数\(array.count)")
        Alamofire.request(.GET, url + userGroupId + GroupId).responseJSON{ response in
            
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    let cnt = (JSON.valueForKey("data"))!.count
                    for(var i:Int=0; i<cnt; i++){
                        self.array.append((JSON.valueForKey("data"))![i].valueForKey("banhezhanminchen")! as! String)
                        //试验室唯一主键Id
                        self.array_id.append((JSON.valueForKey("data"))![i].valueForKey("gprsbianhao")! as! String)
                    }
                }
            }
            self.tableview.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        strDeviceID = array_id[indexPath.row]
        strDeviceName = array[indexPath.row]
        if(strDeviceID != "")
        {
            delegate?.SheBeiSelect(strDeviceID,SheBeiName:strDeviceName, ctl: self)
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
}
