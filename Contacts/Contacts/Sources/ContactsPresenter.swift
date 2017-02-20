//
//  ContactsPresenter.swift
//  MVVM
//
//  Created by Alexey Bukhtin on 20/02/2017.
//  Copyright © 2017 FocusCura. All rights reserved.
//

import Foundation

struct ConstactsPresenter {
    let contactsRouter: ContactsRouter
    let contactsDataSource: ContactsDataSource
    weak var contactsViewController: ContactsViewController!

    func contactDidSelected(at index: Int) {
        let contactViewModel = contactsDataSource.results.value[index]
        contactsRouter.showContactDetail(contactViewModel: contactViewModel)
    }
}
