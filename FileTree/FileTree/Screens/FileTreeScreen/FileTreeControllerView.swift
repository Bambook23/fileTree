//
//  FileTreeControllerView.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

final class FileTreeControllerView: UIView {

  let collectionView: UICollectionView = {
    let gridLayout = UICollectionViewFlowLayout()
    gridLayout.scrollDirection = .vertical
    gridLayout.itemSize = CGSize(width: 120, height: 150)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
    collectionView.showsVerticalScrollIndicator = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(CollectionViewGridLayoutCell.self, forCellWithReuseIdentifier: "gridLayoutCell")

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
