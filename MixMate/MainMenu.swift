//
//  MainMenu.swift
//  MixMate
//
//  Created by Chris Milne on 30/04/2025.
//
import SwiftUI
import Foundation


// Loop through all the available shapes in the Assets folder
struct MainMenu: View {
    @State private var hasUpdatedRegion = false
    let xcelFig: String = "Concrete figs"  // Pic of spreadsheet
    @StateObject var IM: InputModel
    @State private var internalNav: Bool = false  /// ← fallback state
    @State private var navPath: [NavTarget] = []

    var body: some View {
        NavigationStack(path: $navPath) {
        ZStack {
            Color(red: 0.85, green: 0.95, blue: 0.99)
                .edgesIgnoringSafeArea(.all)
            
                VStack {
                    Text("Calculate concrete volume and mix for common shapes. Choose measurements, select strength, and get mix estimates instantly.")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(width: 330)
                    
                    Image(xcelFig)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 330, height: 230)
                    
                    Text("Pick from 6 shapes. Adjust units from: \nMetric (mm, cm, metre, kg) or \nImperial (inches, feet, pounds.)\n Pick from 3 strengths of mix: \n(Basic, Medium, Strong)\n Plus a choice of bags:(20kg, 25kg, 30kg) or (40lb, 60lb, 80lb)")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(width: 330)
                        .padding()
                     
                } // VStack
         } // NavStack
            .navigationTitle("Concrete Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        NavigationLink(destination: ShapeOptions(IM:IM)
                            .navigationBarBackButtonHidden(true)
                        ) {
                            CustomButton(label:"Continue", width: 180, height: 36, logo:
                                            Image("arrow.right.circle"))
                        } // Customelabel
                    } // HStack
                } //ToolBarItem
            } //.toolbar
            }  // ZStak
        } // body
    } // struct MainMenu

// Display all the available shapes and allow a choice
struct ShapeOptions: View {
@State private var listView = false
@State private var resetView = false
@Environment(\.dismiss) var dismiss
@ObservedObject var IM: InputModel
var shapeSmalls: [String] = ["ConcreteSlab", "Round", "Segment", "Open Round", "Half Round", "Elliptical Round"]
    
var body: some View {
 //VStack {
        Text("Tap a shape to enter your measurements")
            .fontWidth(.compressed)
            .fontWeight(.bold)
        List {
            ForEach(shapeSmalls, id: \.self) { pickShape in
      NavigationLink(destination: DataEntry(pickShape: pickShape, shapeAbr: String(pickShape.prefix(1)),  IM:IM)
                    .navigationBarBackButtonHidden(true))
                {
                    ShapesDisplay(IM:IM, shapeAbr: String(pickShape.prefix(1)), pickShape: pickShape)
                }
            } /// ForEach
            
            
        } /// List
   
        .navigationTitle("Choose Shape")
        .navigationBarTitleDisplayMode(.automatic)
        .listStyle(.grouped)
        
        Button(action: { dismiss() }) {
            CustomButton(label:"Return", width: 180,height: 36, logo:
                            Image("arrow.left.circle")) }
 //   } // Vstack
} /// Body
} /// Struct shapeOptions


// Display an image and text of the shape that has been selected.
struct ShapesDisplay: View {
@ObservedObject var IM: InputModel
//    @Binding var isDisplayed : Bool
var shapeAbr: String
var pickShape: String
var body: some View {
    
    HStack {
        Image(pickShape)
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 45)
        Text(pickShape)
            .frame(width: 120, height: 45)
    }
    .contentShape(Rectangle())  // Ensures the row is fully tappable
    
}

} /// struct shapesDisplay

    #Preview {
        MainMenu(IM: InputModel())
    }



