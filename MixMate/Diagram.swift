//
//  Diagram.swift
//  MixMate
//
//  Created by Chris Milne on 06/06/2025.
//

import SwiftUI
import Foundation
import PDFKit

struct Diagram: View {
    @ObservedObject var IM: InputModel
    @Environment(\.dismiss) var dismiss
    @State private var showGenPDF = false
var shapeSmall: String
    var body: some View {
        VStack {
//          DiagramContent(IM:IM).environmentObject(IM)
         DiagramContent(IM:IM, shapeSmall: shapeSmall).environmentObject(IM)
            HStack {
                Button {
                } label: {
                    
                    Picker("Mix", selection: $IM.ratioSelected) {
                        ForEach(IM.ratioMix, id: \.self) {
                            Text($0).font(.system(size: 22, weight: .bold))
                        }/// ForEach
                    }/// Picker
                    .pickerStyle(.segmented)
                    // Use onChange of for Picker
                    .onChange(of: IM.ratioSelected) {
                        IM.updateMeasurement(IM.measureSelected, ratioSelected: IM.ratioSelected)
                        
                    } // onChange of
                } // Label
            }
            HStack {
                Button(action: {
                    showGenPDF = true
                }) {
                    CustomButton(label: " Generate a PDF", width: 180, altColour: true, logo: Image(systemName: "rectangle.and.pencil.and.ellipsis"))
                }
                .sheet(isPresented: $showGenPDF) {
                    GenPDF(shapeSmall: shapeSmall).environmentObject(IM)
                }

                Button(action: { dismiss() }) {
                    CustomButton(label: "Return", width: 100, logo: Image(systemName:"arrow.uturn.backward"))
                }
            }
        }
    }
}
#Preview {
    Diagram(IM: InputModel(), shapeSmall: "")
    }
