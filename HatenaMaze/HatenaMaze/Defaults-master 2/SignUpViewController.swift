//
//  SignUpViewController.swift
//  TechBoard
//
//  Created by Ryo Eguchi on 2015/11/26.
//  Copyright © 2015年 Ryo Eguchi. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createButtonPushed(sender: UIButton) {
        
        self.signUp()
        
    }
    func signUp() {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            
            if succeeded {
                //アカウント作成が成功したらこちらの処理
                NSLog("ログイン成功")
                //メイン画面へ遷移
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            if let error = error {
                let errorString = error.userInfo["error"] as! NSString
                NSLog("%@",errorString)
                // Show the errorString somewhere and let the user try again.
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
