//
//  ViewController.swift
//  Tip_Calculator
//
//  Created by Dan Morton on 12/28/15.
//  Copyright © 2015 Dan Morton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var segmentedControlConstraint: NSLayoutConstraint!
    @IBOutlet weak var textControl: UITextView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var secondaryBackgrounView: UIView!
    @IBOutlet weak var splitTextView: UITextView!
    var tipPercent = 0.15
    var initialConstraintValue : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textControl.becomeFirstResponder()
        textControl.delegate = self
        resetViews()
        moneyLabel.text = "$0"
        
        initialConstraintValue = segmentedControlConstraint.constant;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardPresented:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardHidden:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    @IBAction func userTappedLabel(sender: AnyObject) {
        let gesture = sender as! UITapGestureRecognizer
        let point = gesture.locationInView(self.view)
        
        if (moneyLabel.frame.contains(point)){
            textControl.becomeFirstResponder()
        }
        else {
            textControl.resignFirstResponder()
        }
    }
    
    // this function will move the segmented control
    // up when the keyboard is shown at the boot up 
    // of the app
    func keyboardPresented(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        self.segmentedControlConstraint.constant = keyboardFrame.size.height + 20
        UIView.animateWithDuration(1.0) { () -> Void in
            self.view.layoutIfNeeded()
            self.splitTextView.alpha = 0
        }
        
    }
    
    // this function will move the segmented control
    // up when the keyboard is hidden at the boot up
    // of the app
    func keyboardHidden(notification: NSNotification) {
        self.segmentedControlConstraint.constant = self.initialConstraintValue
        UIView.animateWithDuration(1.0) { () -> Void in
            self.view.layoutIfNeeded()
            self.splitTextView.alpha = 1
        }
        
    }
    
    func validateInput(input: String) -> Bool {
        if ((input as NSString).doubleValue == 0.0) {
            return false
        }
        return true
    }
    
    func updateValues(textView: UITextView) {
        if (!validateInput(textView.text) || numberOfPeriods(textView.text) > 1) {
            moneyLabel.text = "INV"
            resetViews()
            flashScreen()
        }
        else {
            calculateSplitValues()
            var bill = (textView.text! as NSString).doubleValue
            var tip = ((textView.text! as NSString).doubleValue) * tipPercent
            
            tip = Double(round(100 * tip)/100)
            bill = Double(round(100 * bill)/100)
            let total = bill + tip;
            moneyLabel.text = "$\(textView.text!)"
            billLabel.text = "Bill: $\(bill)"
            tipLabel.text = "Tip: $\(tip)"
            totalLabel.text = "Total: $\(total)"
        }
    }
    
    func calculateSplitValues() {
        var bill = (textControl.text! as NSString).doubleValue
        var tip = ((textControl.text! as NSString).doubleValue) * tipPercent
        tip = Double(round(100 * tip)/100)
        bill = Double(round(100 * bill)/100)
        let total = bill + tip;
        
        let twoSplit = Double(round((total / 2)*100)/100)
        let threeSplit = Double(round((total / 3)*100)/100)
        let fourSplit = Double(round((total / 4)*100)/100)
        let fiveSplit = Double(round((total / 5)*100)/100)
        
        let str = "Bill Splitting Values\n   ••\t$\(twoSplit)\n  •••\t$\(threeSplit)\n ••••\t$\(fourSplit)\n•••••\t$\(fiveSplit)"
        splitTextView.text = str
    }
    
    func resetViews() {
        textControl.text = ""
        billLabel.text = "Bill: $0.0"
        tipLabel.text = "Tip: $0.0"
        totalLabel.text = "Total: $0.0"
        splitTextView.text = ""
        
    }
    
    func numberOfPeriods(string: String) -> Int{
        var counter = 0;
        for x in string.characters {
            if (x == ".") {
                counter++
            }
        }
        
        return counter
    }
    
    func flashScreen() {
        let color = secondaryBackgrounView.backgroundColor!
        UIView.animateWithDuration(0.2) { () -> Void in
            self.secondaryBackgrounView.backgroundColor = UIColor.redColor()
            self.secondaryBackgrounView.backgroundColor = color
        }
    }
    
    //--------UITEXTFILED DELEGGATE METHODS------------
    func textViewDidChange(textView: UITextView) {
        if (textView.text! == "") {
            resetViews()
            moneyLabel.text = "$0"
        }
        else {
            updateValues(textView)
        }
    }
    
    
    
    @IBAction func tipValueChanged(sender: AnyObject) {
        let control = sender as! UISegmentedControl
        switch (control.selectedSegmentIndex) {
        case 0:
            tipPercent = 0.15
            break
        case 1:
            tipPercent = 0.20
            break
        case 2:
            tipPercent = 0.25
            break
        case 3:
            tipPercent = 0.30
            break
        default:
            break
        }
        
        textViewDidChange(textControl)
        
    }
    
}

