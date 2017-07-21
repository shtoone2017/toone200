//
//  Constant.swift
//  ConcreteMix
//
//  Created by user on 15/9/29.
//  Copyright © 2015年 shtoone. All rights reserved.
//

import UIKit

struct con {
    static let bkcolor  = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)//灰色
    static let bkcolor1    = UIColor(red: 86/255, green: 143/255, blue: 213/255, alpha: 1)//蓝色
    static let lightGrayColor = UIColor.lightGrayColor()
    static let bkcolorview    = UIColor.whiteColor()
    static let blueMore    = UIColor(red: 88/255, green: 120/255, blue: 145/255, alpha: 1)//深蓝色
    
    static let cell1    = UIColor(red: 78/255, green: 100/255, blue: 132/255, alpha: 1)
    static let cell2    = UIColor(red: 78/255, green: 100/255, blue: 132/255, alpha: 1)
    static let lbcolor1 = UIColor.whiteColor()
    static let btncolor1 = UIColor(red: 243.0, green: 243.0, blue: 243.0, alpha: 1)
    static let btnBlue = UIColor(red: 0/255, green: 245/255, blue: 255/255, alpha: 0.8)
    static let btnOrange = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 0.8)
    static let btnLime = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 0.8)
    static let btnLime1 = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1)
    static let LineColor1 = UIColor(red: 255/255.0, green: 211/255.0, blue: 155/255.0, alpha: 1.0)
    
    static let sthhmmss1 = " 00:00:00"
    static let ethhmmss1 = " 23:59:59"
    static let pagecnt = 15
    //屏幕长
    static let iphone5_height:CGFloat = 568.0
    static let iphone6_height:CGFloat = 667.0
    static let iphone6p_height:CGFloat = 736.0
    
    //scrollview的y点
    static let yValue:Int = 70
    //信鸽token串
    static var deviceTokenStr = ""
    
    //屏幕宽
    static var width = 0
    static var height = 0
    //组织机构List
    static var arrayTree:[Node] = []
    //试验室类型
    static let Hntqd = "100014"
    static let Gjll = "100047"
    static let Gjhjjt = "100048"
    static let Gjjxljjt = "100049"
    //版本
    static let version = "CopyRight:2015-2016"
    //App版本
    static let AppVersion = "ver1.0"
    
    //当前的组织机构ID（登录时）
    static var departId = ""
    //当前的组织机构名称（登录时）
    static var departName = ""
    
    //当前的组织机构ID（导航－试验）
    static var departId_Nav_SY_sel = ""
    //当前的组织机构名称（导航－试验）
    static var departName_Nav_SY_sel = ""
    
    //当前的组织机构ID（导航－拌和站）
    static var departId_Nav_BH_sel = ""
    //当前的组织机构名称（导航－拌和站）
    static var departName_Nav_BH_sel = ""
    
    //当前的组织机构ID（试验）
    static var departId_SY_sel = ""
    //当前的组织机构名称（试验）
    static var departName_SY_sel = ""
    
    //当前的组织机构ID（拌和站）
    static var departId_BH_sel = ""
    //当前的组织机构名称（拌和站）
    static var departName_BH_sel = ""
    
    //项目名称
    //static var xmmc = ""
    //type:SG（施工）GL(管理)
    static var type = ""
    //组织机构更新时间
    static var updateDepartTime = ""
    //权限(水泥 超标处置)
    static var hntchaobiaoReal = true
    //权限(水泥 超标审批)
    static var hntchaobiaoSp = true
    //权限(试验 超标处置)
    static var syschaobiaoReal = true
    //界面权限
    static var userRole = ""//1水泥拌和站    2沥青拌和站    3试验室    4，项目部，(不管他)
    
    //url  (默认云南公投)
    /*
    云南公投:        "http://121.40.150.65:8082/yngt/"
    吴中城际铁路:     "http://120.26.127.135:8082/hntapp/"
    川南城际:        "http://120.26.127.135:8083/tcn/"                
    */
//    static let baseURL = "http://120.26.127.135:8083/tcn/"
    static let baseURL = "http://192.168.11.117:8080/tcncjqms/"
    //试验室-混凝土试件抗压强度试验
    static let hntkangyaURL = baseURL + "sysController.do?hntkangya&"
    static let hntkangyaDetailURL = baseURL + "sysController.do?hntkangyaDetail&"
    //试验室-钢筋试验
    static let gangjinURL = baseURL + "sysController.do?gangjin&"
    static let gangjinDetailURL = baseURL + "sysController.do?gangjinDetail&"
    //试验室-钢筋焊接接头试验
    static let gangjinhanjiejietouURL = baseURL + "sysController.do?gangjinhanjiejietou&"
    static let gangjinhanjiejietouDetailURL = baseURL + "sysController.do?gangjinhanjiejietouDetail&"
    //试验室-钢筋机械连接接头试验
    static let gangjinlianjiejietouURL = baseURL + "sysController.do?gangjinlianjiejietou&"
    static let gangjinlianjiejietouDetailURL = baseURL + "sysController.do?gangjinlianjiejietouDetail&"
    //试验室-获取生产数据列表
    static let AppHntXiangxiListURL = baseURL + "app.do?AppHntXiangxiList&"
    static let AppHntXiangxiListDetailURL = baseURL + "app.do?AppHntXiangxiDetail&"
    //试验室-超标查询POST
    static let AppChaobiaoChuzhiURL = baseURL + "sysController.do?hntkangyaPost"
    //水泥－获取标段及以上用户登陆的统计信息
    static let AppHntMainURL = baseURL + "app.do?AppHntMain&"
    static let sysHomeURL = baseURL + "sysController.do?sysHome&"
    //水泥－超标查询
    static let AppHntChaobiaoListURL = baseURL + "app.do?AppHntChaobiaoList&"
    static let AppHntChaobiaoListDetailURL = baseURL + "app.do?AppHntChaobiaoDetail&"
    //水泥－超标处置POST
    static let AppHntChaobiaoChuzhiURL = baseURL + "app.do?AppHntChaobiaoChuzhi"
    //水泥－超标审批POST
    static let AppHntChaobiaoShenpiURL = baseURL + "app.do?AppHntChaobiaoShenpi"
    //水泥－材料用量核算
    static let AppHntMaterialURL = baseURL + "app.do?AppHntMaterial&"
    //组织机构树
    static let AppDepartTreeURL = baseURL + "app.do?AppDepartTree"
    //设备列表
    static let getShebeiListURL = baseURL + "app.do?getShebeiList&"//水泥
    static let getSysShebeiList = baseURL + "sysController.do?getSysShebeiList&"//试验室
    //试验室Menu数据取得
    static let shiyanshiMenuURL = baseURL + "sysController.do?sysMainLogo&"
    //水泥Menu数据取得
    static let hntMainLogoURL = baseURL + "app.do?hntMainLogo&"
    //App登陆
    static let AppLogin = baseURL + "app.do?AppLogin&"
    //水泥－综合统分
    static let hntCountAnalyzeURL = baseURL + "app.do?hntCountAnalyze&"
    //试验－综合统分
    static let sysCountAnalyzeURL = baseURL + "sysController.do?sysCountAnalyze&"
    //拌合机状态
    static let AppHntBanhejiStateURL = baseURL + "app.do?AppHntBanhejiState&"

    
    ////水泥
    //#data   lilunzhi : 理论
    static let array_title_ll =
       [
        //--水
        "shui1_lilunzhi","shui2_lilunzhi","shui3_lilunzhi","shui4_lilunzhi","shui5_lilunzhi","shui6_lilunzhi","shui7_lilunzhi","shui8_lilunzhi","shui9_lilunzhi","shui10_lilunzhi",
        //--水泥
        "shuini1_lilunzhi","shuini2_lilunzhi","shuini3_lilunzhi","shuini4_lilunzhi","shuini5_lilunzhi","shuini6_lilunzhi","shuini7_lilunzhi","shuini8_lilunzhi","shuini9_lilunzhi","shuini10_lilunzhi",
        //--外加剂,减水剂
        "waijiaji1_lilunzhi","waijiaji2_lilunzhi","waijiaji3_lilunzhi","waijiaji4_lilunzhi","waijiaji5_lilunzhi","waijiaji6_lilunzhi","waijiaji7_lilunzhi","waijiaji8_lilunzhi","waijiaji9_lilunzhi","waijiaji10_lilunzhi",
        //--煤灰
        "feimeihui1_lilunzhi","feimeihui2_lilunzhi","feimeihui3_lilunzhi","feimeihui4_lilunzhi","feimeihui5_lilunzhi","feimeihui6_lilunzhi","feimeihui7_lilunzhi","feimeihui8_lilunzhi","feimeihui9_lilunzhi","feimeihui10_lilunzhi",
        //--砂,碎石
        "shi1_lilunzhi","shi2_lilunzhi","shi3_lilunzhi","shi4_lilunzhi","shi5_lilunzhi","shi6_lilunzhi","shi7_lilunzhi","shi8_lilunzhi","shi9_lilunzhi","shi10_lilunzhi",
        //矿粉
        "kuangfen1_lilunzhi","kuangfen2_lilunzhi","kuangfen3_lilunzhi","kuangfen4_lilunzhi","kuangfen5_lilunzhi","kuangfen6_lilunzhi","kuangfen7_lilunzhi","kuangfen8_lilunzhi","kuangfen9_lilunzhi","kuangfen10_lilunzhi",
        //--粉料
        "fenliao1_lilunzhi","fenliao2_lilunzhi","fenliao3_lilunzhi","fenliao4_lilunzhi","fenliao5_lilunzhi","fenliao6_lilunzhi","fenliao7_lilunzhi","fenliao8_lilunzhi","fenliao9_lilunzhi","fenliao10_lilunzhi",
        //--砂
        "sha1_lilunzhi","sha2_lilunzhi","sha3_lilunzhi","sha4_lilunzhi","sha5_lilunzhi","sha6_lilunzhi","sha7_lilunzhi","sha8_lilunzhi","sha9_lilunzhi","sha10_lilunzhi",
        //--骨料
        "guliao1_lilunzhi","guliao2_lilunzhi","guliao3_lilunzhi","guliao4_lilunzhi","guliao5_lilunzhi","guliao6_lilunzhi","guliao7_lilunzhi","guliao8_lilunzhi","guliao9_lilunzhi","guliao10_lilunzhi"
        ]
    
    //#data   shijizhi : 实际
    static let array_title_sj =
    [
        //--水
        "shui1_shijizhi","shui2_shijizhi","shui3_shijizhi","shui4_shijizhi","shui5_shijizhi","shui6_shijizhi","shui7_shijizhi","shui8_shijizhi","shui9_shijizhi","shui10_shijizhi",
        //--水泥
        "shuini1_shijizhi","shuini2_shijizhi","shuini3_shijizhi","shuini4_shijizhi","shuini5_shijizhi","shuini6_shijizhi","shuini7_shijizhi","shuini8_shijizhi","shuini9_shijizhi","shuini10_shijizhi",
        //--外加剂,减水剂
        "waijiaji1_shijizhi","waijiaji2_shijizhi","waijiaji3_shijizhi","waijiaji4_shijizhi","waijiaji5_shijizhi","waijiaji6_shijizhi","waijiaji7_shijizhi","waijiaji8_shijizhi","waijiaji9_shijizhi","waijiaji10_shijizhi",
        //--煤灰
        "feimeihui1_shijizhi","feimeihui2_shijizhi","feimeihui3_shijizhi","feimeihui4_shijizhi","feimeihui5_shijizhi","feimeihui6_shijizhi","feimeihui7_shijizhi","feimeihui8_shijizhi","feimeihui9_shijizhi","feimeihui10_shijizhi",
        //--砂,碎石
        "shi1_shijizhi","shi2_shijizhi","shi3_shijizhi","shi4_shijizhi","shi5_shijizhi","shi6_shijizhi","shi7_shijizhi","shi8_shijizhi","shi9_shijizhi","shi10_shijizhi",
        //矿粉
        "kuangfen1_shijizhi","kuangfen2_shijizhi","kuangfen3_shijizhi","kuangfen4_shijizhi","kuangfen5_shijizhi","kuangfen6_shijizhi","kuangfen7_shijizhi","kuangfen8_shijizhi","kuangfen9_shijizhi","kuangfen10_shijizhi",
        //--粉料
        "fenliao1_shijizhi","fenliao2_shijizhi","fenliao3_shijizhi","fenliao4_shijizhi","fenliao5_shijizhi","fenliao6_shijizhi","fenliao7_shijizhi","fenliao8_shijizhi","fenliao9_shijizhi","fenliao10_shijizhi",
        //--砂
        "sha1_shijizhi","sha2_shijizhi","sha3_shijizhi","sha4_shijizhi","sha5_shijizhi","sha6_shijizhi","sha7_shijizhi","sha8_shijizhi","sha9_shijizhi","sha10_shijizhi",
        //--骨料
        "guliao1_shijizhi","guliao2_shijizhi","guliao3_shijizhi","guliao4_shijizhi","guliao5_shijizhi","guliao6_shijizhi","guliao7_shijizhi","guliao8_shijizhi","guliao9_shijizhi","guliao10_shijizhi"
    ]
    
//    //#data   wucha : 误差
//    static let array_title_sj =
//    [
//        //--水
//        "shw1","shw2","shw3","shw4","shw5","shw6","shw7","shw8","shw9","shw10",
//        //--水泥
//        "flw1","flw2","flw3","flw4","flw5","flw6","flw7","flw8","flw9","flw10",
//        //--外加剂,减水剂
//        "wjw1","wjw2","wjw3","wjw4","wjw5","wjw6","wjw7","wjw8","wjw9","wjw10",
//        //--煤灰
//        "flw1","flw2","flw3","flw4","flw5","flw6","flw7","flw8","flw9","flw10",
//        //--砂,碎石
//        "shi1_shijizhi","shi2_shijizhi","shi3_shijizhi","shi4_shijizhi","shi5_shijizhi","shi6_shijizhi","shi7_shijizhi","shi8_shijizhi","shi9_shijizhi","shi10_shijizhi",
//        //--粉料
//        "fenliao1_shijizhi","fenliao2_shijizhi","fenliao3_shijizhi","fenliao4_shijizhi","fenliao5_shijizhi","fenliao6_shijizhi","fenliao7_shijizhi","fenliao8_shijizhi","fenliao9_shijizhi","fenliao10_shijizhi",
//        //--砂
//        "sha1_shijizhi","sha2_shijizhi","sha3_shijizhi","sha4_shijizhi","sha5_shijizhi","sha6_shijizhi","sha7_shijizhi","sha8_shijizhi","sha9_shijizhi","sha10_shijizhi",
//        //--骨料
//        "glw1","glw2","glw3","glw4","glw5","glw6","glw7","glw8","glw9","glw10"
//    ]
    
    
    //返回时间戳
    static func getLongTime(datestr:String, flg:Int) -> Int {
        var strtime = datestr.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if(flg==0){
            strtime = strtime + con.sthhmmss1
        }else{
            strtime = strtime + con.ethhmmss1
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let ns:NSDate = dateFormatter.dateFromString(strtime)!
        let long_time = Int(ns.timeIntervalSince1970.datatypeValue)
        return long_time
    }
    
    static func tranferStrToZero(str:String, addValue:Bool = false) -> String{
        if(str == "")
        {
            if(addValue == false)
            {
                return "0"
            }
            else
            {
                return "0.00"
            }
        }
        else
        {
            return str
        }
    }
}
