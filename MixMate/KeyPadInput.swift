//
//  KeyPadInput.swift
//  MixMate
//
//  Created by Chris Milne on 20/06/2025.
//

import SwiftUI
import UIKit

struct KeyPadInput: UIViewRepresentable {
    @Binding var text: String
    var isStyled: Bool
    var label: String
    var unit: String

    func makeUIView(context: Context) -> UIView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center

        let labelView = UILabel()
        labelView.tag = 1
        labelView.text = label
        labelView.font = UIFont.preferredFont(forTextStyle: .title2)
        labelView.textAlignment = .left
        labelView.widthAnchor.constraint(equalToConstant: 86).isActive = true
        labelView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let textField = UITextField()
        textField.tag = 99
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.inputView = UIView() // disable system keyboard
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.systemBackground
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = isStyled ? 3 : 1
        textField.layer.borderColor = (isStyled ? UIColor.red : UIColor.gray).cgColor
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 86).isActive = true
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 11

        let unitLabel = UILabel()
        unitLabel.tag = 2
        unitLabel.text = unit
        unitLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        unitLabel.textAlignment = .left
        unitLabel.widthAnchor.constraint(equalToConstant: 85).isActive = true
        unitLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        stack.addArrangedSubview(labelView)
        stack.addArrangedSubview(textField)
        stack.addArrangedSubview(unitLabel)

        return stack
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let stack = uiView as? UIStackView,
              let textField = stack.arrangedSubviews.first(where: { $0.tag == 99 }) as? UITextField
        else { return }

        textField.text = text
        textField.layer.borderWidth = isStyled ? 3 : 1
        textField.layer.borderColor = (isStyled ? UIColor.red : UIColor.gray).cgColor

        // Ensure label and unit refresh too
        if let labelView = stack.viewWithTag(1) as? UILabel {
            labelView.text = label
        }
        if let unitLabel = stack.viewWithTag(2) as? UILabel {
            unitLabel.text = unit
        }
    }
}
