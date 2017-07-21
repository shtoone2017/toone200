//
//  DrawingView.swift
//  Metro
//
//  Created by user on 15/6/13.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class SSBarPlus: UIView {
    
    let PI = 3.14159265358979323846
    //初始原点X
    var left:Int = 20
    //初始原点Y
    var top:Int  = 20
    //第一个Bar距离初始原点的距离
    var xLeft:Int = 10
    //Bar的宽度
    var barWiddth:Int = 15
    //X轴长
    var xSet:Int = 200
    //Y轴长
    var ySet:Int = 1000
    //每个Bar的间距
    var xStep:Int = 30
    //点位名
    var arrayName:[String] = []  //["点位1","点位2","点位3","点位4","点位5","点位6"]
    //点位值
    var arrayValue:[String] = [] //["100","50","53","64","88","77"]
    //Bar相对高度
    var arrayHeight:[Double] = []
    //Bar的X轴四个坐标点
    var arrayBarX = [0.00,0.00,0.00,0.00]
    //放大倍数
    //var cn :Double = 0.0
    var strtitle:String = ""
    var dispalyflg:Int = 0
    //负数对应
    var array_minus:[String] = []
    
    //x,y,height,width
    var x:CGFloat = 0
    var y:CGFloat = 0
    var height:CGFloat = 0
    var width:CGFloat = 0
    
    var uiscroll:UIScrollView!
    var viewX:UIView!
    var viewData:UIView!
    let Bar1_Color = con.blueMore//UIColor(red: 207/255.0, green: 248/255.0, blue: 246/255.0, alpha: 1.0)
    let Bar2_Color = UIColor(red: 217/255.0, green: 80/255.0, blue: 138/255.0, alpha: 1.0)
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    init(frame: CGRect, arry_nm:[String], arry_vl:[String],title:String) {
        super.init(frame: frame)
        arrayName  = arry_nm
        arrayValue = arry_vl
        strtitle = title
        x = frame.origin.x
        y = frame.origin.y
        height = frame.height
        width = frame.width
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        createXY()
        findHeight()
        createBar()
        if(dispalyflg == 0){
            DianWeiDescription()
        }
        arrayBarXDescription()
        
        uiscroll = UIScrollView(frame: CGRect(x: 0, y: 0, width:self.bounds.width, height:self.bounds.height))
        uiscroll.showsHorizontalScrollIndicator = true
        uiscroll.contentSize = CGSize(width: viewData.bounds.width, height: self.bounds.height)
        uiscroll.addSubview(viewData)
        self.addSubview(uiscroll)
    }
    
    //画XY轴
    func createXY(){
        //X轴
        viewX = UIView(frame: CGRect(x: 0,y: 0,width: 1,height: xSet+top))
        let lbx = UILabel(frame:CGRect(x: left,y: 0,width: 1,height: xSet+top))
        lbx.backgroundColor = con.blueMore
        viewX.addSubview(lbx)
        self.addSubview(viewX)
        
        //Y轴
        let changdu = arrayValue.count*(barWiddth*2 + xStep) + left
        self.viewData = UIView(frame: CGRect(x:0, y: 0, width:CGFloat(changdu), height: self.bounds.height))
        let lby = UILabel(frame:CGRect(x: left,y: top+xSet,width: changdu + 100,height: 1))
        lby.backgroundColor = con.blueMore
        viewData.addSubview(lby)
    }
    
    //Bar相对高度
    func findHeight(){
        //最大数
        var tmp:Double = 0
        //最大点位值
        for(var i:Int=0;i<arrayValue.count;i++){
            var a:Double = (arrayValue[i] as NSString).doubleValue
            if(a >= 0){
                array_minus.append("1")
            }else{
                a = abs(a)
                array_minus.append("-1")
            }
            
            if(tmp<a){
                tmp = a
            }
        }
        //Bar的X轴四个坐标点
        arrayBarX[0] = tmp
        arrayBarX[1] = tmp - tmp/4
        arrayBarX[2] = tmp/2
        arrayBarX[3] = tmp/4
        
        if(tmp == 0){
            tmp = 1
        }
        
        for(var i:Int=0;i<arrayValue.count;i++){
            var a:Double = (arrayValue[i] as NSString).doubleValue
           
            if(a < 0){
                a = abs(a)
            }
            arrayHeight.append(a/tmp*Double(xSet))
        }
    }
    
    //画Bar
    func createBar(){
        var x:Int = 0
        var y:Double = 0
        var cnt:Int = 0
        
        for(var i:Int=0;i<arrayValue.count;i++){
            //x = x + xStep + barWiddth
            y = arrayHeight[i]
            
            if(dispalyflg == 0){
                if(i%2 == 0){
                    x = x + xStep + barWiddth
                }else{
                    x = x + barWiddth
                }
            }else{
                x = x + xStep + barWiddth
            }
            
            let shapeLayer: CAShapeLayer = CAShapeLayer()
            if(dispalyflg == 0){
                if(i%2 == 0){
                    shapeLayer.strokeColor = Bar1_Color.CGColor
                }else{
                    shapeLayer.strokeColor = UIColor.greenColor().CGColor
                }
            }else{
                shapeLayer.strokeColor = Bar1_Color.CGColor
            }
            
            if(array_minus[i] == "-1"){
                shapeLayer.strokeColor = Bar2_Color.CGColor
            }
            shapeLayer.lineWidth = CGFloat(barWiddth)
            shapeLayer.frame = CGRectMake(CGFloat(left + x + 2),CGFloat(top + xSet - Int(y)),CGFloat(barWiddth),CGFloat(y))
            self.viewData.layer.addSublayer(shapeLayer)

            //柱图
            let barPath: UIBezierPath = UIBezierPath()
            barPath.moveToPoint(CGPointMake(8, CGFloat(y)))
            barPath.addLineToPoint(CGPointMake(8, 0))

            //barPath.stroke()
            
            shapeLayer.path = barPath.CGPath
            
            
            CATransaction.begin()
            
            let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = 1.0
            pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pathAnimation.fromValue = 0.0
            pathAnimation.toValue = 1
            
            CATransaction.setCompletionBlock({
                () -> Void in
                return
            })
            
            CATransaction.commit()
            UIGraphicsEndImageContext()
            
            shapeLayer.addAnimation(pathAnimation, forKey: "barAnimation")
            
            
            //数字
            let lbtxt = UILabel(frame:CGRect(x: left + x,y: top + xSet - Int(y) - 20,width: barWiddth+30,height: 20))
            lbtxt.font = UIFont.systemFontOfSize(10)
            lbtxt.text = String(arrayValue[i])
            lbtxt.textColor = con.blueMore
            lbtxt.adjustsFontSizeToFitWidth  = true
            viewData.addSubview(lbtxt)
            
            if(dispalyflg == 0){
                if(i%2 == 0){
                    //点位名
                    let lbdianwei = UILabel(frame:CGRect(x: left + x,y: top + xSet + 5,width: barWiddth+20,height: 20))
                    lbdianwei.font = UIFont.systemFontOfSize(10)
                    lbdianwei.text = String(arrayName[cnt])
                    lbdianwei.textColor = con.blueMore
                    lbdianwei.adjustsFontSizeToFitWidth  = true
                    viewData.addSubview(lbdianwei)
                    cnt++
                }
            }else{
                //点位名
                let lbdianwei = UILabel(frame:CGRect(x: left + x,y: top + xSet + 5,width: barWiddth+20,height: 20))
                lbdianwei.font = UIFont.systemFontOfSize(10)
                lbdianwei.text = String(arrayName[cnt])
                lbdianwei.textColor = con.blueMore
                lbdianwei.adjustsFontSizeToFitWidth  = true
                viewData.addSubview(lbdianwei)
                cnt++
            }
        }
    }
    
    //对应点位说明
    func DianWeiDescription(){
        var yStep:Int = 0
        var y:Int = 0
        for(var i:Int=0;i<2;i++){
            yStep = 15 + yStep
            y = top + yStep
            
            let lb1 = UILabel(frame:CGRect(x: left + barWiddth*2 + arrayValue.count/2*xStep + arrayValue.count*barWiddth,y: y,width: barWiddth*2,height: 10))
            let lb2 = UILabel(frame:CGRect(x: left + barWiddth*2 + arrayValue.count/2*xStep + arrayValue.count*barWiddth + barWiddth*2 + 5,y: y,width: barWiddth*2,height: 10))
            lb2.font = UIFont.systemFontOfSize(10)
            
            
            if(i==0){
                lb1.backgroundColor = Bar1_Color
                lb2.text = "实际"
            }else{
                lb1.backgroundColor = UIColor.greenColor()
                lb2.text = "配比"
            }

            lb2.textColor = con.blueMore
            
            viewData.addSubview(lb1)
            viewData.addSubview(lb2)
        }
    }
    
    //Bar的X轴四个坐标点
    func arrayBarXDescription(){
        var yStep:Int = 0
        var y:Int = 0
        for(var i:Int=0;i<arrayBarX.count;i++){
            y = top + yStep
            let lb1 = UILabel(frame:CGRect(x: left,y: y,width: barWiddth+25,height: 10))
            yStep = xSet*(i+1)/4
            lb1.font = UIFont.systemFontOfSize(10)
            lb1.text = String(stringInterpolationSegment: Double(arrayBarX[i]))
            lb1.textColor = con.blueMore
            lb1.adjustsFontSizeToFitWidth  = true
            viewX.addSubview(lb1)
        }
        
        let lb = UILabel(frame:CGRect(x: left+100,y: 0,width: 200,height: 10))
        lb.text = strtitle
        lb.textColor = con.blueMore
        lb.font = UIFont.systemFontOfSize(12)
        viewData.addSubview(lb)
    }
}