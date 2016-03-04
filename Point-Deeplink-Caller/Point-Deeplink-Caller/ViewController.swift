//
//  ViewController.swift
//  Point-Deeplink-Caller
//
//  Created by Diego Flores Domenech on 3/3/16.
//  Copyright © 2016 Diego Flores Domenech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var paymentReferenceTextField: UITextField!
    @IBOutlet weak var debitCreditSegmentedControl: UISegmentedControl!
    @IBOutlet weak var installmentsTextField: UITextField!
    
    var paymentType = "debit"
    let returnURL = "mpostest://"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapGesture = UITapGestureRecognizer(target: self, action: "didTapOnScreen")
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapOnScreen(){
        self.view.endEditing(true)
    }

    @IBAction func didSelectPayButton(sender: AnyObject) {
        if let amount = amountTextField.text, let paymentReference = paymentReferenceTextField.text, let installments = installmentsTextField.text{
            UIApplication.sharedApplication().openURL(NSURL(string: "mpos://?amount=\(amount)&installments=\(installments)&return_url=\(returnURL)&reference_code=\(paymentReference)&debit_credit=\(paymentType)")!)
        }
    }

    @IBAction func segmentedControlValueChanged(sender: AnyObject) {
        if debitCreditSegmentedControl.selectedSegmentIndex == 0{
            paymentType = "debit"
            installmentsTextField.userInteractionEnabled = false
            installmentsTextField.text = "1"
        }else{
            paymentType = "credit"
            installmentsTextField.userInteractionEnabled = true
        }
    }
}

