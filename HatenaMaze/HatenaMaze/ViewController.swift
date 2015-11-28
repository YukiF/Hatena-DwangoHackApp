//
//  ViewController.swift
//  HatenaMaze
//
//  Created by Yuki.F on 2015/11/28.
//  Copyright © 2015年 Yuki Futagami. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox


class ViewController: UIViewController {
    
    var playerView: UIImageView!
    var playerMotionManager: CMMotionManager!
    var speedX: Double = 0.0
    var speedY: Double = 0.0

    let screenSize = UIScreen.mainScreen().bounds.size
    /*
    0:プレイヤーの通れる場所
    1:壁
    2:スタート
    3:ゴール
    4:ワープポイント
    5:ワープ移動ポイント
    */
    let mazePattern0 = [
        
        [1, 0, 0, 0, 1, 1],
        [1, 0, 1, 0, 1, 0],
        [1, 0, 1, 0, 1, 0],
        [1, 0, 1, 0, 0, 0],
        [1, 0, 0, 1, 1, 0],
        [1, 1, 0, 1, 1, 0],
        [0, 0, 0, 1, 0, 0],
        [0, 1, 1, 1, 0, 1],
        [0, 0, 0, 1, 0, 0],
        [1, 1, 3, 1, 1, 2],
    ]
    let mazePattern1 = [
        
        [3, 1, 1, 1, 1, 2],
        [0, 1, 0, 0, 0, 0],
        [0, 0, 1, 1, 1, 0],
        [1, 0, 1, 1, 0, 0],
        [1, 0, 1, 1, 0, 1],
        [0, 0, 1, 1, 0, 0],
        [0, 1, 1, 0, 1, 0],
        [0, 0, 0, 0, 1, 0],
        [1, 0, 1, 0, 0, 0],
        [1, 0, 1, 1, 1, 1],
    ]
    let mazePattern2 = [
        [1, 0, 1, 1, 1, 1],
        [1, 0, 0, 0, 0, 0],
        [1, 0, 1, 0, 1, 0],
        [3, 0, 1, 0, 1, 1],
        [1, 0, 1, 0, 1, 2],
        [1, 1, 1, 0, 1, 0],
        [0, 0, 1, 0, 1, 0],
        [0, 1, 1, 0, 1, 0],
        [0, 0, 0, 0, 0, 0],
        [1, 1, 0, 1, 1, 0],
    ]
    
    var mazeNumber: Int!
    var maze: [[Int]]!
    var goalView: UIView!
    var startView: UIView!
    
    var isDuringGame: Bool = false
    
    var wallRectArray = [CGRect]()
    var roadRectArray = [CGRect]()
    
    var blogImageView: [UIImageView]!
    
    var lastRoadTouch = NSUserDefaults.standardUserDefaults()
    var lastRoadCenterPoint: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for var i = 0; i<14;i++ {
            blogImageView[i] = UIImageView()
        }
        
        isDuringGame = false
        
        mazeNumber = Int(arc4random_uniform(2))
        
        switch mazeNumber {
        case 0:
            self.maze = mazePattern0
        case 1:
            self.maze = mazePattern1
        case 2:
            self.maze = mazePattern2
        default:
            break
        }
        
        let cellWidth = screenSize.width / CGFloat(maze[0].count) // 6
        let cellHeight = screenSize.height / CGFloat(maze.count)//10
        
        let cellOffsetX = screenSize.width / CGFloat(maze[0].count * 2)
        let cellOffsetY = screenSize.height / CGFloat(maze.count * 2)
        
        for y in 0 ..< maze.count {
            for x in 0 ..< maze[y].count {
                switch maze[y][x] {
                case 0:
                    let roadView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    roadRectArray.append(roadView.frame)
                case 1:
                    let wallView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    wallView.backgroundColor = UIColor.blackColor()
                    view.addSubview(wallView)
                    wallRectArray.append(wallView.frame)
                    //wallView.addSubview(blogImageView)
                case 2:
                    startView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    startView.backgroundColor = UIColor.greenColor()
                    self.view.addSubview(startView)
                case 3:
                    goalView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    goalView.backgroundColor = UIColor.redColor()
                    self.view.addSubview(goalView)
                default:
                    break
                }
            }
        }
        playerView = UIImageView(frame: CGRectMake(0 , 0, screenSize.width / 15, screenSize.width / 15))
        let playerImage = UIImage(named: "hatenaPlayerView.png")
        playerView.image = playerImage
        playerView.center = startView.center
        self.view.addSubview(playerView)
        
        // MotionManagerを生成.
        playerMotionManager = CMMotionManager()
        playerMotionManager.accelerometerUpdateInterval = 0.02
        
        self.startAccelerometer()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if isDuringGame == true {
            // 加速度を始める
            if !playerMotionManager.accelerometerActive {
                self.startAccelerometer()
            }
            // スピードを初期化
            speedX = 0.0
            speedY = 0.0
            playerView.center = CGPointFromString(lastRoadTouch.stringForKey("lastRoad")!)

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createView(x x: Int, y: Int, width: CGFloat, height: CGFloat, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> UIView {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let view = UIView(frame: rect)
        
        let center = CGPoint(
            x: offsetX + width * CGFloat(x),
            y: offsetY + height * CGFloat(y)
        )
        
        view.center = center
        return view
    }
    
    func startAccelerometer() {
        
        // 加速度を取得する
        let handler:CMAccelerometerHandler = {(accelerometerData:CMAccelerometerData?, error:NSError?) -> Void in
            
            self.speedX += accelerometerData!.acceleration.x
            self.speedY += accelerometerData!.acceleration.y
            
            var posX = self.playerView.center.x + (CGFloat(self.speedX) / 3)
            var posY = self.playerView.center.y - (CGFloat(self.speedY) / 3)
            
            if posX <= (self.playerView.frame.width / 2) {
                self.speedX = 0
                posX = self.playerView.frame.width / 2
            }
            if posY <= (self.playerView.frame.height / 2) {
                self.speedY = 0
                posY = self.playerView.frame.height / 2
            }
            if posX >= (self.screenSize.width - (self.playerView.frame.width / 2)) {
                self.speedX = 0
                posX = self.screenSize.width - (self.playerView.frame.width / 2)
            }
            if posY >= (self.screenSize.height - (self.playerView.frame.height / 2)) {
                self.speedY = 0
                posY = self.screenSize.height - (self.playerView.frame.height / 2)
            }
            
            for roadRect in self.roadRectArray {
                if (CGRectIntersectsRect(roadRect,self.playerView.frame)){
                    let view = UIView(frame: roadRect)
                    self.lastRoadCenterPoint = view.center
                    print(self.lastRoadCenterPoint)
                }
            }

            
            for wallRect in self.wallRectArray {
                if (CGRectIntersectsRect(wallRect,self.playerView.frame)){
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    self.lastRoadTouch.setObject(NSStringFromCGPoint(self.lastRoadCenterPoint), forKey: "lastRoad")
                    self.lastRoadTouch.synchronize()
                    print(self.lastRoadTouch.stringForKey("lastRoad"))
                    self.gameCheck("Stop!", message: "壁に当たりました。記事画面に進みます。", isClear: false)
                    return
                }
            }
            
            if (CGRectIntersectsRect(self.goalView.frame,self.playerView.frame)){
                self.gameCheck("Clear!",message: "クリアしました、検索画面に戻ります。", isClear: true)
                return
            }
            self.playerView.center = CGPointMake(posX, posY)
        }
        // 加速度の開始
        playerMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: handler)
        
    }
    
    func gameCheck(result:String,message:String,isClear:Bool){
        
        //加速度を止める
        if playerMotionManager.accelerometerActive {
            playerMotionManager.stopAccelerometerUpdates()
        }
        let gameCheckAlert: UIAlertController = UIAlertController(title:result, message:message, preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "OK", style: .Default) { action in
            self.segue(isClear)
        }
        gameCheckAlert.addAction(okayAction)
        self.presentViewController(gameCheckAlert, animated: true, completion: nil)
    }
    
    func segue(isClear:Bool) {
        if isClear == false {
            isDuringGame = true
            self.performSegueWithIdentifier("toContents", sender: nil)
        }else{
           self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
 

}

