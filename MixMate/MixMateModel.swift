//
//  InputModel.swift
//  MixMate
//
//  Created by Chris Milne on 22/06/2025.
// Put all the related data and logic in a single ViewModel. Use @Published in conjunction with ObservableObject and @StateObject

import Foundation
import Combine

public class InputModel: ObservableObject {
    @Published public var LenAAct: Double = 0.0
    @Published public var LenBAct: Double = 0.0
    @Published public var WidthACT: Double = 0.0
    @Published public var HeightACT: Double = 0.0
    @Published public var DiameterACT: Double = 0.0
    @Published public var DiameterSmallACT: Double = 0.0
    @Published public var DiameterLargeACT: Double = 0.0
    @Published public var Area: Double = 0.0
    @Published public var Volume: Double = 0.0

    @Published public var BagsCementSmall: Double = 0.0
    @Published public var BagsCementMed: Double = 0.0
    @Published public var BagsCementLarge: Double = 0.0
    @Published public var BagsSandSmall: Double = 0.0
    @Published public var BagsSandMed: Double = 0.0
    @Published public var BagsSandLarge: Double = 0.0
    @Published public var BagsAggregateSmall: Double = 0.0
    @Published public var BagsAggregateMed: Double = 0.0
    @Published public var BagsAggregateLarge: Double = 0.0

    @Published public var ratioSelected: String = "Basic"
    @Published public var ratioMix: [String] = ["Basic", "Medium", "Strong"]
    @Published public var errorMessage: String = ""
    @Published public var CountryCode: String? = Locale.current.region?.identifier
    @Published public var measureSelected: String = "MTR"
    @Published public var note: String = "mtr"
    @Published public var measurements: [String] = ["MM", "CM", "MTR"]
    @Published public var notationAbr: [String] = ["mm", "cm", "mtr"]
    @Published public var weightSmall: String = "20kg"
    @Published public var weightMed: String = "25kg"
    @Published public var weightLarge: String = "30kg"
    @Published public var selectedIndex = 0
    @Published public var shapeAbr: String = ""
    @Published public var pickShape: String = ""
    @Published public var showError: Bool = false
    @Published public var USAregion: Bool = false

    public init() {}
    // Update the notationAbr & Bags if the Measurement changes
    public func updateMeasurement(_ newMeasurement: String, ratioSelected: String) {
        if let Mindex = measurements.firstIndex(of: newMeasurement) {
            note = notationAbr[Mindex]
        }
        reCalcBags()
    }

    public func reCalcBags() {
        guard !shapeAbr.isEmpty else {
            print("⚠️ shapeAbr is blank — skipping reCalcBags")
            return
        }

        let valResult = DataHandler.shapeFigs(
            A: LenAAct, B: WidthACT, C: HeightACT,
            D: DiameterACT, E: DiameterSmallACT,
            F: note, G: shapeAbr, I: DiameterLargeACT, J: LenBAct, K: ratioSelected
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

    public func updateRegion(for system: String) {
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
    public func updateValuesShape(shapeAbr: String) -> Bool {
        showError = false
        errorMessage = ""
        
        // Basic checks for all shapes
        let allValues = [LenAAct, LenBAct, WidthACT, HeightACT, DiameterACT, DiameterSmallACT, DiameterLargeACT]
        if allValues.contains(where: { $0 < 0 }) {
            showError = true
            errorMessage = "Dimensions must be positive"
            return false
        }
        
        // Check that small diameters are less than large diameters for OpenRound and Elliptical round
        if shapeAbr == "O" || shapeAbr == "E" {
            if DiameterLargeACT < DiameterSmallACT {
                showError = true
                errorMessage = "Small Diameter must be less than Large Diameter"
                return false
            }
        }
        
        // Checks for Segment (triangle)
        if shapeAbr == "S" && LenAAct > 0 && WidthACT > 0 && LenBAct > 0 {
            if !isValidTriangle(LenAAct, WidthACT, LenBAct) {
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

    } // Class
