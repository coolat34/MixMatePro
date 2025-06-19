//
//  MainMenu.swift
//  MixMate
//
//  Created by Chris Milne on 30/04/2025.
//
import SwiftUI
import Foundation

// Put all the related data and logic in a single ViewModel. Use @Published in conjunction with ObservableObject and @StateObject
class InputModel: ObservableObject {
    @Published var Len: Double = 0.0
    @Published var LenB: Double = 0.0
    @Published var Width: Double = 0.0
    @Published var Height: Double = 0.0
    @Published var Diameter: Double = 0.0
    @Published var Diametersmall: Double = 0.0
    @Published var DiameterLarge: Double = 0.0
    @Published var Area: Double = 0.0
    @Published var Volume: Double = 0.0
    @Published var BagsCementSmall: Double = 0.0
    @Published var BagsCementMed: Double = 0.0
    @Published var BagsCementLarge: Double = 0.0
    @Published var BagsSandSmall: Double = 0.0
    @Published var BagsSandMed: Double = 0.0
    @Published var BagsSandLarge: Double = 0.0
    @Published var BagsAggregateSmall: Double = 0.0
    @Published var BagsAggregateMed: Double = 0.0
    @Published var BagsAggregateLarge: Double = 0.0
    @Published var ratioSelected: String = "Basic"
    @Published var ratioMix: [String] = ["Basic", "Medium", "Strong"]
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var CountryCode: String? = Locale.current.region?.identifier
    @Published var USAregion: Bool = false
    @Published var measureSelected: String = "MTR"
    @Published var note: String = "mtr"
    @Published var measurements: [String] = ["MM", "CM", "MTR"]
    @Published var notationAbr: [String] = ["mm", "cm", "mtr"]
    @Published var weightSmall: String = "20kg"
    @Published var weightMed: String = "25kg"
    @Published var weightLarge: String = "30kg"
    @Published var selectedIndex = 0
    @Published var shapeSmall: String = ""
    @Published var shapeAbr: String = ""

    
    //MARK: Update Measurements
    // Update the notationAbr & Bags if the Measurement changes
    func updateMeasurement(_ newMeasurement: String,ratioSelected: String) {
        if let Mindex = measurements.firstIndex(of: newMeasurement)
        
        {
            note = notationAbr[Mindex]  // measurements

        }

        reCalcBags() // ReCalc Bags
    }
    
    func reCalcBags() {
        guard !shapeAbr.isEmpty else {
                print("⚠️ shapeAbr is blank — skipping reCalcBags")
                return
            }
        
        let valResult = DataHandler.shapeFigs(
            A: Len, B: Width, C: Height,
            D: Diameter, E: Diametersmall,
            F: note, G: shapeAbr, I: DiameterLarge, J: LenB, K: ratioSelected
        )
       
        Area = valResult.Area
        Volume = valResult.Volume
        BagsCementSmall = valResult.BagsCementSmall
        BagsCementMed = valResult.BagsCementMed
        BagsCementLarge = valResult.BagsCementLarge
        BagsSandSmall = valResult.BagsSandSmall
        BagsSandMed = valResult.BagsSandMed
        BagsSandLarge = valResult.BagsSandLarge
        BagsAggregateSmall = valResult.BagsAggregateSmall
        BagsAggregateMed = valResult.BagsAggregateMed
        BagsAggregateLarge = valResult.BagsAggregateLarge
    }
    
    func updateRegion(for system: String) {
        if system == "metric" {
            measureSelected = "MTR"
            note = "mtr"
            measurements = ["MM", "CM", "MTR"]
            notationAbr = ["mm", "cm", "mtr"]
            weightSmall = "20kg"
            weightMed = "25kg"
            weightLarge = "30kg"
        } else {
            measureSelected = "ft"
            note = "ft"
            measurements = ["Inches", "Feet"]
            notationAbr = ["in", "ft"]
            weightSmall = "40lb"
            weightMed = "60lb"
            weightLarge = "80lb"
        }
    }
    
    // Calculate all values when a variable is entered or changed
    func updateValuesShape(shapeAbr: String) -> Bool {
        // Reset error
        showError = false
        errorMessage = ""
        
        // Basic checks for all shapes
        let allValues = [Len, LenB, Width, Height, Diameter, Diametersmall, DiameterLarge]
        if allValues.contains(where: { $0 < 0 }) {
            showError = true
            errorMessage = "Dimensions must be positive"
            return false
        }
        // Check that small diameters are less than large diameters for OpenRound and Elliptical round
        
        if shapeAbr == "O" || shapeAbr == "E" {
            if DiameterLarge < Diametersmall {
                showError = true
                errorMessage = "Small Diameter must be less than Large Diameter"
                return false
            }
        }
        
        // Checks for Segment (triangle)
        if shapeAbr == "S" && Len > 0 && Width > 0 && LenB > 0 {
            if !isValidTriangle(Len, Width, LenB) {
                showError = true
                errorMessage = "Sides do not form a valid triangle."
                return false
            }
        }
        
        // Check any 2 sides of triangle must be greater than the third side
        func isValidTriangle(_ a: Double, _ b: Double, _ c: Double) -> Bool {
            return a + b > c && a + c > b && b + c > a
        }
        // All checks passed
        reCalcBags()
        return true }
    
    
    
    // Reset all input variables
    func resetValues() {
        Len = 0.0
        LenB = 0.0
        Width = 0.0
        Height = 0.0
        Diameter = 0.0
        Diametersmall = 0.0
        DiameterLarge = 0.0
    }
    
} // Struct

// Loop through all the available shapes in the Assets folder
struct MainMenu: View {
    @State var isShapeList = false
    @State private var isContinue = false
    @State private var isPressed = false  // for animation
    @State private var hasUpdatedRegion = false
    let xcelFig: String = "Concrete figs"  // Pic of spreadsheet
    @StateObject var IM = InputModel()
    var body: some View {
        NavigationStack {
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
                   //     .padding()
                    
                    
                    
                    Text("Pick from 6 shapes. Adjust units from: \nMetric (mm, cm, metre, kg) or \nImperial (inches, feet, pounds.)\n Pick from 3 strengths of mix: \n(Basic, Medium, Strong)\n Plus a choice of bags:(20kg, 25kg, 30kg) or (40lb, 60lb, 80lb)")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(width: 330)
                        .padding()
                } // VStack
      //          .padding()
            } // ZStack
            .navigationTitle("Concrete Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        NavigationLink(destination: ShapePicker(IM:IM)
                        .navigationBarBackButtonHidden(true)
                    ) {
                        CustomButton(label:"Continue", width: 180, height: 36, logo:
                Image("arrow.right.circle")) }

                        }  // HStack
                } // ToolBarItem
            }  // .toolbar
        }  // NavStack
    } // body
} // struct

#Preview {
    MainMenu()
}



