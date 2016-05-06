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
    let successURL = "mpostest://success"
    let failureURL = "mpostest://failure"
    
    let clientId = "1234"
    let clientSecret = "4321"
    let accessToken = "APP_USR-7353443692214630-050609-ffc870c554412cea8bd8eff2cb6e935d__LA_LB__-175428814"
    
    var sendAccessToken = true
    var sendAppId = true
    var sendAppFee = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTapOnScreen))
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
                        let baseQuery = getURL(amount, installments: installments, debitCredit: paymentType, referenceCode: paymentReference)
                        openURL(baseQuery)
                    }else{
                        let baseQuery = getURL(amount, installments: installments, debitCredit: paymentType, referenceCode: nil)
                        openURL(baseQuery)
                    }
                }else{
                    let baseQuery = getURL(amount, installments: installments, debitCredit: paymentType, referenceCode: nil)
                    openURL(baseQuery)
                }
            }else{
                UIAlertView(title: "Error", message: "Por favor complete todos los campos", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }else{
            UIAlertView(title: "Error", message: "Por favor complete todos los campos", delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    func getURL(amount : String, installments: String?, debitCredit: String, referenceCode : String?) -> String{
        var baseQuery = "?amount=\(amount)&success_url=\(successURL)&fail_url=\(failureURL)&debit_credit=\(paymentType)"
        if let installments = installments {
            baseQuery += "&installments=\(installments)"
        }
        if let referenceCode = referenceCode{
            baseQuery += "&description=\(referenceCode)"
        }
        if sendAppId {
            baseQuery += "&client_id=\(clientId)&client_secret=\(clientSecret)"
        }
        if sendAccessToken {
            baseQuery += "&access_token=\(accessToken)"
        }
        if sendAppFee {
            baseQuery += "&application_fee=\(3)"
        }
        return baseQuery
    }
    
    func openURL(baseQuery : String){
        let query = baseQuery.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        let url = NSURL(string: "mpos://" + query)
        UIApplication.sharedApplication().openURL(url!)
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

