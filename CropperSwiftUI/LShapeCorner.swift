//
//  LShapCornerView.swift
//  CropperSwiftUI
//
//  Created by Mithilesh on 11/04/25.
//

import SwiftUI

struct LShapeCorner: View {
    let size: CGFloat
    let lineWidth: CGFloat
    let corner: CropperViewModel.Corner

    var body: some View {
        Canvas { context, size in
            var path = Path()
            let length: CGFloat = size.width

            switch corner {
            case .topLeft:
                path.move(to: CGPoint(x: 0, y: length))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: length, y: 0))
            case .topRight:
                path.move(to: CGPoint(x: length, y: length))
                path.addLine(to: CGPoint(x: length, y: 0))
                path.addLine(to: CGPoint(x: 0, y: 0))
            case .bottomRight:
                path.move(to: CGPoint(x: length, y: 0))
                path.addLine(to: CGPoint(x: length, y: length))
                path.addLine(to: CGPoint(x: 0, y: length))
            case .bottomLeft:
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 0, y: length))
                path.addLine(to: CGPoint(x: length, y: length))
            }

            context.stroke(path, with: .color(.white), lineWidth: lineWidth)
        }
        .frame(width: size, height: size)
    }
}

//struct LShapeCorner: View {
//    let size: CGFloat
//    let lineWidth: CGFloat
//    let corner: CropperViewModel.Corner
//
//    var body: some View {
//        Path { path in
//            switch corner {
//            case .topLeft:
//                path.move(to: CGPoint(x: 0, y: size))
//                path.addLine(to: .zero)
//                path.addLine(to: CGPoint(x: size, y: 0))
//            case .topRight:
//                path.move(to: CGPoint(x: 0, y: 0))
//                path.addLine(to: CGPoint(x: size, y: 0))
//                path.addLine(to: CGPoint(x: size, y: size))
//            case .bottomRight:
//                path.move(to: CGPoint(x: size, y: 0))
//                path.addLine(to: CGPoint(x: size, y: size))
//                path.addLine(to: CGPoint(x: 0, y: size))
//            case .bottomLeft:
//                path.move(to: CGPoint(x: size, y: size))
//                path.addLine(to: CGPoint(x: 0, y: size))
//                path.addLine(to: CGPoint(x: 0, y: 0))
//            }
//        }
//        .stroke(Color.white, lineWidth: lineWidth)
//        .frame(width: size, height: size)
//    }
//}
