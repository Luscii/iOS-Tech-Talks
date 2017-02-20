//
//  ContactsDataSource.swift
//  MVVM
//
//  Created by Alexey Bukhtin on 10/02/2017.
//  Copyright © 2017 FocusCura. All rights reserved.
//

import RealmSwift
import RxSwift
import RxRealm

class ContactsDataSource {
    var results = Variable<[ContactViewModel]>([])
    let disposeBag = DisposeBag()

    init() {
        let realm = try! Realm()
        let contacts = realm.objects(Contact.self)

        Observable.array(from: contacts)
            .map { contacts in
                return contacts.map { contact in
                    return ContactViewModel(contact: contact)
                }
            }
            .subscribe { [unowned self] contactViewModels in
                if let contactViewModels = contactViewModels.element {
                    self.results.value = contactViewModels
                }
        }.addDisposableTo(disposeBag)
    }
}
