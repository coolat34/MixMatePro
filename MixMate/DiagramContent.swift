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
var pickShape: String
    var body: some View {
        
        VStack {
            Text(pickShape)
                .font(.largeTitle)
            
            Image(pickShape)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 150)
                .padding()
            
            Text("Rounded to nearest 1/2 Bag").font(.title2)
            
        } // VStack
        
 //       Spacer()

        // MARK: Bags Description
        
        HStack(spacing: 5) {
            
            Text("Bags").frame(minWidth: 70)
            Text("Cement").frame(minWidth: 70)
            Text("Sand").frame(minWidth: 70)
            Text("Aggregate").frame(minWidth: 70)
        }/// HStack
        .font(.title3)
        .frame(height: 40)
        .foregroundColor(.black)
        .background( Color(red: 0.85, green: 0.95, blue: 0.99))
     
        // MARK: Bags Value
        OutputBagField(label: IM.weightSmall, valCem: IM.BagsCementSmall, valSand: IM.BagsSandSmall, valAgg: IM.BagsAggregateSmall)
        OutputBagField(label: IM.weightMed, valCem: IM.BagsCementMed, valSand: IM.BagsSandMed, valAgg: IM.BagsAggregateMed)
        OutputBagField(label: IM.weightLarge, valCem: IM.BagsCementLarge, valSand: IM.BagsSandLarge, valAgg: IM.BagsAggregateLarge)
        Text("Mix Strength").font(.title3)
        .navigationBarBackButtonHidden(true)
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
                    .frame(minWidth: 70, alignment: .center)
                Text("\(String(format: "%.1f", valCem))")
                    .frame(minWidth: 70, alignment: .center)
                Text("\(String(format: "%.1f", valSand))")
                    .frame(minWidth: 70, alignment: .center)
                Text("\(String(format: "%.1f", valAgg))")
                    .frame(minWidth: 70, alignment: .leading)
                
            } // HStack
            .font(.title3)
            .foregroundColor(.black)
            .background( Color(red: 0.85, green: 0.95, blue: 0.99))
            //  .padding(10)
            .frame(height: 40)
        } // VStack
    } // Body
} // Struct

#Preview {
    DiagramContent(IM: InputModel(), pickShape: "")
}
