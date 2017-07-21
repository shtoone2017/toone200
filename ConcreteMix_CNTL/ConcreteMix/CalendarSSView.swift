//
//  DrawingView.swift
//  Metro
//
//  Created by user on 15/6/13.
//  Copyright (c) 2015年 user. All rights reserved.
//

import UIKit

class CalendarSSView: UIView,CalendarViewDelegate {
    
    var datetime = ""
    var delegate:CalendarSelectDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCalendar()
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    func createCalendar(){
        //初始时间
        let date:NSDate = NSDate()
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        datetime = formatter.stringFromDate(date)
        
        //日期控件
        let clview = CalendarView(frame: CGRect(x: 20, y: 15, width: 300, height: 320))
        clview.calendarDelegate = self
        clview.shouldShowHeaders = true
        clview.selectionColor = UIColor(red: 0.203, green: 0.666, blue: 0.862, alpha: 1.0)
        clview.fontHeaderColor = UIColor(red: 0.203, green: 0.666, blue: 0.862, alpha: 1.0)
        self.addSubview(clview)
        
        //确定
        let btn_OK = SFlatButton(frame: CGRect(x: 25, y: 290, width: 50, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        btn_OK.setTitle("确定", forState: UIControlState.Normal)
        btn_OK.addTarget(self, action: "btn_OKClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        btn_OK.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.addSubview(btn_OK)
        
        //取消
        let btn_Cancel = SFlatButton(frame: CGRect(x: 90, y: 290, width: 50, height: 30), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        btn_Cancel.setTitle("取消", forState: UIControlState.Normal)
        btn_Cancel.addTarget(self, action: "btn_CancelClickBtn:", forControlEvents: UIControlEvents.TouchDown)
        btn_Cancel.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.addSubview(btn_Cancel)
    }
    
    func didChangeCalendarDate(date:NSDate){
        datetime = String(date)
        datetime = (datetime as NSString).substringToIndex(10)
        print(datetime)
    }
    
    func btn_OKClickBtn(sender: UIButton){
        delegate?.DateOK(datetime)
    }
    
    func btn_CancelClickBtn(sender: UIButton){
        delegate?.DateCancel()
    }
}