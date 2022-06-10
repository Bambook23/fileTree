//
//  FileTreeControllerView.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

final class FileTreeControllerView: UIView {

  let collectionView: UICollectionView = {
    let layoutContainer = CollectionViewLayoutContainer()

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutContainer.tableLayout)
    collectionView.showsVerticalScrollIndicator = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(CollectionViewGridLayoutCell.self, forCellWithReuseIdentifier: "gridLayoutCell")
    collectionView.register(CollectionViewTableLayoutCell.self, forCellWithReuseIdentifier: "tableLayoutCell")

    return collectionView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

}

extension FileTreeControllerView {

  private func setupSubviews() {
    backgroundColor = .white
    addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
      collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
    ])

  }

}

struct CollectionViewLayoutContainer {

  let gridLayout: UICollectionViewFlowLayout = {
    let gridLayout = UICollectionViewFlowLayout()
    gridLayout.scrollDirection = .vertical
    gridLayout.itemSize = CGSize(width: 110, height: 150)

    return gridLayout
  }()

  let tableLayout: UICollectionViewLayout = {
    let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    return UICollectionViewCompositionalLayout.list(using: config)
  }()

}

enum CollectionViewLayoutStyle {

  case grid
  case table

}
