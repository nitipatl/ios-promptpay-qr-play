//
//  ViewController.swift
//  test
//
//  Created by Nitipat L on 9/1/2560 BE.
//  Copyright © 2560 Nitipat L. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var imgQRCode: UIImageView = UIImageView()
    var fieldID: UITextField = UITextField()
    var fieldMoney: UITextField = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        fieldID = UITextField(frame: CGRect(x: view.frame.width / 2 - 100, y: 100, width: 200.00, height: 30.00));
        fieldID.borderStyle = UITextBorderStyle.line
        fieldID.text = "xxxxxxxxxx"
        fieldID.keyboardType = UIKeyboardType.numberPad
        view.addSubview(fieldID)
        fieldID.addTarget(self, action: #selector(textFieldIDDidChange(_:)), for: .editingChanged)
        
        fieldMoney = UITextField(frame: CGRect(x: view.frame.width / 2 - 100, y: 140, width: 100.00, height: 30.00));
        fieldMoney.borderStyle = UITextBorderStyle.line
        fieldMoney.text = "100.00"
        fieldMoney.keyboardType = UIKeyboardType.numbersAndPunctuation
        view.addSubview(fieldMoney)
        fieldMoney.addTarget(self, action: #selector(textFieldMoneyDidChange(_:)), for: .editingChanged)
        
        imgQRCode = UIImageView(frame: CGRect(x: view.frame.width / 2 - 150, y: view.frame.height / 3, width: 300.00, height: 300.00))
        view.addSubview(imgQRCode)
        reloadQR()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let scaleX = imgQRCode.frame.width / (filter.outputImage?.extent.size.width)!
            let scaleY = imgQRCode.frame.height / (filter.outputImage?.extent.size.height)!
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            
            if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    func reloadQR() {
        
        let amount = String(format: "%02d", (fieldMoney.text?.characters.count)!) + fieldMoney.text!
        let code = "00020101021129370016A0000006770101110213"+fieldID.text!+"5802TH54"+amount+"53037646304"
        let chsum = String(format: "%04X", crc16(code)!)
        imgQRCode.image = generateQRCode(from: code + chsum)
    }
    
    func textFieldIDDidChange(_ textField: UITextField) {
        reloadQR()
    }
    func textFieldMoneyDidChange(_ textField: UITextField) {
        reloadQR()
    }
    
    func crc16(_ data: String) -> UInt32? {
        var crc: UInt32 = 0xFFFF;
        for c in data.characters
        {
            let s = String(c).unicodeScalars
            var x = ((crc >> 8) ^ UInt32(s[s.startIndex].value)) & 0xFF
            x ^= x >> 4
            crc = ((crc << 8) ^ (x << 12) ^ (x << 5) ^ x) & 0xFFFF
        }
        return crc
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

