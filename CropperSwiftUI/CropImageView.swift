//
//  CropViewModel.swift
//  CropperSwiftUI
//
//  Created by Mithilesh on 10/04/25.
//
import SwiftUI
import ImageIO
import MobileCoreServices
import Photos

struct CropImageView: View {
    let image: UIImage
    @StateObject private var viewModel: CropperViewModel
    let cropAspect: CGFloat
    @State private var initialized = false

    init(image: UIImage, cropAspect: CGFloat /*= 35 / 45*/) {
        self.image = image
        self.cropAspect = cropAspect
        _viewModel = StateObject(wrappedValue: CropperViewModel(initialRect: .zero, aspectRatio: cropAspect))
    }

    var body: some View {
        VStack {
            GeometryReader { geo in
                let containerSize = geo.size
                let imageSize = image.size
                let fittedFrame = calculateFittedImageFrame(imageSize: imageSize, containerSize: containerSize)

                
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: fittedFrame.width, height: fittedFrame.height)
                        .position(x: containerSize.width / 2, y: containerSize.height / 2)
                        .overlay(
                            CropOverlay(viewModel: viewModel, imageSize: fittedFrame.size)
                                .frame(width: fittedFrame.width, height: fittedFrame.height)
                                .clipped()
                            
                        )
                        .onAppear {
                            if !initialized {
                                initialized = true

                                let cropWidth: CGFloat = fittedFrame.width * 0.5
                                let cropHeight = cropWidth / cropAspect
                                let originX = (fittedFrame.width - cropWidth) / 2
                                let originY = (fittedFrame.height - cropHeight) / 2

                                viewModel.cropRect = CGRect(x: originX, y: originY, width: cropWidth, height: cropHeight)
                                viewModel.imageSize = fittedFrame.size
                                
//                                let dpi: CGFloat = 300
//                                let widthPx = mmToPixels(mm: 35, dpi: dpi)
//
//                                let cropWidth = min(fittedFrame.width, widthPx)
//                                let cropHeight = cropWidth / cropAspect
//                                let originX = (fittedFrame.width - cropWidth) / 2
//                                let originY = (fittedFrame.height - cropHeight) / 2
//                                viewModel.cropRect = CGRect(x: originX, y: originY, width: cropWidth, height: cropHeight)
                            }
                        }
                }
            }

            Button("Crop Image") {
                if let cropped = cropImage(original: image, rect: viewModel.cropRect, in: viewModel.imageSize) {
                    print("Image cropped")
                    if let dataWithDPI = saveImageWithDPI(image: cropped, dpi: 300) {
                        // Save dataWithDPI to disk, send via network, etc.
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let fileURL = documentsDirectory.appendingPathComponent("outputImage.jpg")
                        
                        do {
                            try dataWithDPI.write(to: fileURL)
                            print("Image saved with 300 DPI to \(fileURL)")
                        } catch {
                            print("Failed to save image: \(error)")
                        }
                        
                        let finalData = dataWithDPI as Data

                            // Save to Photos using PHPhotoLibrary
                            PHPhotoLibrary.shared().performChanges({
                                let options = PHAssetResourceCreationOptions()
                                let request = PHAssetCreationRequest.forAsset()
                                request.addResource(with: .photo, data: finalData, options: options)
                            }) { success, error in
                                if success {
                                    print("✅ Image with DPI saved to Photos")
                                } else if let error = error {
                                    print("❌ Failed to save: \(error.localizedDescription)")
                                }
                            }
                    }
                }
            }
            .padding()
        }
    }

    func saveImageWithDPI(image: UIImage, dpi: CGFloat = 300) -> Data? {
        // Ensure we have a CGImage from our UIImage.
        guard let cgImage = image.cgImage else { return nil }
        
        // Create mutable data to hold the image data.
        let imageData = NSMutableData()
        
        // Create a destination for a JPEG with the mutable data.
        guard let destination = CGImageDestinationCreateWithData(imageData, kUTTypePNG, 1, nil) else {
            return nil
        }
        
        // Prepare DPI metadata as a dictionary.
        let dpiProperties: [CFString: Any] = [
            kCGImagePropertyDPIWidth: dpi,
            kCGImagePropertyDPIHeight: dpi
        ]
        
        // Additional metadata can be added as needed; here we use only the DPI properties.
        let metadata: [CFString: Any] = dpiProperties as [CFString : Any]
        
        // Add the image to the destination along with the metadata.
        CGImageDestinationAddImage(destination, cgImage, metadata as CFDictionary)
        
        // Finalize the destination; if successful, imageData now contains our JPEG data with DPI settings.
        guard CGImageDestinationFinalize(destination) else {
            print("Failed to finalize image destination")
            return nil
        }
        
        return imageData as Data
    }

    func calculateFittedImageFrame(imageSize: CGSize, containerSize: CGSize) -> CGRect {
        let imageAspect = imageSize.width / imageSize.height
        let containerAspect = containerSize.width / containerSize.height

        if imageAspect > containerAspect {
            let width = containerSize.width
            let height = width / imageAspect
            let y = (containerSize.height - height) / 2
            return CGRect(x: 0, y: y, width: width, height: height)
        } else {
            let height = containerSize.height
            let width = height * imageAspect
            let x = (containerSize.width - width) / 2
            return CGRect(x: x, y: 0, width: width, height: height)
        }
    }

    func cropImage(original: UIImage, rect: CGRect, in imageViewSize: CGSize) -> UIImage? {
        let scaleX = original.size.width / imageViewSize.width
        let scaleY = original.size.height / imageViewSize.height

        let scaledRect = CGRect(
            x: rect.origin.x * scaleX,
            y: rect.origin.y * scaleY,
            width: rect.size.width * scaleX,
            height: rect.size.height * scaleY
        )

        guard let cgImage = original.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    /// Extracts DPI (dots per inch) from image metadata, falls back to default if not found.
    func getImageDPI(from image: UIImage, fallbackDPI: CGFloat = 300) -> CGFloat {
        guard let data = image.jpegData(compressionQuality: 1.0),
              let source = CGImageSourceCreateWithData(data as CFData, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any] else {
            return fallbackDPI
        }

        let dpiWidth = properties[kCGImagePropertyDPIWidth] as? CGFloat
        let dpiHeight = properties[kCGImagePropertyDPIHeight] as? CGFloat

        // Some images might only define one or the other
        if let widthDPI = dpiWidth, let heightDPI = dpiHeight {
            return (widthDPI + heightDPI) / 2
        } else if let widthDPI = dpiWidth {
            return widthDPI
        } else if let heightDPI = dpiHeight {
            return heightDPI
        } else {
            return fallbackDPI
        }
    }

}

//struct CropImageView: View {
//    let image: UIImage
//    @StateObject private var viewModel: CropperViewModel
//    @State private var initialized = false
//    @State private var cropAspect = 0.0
//
//    init(image: UIImage, cropAspect: CGFloat = 35 / 45) {
//        self.image = image
//        self.cropAspect = cropAspect
//        let initialRect = CGRect(x: 100, y: 100, width: 140, height: 140 / cropAspect)
//        _viewModel = StateObject(wrappedValue: CropperViewModel(initialRect: initialRect, aspectRatio: cropAspect))
//    }
//
//    var body: some View {
//        VStack {
//            GeometryReader { geo in
//                ZStack {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                        .overlay(
//                            CropOverlay(viewModel: viewModel, imageSize: geo.size)
//                        )
//                        .onAppear {
//                            if !initialized {
//                                initialized = true
//                                let width: CGFloat = 150
//                                let height = width / cropAspect
//                                let originX = (geo.size.width - width) / 2
//                                let originY = (geo.size.height - height) / 2
//                                viewModel.cropRect = CGRect(x: originX, y: originY, width: width, height: height)
//                                viewModel.imageSize = geo.size
//                            }
//                        }
//                }
//            }
//
//            Button("Crop Image") {
//                if let cropped = cropImage(original: image, rect: viewModel.cropRect, in: viewModel.imageSize) {
//                    // handle the cropped image here
//                    print("Image cropped")
//                }
//            }
//            .padding()
//        }
//    }
//
//    func cropImage(original: UIImage, rect: CGRect, in imageViewSize: CGSize) -> UIImage? {
//        let scaleX = original.size.width / imageViewSize.width
//        let scaleY = original.size.height / imageViewSize.height
//
//        let scaledRect = CGRect(
//            x: rect.origin.x * scaleX,
//            y: rect.origin.y * scaleY,
//            width: rect.size.width * scaleX,
//            height: rect.size.height * scaleY
//        )
//
//        guard let cgImage = original.cgImage?.cropping(to: scaledRect) else { return nil }
//        return UIImage(cgImage: cgImage)
//    }
//}
