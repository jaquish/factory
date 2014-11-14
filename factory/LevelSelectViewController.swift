//
//  LevelSelectViewController.swift
//  factory
//
//  Created by Zach Jaquish on 11/12/14.
//  Copyright (c) 2014 Zach Jaquish. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var currentLevel: Level? {
        didSet {
            summary!.text = currentLevel?.summary()
        }
    }
    var levelFileURLS = [NSURL]()
    
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var summary: UITextView!
    
    @IBAction func playLevel() {
        performSegueWithIdentifier("playLevelSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let levelSelectVC = segue.destinationViewController as LevelViewController
        levelSelectVC.level = Level(filepath:levelFileURLS[picker.selectedRowInComponent(0)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summary.text = ""
        levelFileURLS = NSBundle.mainBundle().URLsForResourcesWithExtension("level", subdirectory: nil) as [NSURL]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levelFileURLS.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return levelFileURLS[row].lastPathComponent
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentLevel = Level(filepath:levelFileURLS[row])
    }
}
