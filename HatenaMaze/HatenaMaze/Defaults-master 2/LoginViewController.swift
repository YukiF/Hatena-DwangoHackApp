//
//  LoginViewController.swift
//  TechBoard
//
//  Created by Ryo Eguchi on 2015/11/26.
//  Copyright © 2015年 Ryo Eguchi. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

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
    
    @IBAction func loginButtonPushed(sender: UIButton) {
        self.login()
    }
    
    func login() {
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password:passwordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // 成功した時の処理
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                //失敗した時の処理
                NSLog("失敗理由 == %@",error!)
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
