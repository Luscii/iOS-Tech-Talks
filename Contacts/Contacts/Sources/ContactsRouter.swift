//
//  ContactRouter.swift
//  MVVM
//
//  Created by Alexey Bukhtin on 20/02/2017.
//  Copyright © 2017 FocusCura. All rights reserved.
//

import UIKit

struct ContactsRouter {
    let navigationController: UINavigationController

    func showNewContactDetail() {
        showContactDetail(nil)
    }

    func showContactDetail(contactViewModel: ContactViewModel) {
        showContactDetail(contactViewModel)
    }

    private func showContactDetail(_ contactViewModel: ContactViewModel?) {
        let contactDetailViewController = ContactDetailViewController()

        if let contactViewModel = contactViewModel {
            contactDetailViewController.contactViewModel = contactViewModel
        }

        navigationController.pushViewController(contactDetailViewController, animated: true)
    }
}
