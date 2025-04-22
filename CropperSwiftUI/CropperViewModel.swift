//
//  CropViewModel.swift
//  CropperSwiftUI
//
//  Created by Mithilesh on 10/04/25.
//

import Foundation
import SwiftUI

class CropperViewModel: ObservableObject {
    @Published var cropRect: CGRect
    let aspectRatio: CGFloat
    var imageSize: CGSize = .zero

    init(initialRect: CGRect, aspectRatio: CGFloat) {
        self.cropRect = initialRect
        self.aspectRatio = aspectRatio
    }

//    func updatePosition(by offset: CGSize, in bounds: CGSize) {
//        var newRect = cropRect.offsetBy(dx: offset.width, dy: offset.height)
//
//        // Constrain within bounds
//        newRect.origin.x = max(0, min(newRect.origin.x, bounds.width - newRect.width))
//        newRect.origin.y = max(0, min(newRect.origin.y, bounds.height - newRect.height))
//
//        cropRect = newRect
//    }

    func updatePosition(by delta: CGSize, in bounds: CGRect) {
        var newRect = cropRect
        newRect.origin.x += delta.width
        newRect.origin.y += delta.height

        // Clamp to bounds
        newRect.origin.x = max(bounds.minX, min(newRect.origin.x, bounds.maxX - newRect.width))
        newRect.origin.y = max(bounds.minY, min(newRect.origin.y, bounds.maxY - newRect.height))

        cropRect = newRect
    }

    func resize(by drag: CGSize, corner: Corner, in bounds: CGSize) {
        var newRect = cropRect
        let minWidth: CGFloat = 40
        let minHeight = minWidth / aspectRatio

        switch corner {
        case .topLeft:
            newRect.origin.x += drag.width
            newRect.origin.y += drag.width / aspectRatio
            newRect.size.width -= drag.width
            newRect.size.height -= drag.width / aspectRatio

        case .topRight:
            newRect.origin.y -= drag.width / aspectRatio
            newRect.size.width += drag.width
            newRect.size.height += drag.width / aspectRatio

        case .bottomLeft:
            newRect.origin.x += drag.width
            newRect.size.width -= drag.width
            newRect.size.height = newRect.width / aspectRatio

        case .bottomRight:
            newRect.size.width += drag.width
            newRect.size.height = newRect.width / aspectRatio
        }

        // Enforce minimum size
        if newRect.width < minWidth || newRect.height < minHeight {
            return
        }

        // Enforce within image bounds
        if newRect.origin.x < 0 || newRect.origin.y < 0 ||
            newRect.maxX > bounds.width || newRect.maxY > bounds.height {
            return
        }

        cropRect = newRect
    }

//    func resize(by drag: CGSize, corner: Corner, in bounds: CGSize) {
//        var newRect = cropRect
//
//        switch corner {
//        case .topLeft:
//            newRect.origin.x += drag.width
//            newRect.origin.y += drag.width / aspectRatio
//            newRect.size.width -= drag.width
//            newRect.size.height -= drag.width / aspectRatio
//
//        case .topRight:
//            newRect.origin.y -= drag.width / aspectRatio
//            newRect.size.width += drag.width
//            newRect.size.height += drag.width / aspectRatio
//
//        case .bottomLeft:
//            newRect.origin.x += drag.width
//            newRect.size.width -= drag.width
//            newRect.size.height = newRect.width / aspectRatio
//
//        case .bottomRight:
//            newRect.size.width += drag.width
//            newRect.size.height = newRect.width / aspectRatio
//        }
//
//        // Boundary checks
//        if newRect.origin.x < 0 || newRect.origin.y < 0 ||
//            newRect.maxX > bounds.width || newRect.maxY > bounds.height {
//            return
//        }
//
//        cropRect = newRect
//    }

    enum Corner {
        case topLeft, topRight, bottomLeft, bottomRight
        
        static var allCases: [Corner] {
            [.topLeft, .topRight, .bottomLeft, .bottomRight]
        }
    }
}
