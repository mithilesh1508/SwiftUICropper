//
//  ImageUtils.swift
//  CropperSwiftUI
//
//  Created by Mithilesh on 11/04/25.
//

import Foundation
extension CGFloat {
    func mmToPixels(dpi: CGFloat = 300) -> CGFloat {
        return (self / 25.4) * dpi
    }
}
