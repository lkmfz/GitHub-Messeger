//
//  UsersContentCell.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 3/3/2020.
//

import UIKit

final class UsersContentCell: UITableViewCell {

    private struct Constants {
        static let avatarHeight: CGFloat = 55.0
        static let padding: CGFloat = 12.0
    }

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "ic-avatar"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.avatarHeight * 0.5
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray5.cgColor
        return imageView
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = UIColor.darkText
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
    }
    
    private func setupViews() {
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        accessoryType = .disclosureIndicator
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)

        avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding).isActive = true
        avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarHeight).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarHeight).isActive = true

        usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding).isActive = true
        usernameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.padding).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding).isActive = true
        usernameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.avatarHeight).isActive = true
    }

    func configure(_ user: UserContentItemInterface) {
        usernameLabel.text = user.title
        avatarImageView.loadImage(from: user.imageURL, placeholder: #imageLiteral(resourceName: "ic-avatar"))
    }
}

