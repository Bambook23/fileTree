//
//  FileTreeControllerView.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

final class FileTreeControllerView: UIView {

  private let collectionViewLayoutStyle: CollectionViewLayoutStyle

  let collectionView: UICollectionView

  init(collectionViewLayoutStyle: CollectionViewLayoutStyle) {
    self.collectionViewLayoutStyle = collectionViewLayoutStyle
    let layoutContainer = CollectionViewLayoutContainer()
    self.collectionView = UICollectionView(frame: .zero,
                                           collectionViewLayout: collectionViewLayoutStyle == .grid ? layoutContainer.gridLayout : layoutContainer.tableLayout)
    super.init(frame: .zero)
    setupSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("Should use another initializer")
  }

}

extension FileTreeControllerView {

  private func setupSubviews() {
    backgroundColor = .white
    addSubview(collectionView)

    collectionView.showsVerticalScrollIndicator = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(CollectionViewGridLayoutCell.self, forCellWithReuseIdentifier: "gridLayoutCell")
    collectionView.register(CollectionViewTableLayoutCell.self, forCellWithReuseIdentifier: "tableLayoutCell")

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
    var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    config.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    return UICollectionViewCompositionalLayout.list(using: config)
  }()

}

enum CollectionViewLayoutStyle {

  case grid
  case table

}
