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
  private var cellConstraints: [NSLayoutConstraint] = []

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

    let imageViewHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 80)
    imageViewHeightConstraint.priority = UILayoutPriority(999)

    cellConstraints = [
      iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      imageViewHeightConstraint,

      titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
    ]

    NSLayoutConstraint.activate(cellConstraints)
    
  }

  func setData(isDirectory: Bool, title: String) {
    self.iconImageView.image = UIImage(named: isDirectory ? "folder" : "file")
    self.titleLabel.text = title
  }

  func deactivateConstraints() {
    NSLayoutConstraint.deactivate(cellConstraints)
  }

}
