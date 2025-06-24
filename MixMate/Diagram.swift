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
    @State private var showDataEntry = false
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
                    CustomButton(label: " Generate a PDF", width: 180, altColour: true, logo: Image(systemName: "rectangle.and.pencil.and.ellipsis"))
                }
                .sheet(isPresented: $showGenPDF) {
                    GenPDF(pickShape: pickShape).environmentObject(IM)
                }
//MARK: button to return to DataEntry
 /*               Button(action: {
                    showDataEntry = true
                }) {
                    CustomButton(label: "Return", width: 180, altColour: true, logo: Image(systemName: "arrow.uturn.backward"))
                }
                .sheet(isPresented: $showDataEntry) {
                    DataEntry(pickShape: pickShape, shapeAbr: IM.shapeAbr, IM: IM).environmentObject(IM)
                }
*/
                Button(action: { dismiss() }) {
                    CustomButton(label: "Return", width: 100, logo: Image(systemName:"arrow.uturn.backward"))
                }  
            }
        }
    }
}
#Preview {
    Diagram(IM: InputModel(), pickShape: "")
    }
