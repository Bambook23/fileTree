//
//  FileTreeController.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

final class FileTreeController: UIViewController {

  private let fileTreeControllerView: FileTreeControllerView
  private var collectionViewLayoutStyle: CollectionViewLayoutStyle

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
    setupNavbar()
    view().collectionView.delegate = self
    view().collectionView.dataSource = self
  }

}

extension FileTreeController {

  private func view() -> FileTreeControllerView {
    view as! FileTreeControllerView
  }

  private func setupNavbar() {
    title = "Title"
    setLayoutButton()
  }

  private func setLayoutButton() {
    let layoutButton: UIButton = {
      let button = UIButton()
      button.setImage(UIImage(named: collectionViewLayoutStyle == .grid ? "grid" : "list"),
                      for: .normal)
      button.addTarget(self, action: #selector(changeLayout), for: .touchDown)

      return button
    }()

    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: layoutButton)
  }

  @objc private func changeLayout() {
    view().collectionView.collectionViewLayout.invalidateLayout()
    let layoutContainer = CollectionViewLayoutContainer()
    if collectionViewLayoutStyle == .grid {
      view().collectionView.collectionViewLayout.invalidateLayout()
      collectionViewLayoutStyle = .table
      view().collectionView.setCollectionViewLayout(layoutContainer.tableLayout, animated: true)
    } else {
      view().collectionView.collectionViewLayout.invalidateLayout()
      view().collectionView.setCollectionViewLayout(layoutContainer.gridLayout, animated: true)
      collectionViewLayoutStyle = .grid
    }
    let indexPath = view().collectionView.indexPathsForVisibleItems
    for path in indexPath {
      let cell = view().collectionView.cellForItem(at: path)
      cell?.removeFromSuperview()
    }
    view().collectionView.reloadItems(at: indexPath)
    setLayoutButton()
  }
  
}

extension FileTreeController: UICollectionViewDataSource, UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    3
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
