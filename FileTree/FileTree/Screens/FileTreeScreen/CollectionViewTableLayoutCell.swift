//
//  CollectionViewTableLayoutCell.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

final class CollectionViewTableLayoutCell: UICollectionViewListCell {

  private var configuration: UIListContentConfiguration! = nil

  override init(frame: CGRect) {
    super.init(frame: frame)
    configuration = defaultContentConfiguration()
    setupSubviews()

  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

}

extension CollectionViewTableLayoutCell {

  private func setupSubviews() {
    configuration.imageProperties.maximumSize = CGSize(width: 25, height: 30)
    configuration.textProperties.numberOfLines = 1
  }

  func setData(isDirectory: Bool, title: String) {
    configuration.image = UIImage(named: isDirectory ? "folder" : "file")
    accessories = isDirectory ? [.disclosureIndicator()] : []
    configuration.text = title
    contentConfiguration = configuration
  }

}
