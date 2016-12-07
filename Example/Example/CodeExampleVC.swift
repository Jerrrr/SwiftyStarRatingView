//
//  CodeExampleVC.swift
//  Example
//
//  Created by momfo_cjw on 16/12/7.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class CodeExampleVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let starRatingView = SwiftyStarRatingView()
        
        starRatingView.frame.size = CGSize(width: 200, height: 60)
        starRatingView.center = CGPoint(x: self.view.center.x, y: 224)
        
        starRatingView.maximumValue = 5 //最大值 默认为5
        starRatingView.minimumValue = 0 //最小值 默认为0
        starRatingView.value = 3        //初始值 默认为0
        
        starRatingView.allowsHalfStars = true   //是否允许半个星星 默认为是
        starRatingView.accurateHalfStars = true //是否精确显示 默认为是
        starRatingView.continuous = true        //是否持续发生回调 默认为是
        
        starRatingView.backgroundColor = UIColor.orange
        starRatingView.tintColor = UIColor.white
        
        starRatingView.addTarget(self, action: #selector(self.starRatingValueChanged(sender:)), for: .valueChanged)
        
        self.view.addSubview(starRatingView)
        
    }
    
    func starRatingValueChanged(sender: SwiftyStarRatingView) {
        print(sender.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
