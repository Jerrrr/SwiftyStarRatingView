//
//  ViewController.swift
//  Example
//
//  Created by jerry on 16/12/7.
//  Copyright © 2016年 jerry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    
    @IBOutlet weak var valueLab: UILabel!
    
    @IBOutlet weak var spacingLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starRatingViewValueChange()
        starRatingViewSpacingChange()
    }

    @IBAction func allowHalfStarChanged(_ sender: UISwitch) {
        starRatingView.allowsHalfStars = sender.isOn
    }
    
    @IBAction func accurateHalfStarChanged(_ sender: UISwitch) {
        starRatingView.accurateHalfStars = sender.isOn
    }
    
    @IBAction func continuousChanged(_ sender: UISwitch) {
        starRatingView.continuous = sender.isOn
    }
    
    @IBAction func useCustomImageChanged(_ sender: UISwitch) {
        setImageForStarRatingView(value: sender.isOn)
    }
    
    @IBAction func valueChanged(_ sender: UIStepper) {
        starRatingView.value = CGFloat(sender.value)
        starRatingViewValueChange()
    }
    
    @IBAction func spacingChanged(_ sender: UIStepper) {
        starRatingView.spacing = CGFloat(sender.value)
        starRatingViewSpacingChange()
    }
    
    @IBAction func tintColorChanged(_ sender: UIButton) {
        starRatingView.tintColor = getRandomColor()
    }
    
    @IBAction func starRatingValueChanged(_ sender: SwiftyStarRatingView) {
        starRatingViewValueChange()
    }
    
    func starRatingViewValueChange() {
        valueLab.text = "Value : \(starRatingView.value)"
    }
    
    func starRatingViewSpacingChange() {
        spacingLab.text = "Spacing : \(starRatingView.spacing)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRandomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let g = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let b = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        return UIColor(red:r, green:g, blue:b , alpha: 1)
    }
    
    func setImageForStarRatingView(value:Bool) {
        if value == true {
            starRatingView.emptyStarImage = UIImage(named: "1.png")
            starRatingView.halfStarImage = UIImage(named: "2.png")
            starRatingView.filledStarImage = UIImage(named: "3.png")
        } else {
            starRatingView.emptyStarImage = nil
            starRatingView.halfStarImage = nil
            starRatingView.filledStarImage = nil
        }
    }
}
