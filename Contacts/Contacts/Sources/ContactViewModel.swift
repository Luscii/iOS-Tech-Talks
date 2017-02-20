//
//  ContactViewModel.swift
//  MVVM
//
//  Created by Alexey Bukhtin on 10/02/2017.
//  Copyright © 2017 FocusCura. All rights reserved.
//

import Foundation
import RealmSwift

struct ContactViewModel {
    let firstName: String
    let lastName: String
    let fullName: String
    private var contactReference: ThreadSafeReference<Contact>?

    init() {
        firstName = ""
        lastName = ""
        fullName = ""
    }

    init(contact: Contact) {
        self.firstName = contact.firstName
        self.lastName = contact.lastName
        fullName = "\(contact.firstName) \(contact.lastName)".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        contactReference = ThreadSafeReference(to: contact)
    }

    func update(firstName: String, lastName: String) {
        let realm = try! Realm()
        var contact: Contact!

        if let contactReference = contactReference {
            contact = realm.resolve(contactReference)
        }

        try! realm.write {
             if contact == nil {
                contact = Contact()
                realm.add(contact)
            }

            contact.firstName = firstName
            contact.lastName = lastName
        }
    }
}
