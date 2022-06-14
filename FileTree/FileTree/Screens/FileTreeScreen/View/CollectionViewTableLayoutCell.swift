//  CollectionViewTableLayoutCell.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

final class CollectionViewTableLayoutCell: UICollectionViewCell {

  private let iconImageView = UIImageView()
  private let titleLabel = UILabel()
  private let accessoryImageView = UIImageView()
  private var cellConstraints: [NSLayoutConstraint] = []

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

}

extension CollectionViewTableLayoutCell {

  private func setupSubviews() {
    contentView.layer.borderWidth = 0.5
    contentView.layer.cornerRadius = 5

    iconImageView.contentMode = .scaleToFill
    iconImageView.layer.masksToBounds = true
    iconImageView.image = UIImage(named: "folder")
    iconImageView.translatesAutoresizingMaskIntoConstraints = false

    titleLabel.numberOfLines = 1
    titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    accessoryImageView.contentMode = .scaleToFill
    accessoryImageView.image = UIImage(systemName: "arrow.right")
    accessoryImageView.layer.masksToBounds = true
    accessoryImageView.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(iconImageView)
    contentView.addSubview(accessoryImageView)
    contentView.addSubview(titleLabel)

    cellConstraints = [
      iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
      iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
      iconImageView.widthAnchor.constraint(equalToConstant: 40),
      iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

      accessoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
      accessoryImageView.widthAnchor.constraint(equalToConstant: 20),

      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: accessoryImageView.trailingAnchor, constant: -20)
    ]

    NSLayoutConstraint.activate(cellConstraints)

  }

  func setData(isDirectory: Bool, title: String) {
    accessoryImageView.isHidden = !isDirectory
    iconImageView.image = UIImage(named: isDirectory ? "folder" : "file")
    titleLabel.text = title
  }

}
