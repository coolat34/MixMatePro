//
//  ShapeGallery.swift
//  MixMate
//
//  Created by Chris Milne on 11/06/2025.
//

import SwiftUI

struct ShapeGallery: View {
    @ObservedObject var IM: InputModel
    var shapeAbr: String
    var shapeSmall: String
    var body: some View {
        
        HStack {
            Image(shapeSmall)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 45)
            Text(shapeSmall)
                .frame(width: 120, height: 45)
        }
        .contentShape(Rectangle())  // Ensures the row is fully tappable
        
    }
}

#Preview {
    ShapeGallery(IM: InputModel(), shapeAbr: "Sq", shapeSmall: "Square")
}
