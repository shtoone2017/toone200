import QuartzCore
import UIKit

class CircleShowView: UIView {
    
    //var _trackLayer    : CAShapeLayer!
    //var _trackPath     : UIBezierPath!
    var _progressLayer : CAShapeLayer!
    var _progressPath  : UIBezierPath!
    var _progressWidth : Float = 2.0
    //var _progress      : Double = 0.8
    
    var x:CGFloat = 0
    var y:CGFloat = 0
    var height:CGFloat = 0
    var width:CGFloat = 0
    var value:String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        x = frame.origin.x
        y = frame.origin.y
        height = frame.height
        width = frame.width
        //画圆
        setCircle()
    }
    
    init(frame: CGRect, txt:String) {
        super.init(frame: frame)
        x = frame.origin.x
        y = frame.origin.y
        height = frame.height
        width = frame.width
        value = txt
        //画圆
        setCircle()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }

    func setCircle(){
        
        //数字
        let lb = UILabel(frame: CGRect(x:width/3,y:height/3,width:100,height:30))
        lb.textColor = UIColor.whiteColor()
        lb.text = value
        lb.font = UIFont.systemFontOfSize(20)
        let LabelAnimation = NumberAnimation(label: lb, TotheValue: value!)
        self.addSubview(lb)
        
        //圆形
        let radius = (Float(self.bounds.size.width) - _progressWidth)/2
        let layer = CAShapeLayer()
        self.layer.addSublayer(layer)
        layer.fillColor = nil
        layer.frame = self.bounds
        layer.strokeColor = con.bkcolor.CGColor
        let layerpath = UIBezierPath(arcCenter: CGPoint(x: width/2, y: height/2), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true)
        layer.path = layerpath.CGPath
        layer.lineWidth  = CGFloat(_progressWidth)
        
        let Progress = CAShapeLayer()
        self.layer.addSublayer(Progress)
        Progress.fillColor = nil
        Progress.frame = self.bounds
        Progress.strokeColor = UIColor.greenColor().CGColor

        let Progresspath = UIBezierPath(arcCenter: CGPoint(x: width/2, y: height/2), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true)
        Progress.path = Progresspath.CGPath
        
        let fillAnimation = CABasicAnimation(keyPath:"strokeEnd")
        fillAnimation.duration = 1
        fillAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        fillAnimation.fillMode = kCAFillModeForwards
        fillAnimation.fromValue = 0
        fillAnimation.toValue = 1
        fillAnimation.removedOnCompletion = true
        Progress.addAnimation(fillAnimation, forKey: "strokeEnd")
        Progress.lineWidth = CGFloat(_progressWidth)
    }

}