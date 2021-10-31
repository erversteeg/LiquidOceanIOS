//
//  CanvasFrameViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 10/31/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

protocol CanvasFrameViewControllerDelegate: AnyObject {
    func createCanvasFrame(centerX: Int, centerY: Int, width: Int, height: Int)
}

class CanvasFrameViewController: UIViewController, UITextFieldDelegate {

    weak var delegate: CanvasFrameViewControllerDelegate?
    
    var x: Int!
    var y: Int!
    
    weak var canvasFrameViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
        lpgr.minimumPressDuration = 0
        lpgr.cancelsTouchesInView = false
        //view.addGestureRecognizer(lpgr)
    }
    
    override func viewDidLayoutSubviews() {
        setBackground()
    }
    
    @objc func didLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            widthTextField.resignFirstResponder()
            heightTextField.resignFirstResponder()
        }
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        if isInputValid(text: widthTextField.text!) && isInputValid(text: heightTextField.text!) {
            let width = Int(widthTextField.text!)!
            let height = Int(heightTextField.text!)!
            
            if width > 0 && width < 1000 && height > 0 && height < 1000 {
                delegate?.createCanvasFrame(centerX: x, centerY: y, width: width, height: height)
            }
        }
    }
    
    func isInputValid(text: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^\\d{1,3}$", options: [])
        let result = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.count))
        
        return result != nil
    }
    
    func closeKeyboard() {
        widthTextField.resignFirstResponder()
        heightTextField.resignFirstResponder()
    }
    
    func setBackground() {
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor(argb: Utils.int32FromColorHex(hex: "0xff000000")).cgColor, UIColor(argb: Utils.int32FromColorHex(hex: "0xff333333")).cgColor]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)

        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if canvasFrameViewTop.constant > 50 {
            canvasFrameViewTop.constant = 20
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == widthTextField {
            heightTextField.becomeFirstResponder()
        }
        else if textField == heightTextField {
            heightTextField.resignFirstResponder()
        }
        
        return true
    }
}
