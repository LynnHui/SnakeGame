//
//  ViewController.swift
//  SnakeGame
//
//  Created by lynn.hui on 15/5/15.
//  Copyright (c) 2015年 lynn.hui. All rights reserved.
//

import UIKit

let kScreenWith = UIScreen.mainScreen().bounds.size.width
let kScreenHeight = UIScreen.mainScreen().bounds.size.height
let kBlueMsgPix = "蓝方"
let kRedMsgPix = "红方"
class ViewController: UIViewController,UIAlertViewDelegate,DiceDelegate,MenuDelegate{

    var isFirst: Bool = false
    var mapAry = [Int](count: 101, repeatedValue: 0)
    
    var mapWidth: CGFloat = 0.0
    var mapHeight: CGFloat = 0.0
    
    var bluePlayerScore = 1
    var redPlayerScore = 1
    var score = 0
    var recordAry = [String]()
    
    @IBOutlet weak var mapImg: UIImageView!
    @IBOutlet weak var tool:UIToolbar!
    @IBOutlet weak var blueBtn: UIButton!
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var list:RecordList!
    var menu: MenusView!
    var msgLbl: UILabel!
    var bluePlayer: UIImageView!
    var redPlayer: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var spaceItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        msgLbl = UILabel(frame: CGRectMake(0, 0, 300, 40))
        msgLbl.backgroundColor = UIColor.clearColor()
        msgLbl.textAlignment = NSTextAlignment.Center
        
        var menuBtn: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        menuBtn.frame = CGRectMake(0, 0, 50, 40)
        menuBtn.setTitle("蛇棋", forState: UIControlState.Normal)
        menuBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        menuBtn.addTarget(self, action: "doMenusAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        var menuItem = UIBarButtonItem(customView: menuBtn)
        var msgItem = UIBarButtonItem(customView: msgLbl)
        tool.items = [menuItem,spaceItem,msgItem,spaceItem]
        
        mapWidth = kScreenWith - 150
        mapHeight = kScreenHeight - 44 - 20
        print("W:\(kScreenWith), H:\(kScreenHeight)")
        var crect = CGRectMake(0, mapHeight-mapHeight/10, mapWidth/10, mapHeight/10)
        
        bluePlayer = UIImageView(frame: crect)
        bluePlayer.image = UIImage(named: "blue")
        mapImg.addSubview(bluePlayer)
        
        redPlayer = UIImageView(frame: crect)
        redPlayer.image = UIImage(named: "red")
        mapImg.addSubview(redPlayer)
        
        mapAry[03] = +21; mapAry[13] = +18; mapAry[26] = +58; mapAry[42] = +39;mapAry[66] = +21;mapAry[72] = +19;
        mapAry[25] = -18; mapAry[38] = -18; mapAry[55] = -27; mapAry[64] = -21;mapAry[71] = -42; mapAry[89] = -21;
        mapAry[95] = -10; mapAry[98] = -16;
        
        self.getDate()
//        mapAry[04] = 101;mapAry[09] = 101;mapAry[12] = 101;mapAry[19] = 101;mapAry[23] = 101;mapAry[27] = 101;
//        mapAry[36] = 101;mapAry[39] = 101;mapAry[41] = 101;mapAry[48] = 101;mapAry[54] = 101;mapAry[57] = 101;
//        mapAry[61] = 101;mapAry[65] = 101;mapAry[74] = 101;mapAry[77] = 101;mapAry[83] = 101;mapAry[86] = 101;
//        mapAry[94] = 101;mapAry[99] = 101;
        
        self.doDetermineBySystem()
    }

    func doDetermineBySystem(){
        isFirst = arc4random() % 2 == 0 ? true : false
        if isFirst {
            blueBtn.enabled = true
            redBtn.enabled = false
            msgLbl.text = "系统判定\(kBlueMsgPix)优先"
            recordAry.append("系统判定\(kBlueMsgPix)优先\n\(self.getDate())")
        }else{
            redBtn.enabled = true
            blueBtn.enabled = false
            msgLbl.text = "系统判定\(kRedMsgPix)优先"
            recordAry.append("系统判定\(kRedMsgPix)优先\n\(self.getDate())")
        }
    }
    
    func callBack(number: Int, withPlayer _player: Int){
        if _player == 0{
            msgLbl.text = "请\(kBlueMsgPix)前进 \(number) 步"
            recordAry.append("\(kBlueMsgPix)前进了 \(number) 步\n\(self.getDate())")
            score = bluePlayerScore
        }else{
            msgLbl.text = "请\(kRedMsgPix)前进 \(number) 步"
            recordAry.append("\(kRedMsgPix)前进了 \(number) 步\n\(self.getDate())")
            score = redPlayerScore
        }
        self.doScoreAction(number, withPlayer: _player)
    }
    
    func doScoreAction(number: Int, withPlayer _player: Int){
        var Point1 = self.doCalculationPoint(score)
        var Point2 = self.doCalculationPoint(score + number)
        var turnPointAry: Array<NSValue> = self.getTurnPoint(score, withScore: number)
        
        var pointAry: Array<NSValue> = [NSValue.init(CGPoint: Point1)]
        pointAry += turnPointAry
        pointAry.append(NSValue.init(CGPoint: Point2))
        
        score += number
        if score > 100{score = 100}
        self.doMovePlayerAction(pointAry, desPoint: Point2, withPlayer: _player)
    }

    func doHaveBonusAction(_player: Int, playerName name: String){
        if mapAry[score] > 0{
            msgLbl.text = "恭喜\(name)获得梯子奖励，前进 \(mapAry[score])步"
            recordAry.append("\(name)获得梯子，前进 \(mapAry[score]) 步\n\(self.getDate())")
        }else{
            msgLbl.text = "\(name)不幸被蛇咬到，后退 \(-mapAry[score])步"
            recordAry.append("\(name)被蛇咬，后退 \(-mapAry[score]) 步\n\(self.getDate())")
        }
        
        var Point1 = self.doCalculationPoint(score)
        var pointAry: Array<NSValue> = [NSValue.init(CGPoint: Point1)]
            
        score += mapAry[score]
        var Point2 = self.doCalculationPoint(score)
        pointAry.append(NSValue.init(CGPoint: Point2))
        self.doMovePlayerAction(pointAry, desPoint: Point2, withPlayer: _player)
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool){
        var playerName = anim.valueForKey("player") as! String
        if playerName == "blue" {
            bluePlayer.stopAnimating()
            if mapAry[score] != 0{
                self.doHaveBonusAction(0, playerName: kBlueMsgPix)
                return
            }
    
            bluePlayerScore = score
            if bluePlayerScore >= 100{
                var alert1 = UIAlertView(title: "恭喜", message: "蓝方获胜了", delegate: self, cancelButtonTitle: "炫耀一下", otherButtonTitles: "再来一次")
                alert1.show()
                return
            }
            msgLbl.text = "请\(kRedMsgPix)掷骰子"
        }else{
            redPlayer.stopAnimating()
            if mapAry[score] != 0{
                self.doHaveBonusAction(1, playerName: kRedMsgPix)
                return
            }
            
            redPlayerScore = score
            if redPlayerScore >= 100{
                var alert1 = UIAlertView(title: "恭喜", message: "红方获胜了", delegate: self, cancelButtonTitle: "炫耀一下", otherButtonTitles: "再来一次")
                alert1.show()
                return
            }
            msgLbl.text = "请\(kBlueMsgPix)掷骰子"
        }
    }
    
    func doMovePlayerAction(pointAry:Array<NSValue>, desPoint des:CGPoint, withPlayer player:Int){
        var animation = CAKeyframeAnimation(keyPath: "position")
        animation.values = pointAry as AnyObject as! [AnyObject]
        animation.duration = 2.0
        animation.delegate = self
        
        
        var animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation]
        animationGroup.duration = 2.0
        animationGroup.delegate = self
        if player == 0{
            animationGroup.setValue("blue", forKey: "player")
            bluePlayer.layer.position = des
            bluePlayer.layer.addAnimation(animationGroup, forKey: "position")
        }else{
            animationGroup.setValue("red", forKey: "player")
            redPlayer.layer.position = des
            redPlayer.layer.addAnimation(animationGroup, forKey: "position")
        }
    }

    func doCalculationPoint(var score: Int) ->CGPoint{
        var pointX: CGFloat
        var pointY: CGFloat
        
        if score > 100 { score = 100 }
        
        var m = (score - 1) / 10
        var n = (score - 1) % 10
        
        if m % 2 == 0 {
            pointX = (mapWidth/10) * CGFloat(n)
        }else{
            pointX = (mapWidth/10) * CGFloat(9-n)
        }
        pointX += mapWidth/20
        pointY = (mapHeight/10) * CGFloat(9-m) + mapHeight/20
        
        var point = CGPointMake(pointX, pointY)
        return point
    }
    
    func getTurnPoint(currentScore: Int, withScore score: Int)->Array<NSValue>{
        var pointAry: Array<NSValue> = Array<NSValue>()
        var turnNum = [10,11,20,21,30,31,40,41,50,51,60,61,70,71,80,81,90,91]
        for num in turnNum {
            if num>currentScore && num < currentScore + score{
                var point = self.doCalculationPoint(num)
                pointAry.append(NSValue.init(CGPoint: point))
            }
        }
        return pointAry
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1{
            self.doDetermineBySystem()
            
            bluePlayerScore = 1
            redPlayerScore = 1
            
            var crect = CGRectMake(0, mapHeight-mapHeight/10, mapWidth/10, mapHeight/10)
            bluePlayer.frame = crect
            redPlayer.frame = crect
        }
    }

    @IBAction func doShakingBlueAction(sender:UIButton!){
        sender.enabled = false
        redBtn.enabled = true
        msgLbl.text = "\(kBlueMsgPix)掷骰子中..."
        
        var  diceShakingView = DiceShakingView.init(frame:CGRectMake(0, 0, kScreenWith, kScreenHeight))
        diceShakingView.delegate = self
        diceShakingView.player = 0
        self.view.addSubview(diceShakingView)
    }
    
    @IBAction func doShakingRedAction(sender:UIButton!){
        sender.enabled = false
        blueBtn.enabled = true
        msgLbl.text = "\(kRedMsgPix)掷骰子中..."
        
        var diceShakingView = DiceShakingView.init(frame:CGRectMake(0, 0, kScreenWith, kScreenHeight))
        diceShakingView.delegate = self
        diceShakingView.player = 1
        self.view.addSubview(diceShakingView)
    }
    
    func doMenusAction(){
        menu = MenusView.init(frame:CGRectMake(5, 32, 70, 120))
        menu.delegate = self
        cancelBtn.hidden = false
        self.view.addSubview(menu)
    }
    
    @IBAction func doCancelAction(sender:UIButton!){
        if menu != nil{menu.removeFromSuperview()}
        if list != nil {list.removeFromSuperview()}
        cancelBtn.hidden = true
    }
    
    func callBackFromMenu(index: Int) {
        if index == 0{
            bluePlayerScore = 1
            redPlayerScore = 1
            score = 0
            recordAry.removeAll(keepCapacity: true)
            var crect = CGRectMake(0, mapHeight-mapHeight/10, mapWidth/10, mapHeight/10)
            bluePlayer.frame = crect
            redPlayer.frame = crect
            
            self.doDetermineBySystem()
            cancelBtn.hidden = true
        }else{
            list = RecordList.init(frame:CGRectMake(0, 32, 200, kScreenHeight - 62))
            list.setRecordAction(recordAry)
            self.view.addSubview(list)
        }
    }
    
    func getDate() -> String{
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.stringFromDate(NSDate())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

