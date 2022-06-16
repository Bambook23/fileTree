//
//  ItemAddingController.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 16.06.2022.
//

import UIKit

final class ItemAddingController: UIViewController {

  private let itemAddingControllerView: ItemAddingControllerView
  private let networkManager: NetworkManager
  private let parentUUID: String
  private let itemType: ItemType

  init(itemType: ItemType, parentUUID: String, networkManager: NetworkManager) {
    self.itemAddingControllerView = ItemAddingControllerView()
    self.networkManager = networkManager
    self.parentUUID = parentUUID
    self.itemType = itemType
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("Shoud use another init")
  }

  override func loadView() {
    view = itemAddingControllerView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubviews()
  }

}

extension ItemAddingController {

  private func view() -> ItemAddingControllerView {
    view as! ItemAddingControllerView
  }

  private func setupSubviews() {
    view().setLabelText(itemType: itemType)
    view().setCancelButtonAction(target: self, action: #selector(onCancelButtonTap), for: .touchUpInside)
    view().setCreateButtonAction(target: self, action: #selector(onCreateButtonTap), for: .touchUpInside)
  }

}

extension ItemAddingController {

  @objc private func onCancelButtonTap() {
    print("Adding canceled")
    dismiss(animated: true)
  }

  @objc private func onCreateButtonTap() {
    if let itemName = view().getTextFieldText() {
      if itemName.isEmpty {
        dismiss(animated: true)
      } else {
        createItem()
      }
    }
  }

  private func createItem() {
    let dismissView = { [weak self] in
      self?.dismiss(animated: true)
    }
    networkManager.createItem(parentUUID: parentUUID,
                              itemType: itemType,
                              itemName: view().getTextFieldText() ?? "No name",
                              completion: dismissView)
  }

}
