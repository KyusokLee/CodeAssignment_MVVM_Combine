//
//  UIColor+Utils.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/02.
//

import Foundation
import UIKit

/// UIColorをhex codeタイプで設定できるように
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: CGFloat(a) / 255.0
        )
    }
    
    convenience init(rgb: Int) {
        self.init(red: (rgb >> 16) & 0xFF,
                  green: (rgb >> 8) & 0xFF,
                  blue: rgb & 0xFF
        )
    }
    
    convenience init(argb: Int) {
        self.init(red: (argb >> 16) & 0xFF,
                  green: (argb >> 8) & 0xFF,
                  blue: argb & 0xFF,
                  a: (argb >> 24) & 0xFF
        )
    }
}
