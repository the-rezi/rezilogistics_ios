//
//  ViewController.swift
//  ReziLogistics
//
//  Created by Husein Kareem on 11/15/18.
//  Copyright © 2018 Rezi Logistics. All rights reserved.
//

import UIKit
import NMAKit

class ViewController: UIViewController {

    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    
    private let customerPhoneNumber = "tel://1234567890"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.goButton.layer.cornerRadius = 128.0 / 2.0
        self.callButton.layer.borderWidth = 1.0
        self.callButton.layer.borderColor = UIColor.blue.cgColor
    }

    @IBAction private func callButtonTapped(_ sender: Any) {
        guard let url = URL(string: self.customerPhoneNumber) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}

