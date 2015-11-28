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
import SDWebImage

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPopularBlogEntryURL()
        
        // Do any additional setup after loading the view.
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
                    
                    print(webPageUrl)
                    self.getWebImageURL(webPageUrl!,number: i)
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
    func getWebImageURL(pageUrl:String,number:Int) {
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
