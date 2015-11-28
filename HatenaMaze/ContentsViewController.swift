//
//  ContentsViewController.swift
//  HatenaMaze
//
//  Created by Yuki.F on 2015/11/28.
//  Copyright © 2015年 Yuki Futagami. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class ContentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bookmark() {
        SVProgressHUD.showInfoWithStatus("ブックマークに追加しました！", maskType: .Black)
    }
    
    @IBAction func sendO2() {
        let push = PFPush()
        let username = PFUser.currentUser()?.username
        let pushQuery = PFInstallation.query()
        pushQuery!.whereKey("pushNotification", equalTo:true)
        let data = [
            "alert" : String(format: "O2! from %@",username!),
            "badge" : "Increment",
            "sound": "o2Man.caf"
        ]
        push.setQuery(pushQuery)
        push.setData(data)
        push.sendPushInBackgroundWithBlock {
            (success: Bool , error: NSError?) -> Void in
            if (success) {
                NSLog("Push通知送信成功。")
                SVProgressHUD.showSuccessWithStatus("Sent O2!", maskType: SVProgressHUDMaskType.Black)
            } else if (error!.code == 112) {
                print("Could not send push. Push is misconfigured: \(error!.description).");
            } else {
                print("Error sending push: \(error!.description).");
            }
        }
    }

    
    
}
