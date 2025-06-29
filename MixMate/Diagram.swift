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
    @Binding var navPath: [NavTarget]
    
var pickShape: String
    var body: some View {
        VStack {
         DiagramContent(IM:IM, pickShape: pickShape).environmentObject(IM)
            HStack {
                Button {
                } label: {
                    
                    Picker("Mix", selection: $IM.ratioSelected) {
                        ForEach(IM.ratioMix, id: \.self) {
                            Text($0).font(.system(size: 36, weight: .bold))
                        }/// ForEach
                    }/// Picker
                    .pickerStyle(.segmented)
                    // Use onChange of for Picker
                    .onChange(of: IM.ratioSelected) {
                        IM.updateMeasurement(IM.measureSelected, ratioSelected: IM.ratioSelected)
                        
                    } // onChange of
                } // Label
            }
            .padding()
            HStack {
                Button(action: {
                    showGenPDF = true
                }) {
                    CustomButton(label: " Make a PDF", width: 150, altColour: true, logo: Image(systemName: "rectangle.and.pencil.and.ellipsis"))
                }
                .sheet(isPresented: $showGenPDF) {
                    GenPDF(pickShape: pickShape).environmentObject(IM)
                }

                // ✅ Return to DataEntry via navPath
                Button(action: {
                   navPath.append(.shapeEntry(pickShape))
                }) {
                    CustomButton(label: "Return", width: 80, altColour: true, logo: Image(systemName: "arrow.uturn.backward"))
                }

                // ✅ Show Info page via navPath
                Button(action: {
                    navPath.append(.info(pickShape))
                }) {
                    CustomButton(label: "Info", width: 80, altColour: true, logo: Image(systemName: "questionmark.bubble"))
                }
            }
            }
        }
    }

