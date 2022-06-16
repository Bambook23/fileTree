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

  init(itemType: ItemType, parentUUID: String, networkManager: NetworkManager) {
    self.itemAddingControllerView = ItemAddingControllerView()
    self.networkManager = networkManager
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
    view().setCancelButtonAction(target: self, action: #selector(onCancelButtonTap), for: .touchUpInside)
    view().setCreateButtonAction(target: self, action: #selector(onCreateButtonTap), for: .touchUpInside)
  }

}

extension ItemAddingController {

  @objc private func onCancelButtonTap() {
    print("Adding canceled")
  }

  @objc private func onCreateButtonTap() {
    createItem()
  }

  private func createItem() {
    networkManager.createItem(parentUUID: "DB5CBFD0-8A96-4D1E-B2A7-09419BDC2198",
                              itemType: .file,
                              itemName: view().getTextFieldText() ?? "No name")
  }

}
