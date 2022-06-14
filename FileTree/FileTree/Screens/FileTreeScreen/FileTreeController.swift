//
//  FileTreeController.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

final class FileTreeController: UIViewController {

  private let fileTreeControllerView: FileTreeControllerView
  private let requestsManager: NetworkManager
  private var collectionViewLayoutStyle: CollectionViewLayoutStyle

  init(collectionViewLayoutStyle: CollectionViewLayoutStyle, requestsManager: NetworkManager) {
    self.collectionViewLayoutStyle = collectionViewLayoutStyle
    self.fileTreeControllerView = FileTreeControllerView(collectionViewLayoutStyle:
                                                          collectionViewLayoutStyle)
    self.requestsManager = requestsManager
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
    requestsManager.getItems()
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
      button.setImage(UIImage(named: collectionViewLayoutStyle == .grid ? "list" : "grid"),
                      for: .normal)
      button.addTarget(self, action: #selector(changeLayout), for: .touchDown)

      return button
    }()

    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: layoutButton)
  }

  @objc private func changeLayout() {
    let layoutContainer = CollectionViewLayoutContainer()

    if collectionViewLayoutStyle == .grid {
      view().collectionView.setCollectionViewLayout(layoutContainer.tableLayout, animated: true)
      collectionViewLayoutStyle = .table
    } else {
      view().collectionView.setCollectionViewLayout(layoutContainer.gridLayout, animated: true)
      collectionViewLayoutStyle = .grid
    }

    func reloadVisibleCells() {
      let indexPaths = view().collectionView.indexPathsForVisibleItems
      for path in indexPaths {
        if let cell = view().collectionView.cellForItem(at: path) {
          cell.removeFromSuperview()
        }
      }
      view().collectionView.reloadItems(at: indexPaths)
    }
    
    reloadVisibleCells()

    setLayoutButton()
  }

}

extension FileTreeController: UICollectionViewDataSource, UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    100
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
