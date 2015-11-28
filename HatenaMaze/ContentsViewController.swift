//
//  ContentsViewController.swift
//  HatenaMaze
//
//  Created by Yuki.F on 2015/11/28.
//  Copyright © 2015年 Yuki Futagami. All rights reserved.
//

import UIKit

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
    
    
}
