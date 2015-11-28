//
//  WelcomeViewController.swift
//  HatenaMaze
//
//  Created by Ryo Eguchi on 2015/11/28.
//  Copyright © 2015年 Yuki Futagami. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Parse
import SVProgressHUD

class WelcomeViewController: UIViewController {
    @IBOutlet var usernameLabel: UILabel!
    var wholeArray: [AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        wholeArray = []
        self.getPopularBlogEntryURL()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() == nil {
            self.performSegueWithIdentifier("toNew", sender: nil)
        }else{
            usernameLabel.text = "Welcome,\(PFUser.currentUser()?.username!)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: NETWORK CONNECTION
    
    func getPopularBlogEntryURL() {
        Alamofire.request(.GET, "https://ajax.googleapis.com/ajax/services/feed/load",parameters:["v":"1.0","q":"http://blog.hatena.ne.jp/-/hotentry/rss","num":"-1"])
            .responseJSON{ response in
                let json = JSON(data: response.data!)
                for var i = 0;i<15;i++ {
                    let webPageUrl = json["responseData"]["feed"]["entries"][i]["link"].string
                    let webTitle = json["responseData"]["feed"]["entries"][i]["title"].string
                    print(webPageUrl)
                    
                    self.getWebImageURL(webPageUrl!,number: i,title: webTitle!)
                    SVProgressHUD.dismiss()
                }
                
                /*if let JSON = JSON(data: response.result.value) {
                let webPageUrl = JSON["responseData"]["entries"][0]["link"].string
                
                }*/
        }
    }
    
    
    
    /*[メソッド]getWebImageURL
    【入力】ウェブページのURL（String型）
    　【出力】サムネイル画像のURL（String型）
    */
    func getWebImageURL(pageUrl:String,number:Int,title:String) {
        Alamofire.request(.GET, "http://api.hitonobetsu.com/ogp/analysis", parameters: ["url": pageUrl])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let webUrl = JSON["image"] as! String
                    print("webURL: \(webUrl)")
                    let imageURL = NSURL(string: webUrl)
                    //self.blogImageView[number].sd_setImageWithURL(imageURL!)
                    self.wholeArray.append(["title":title,"webPageUrl":pageUrl,"imageUrl":imageURL!])
                }
                
        }
    }
    
    @IBAction func goNextPage(sender: UIButton){
        self.performSegueWithIdentifier("toMaze", sender: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMaze" {
            let mazeView = segue.destinationViewController as! ViewController
            mazeView.wholeArray = self.wholeArray
        }
    }
    
    @IBAction func logoutButtonPushed(sender: AnyObject) {
        PFUser.logOut()
        SVProgressHUD.showInfoWithStatus("ログアウトしました", maskType: .Black)
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
