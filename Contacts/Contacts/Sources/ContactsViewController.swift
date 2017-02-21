//
//  ViewController.swift
//  MVVM
//
//  Created by Alexey Bukhtin on 10/02/2017.
//  Copyright © 2017 FocusCura. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ContactsViewController: UIViewController {

    var contactsPresenter: ConstactsPresenter!
    let disposeBag = DisposeBag()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        setupTableView()
        setupAddButton()
    }

    private func setupTableView() {
        guard let contactsPresenter = contactsPresenter else {
            return
        }

        // Bind DataSource to TableView items.
        contactsPresenter.contactsDataSource.results.asObservable().bindTo(tableView.rx.items(cellIdentifier: "ContactCell")) { _, contactViewModel, cell in
            cell.textLabel?.text = contactViewModel.fullName
            cell.accessoryType = .disclosureIndicator
            }.disposed(by: self.disposeBag)

        // Subscribe to selected item events.
        _ = tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            contactsPresenter.contactDidSelected(at: indexPath.row)
        }).disposed(by: self.disposeBag)
    }

    private func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: contactsPresenter.contactsRouter,
                                                            action: #selector(ContactsRouter.showNewContactDetail))
    }
}
