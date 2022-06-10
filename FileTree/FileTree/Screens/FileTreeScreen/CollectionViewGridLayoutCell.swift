//
//  CollectionViewGridLayoutCell.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

final class CollectionViewGridLayoutCell: UICollectionViewCell {

  private let iconImageView = UIImageView()
  private let titleLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

}

extension CollectionViewGridLayoutCell {

  private func setupSubviews() {
    contentView.layer.borderWidth = 1
    contentView.layer.cornerRadius = 5

    iconImageView.contentMode = .scaleToFill
    iconImageView.layer.masksToBounds = true
    iconImageView.translatesAutoresizingMaskIntoConstraints = false

    titleLabel.textAlignment = .center
    titleLabel.font = .systemFont(ofSize: 15, weight: .regular)
    titleLabel.numberOfLines = 0
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(iconImageView)
    contentView.addSubview(titleLabel)

    NSLayoutConstraint.activate([
      iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
      iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
      iconImageView.heightAnchor.constraint(equalToConstant: 70),

      titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
    ])
  }

  func setData(isDirectory: Bool, title: String) {
    self.iconImageView.image = UIImage(named: isDirectory ? "folder" : "file")
    self.titleLabel.text = title
  }

}
