//
//  GameOverViewController.swift
//  factory
//
//  Created by Zach Jaquish on 11/18/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet var outputSummary: UIView!
    @IBOutlet var summaryLabel: UILabel!
    
    var level: Level!
    
    @IBAction func unwindToMainMenu() {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateOutputSummaryView()
    }
    
    func updateOutputSummaryView() {
        
        var point = CGPoint(x: 0, y: WidgeSize.height)
        
        for widgeType in level.outputs {
            var preview: UIView!
            let visual: AnyObject = widgeType.visual()
            switch visual {
            case is UIColor:
                preview = UIView()
                preview.backgroundColor = visual as? UIColor
            case is String:
                preview = UIImageView(image: UIImage(named: visual as String))
            default:
                fatalError("whoops")
            }
            
            preview.frame = CGRect(origin: point, size: WidgeSize)
            outputSummary.addSubview(preview)
            
            point.x += WidgeSize.width
            point.x += 10
            if point.x > outputSummary.frame.size.width - WidgeSize.width {
                point.x = 0
                point.y += 10
                point.y += WidgeSize.height
            }
        }
        
        let goodCount = level.outputs.filter { contains(self.level.winning_outputs, $0) }.count
        let badCount = level.outputs.filter { !contains(self.level.winning_outputs, $0) }.count
        summaryLabel.text = "Good:\(goodCount) Bad:\(badCount)"
    }
}
