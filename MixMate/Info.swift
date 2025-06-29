//
//  Info.swift
//  MixMate
//
//  Created by Chris Milne on 27/06/2025.
//

import SwiftUI

struct Info: View {
    let xcelFig: String = "Concrete figs"  // Pic of spreadsheet
    @Binding var navPath: [NavTarget]
    @ObservedObject var IM: InputModel
    var pickShape: String
    
    var body: some View {

        ZStack {
            Color(red: 0.85, green: 0.95, blue: 0.99)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("The proportions, in the table below, are based on industry standards.\nA basic strength of 1450 psi is known as Ratio M10. Other mixes, M15 and M20, are available by selecting the appropriate Mix Strength from the previous screen. \n")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .frame(width: 330)
                
                Image(xcelFig)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 330, height: 250)
                
                Text("Pick from 6 shapes. Adjust units from: \nMetric (mm, cm, metre, kg) or \nImperial (inches, feet, pounds.)\n Pick from 3 strengths of mix: \n(Basic, Medium, Strong)\n Plus a choice of bags:\n(20kg, 25kg, 30kg) or (40lb, 60lb, 80lb)")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .frame(width: 330)
                    .padding()
                    .navigationTitle("Concrete Calculator")
                    .navigationBarTitleDisplayMode(.inline)

                Button(action: {
                    navPath.removeLast()
                }) {
                    CustomButton(label: "Return", width: 80, altColour: true, logo: Image(systemName: "arrow.uturn.backward"))
                }
            } // VStack
                } // ZStack
    } // body
}

