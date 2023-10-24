//
//  UIStackView+Extension.swift
//  ForeFlightCodingExercise
//
//  Created by Danny Tsang on 10/23/23.
//

import UIKit

extension UIStackView {
    func removeAllArrangedViews() {
        for view in self.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
