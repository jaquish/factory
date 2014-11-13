//
//  LevelSelectViewController.swift
//  factory
//
//  Created by Zach Jaquish on 11/12/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var picker: UIPickerView?
    
    @IBAction func playLevel() {
        performSegueWithIdentifier("playLevelSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let levelSelectVC = segue.destinationViewController as LevelViewController
        levelSelectVC.level = Level(picker!.selectedRowInComponent(0))
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "Level \(row)"
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
