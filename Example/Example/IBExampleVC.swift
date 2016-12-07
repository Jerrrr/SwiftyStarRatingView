//
//  IBExampleVC.swift
//  Example
//
//  Created by momfo_cjw on 16/12/7.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class IBExampleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func starRatingValueChanged(_ sender: SwiftyStarRatingView) {
        print(sender.value)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
