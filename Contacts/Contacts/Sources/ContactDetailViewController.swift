//
//  ContactDetailViewController.swift
//  MVVM
//
//  Created by Alexey Bukhtin on 11/02/2017.
//  Copyright © 2017 FocusCura. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class ContactDetailViewController: UIViewController {
    var contactViewModel: ContactViewModel = ContactViewModel()
    private let disposeBag = DisposeBag()

    lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First Name"
        self.view.addSubview(textField)

        textField.snp.makeConstraints({ (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        })

        return textField
    }()

    lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last Name"
        self.view.addSubview(textField)

        textField.snp.makeConstraints({ (make) in
            make.top.equalTo(self.firstNameTextField.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        })

        return textField
    }()

    lazy var saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor(red: 0.2, green: 0.7, blue: 0.2, alpha: 1), for: .disabled)
        button.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1)
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.titleLabel?.textAlignment = .center
        button.sizeToFit()
        self.view.addSubview(button)

        button.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lastNameTextField.snp.bottom).offset(20)
            make.centerX.equalTo(self.view.snp.centerX)
        })

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        saveButton.addTarget(self, action: #selector(saveAndDismiss), for: .touchUpInside)
        firstNameTextField.text = contactViewModel.firstName
        lastNameTextField.text = contactViewModel.lastName

        // Disable saveButton, if textfields are empty.
        let isEnabled = Observable.combineLatest(firstNameTextField.rx.text, lastNameTextField.rx.text) { (firstName, lastName) -> Bool in
            return (firstName?.characters.count)! > 0 || (lastName?.characters.count)! > 0
        }

        isEnabled.bindTo(saveButton.rx.isEnabled).addDisposableTo(disposeBag)
    }

    func saveAndDismiss() {
        contactViewModel.update(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!)
        _ = navigationController?.popViewController(animated: true)
    }
}
