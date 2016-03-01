//
//  ViewController.swift
//  数据库
//
//  Created by space on 16/2/29.
//  Copyright © 2016年 Space. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let one = inputViwController()
        self.navigationController?.pushViewController(one, animated: true)
    }

}

