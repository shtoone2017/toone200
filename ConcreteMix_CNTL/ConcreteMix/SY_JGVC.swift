//
//  SY_JGVC.swift
//  ConcreteMix
//
//  Created by user on 15/10/21.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit
import Alamofire

class SY_JGVC: UIViewController,TreeTableCellDelegate,KSRefreshViewDelegate {

    var tableview: TreeTableView!
    var delegate : GroupIDSelectDelegate?
    var IGroupID = ""
    var IType = ""
    var IFuntype = ""
    var strGroupID = ""
    var strGroupName = ""
    
    //Json Url & 参数 Begin##############################################################################################################################
    var url = con.AppDepartTreeURL
    var userGroupId = "&userGroupId="
    var updateDepartTime = "&updateDepartTime="
    var type = "&type="
    var funtype = "&funtype="
    //Json Url & 参数 End################################################################################################################################
    
    //数据接收部 Begin+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var array:[Node] = []
    //数据接收部 End+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(IFuntype == "3")
        {
            self.title = con.departName_SY_sel + ">试验室管理>组织机构"
        }
        else
        {
            self.title = con.departName_BH_sel + ">拌和站管理>组织机构"
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "Heiti SC", size: 13.0)!]
        //加载树
        getJsonDataTree()
        
        //按钮
        let OkBtn = SFlatButton(frame: CGRect(x: 20, y:con.height - 40, width: 80, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        OkBtn.backgroundColor = con.blueMore
        OkBtn.setTitle("确  定", forState: UIControlState.Normal)
        OkBtn.addTarget(self, action: "btn_OkClick:", forControlEvents: UIControlEvents.TouchDown)
        self.view.addSubview(OkBtn)
    }

    //确定按钮
    func btn_OkClick(sender: UIButton){
        if(strGroupID != "")
        {
            delegate?.GroupIDSelect(strGroupID,GroupName: strGroupName,ctl:self)
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    func cellClick(node: Node!) {
        print(node.name)
        print(node.nodeId)
        strGroupID = node.nodeId
        strGroupName = node.name
    }
    
    func getJsonDataTree(){
        self.array = []
        con.arrayTree = []
        SVProgressHUD.show()
        
        let ns:NSDate = NSDate()
        let long_time = Int(ns.timeIntervalSince1970.datatypeValue)
        
        print(url + userGroupId + IGroupID + type + IType + funtype + IFuntype + updateDepartTime + String(long_time))
        Alamofire.request(.GET, url + userGroupId + IGroupID + type + IType + funtype + IFuntype + updateDepartTime + String(long_time)).responseJSON{ response in
            
            //取得JSON
            if let JSON = response.result.value {
                let success = JSON.valueForKey("success") as! Bool
                //取得有数据时
                if(success == true){
                    let cnt = (JSON.valueForKey("data"))!.count
                    if(cnt == 0)
                    {
                        SVProgressHUD.dismiss()
                        return
                    }
                    for(var i:Int=0; i<cnt; i++){
                        let node = Node()
                        node.parentId = (JSON.valueForKey("data"))![i].valueForKey("parentdepartid")! as! String
                        node.nodeId = (JSON.valueForKey("data"))![i].valueForKey("ID")! as! String
                        node.name = (JSON.valueForKey("data"))![i].valueForKey("departname")! as! String
                        self.array.append(node)
                    }
                    //处理树
                    var level:Int = 0
                    for(var i:Int=0; i<self.array.count; i++){
                        level = 0
                        if(self.array[i].parentId == "")
                        {
                            level = 0
                        }
                        else
                        {
                            self.findtreeLevel(self.array[i],tree:self.array,i:0, level:&level)
                        }
                        //所有节点都展开
                        self.array[i].expand = true
                        self.array[i].depth = Int32(level)
                    }
                    
                    for(var i:Int=0; i<self.array.count; i++){
                        if(self.array[i].parentId == "")
                        {
                            con.arrayTree.append(self.array[i])
                        }
                    }
                    let rootCnt = con.arrayTree.count
                    //递归添加子节点
                    for(var i:Int=0; i < rootCnt; i++){
                        self.addTreeNode(con.arrayTree[i],tree:self.array,treeCons:&con.arrayTree)
                    }
                    print(con.arrayTree.count)
                    //树
                    self.tableview = TreeTableView(frame: CGRect(x: 5, y: 65, width: con.width-10, height: con.height - 120), withData: con.arrayTree, type:self.IType)
                    self.view.backgroundColor = con.bkcolor1
                    self.tableview.treeTableCellDelegate = self
                    self.tableview.layer.cornerRadius = 10
                    self.view.addSubview(self.tableview)
                }
            }
            SVProgressHUD.dismiss()
        }
    }
    
    //找出节点的层级
    func findtreeLevel(treeNode:Node, tree:[Node], var i:Int, inout level:Int){
        if(treeNode.parentId == tree[i].nodeId){
            
            let treeNodeTmp = Node()
            treeNodeTmp.nodeId = tree[i].nodeId
            treeNodeTmp.parentId = tree[i].parentId
            
            //            treeNode.nodeId = tree[i].nodeId
            //            treeNode.parentId = tree[i].parentId
            level++
            i = 0
            findtreeLevel(treeNodeTmp, tree:tree, i:i, level:&level)
        }
        else{
            if(treeNode.parentId == ""){
                return;
            }else{
                i++
                findtreeLevel(treeNode, tree:tree, i:i, level:&level)
            }
        }
    }
    
    //从上到下添加树节点
    func addTreeNode(treeNode:Node, tree:[Node], inout treeCons:[Node]){
        for(var i:Int = 0; i<tree.count; i++)
        {
            if(treeNode.nodeId == tree[i].parentId)
            {
                treeCons.append(tree[i])
                addTreeNode(tree[i], tree:tree, treeCons:&treeCons)
            }
        }
    }
}
