//
//  ItemAddingControllerView.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 16.06.2022.
//

import UIKit

final class ItemAddingControllerView: UIView {

  private let itemAddingView: UIView
  private let label: UILabel
  private let textField: UITextField
  private let createButton: UIButton
  private let cancelButton: UIButton

  override init(frame: CGRect) {
    self.itemAddingView = UIView()
    self.label = UILabel()
    self.textField = UITextField()
    createButton = UIButton()
    cancelButton = UIButton()
    super.init(frame: frame)
    setupSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

}

extension ItemAddingControllerView {

  private func setupSubviews() {
    self.alpha = 70

    itemAddingView.backgroundColor = .white
    itemAddingView.layer.cornerRadius = 5

    label.font = .systemFont(ofSize: 20)
    label.text = "Create item"

    textField.placeholder = "Name"
    textField.layer.borderWidth = 0.25

    createButton.setTitle("Create", for: .normal)
    createButton.setTitleColor(.systemBlue, for: .normal)
    createButton.setTitleShadowColor(.black, for: .highlighted)

    cancelButton.setTitle("Cancel", for: .normal)
    cancelButton.setTitleColor(.systemRed, for: .normal)
    cancelButton.setTitleShadowColor(.black, for: .highlighted)

    itemAddingView.translatesAutoresizingMaskIntoConstraints = false
    label.translatesAutoresizingMaskIntoConstraints = false
    textField.translatesAutoresizingMaskIntoConstraints = false
    createButton.translatesAutoresizingMaskIntoConstraints = false
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(itemAddingView)
    itemAddingView.addSubview(label)
    itemAddingView.addSubview(textField)
    itemAddingView.addSubview(createButton)
    itemAddingView.addSubview(cancelButton)

    NSLayoutConstraint.activate([
      itemAddingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      itemAddingView.centerYAnchor.constraint(equalTo: self.centerYAnchor,
                                              constant: -UIScreen.main.bounds.height * 0.20),
      itemAddingView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7),
      itemAddingView.heightAnchor.constraint(equalToConstant: 180),

      label.centerXAnchor.constraint(equalTo: itemAddingView.centerXAnchor),
      label.topAnchor.constraint(equalTo: itemAddingView.topAnchor, constant: 20),
      label.heightAnchor.constraint(equalToConstant: 30),

      textField.leadingAnchor.constraint(equalTo: itemAddingView.leadingAnchor, constant: 30),
      textField.trailingAnchor.constraint(equalTo: itemAddingView.trailingAnchor, constant: -30),
      textField.topAnchor.constraint(equalTo: label.topAnchor, constant: 50),
      textField.heightAnchor.constraint(equalToConstant: 30),

      createButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
      createButton.trailingAnchor.constraint(equalTo: itemAddingView.trailingAnchor),
      createButton.widthAnchor.constraint(equalTo: itemAddingView.widthAnchor, multiplier: 0.5),
      createButton.bottomAnchor.constraint(equalTo: itemAddingView.bottomAnchor, constant: -20),

      cancelButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
      cancelButton.leadingAnchor.constraint(equalTo: itemAddingView.leadingAnchor),
      cancelButton.widthAnchor.constraint(equalTo: itemAddingView.widthAnchor, multiplier: 0.5),
      cancelButton.bottomAnchor.constraint(equalTo: itemAddingView.bottomAnchor, constant: -20)
    ])
  }

}

extension ItemAddingControllerView {

  func setCancelButtonAction(target: Any, action: Selector, for event: UIControl.Event) {
    cancelButton.addTarget(target, action: action, for: event)
  }

  func setCreateButtonAction(target: Any, action: Selector, for event: UIControl.Event) {
    createButton.addTarget(target, action: action, for: event)
  }

  func getTextFieldText() -> String? {
    textField.text
  }

}
