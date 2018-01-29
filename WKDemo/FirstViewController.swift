//
//  FirstViewController.swift
//  WKDemo
//
//  Created by Arnab on 29/01/18.
//  Copyright © 2018 Arnab Hore. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var urlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextField EditingChanged
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
//        DispatchQueue.main.async {
//            if (sender.text?.count)! > 0 && UIApplication.shared.canOpenURL(URL(string: sender.text!)!) {
//                self.urlTextField.returnKeyType = .go
//            } else {
//                self.urlTextField.returnKeyType = .default
//            }
//        }
    }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text?.count)! == 0 {
            textField.text = "https://"
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewController {
            if !(self.urlTextField.text?.isEmpty)! {
                vc.customUrl = urlTextField.text
            }
        }
    }
}
