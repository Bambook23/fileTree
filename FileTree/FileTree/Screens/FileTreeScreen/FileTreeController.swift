//
//  FileTreeController.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

final class FileTreeController: UIViewController {

  private var collectionData: [DirectoryObject]
  private var itemsToShow: [DirectoryObject] = []
  private let fileTreeControllerView: FileTreeControllerView
  private let directoryObjectUUID: UUID?
  private var requestsManager: NetworkManager
  private var collectionViewLayoutStyle: CollectionViewLayoutStyle

  init(collectionViewLayoutStyle: CollectionViewLayoutStyle, requestsManager: NetworkManager, collectionData: [DirectoryObject], directoryObjectUUID: UUID?) {
    self.collectionViewLayoutStyle = collectionViewLayoutStyle
    self.fileTreeControllerView = FileTreeControllerView(collectionViewLayoutStyle:
                                                          collectionViewLayoutStyle)
    self.requestsManager = requestsManager
    self.collectionData = collectionData
    self.directoryObjectUUID = directoryObjectUUID
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
    requestsManager.delegate = self
    view().collectionView.delegate = self
    view().collectionView.dataSource = self
    if navigationController?.viewControllers.first == self {
      requestsManager.getItems()
    } else {
      itemsToShow = getItemsToShow()
    }
  }

}

extension FileTreeController {

  private func view() -> FileTreeControllerView {
    view as! FileTreeControllerView
  }

  private func setupNavbar() {
    title = "Title"
    navigationItem.backButtonTitle = ""
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
    itemsToShow.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let directoryItem = itemsToShow[indexPath.row]
    switch collectionViewLayoutStyle {
    case .grid:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridLayoutCell", for: indexPath) as! CollectionViewGridLayoutCell
      cell.setData(isDirectory: directoryItem.itemType == .directory ? true : false,
                   title: directoryItem.itemName)
      return cell

    case .table:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableLayoutCell", for: indexPath) as! CollectionViewTableLayoutCell
      cell.setData(isDirectory: directoryItem.itemType == .directory ? true : false,
                   title: directoryItem.itemName)
      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedItem = itemsToShow[indexPath.row]
    if selectedItem.itemType == .directory {
      let controller = FileTreeController(collectionViewLayoutStyle: collectionViewLayoutStyle,
                                          requestsManager: requestsManager,
                                          collectionData: collectionData,
                                          directoryObjectUUID: UUID(uuidString: selectedItem.uuid))

      navigationController?.pushViewController(controller, animated: true)
    }
  }

}

extension FileTreeController: NetworkManagerDelegate {

  func didGetItems(items: [DirectoryObject]) {
    collectionData = items
    itemsToShow = getItemsToShow()
    self.view().collectionView.reloadData()
  }

}

extension FileTreeController {

  private func getItemsToShow() -> [DirectoryObject] {
    return collectionData.filter { directoryObject in
      return UUID(uuidString: directoryObject.parentUUID) == directoryObjectUUID
    }.sorted { $0.itemType < $1.itemType }
  }

}
