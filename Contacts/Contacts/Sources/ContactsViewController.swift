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
        tableView.delegate = self
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
        setupAddButton()

        // Bind DataSource to TableView.
        if let contactsPresenter = contactsPresenter {
            contactsPresenter.contactsDataSource.results.asObservable().bindTo(tableView.rx.items(cellIdentifier: "ContactCell")) { _, contactViewModel, cell in
                cell.textLabel?.text = contactViewModel.fullName
                cell.accessoryType = .disclosureIndicator
            }.disposed(by: self.disposeBag)
        }
    }

    private func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: contactsPresenter.contactsRouter,
                                                            action: #selector(ContactsRouter.showNewContactDetail))
    }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let contactsPresenter = contactsPresenter else {
            return
        }

        contactsPresenter.contactDidSelected(at: indexPath.row)
    }
}
