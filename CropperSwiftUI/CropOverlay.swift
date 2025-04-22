//
//  CropViewModel.swift
//  CropperSwiftUI
//
//  Created by Mithilesh on 10/04/25.
//
import SwiftUI

//struct CropOverlay: View {
//    @ObservedObject var viewModel: CropperViewModel
//    let imageSize: CGSize
//    @State private var lastDragOffset: CGSize = .zero
//    @State private var lastDragOffset2: CGSize = .zero
//    var body: some View {
//        GeometryReader { geometry in
//            let bounds = geometry.size
////            ZStack {
////
////                Rectangle()
////                    .path(in: viewModel.cropRect)
////                    .stroke(Color.red, lineWidth: 2)
////                    .background(Color.black.opacity(0.2))
////                    .gesture(
////                        DragGesture()
////                            .onChanged { value in
////                                let delta = CGSize(
////                                    width: value.translation.width - lastDragOffset.width,
////                                    height: value.translation.height - lastDragOffset.height
////                                )
////                                lastDragOffset = value.translation
////                                viewModel.updatePosition(by: delta, in: bounds)
////                            }
////                            .onEnded { _ in
////                                lastDragOffset = .zero
////                            }
////                    )
////
////
////                ForEach(CropperViewModel.Corner.allCases, id: \.self) { corner in
////                    ZStack {
////                           // Transparent area to catch gesture
////                           Rectangle()
////                               .fill(Color.clear)
////                               .frame(width: 30, height: 30) // gives enough touch area
////
////                           // Visual L-shape corner
////                           LShapeCorner(size: 15, lineWidth: 3, corner: corner)
////                       }
////                       .position(cornerPosition(corner: corner))
////                       .contentShape(Rectangle()) // ensures tap area is full frame
////                       .gesture(
////                           DragGesture()
////                               .onChanged { value in
////                                   let delta = CGSize(
////                                       width: value.translation.width - lastDragOffset2.width,
////                                       height: value.translation.height - lastDragOffset2.height
////                                   )
////                                   lastDragOffset2 = value.translation
////                                   viewModel.resize(by: delta, corner: corner, in: bounds)
////                               }
////                               .onEnded { _ in
////                                   lastDragOffset2 = .zero
////                               }
////                       )
////
//////                    Circle()
//////                        .fill(Color.white)
//////                        .frame(width: 20, height: 20)
//////                        .position(cornerPosition(corner: corner))
//////                        .gesture(
//////                            DragGesture()
//////                                .onChanged { value in
//////                                    //viewModel.resize(by: value.translation, corner: corner, in: bounds)
//////                                    let delta = CGSize(
//////                                        width: value.translation.width - lastDragOffset.width,
//////                                        height: value.translation.height - lastDragOffset.height
//////                                    )
//////                                    lastDragOffset = value.translation
//////                                    viewModel.resize(by: delta, corner: corner, in: bounds)
//////                                }
//////                                .onEnded({ _ in
//////                                    lastDragOffset = .zero
//////                                })
//////                        )
////                }
////            }
//
//
//
//            ZStack {
//                Color.clear
//                    .contentShape(Rectangle()) // ensures hit area
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                let delta = CGSize(
//                                    width: value.translation.width - lastDragOffset.width,
//                                    height: value.translation.height - lastDragOffset.height
//                                )
//                                lastDragOffset = value.translation
//                                viewModel.updatePosition(by: delta, in: bounds)
//                            }
//                            .onEnded { _ in
//                                lastDragOffset = .zero
//                            }
//                    )
//
//                // Crop rectangle visual
//                Path { path in
//                    path.addRect(viewModel.cropRect)
//                }
//                .stroke(Color.red, lineWidth: 2)
//                .background(Color.black.opacity(0.2))
//
//                // Corners
//                ForEach(CropperViewModel.Corner.allCases, id: \.self) { corner in
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.clear)
//                            .frame(width: 30, height: 30)
//
//                        LShapeCorner(size: 15, lineWidth: 3, corner: corner)
//                    }
//                    .position(cornerPosition(corner: corner))
//                    .contentShape(Rectangle())
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                let delta = CGSize(
//                                    width: value.translation.width - lastDragOffset2.width,
//                                    height: value.translation.height - lastDragOffset2.height
//                                )
//                                lastDragOffset2 = value.translation
//                                viewModel.resize(by: delta, corner: corner, in: bounds)
//                            }
//                            .onEnded { _ in
//                                lastDragOffset2 = .zero
//                            }
//                    )
//                }
//            }
//
//        }
//    }
//
//    func cornerPosition(corner: CropperViewModel.Corner) -> CGPoint {
//        let rect = viewModel.cropRect
//        switch corner {
//        case .topLeft:
//            return rect.origin
//        case .topRight:
//            return CGPoint(x: rect.maxX, y: rect.minY)
//        case .bottomLeft:
//            return CGPoint(x: rect.minX, y: rect.maxY)
//        case .bottomRight:
//            return CGPoint(x: rect.maxX, y: rect.maxY)
//        }
//    }
//}


//struct CropOverlay: View {
//    @ObservedObject var viewModel: CropperViewModel
//    let imageSize: CGSize
//
//    @State private var lastDragOffset: CGSize = .zero
//    @State private var lastResizeOffset: CGSize = .zero
//
//    var body: some View {
//        GeometryReader { geometry in
//            let bounds = geometry.size
//
//            ZStack {
//                // Pan Gesture
//                /**/
//                let panGesture = DragGesture()
//                    .onChanged { value in
//                        let delta = CGSize(
//                            width: value.translation.width - lastDragOffset.width,
//                            height: value.translation.height - lastDragOffset.height
//                        )
//                        lastDragOffset = value.translation
//                        viewModel.updatePosition(by: delta, in: geometry.frame(in: .local))
//                    }
//                    .onEnded { _ in
//                        lastDragOffset = .zero
//                    }
//
//                // Crop Shape (Interactive base for pan gesture)
//                CropRectShape(rect: viewModel.cropRect)
//                    .stroke(Color.red, lineWidth: 2)
//                    .background(
//                        CropRectShape(rect: viewModel.cropRect)
//                            .fill(Color.black.opacity(0.3))
//                    )
//                    .simultaneousGesture(panGesture) // Attach pan gesture
//
//
//                // Corner Resizing
//                ForEach(CropperViewModel.Corner.allCases, id: \.self) { corner in
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.clear)
//                            .frame(width: 40, height: 40) // touch-friendly
//
//                        LShapeCorner(size: 15, lineWidth: 3, corner: corner)
//
//                    }
//                    .position(cornerPosition(corner: corner))
//                    .contentShape(Rectangle())
//                    .gesture(
//
//                        DragGesture()
//                            .onChanged { value in
//                                let delta = CGSize(
//                                    width: value.translation.width - lastResizeOffset.width,
//                                    height: value.translation.height - lastResizeOffset.height
//                                )
//                                lastResizeOffset = value.translation
//                                viewModel.resize(by: delta, corner: corner, in: bounds)
//                            }
//                            .onEnded { _ in
//                                lastResizeOffset = .zero
//                            }
//                    )
//                }
//            }
//        }
//    }
//
//    func cornerPosition(corner: CropperViewModel.Corner) -> CGPoint {
//        let rect = viewModel.cropRect
//        switch corner {
//        case .topLeft: return rect.origin
//        case .topRight: return CGPoint(x: rect.maxX, y: rect.minY)
//        case .bottomLeft: return CGPoint(x: rect.minX, y: rect.maxY)
//        case .bottomRight: return CGPoint(x: rect.maxX, y: rect.maxY)
//        }
//    }
//}



struct CropOverlay: View {
    @ObservedObject var viewModel: CropperViewModel
    let imageSize: CGSize

    @State private var lastDragOffset: CGSize = .zero
    @State private var lastResizeOffset: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            let bounds = geometry.size

            ZStack {
                // Dimmed background
                Color.black.opacity(0.4)

                // Crop Rectangle
                CropRectShape(rect: viewModel.cropRect)
                    .stroke(Color.red, lineWidth: 2)
                    .background(
                        CropRectShape(rect: viewModel.cropRect)
                            .fill(Color.clear)
                    )
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let delta = CGSize(
                                    width: value.translation.width - lastDragOffset.width,
                                    height: value.translation.height - lastDragOffset.height
                                )
                                lastDragOffset = value.translation
                                viewModel.updatePosition(by: delta, in: geometry.frame(in: .local))
                            }
                            .onEnded { _ in
                                lastDragOffset = .zero
                            }
                    )

                // Corner Handles
                ForEach(CropperViewModel.Corner.allCases, id: \.self) { corner in
                    ZStack {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 44, height: 44) // Large touch area
                            .contentShape(Rectangle())

                        LShapeCorner(size: 15, lineWidth: 3, corner: corner)
                            .foregroundColor(.white)
                    }
                    .position(cornerPosition(corner: corner))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let delta = CGSize(
                                    width: value.translation.width - lastResizeOffset.width,
                                    height: value.translation.height - lastResizeOffset.height
                                )
                                lastResizeOffset = value.translation
                                viewModel.resize(by: delta, corner: corner, in: bounds)
                            }
                            .onEnded { _ in
                                lastResizeOffset = .zero
                            }
                    )
                    .zIndex(1) // Ensure corners are above crop area
                }
            }
        }
    }

    func cornerPosition(corner: CropperViewModel.Corner) -> CGPoint {
        let rect = viewModel.cropRect
        switch corner {
        case .topLeft: return rect.origin
        case .topRight: return CGPoint(x: rect.maxX, y: rect.minY)
        case .bottomLeft: return CGPoint(x: rect.minX, y: rect.maxY)
        case .bottomRight: return CGPoint(x: rect.maxX, y: rect.maxY)
        }
    }
}


//struct CropOverlay: View {
//    @ObservedObject var viewModel: CropperViewModel
//    let imageSize: CGSize
//
//    @State private var lastDragOffset: CGSize = .zero
//    @State private var lastResizeOffset: CGSize = .zero
//
//    var body: some View {
//        GeometryReader { geometry in
//            let bounds = geometry.size
//
//            ZStack {
//                // Crop Shape (visual + interactive layer)
//                CropRectShape(rect: viewModel.cropRect)
//                    .stroke(Color.red, lineWidth: 2)
//                    .background(
//                        CropRectShape(rect: viewModel.cropRect)
//                            .fill(Color.black.opacity(0.3))
//                    )
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                let delta = CGSize(
//                                    width: value.translation.width - lastDragOffset.width,
//                                    height: value.translation.height - lastDragOffset.height
//                                )
//                                lastDragOffset = value.translation
//                                viewModel.updatePosition(by: delta, in: bounds)
//                            }
//                            .onEnded { _ in
//                                lastDragOffset = .zero
//                            }
//                    )
//
//                // Corner handles with L-shapes
//                ForEach(CropperViewModel.Corner.allCases, id: \.self) { corner in
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.clear)
//                            .frame(width: 40, height: 40) // touch-friendly
//
//                        LShapeCorner(size: 15, lineWidth: 3, corner: corner)
//                    }
//                    .position(cornerPosition(corner: corner))
//                    .contentShape(Rectangle()) // makes whole area interactive
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                let delta = CGSize(
//                                    width: value.translation.width - lastResizeOffset.width,
//                                    height: value.translation.height - lastResizeOffset.height
//                                )
//                                lastResizeOffset = value.translation
//                                viewModel.resize(by: delta, corner: corner, in: bounds)
//                            }
//                            .onEnded { _ in
//                                lastResizeOffset = .zero
//                            }
//                    )
//                }
//            }
//        }
//    }
//
//    func cornerPosition(corner: CropperViewModel.Corner) -> CGPoint {
//        let rect = viewModel.cropRect
//        switch corner {
//        case .topLeft:
//            return rect.origin
//        case .topRight:
//            return CGPoint(x: rect.maxX, y: rect.minY)
//        case .bottomLeft:
//            return CGPoint(x: rect.minX, y: rect.maxY)
//        case .bottomRight:
//            return CGPoint(x: rect.maxX, y: rect.maxY)
//        }
//    }
//}


extension CropperViewModel.Corner: CaseIterable {

}

