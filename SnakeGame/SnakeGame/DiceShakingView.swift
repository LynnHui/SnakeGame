//
//  DiceShakingView.swift
//  SwiftTest
//
//  Created by lynn.hui on 15/5/14.
//  Copyright (c) 2015年 lynn.hui. All rights reserved.
//

import UIKit

@objc protocol DiceDelegate{
    optional func callBack(number: Int, withPlayer _player: Int)
}

class DiceShakingView: UIView {
    var delegate: DiceDelegate?
    var player: Int? // 0 蓝方 1 红方
    
    var diceImg: UIImageView!
    var moveDiceImg: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        self.initUI()
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "doAction", userInfo: nil, repeats: false)
    }
    
    func initUI(){
        var moveImgAry = [UIImage(named: "dice_shaking_1")!,UIImage(named: "dice_shaking_2")!,UIImage(named: "dice_shaking_3")!]
        
        moveDiceImg = UIImageView(frame: CGRectMake(self.frame.size.width/2-21, self.frame.size.height/2-21, 42, 43))
        moveDiceImg.hidden = true
        moveDiceImg.animationImages = moveImgAry
        moveDiceImg.animationDuration = 0.5
        moveDiceImg.startAnimating()
        self.addSubview(moveDiceImg)
        
        diceImg = UIImageView(frame: CGRectMake(self.frame.size.width/2-21, self.frame.size.height/2-21, 42, 43))
        diceImg.image = UIImage(named: "dice_1")
        self.addSubview(diceImg)
    }
    
    func doAction(){
        diceImg.hidden = true
        moveDiceImg.hidden = false
        
        var spin = CABasicAnimation(keyPath: "transform.rotation")
        spin.duration = 4
        spin.toValue = NSNumber(double: M_PI * 16.0)
        
        var pointAry = [NSValue.init(CGPoint: CGPointMake(self.frame.size.width/2, 50)),
                        NSValue.init(CGPoint: CGPointMake(self.frame.size.width/2 - 100, self.frame.size.height/2)),
                        NSValue.init(CGPoint: CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 100)),
                        NSValue.init(CGPoint: CGPointMake(self.frame.size.width/2 + 100, self.frame.size.height/2)),
                        NSValue.init(CGPoint: CGPointMake(self.frame.size.width/2 - 100, self.frame.size.height/2 - 100)),
                        NSValue.init(CGPoint: CGPointMake(self.frame.size.width/2, self.frame.size.height/2))]
        
        var animation = CAKeyframeAnimation(keyPath: "position")
        animation.values = pointAry
        animation.duration = 4.0
        animation.delegate = self
        moveDiceImg.layer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        
        var animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation,spin]
        animationGroup.duration = 4.0
        animationGroup.delegate = self
        moveDiceImg.layer.addAnimation(animationGroup, forKey: "position")
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        moveDiceImg.stopAnimating()
        moveDiceImg.removeFromSuperview()

        var shakeNum = arc4random() % 6 + 1
        switch shakeNum {
        case 1 : diceImg.image = UIImage(named: "dice_1")
        case 2 : diceImg.image = UIImage(named: "dice_2")
        case 3 : diceImg.image = UIImage(named: "dice_3")
        case 4 : diceImg.image = UIImage(named: "dice_4")
        case 5 : diceImg.image = UIImage(named: "dice_5")
        default : diceImg.image = UIImage(named: "dice_6")
        }
        
        diceImg.hidden = false
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "doBackAction:", userInfo: Int(shakeNum), repeats: false)
    }
    
    func doBackAction(timer: NSTimer){
        var diceNumber = Int(timer.userInfo as! NSNumber)
        delegate?.callBack!(Int(diceNumber), withPlayer: player!)
        self.removeFromSuperview()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func translatesAutoresizingMaskIntoConstraints() -> Bool {
        return false
    }
}
