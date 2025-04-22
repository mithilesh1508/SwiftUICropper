//
//  CropRectShape.swift
//  CropperSwiftUI
//
//  Created by Mithilesh on 11/04/25.
//

import SwiftUI

struct CropRectShape: Shape {
    var rect: CGRect

    func path(in _: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        return path
    }
}

