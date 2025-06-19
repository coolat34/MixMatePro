//
//  DiagramContent.swift
//  MixMate
//
//  Created by Chris Milne on 05/06/2025.
//

import SwiftUI
import PDFKit

struct DiagramContent: View {
    @ObservedObject var IM: InputModel
    @Environment(\.dismiss) var dismiss
var shapeSmall: String
    var body: some View {
        
        VStack {
            Text(shapeSmall)
                .font(.largeTitle)
            
            Image(shapeSmall)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 150)
                .padding()
            
            Text("Rounded to the nearest 1/2 Bag")
            
        } // VStack
        
        Spacer()

        // MARK: Bags Description
        
        HStack(spacing: 5) {
            
            Text("Bags").frame(minWidth: 80)
            Text("Cement").frame(minWidth: 80)
            Text("Sand").frame(minWidth: 80)
            Text("Aggregate").frame(minWidth: 80)
        }/// HStack
        .font(.title3)
        .frame(height: 50)
        .foregroundColor(.black)
        .background( Color(red: 0.85, green: 0.95, blue: 0.99))
     
        // MARK: Bags Value
        OutputBagField(label: IM.weightSmall, valCem: IM.BagsCementSmall, valSand: IM.BagsSandSmall, valAgg: IM.BagsAggregateSmall)
        OutputBagField(label: IM.weightMed, valCem: IM.BagsCementMed, valSand: IM.BagsSandMed, valAgg: IM.BagsAggregateMed)
        OutputBagField(label: IM.weightLarge, valCem: IM.BagsCementLarge, valSand: IM.BagsSandLarge, valAgg: IM.BagsAggregateLarge)
                   
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Bag Configuration")
        .navigationBarTitleDisplayMode(.inline)
        
    } // Body
} /// struct
struct OutputBagField: View {
    let label: String
    let valCem: Double
    let valSand: Double
    let valAgg: Double
    
    var body: some View {
        VStack {
            HStack {
                Text(label)
                    .frame(minWidth: 80, alignment: .center)
                Text("\(String(format: "%.1f", valCem))")
                    .frame(minWidth: 80, alignment: .center)
                Text("\(String(format: "%.1f", valSand))")
                    .frame(minWidth: 80, alignment: .center)
                Text("\(String(format: "%.1f", valAgg))")
                    .frame(minWidth: 80, alignment: .leading)
                
            } // HStack
            .font(.title3)
            .foregroundColor(.black)
            .background( Color(red: 0.85, green: 0.95, blue: 0.99))
            //  .padding(10)
            .frame(height: 50)
        } // VStack
    } // Body
} // Struct

#Preview {
    DiagramContent(IM: InputModel(), shapeSmall: "")
}
