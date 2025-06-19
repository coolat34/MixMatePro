//
//  ShapePicker.swift
//  MixMate
//
//  Created by Chris Milne on 11/06/2025.
//

import SwiftUI

struct ShapePicker: View {
    // Display all the available shapes and allow a choice
        @State private var listView = false
        @State private var resetView = false
        @Environment(\.dismiss) var dismiss
        @ObservedObject var IM: InputModel
        var shapeSmalls: [String] = ["ConcreteSlab", "Round", "Segment", "Open Round", "Half Round", "Elliptical Round"]
        var body: some View {
            Text("Tap a shape to enter your measurements")
                .fontWidth(.compressed)
                .fontWeight(.bold)
            List {
                ForEach(shapeSmalls, id: \.self) { shapeSmall in
                    NavigationLink(destination: ShapeInput(shapeSmall: shapeSmall, shapeAbr: String(shapeSmall.prefix(1)),  IM:IM)
                        .navigationBarBackButtonHidden(true))
                    {
                        
                        ShapeGallery(IM:IM, shapeAbr: String(shapeSmall.prefix(1)), shapeSmall: shapeSmall)
                        
                    }
                } /// ForEach
                
                
            } /// List
            .navigationTitle("Choose Shape")
            .navigationBarTitleDisplayMode(.automatic)
            
            .listStyle(.grouped)
            
            Button(action: { dismiss() }) {
                CustomButton(label:"Return", width: 120,height: 48, logo:
                                Image("arrow.left.circle")) }
        } /// Body
    } /// Struct
#Preview {
    ShapePicker(IM: InputModel())
}
