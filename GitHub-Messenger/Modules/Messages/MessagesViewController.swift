//
//  MessagesViewController.swift
//  GitHub-Messenger
//
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class MessagesViewController: UIViewController {

    // MARK: - Private properties -

    private lazy var collectionView: MessageCollectionView = {
        let view = MessageCollectionView()
        view.dataSource = self
        view.delegate = self
        view.prefetchDataSource = self
        view.isPrefetchingEnabled = true
        return view
    }()
    
    private lazy var messageInputView: MessageInputView = {
        let view = MessageInputView()
        view.didSendMessage = presenter.insertNewTextMessage
        return view
    }()

    private let keyboardLayoutGuide = MessageInputLayoutGuide()

    // MARK: - Public properties -

    var presenter: MessagesPresenterInterface!

    // MARK: - Lifecycle -
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        navigationItem.largeTitleDisplayMode = .never
        title = user.title
        view.backgroundColor = .secondarySystemBackground
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presenter.viewDidLoad()
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        presenter.keyboardWillShow()
    }
}

// MARK: - Extensions -

extension MessagesViewController: MessagesViewInterface {

    func setupViews() {
        view.addSubview(collectionView)
        view.addLayoutGuide(keyboardLayoutGuide)
        view.addSubview(messageInputView)

        collectionView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor).isActive = true

        messageInputView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor).isActive = true
        messageInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    func showAlertMessage(_ message: String) {
        let alertView = UIAlertController(title: "Oopss, sorry.. 😿", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(action)
        present(alertView, animated: true, completion: nil)
    }

    func scrollToBottom(animated: Bool) {
        collectionView.scrollToBottom(animated: animated)
    }

    func performBatchUpdate(_ message: Message) {
        guard (presenter.numberOfSections() - 1) >= 0 else {
            presenter.showErrorMessage("Something went wrong 😢")
            return
        }

        collectionView.performBatchUpdates({
            self.presenter.appendNewMessage(message)
            self.collectionView.insertSections([presenter.numberOfSections() - 1])
        }, completion: { _ in
            self.scrollToBottom(animated: true)
        })
    }
}

extension MessagesViewController: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout {

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOrItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = presenter.item(at: indexPath)
        let cell: MessageContentCell

        switch message.direction {
        case .outgoing:
            cell = collectionView.dequeueReusableCell(withClass: MessageContentCell.self, identifier: MessageContentCell.NibName.outgoing, for: indexPath)
        case .incoming:
            cell = collectionView.dequeueReusableCell(withClass: MessageContentCell.self, identifier: MessageContentCell.NibName.incoming, for: indexPath)
        }

        cell.configure(message)
        return cell
    }

    // MARK: UICollectionViewDataSourcePrefetching

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let message = presenter.item(at: indexPath)
            self.collectionView.calculatedCellSize(message: message, indexPath: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = presenter.item(at: indexPath)
        return self.collectionView.calculatedCellSize(message: message, indexPath: indexPath)
    }

    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: .greatestFiniteMagnitude, height: 20.0)
    }
}
