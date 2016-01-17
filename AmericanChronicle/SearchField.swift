//
//  SearchField.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/31/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class SearchField: UIView, UITextFieldDelegate {

    let textField: UITextField
    var shouldBeginEditingHandler: ((Void) -> Bool)?
    var shouldChangeCharactersHandler: ((text: String, range: NSRange, replacementString: String) -> Bool)?
    var shouldReturnHandler: ((Void) -> Bool)?
    var placeholder: String? {
        get {
            return textField.placeholder
        }
        set {
            textField.placeholder = newValue
        }
    }

    var text: String {
        get {
            return textField.text!
        }
        set {
            textField.text = newValue
        }
    }

    // Init methods

    func commonInit() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)

        textField.delegate = self

        let searchIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        searchIcon.image = UIImage(named: "apd_toolbar_search")
        searchIcon.contentMode = .Center
        textField.leftView = searchIcon
        textField.leftViewMode = .Always
        textField.placeholder = "Search all Newspapers"
        textField.font = UIFont(name: "AvenirNext-Regular", size: 20.0)
        textField.autocapitalizationType = .None
        textField.autocorrectionType = .No
        textField.returnKeyType = .Search
        textField.snp_makeConstraints { make in
            make.leading.equalTo(10.0)
            make.top.equalTo(10.0)
            make.trailing.equalTo(-10.0)
            make.bottom.equalTo(-10.0)
        }
    }

    required init?(coder: NSCoder) {
        textField = UITextField()
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        textField = UITextField()
        super.init(frame: frame)
        self.commonInit()
    }

    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }

    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 64)
    }

    // MARK: UITextFieldDelegate methods

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return shouldBeginEditingHandler?() ?? true
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return shouldChangeCharactersHandler?(text: textField.text!, range: range, replacementString: string) ?? true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return shouldReturnHandler?() ?? true
    }
}
