//
//  FileTreeController.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

final class FileTreeController: UIViewController {

  private let fileTreeControllerView = FileTreeControllerView()

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
    30
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridLayoutCell", for: indexPath)
    return cell
  }

}
