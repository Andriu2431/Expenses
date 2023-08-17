//
//  PasscodeView.swift
//  Expenses
//
//  Created by Andrii Malyk on 17.08.2023.
//

import UIKit

class Passcode: UIView {
    var didFinishedEnterCode:((String)-> Void)?
    
    private let stack = UIStackView()
    private var maxLength = 4
    private var code: String = "" {
        didSet {
            updateStack(by: code)
            if code.count == maxLength, let didFinishedEnterCode = didFinishedEnterCode {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    didFinishedEnterCode(self.code)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    private func setupUI() {
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        updateStack(by: code)
    }
    
    private func updateStack(by code: String) {
        var emptyPins:[UIView] = Array(0..<maxLength).map{_ in emptyPin()}
        let userPinLength = code.count
        let pins:[UIView] = Array(0..<userPinLength).map{_ in pin()}
        
        for (index, element) in pins.enumerated() {
            emptyPins[index] = element
        }
        stack.removeAllArrangedSubviews()
        for view in emptyPins {
            stack.addArrangedSubview(view)
        }
    }
    
    private func emptyPin() -> UIView {
        let pin = Pin()
        pin.pin.backgroundColor = #colorLiteral(red: 0.3300272226, green: 0.2663447857, blue: 0.5687814951, alpha: 1).withAlphaComponent(0.3)
        return pin
    }
    
    private func pin() -> UIView {
        let pin = Pin()
        pin.pin.backgroundColor = #colorLiteral(red: 0.3300272226, green: 0.2663447857, blue: 0.5687814951, alpha: 1)
        return pin
    }
    
    func insertText(_ text: String) {
        if code.count == maxLength {
            return
        }
        code.append(contentsOf: text)
    }
    
    func deleteBackward() {
        if code.count > 0 {
            code.removeLast()
        }
    }
    
    func clearAllCode() {
        code.removeAll()
    }
}
