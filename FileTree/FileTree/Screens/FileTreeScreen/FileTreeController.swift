//
//  FileTreeController.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 10.06.2022.
//

import UIKit

final class FileTreeController: UIViewController {

  private let dataContainer: DirectoryDataContainer
  private var itemsToShow: [DirectoryObject] = []
  private let fileTreeControllerView: FileTreeControllerView
  private let directoryObjectUUID: UUID?
  private var requestsManager: NetworkManager
  private var collectionViewLayoutStyle: CollectionViewLayoutStyle

  init(collectionViewLayoutStyle: CollectionViewLayoutStyle, requestsManager: NetworkManager, directoryObjectUUID: UUID?, dataContainer: DirectoryDataContainer) {
    self.collectionViewLayoutStyle = collectionViewLayoutStyle
    self.fileTreeControllerView = FileTreeControllerView(collectionViewLayoutStyle:
                                                          collectionViewLayoutStyle)
    self.requestsManager = requestsManager
    self.directoryObjectUUID = directoryObjectUUID
    self.dataContainer = dataContainer
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Shoud use another init")
  }

  override func loadView() {
    view = fileTreeControllerView
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    dataContainer.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavbar()
    requestsManager.delegate = dataContainer
    view().collectionView.delegate = self
    view().collectionView.dataSource = self
    addGestureToCollection()
    if navigationController?.viewControllers.first == self {
      requestsManager.getItems()
    } else {
      itemsToShow = getItemsToShow(from: dataContainer.collectionData)
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
                                          directoryObjectUUID: UUID(uuidString: selectedItem.uuid),
                                          dataContainer: dataContainer)

      navigationController?.pushViewController(controller, animated: true)
    }
  }

}

extension FileTreeController: DirectoryDataContainerDelegate {

  func didUpdataData(items: [DirectoryObject]) {
    itemsToShow = getItemsToShow(from: items)
    self.view().collectionView.reloadData()
  }

}

extension FileTreeController {

  private func getItemsToShow(from items: [DirectoryObject]) -> [DirectoryObject] {
    return items.filter { directoryObject in
      return UUID(uuidString: directoryObject.parentUUID) == directoryObjectUUID
    }.sorted { $0.itemType < $1.itemType }
  }

  private func addGestureToCollection() {
    let longPressedGesture = UILongPressGestureRecognizer(target: self,
                                                        action: #selector(self.onLongPress))

    longPressedGesture.minimumPressDuration = 1
    longPressedGesture.delaysTouchesBegan = true
    view().collectionView.addGestureRecognizer(longPressedGesture)
  }

  private func deleteItem(at path: IndexPath) {
    let item = itemsToShow[path.row]
    requestsManager.deleteItems(uuid: item.uuid, itemType: item.itemType)
  }

  @objc private func onLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
    if gestureRecognizer.state != .began { return }
    let point = gestureRecognizer.location(in: view().collectionView)
    if let indexPath = view().collectionView.indexPathForItem(at: point) {
      let alertController = UIAlertController(title: "Delete",
                                              message: "Do you want to delete an item?",
                                              preferredStyle: .actionSheet)

      let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
        self?.deleteItem(at: indexPath)
      }

      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
          print("Deletion canceled")
      }

      alertController.addAction(deleteAction)
      alertController.addAction(cancelAction)
      DispatchQueue.main.async { [weak self] in
        self?.navigationController?.present(alertController, animated: true)
      }
    }
  }

}
