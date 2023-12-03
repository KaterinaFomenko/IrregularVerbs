//
//  UIView+Ex.swift
//  IrregularVerbs
//
//  Created by Katerina on 29/11/2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            addSubview(view)
        }
    }
}



