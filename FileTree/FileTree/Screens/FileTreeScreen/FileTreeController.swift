//
//  FileTreeController.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

final class FileTreeController: UIViewController {

  private let fileTreeControllerView: FileTreeControllerView
  private let collectionViewLayoutStyle: CollectionViewLayoutStyle

  init(collectionViewLayoutStyle: CollectionViewLayoutStyle) {
    self.collectionViewLayoutStyle = collectionViewLayoutStyle
    self.fileTreeControllerView = FileTreeControllerView(collectionViewLayoutStyle:
                                                          collectionViewLayoutStyle)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Shoud use another init")
  }

  override func loadView() {
    view = fileTreeControllerView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view().collectionView.delegate = self
    view().collectionView.dataSource = self
  }

}

extension FileTreeController {

  private func view() -> FileTreeControllerView {
    view as! FileTreeControllerView
  }

}

extension FileTreeController: UICollectionViewDataSource, UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionViewLayoutStyle {
    case .grid:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridLayoutCell", for: indexPath) as! CollectionViewGridLayoutCell
      cell.setData(isDirectory: indexPath.row % 2 == 0, title: "test.txt")
      return cell

    case .table:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableLayoutCell", for: indexPath) as! CollectionViewTableLayoutCell
      cell.setData(isDirectory: indexPath.row % 2 == 0, title: "test.txt")
      return cell
    }
  }

}
