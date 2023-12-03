//
//  UIStackView+Ex.swift
//  IrregularVerbs
//
//  Created by Katerina on 29/11/2023.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
