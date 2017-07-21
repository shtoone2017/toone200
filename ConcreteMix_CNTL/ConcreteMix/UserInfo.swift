//
//  UserInfo.swift
//  ConcreteMix
//
//  Created by user on 15/10/5.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import SQLite

class UserInfo{
    
    var BidId:String = ""
    var user:String = ""
    var pass:String = ""
    
    //Json Url & 参数 Begin##############################################################################################################################
    var userName = "userName="
    var userPwd =  "&userPwd="
    //Json Url & 参数 End################################################################################################################################
    
    //Json Url & 参数 Begin##############################################################################################################################
    var username = "username="
    var biaoduanid = "&biaoduanid="
    var leixing = "&leixing"
    //Json Url & 参数 End################################################################################################################################
    
    //数据接收部 Begin+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    var array_Master:[String] = []
    //数据接收部 End+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    let CodeSql =
    "CREATE TABLE MSG (" +
        "id VARCHAR(20)," +
        "msg VARCHAR(100), " +
        "longdate DOUBLE)"
    
    let isExist = "SELECT COUNT(*) FROM sqlite_master where type='table' and name=?"
    
    let DropCodeSql = "DROP TABLE MSG"
    
    var stmt:Statement!
    var db:Connection!
    
    init(){
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory:String = paths.first as String!
        let path = documentsDirectory.stringByAppendingString("database.sqlite3")
        print("database.sqlite3路径:",path)
        do{
            db = try Connection(path)
        }
        catch{
            print("数据库连接失败")
        }
    }
    
    //=============================================================Code表=====================================================================================
    func createTable_Code(){
        var ok : Int64 = 1
        //先判断table是否存在
        for row in db.prepare("SELECT COUNT(*) FROM sqlite_master where type='table' and name=?","MSG") {
            ok = row[0] as! Int64!
        }
        //存在就先清空数据
        if(ok != 1){
//            //DROP数据库
//            do{
//                try db.run(DropCodeSql)
//            }
//            catch{
//                print("数据库DROP失败")
//            }
            //创建数据库
            do{
                try db.execute(CodeSql)
            }
            catch{
                print("数据库创建失败")
            }
        }
        

    }
    
    func insertTable_Data(id:String, msg:String, longdate:Double){
        stmt = db.prepare("INSERT INTO MSG (id, msg, longdate) VALUES (?, ?, ?)")
        do{
            try stmt.run(id, msg, longdate)
        }
        catch{
            print("数据库INSERT失败")
        }
    }
    
    
    func getTable_Msg_Data(from:Int, to:Int)->[MsgData]{
        var data:[MsgData] = []
        for row in db.prepare("SELECT msg, longdate FROM MSG WHERE longdate >= ? and longdate<= ? order by longdate desc", from, to) {
            let d  = MsgData()
            d.msg = row[0] as! String
            d.longdate = row[1] as! Double
            data.append(d)
        }
        return data
    }
    
    func getTable_Code_Id(code:String, BidId:String)->[String]{
        var Id:[String] = []
        for row in db.prepare("SELECT id FROM Code WHERE Code = ? and BidId = ?", code, BidId) {
            Id.append(row[0] as! String)
        }
        return Id
    }
    
    
    //=============================================================用户ID===================================================================================
    
    //获取沙盒路径
    func documentsDirectory() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory:String = paths.first as String!
        return documentsDirectory
    }
    
    //获取数据文件地址
    func dataSQLPath() -> String{
        return self.documentsDirectory().stringByAppendingString("/database.sqlite3")
    }
    
    //获取数据文件地址
    func dataFilePath() -> String{
        return self.documentsDirectory().stringByAppendingString("UserLists.plist")
    }
    
    //获取标段文件地址
    func dataBidPath() -> String{
        return self.documentsDirectory().stringByAppendingString("BidLists.plist")
    }
    
    //获取用户ID
    func loadUserList() -> String{
        let path = self.dataFilePath()
        let defaultManager = NSFileManager()
        var user:String = ""
        if defaultManager.fileExistsAtPath(path){
            let data = NSData(contentsOfFile:path)
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
            user = unarchiver.decodeObjectForKey("User") as! String
            unarchiver.finishDecoding()
        }else{
            user = ""
        }
        return user
    }
    
    //获取用户密码
    func loadPassList() -> String{
        let path = self.dataFilePath()
        let defaultManager = NSFileManager()
        var user:String = ""
        if defaultManager.fileExistsAtPath(path){
            let data = NSData(contentsOfFile:path)
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
            user = unarchiver.decodeObjectForKey("Pass") as! String
            unarchiver.finishDecoding()
        }else{
            user = ""
        }
        return user
    }
    //获取标段
    func loadBidIdList() -> String{
        let path = self.dataBidPath()
        let defaultManager = NSFileManager()
        var user:String = ""
        if defaultManager.fileExistsAtPath(path){
            let data = NSData(contentsOfFile:path)
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data!)
            user = unarchiver.decodeObjectForKey("BidId") as! String
            unarchiver.finishDecoding()
        }else{
            user = ""
        }
        return user
    }
    
    //保存用户
    func saveUserList(user:String,password:String){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(user, forKey: "User")
        archiver.encodeObject(password, forKey: "Pass")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    //保存标段
    func saveBidIdList(BidId:String){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(BidId, forKey: "BidId")
        archiver.finishEncoding()
        data.writeToFile(dataBidPath(), atomically: true)
    }
}