//
//  ContentView.swift
//  CropperSwiftUI
//
//  Created by Mithilesh on 10/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
           if let image = UIImage(named: "side-view-young-woman") {
              // CropImageView(image: image)
               //let dpi: CGFloat = 300
               let widthPx = CGFloat(35.0).mmToPixels()//mmToPixels(mm: 35, dpi: dpi)
               let heightPx = CGFloat(45.0).mmToPixels()
               let cropAspect = widthPx / heightPx
               CropImageView(image: image, cropAspect: cropAspect)
           } else {
               Text("Image not found")
           }
       }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
