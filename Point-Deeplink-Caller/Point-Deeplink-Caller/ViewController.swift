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
        if let amount = amountTextField.text, let installments = installmentsTextField.text{
            if amount != "" && installments != ""{
                if let paymentReference = paymentReferenceTextField.text{
                    if paymentReference != ""{
                        if paymentType == "debit"{
                            let query = "?amount=\(amount)&installments=1&return_url=\(returnURL)&reference_code=\(paymentReference)&debit_credit=\(paymentType)".stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                            let url = NSURL(string: "mpos://" + query)
                            UIApplication.sharedApplication().openURL(url!)
                        }else{
                            let query = "?amount=\(amount)&installments=\(installments)&return_url=\(returnURL)&reference_code=\(paymentReference)&debit_credit=\(paymentType)".stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
                            let url = NSURL(string: "mpos://" + query)
                            UIApplication.sharedApplication().openURL(url!)
                        }
                    }else{
                        openURLWithoutReferenceCode(amount,installments: installments,returnURL: returnURL)
                    }
                }else{
                    openURLWithoutReferenceCode(amount,installments: installments,returnURL: returnURL)
                }
            }else{
                UIAlertView(title: "Error", message: "Por favor complete todos los campos", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }else{
            UIAlertView(title: "Error", message: "Por favor complete todos los campos", delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    func openURLWithoutReferenceCode(amount : String, installments: String, returnURL : String){
        if paymentType == "debit"{
            let query = "?amount=\(amount)&installments=1&return_url=\(returnURL)&debit_credit=\(paymentType)".stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
            let url = NSURL(string: "mpos://" + query)
            UIApplication.sharedApplication().openURL(url!)
        }else{
            let query = "?amount=\(amount)&installments=\(installments)&return_url=\(returnURL)&debit_credit=\(paymentType)".stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
            let url = NSURL(string: "mpos://" + query)
            UIApplication.sharedApplication().openURL(url!)
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

