//
//  CollectionViewGridLayoutCell.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

final class CollectionViewGridLayoutCell: UICollectionViewCell {

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

    let iconImageView: UIImageView = {
      let imageView = UIImageView(image: UIImage(named: "folder"))
      imageView.contentMode = .scaleToFill
      imageView.layer.masksToBounds = true
      imageView.translatesAutoresizingMaskIntoConstraints = false

      return imageView
    }()

    let titleLabel: UILabel = {
      let label = UILabel()
      label.textAlignment = .center
      label.font = .systemFont(ofSize: 15, weight: .regular)
      label.numberOfLines = 0
      label.text = "file.txtaSasASasasfdfsdfasdasdfile.txtaSasASasasfdfsdfasdasd"
      label.translatesAutoresizingMaskIntoConstraints = false

      return label
    }()

    contentView.addSubview(iconImageView)
    contentView.addSubview(titleLabel)

    NSLayoutConstraint.activate([
      iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      iconImageView.heightAnchor.constraint(equalToConstant: 70),

      titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
    ])

  }

}
