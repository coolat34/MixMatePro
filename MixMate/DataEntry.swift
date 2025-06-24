//
//  DataEntry.swift
//  MixMate
//
//  Created by Chris Milne on 23/06/2025.
//
import SwiftUI
import Foundation

// Shape has been selected. Now Take input of the variables

enum NavTarget: Hashable {
    case last             // Returns to MainMenu
    case next             // Goes to Diagram (final screen)
}
enum FocusedField: Hashable {
case HeightACT, WidthACT, LenAAct, LenBAct, DiameterACT, DiameterLargeACT, DiameterSmallACT
}

struct DataEntry: View {
    @Environment(\.dismiss) var dismiss
    var pickShape: String
    var shapeAbr: String
    
    // @StateObject prevents re-renders when properties change.
    @ObservedObject var IM: InputModel
    @AppStorage("preferredUnitSystem") var preferredUnitSystem: String = Locale.current.region?.identifier == "US" ? "imperial" : "metric"
    @State var lenASTR: String = ""
    @State var widthSTR: String = ""
    @State var heightSTR: String = ""
    @State var lenBSTR: String = ""
    @State var diameterSTR: String = ""
    @State var diameterLargeSTR: String = ""
    @State var diameterSmallSTR: String = ""
    @State private var Inputvalue: String = ""
    @State var Outputvalue: Double = 0.0
    @State private var activeField: FocusedField = .HeightACT
    @State private var navPath: [NavTarget] = [] /// Holds destinations. E.G LastScreen or NextScreen
    @FocusState private var focusedField: Bool /// Used to dismiss the Decimal Keypad
    @State var isStyled: Bool = false /// Style applied to the active input field
    
    var body: some View {
        ZStack {  // Cover the entire screen
            Color(red: 0.85, green: 0.95, blue: 0.99)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    IM.shapeAbr = shapeAbr
                    IM.pickShape = pickShape  }
            NavigationStack(path: $navPath) {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .center, spacing: 12) {
                            Text("Enter measurements").fontWidth(.compressed)
                            Text(pickShape).font(.largeTitle)
                            Image(pickShape)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 120)
                            
                            // Amend preferrence of Metric or Imperial
                            Picker("Units", selection: $preferredUnitSystem) {
                                Text("Metric").tag("metric")
                                Text("Imperial").tag("imperial")
                            } /// Picker
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 300)
                            .onChange(of: preferredUnitSystem) {
                                IM.updateRegion(for: preferredUnitSystem)
                            } /// onChange of
                            
    // MARK: Amend preference of Metres, Centimetres or Millimetres
                            Picker("Measurement", selection: $IM.measureSelected) {
                                ForEach(IM.measurements, id: \.self) { Text($0) }
                            }/// Picker
                            .pickerStyle(.segmented)
                            .frame(width: 300)
                            // Use onChange of for Picker
                            .onChange(of: IM.measureSelected) {
                                IM.updateMeasurement(IM.measureSelected,   ratioSelected: IM.ratioSelected)
                            } // on Change of

    // MARK: Area output
                            HStack {
                                Text("Area").frame(width: 60)
                                Text(String(format: "%.1f", IM.Area))
                                    .foregroundColor(.red)
                                    .bold()
                                Text("sq.\(IM.note)").italic()
                                Spacer().frame(width: 20)
                                Text("Volume").frame(width: 80)
                                Text(String(format: "%.1f", IM.Volume))
                                    .foregroundColor(.red)
                                    .bold()
                                Text("cu.\(IM.note)").italic()
                            } /// HStack
                        } /// VStack
                      
    //MARK: Measurement Input
                        /*
                         COSHER:HeightACT, CS:LenAAct, WidthACT, S:LenBAct, RH:DiameterACT, OE:DiameterLargeACT, DiameterSmallACT   */
                      
                        VStack(alignment: .leading, spacing: 2) {

                            if "COSHER".contains(IM.shapeAbr) {  // All Shapes
                                KeyPadInput(text: $heightSTR, isStyled: activeField == .HeightACT, label: "Height",  unit: IM.note)
                                    .frame(height: 30)
                                    .focused($focusedField)
                                    .onChange(of: heightSTR) {
                                        IM.HeightACT = Double(heightSTR) ?? 0
                                        _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                    }
                            } /// All Shapes
                            
                            if "CS".contains(IM.shapeAbr) {  // Slab or Segment
                                KeyPadInput(text: $lenASTR, isStyled: activeField == .LenAAct, label: "Length A",  unit: IM.note)
                                    .frame(height: 30)
                                    .focused($focusedField)
                                    .onChange(of: lenASTR) {
                                        IM.LenAAct = Double(lenASTR) ?? 0
                                        _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                    }
                                
                                KeyPadInput(text: $widthSTR, isStyled: activeField == .WidthACT, label: "Width",  unit: IM.note)
                                    .frame(height: 30)
                                    .focused($focusedField)
                                    .onChange(of: widthSTR) {
                                        IM.WidthACT = Double(widthSTR) ?? 0
                                        _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                    }
                            } // Concrete & Segment
                            
                            if "S".contains(IM.shapeAbr) {  // Segment
                                KeyPadInput(text: $lenBSTR, isStyled: activeField == .LenBAct, label: "Length B",  unit: IM.note)
                                    .frame(height: 30)
                                    .focused($focusedField)
                                    .onChange(of: lenBSTR) {
                                        IM.LenBAct = Double(lenBSTR) ?? 0
                                        _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                    }
                            } /// segment
                            
                            if "RH".contains(IM.shapeAbr) { // Round Half-Round
                                KeyPadInput(text: $diameterSTR, isStyled: activeField == .DiameterACT, label: "diameter",  unit: IM.note)
                                    .frame(height: 30)
                                    .focused($focusedField)
                                    .onChange(of: diameterSTR) {
                                        IM.DiameterACT = Double(diameterSTR) ?? 0
                                        _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                    }
                            } ///Round / Half round
                            
                            
                            if "OE".contains(IM.shapeAbr) { // open Round & Elliptical Round
                                KeyPadInput(text: $diameterLargeSTR, isStyled: activeField == .DiameterLargeACT, label: " Large \n Diameter",  unit: IM.note)
                                    .frame(height: 30)
                                    .focused($focusedField)
                                    .onChange(of: diameterLargeSTR) {
                                        IM.DiameterLargeACT = Double(diameterLargeSTR) ?? 0
                                        _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                    }
                                
                                KeyPadInput(text: $diameterSmallSTR, isStyled: activeField == .DiameterSmallACT, label: " Small \n Diameter",  unit: IM.note)
                                    .frame(height: 30)
                                    .focused($focusedField)
                                    .onChange(of: diameterSmallSTR) {
                                        IM.DiameterSmallACT = Double(diameterSmallSTR) ?? 0
                                        _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                    }
                            } // open Round & Elliptical Round
                        } /// VStack
                        .padding(.horizontal, 1)
                    } /// ScrollView
                    Spacer()
                        .onAppear {
                            activeField = .HeightACT
                        } // on Appear
                    
                    /// activeInputBinding Lets numeric keypad dynamically update the currently active field
                    var activeInputBinding: Binding<String> {
                        switch activeField {
                        case .HeightACT:
                            return $heightSTR
                        case .WidthACT:
                            return $widthSTR
                        case .LenAAct:
                            return $lenASTR
                        case .LenBAct:
                            return $lenBSTR
                        case .DiameterACT:
                            return $diameterSTR
                        case .DiameterLargeACT:
                            return $diameterLargeSTR
                        case .DiameterSmallACT:
                            return $diameterSmallSTR
                        } ///Switch
                    } /// var active
                    
                    NumericKeypad(
                        input: activeInputBinding,
                        onCommit: {
                            switch activeField {
                            case .HeightACT:
                                IM.HeightACT = Double(heightSTR) ?? 0.0
                            case .WidthACT:
                                IM.WidthACT = Double(widthSTR) ?? 0.0
                            case .LenAAct:
                                IM.LenAAct = Double(lenASTR) ?? 0.0
                            case .LenBAct:
                                IM.LenBAct = Double(lenBSTR) ?? 0.0
                            case .DiameterACT:
                                IM.DiameterACT = Double(diameterSTR) ?? 0.0
                            case .DiameterLargeACT:
                                IM.DiameterLargeACT = Double(diameterLargeSTR) ?? 0.0
                            case .DiameterSmallACT:
                                IM.DiameterSmallACT = Double(diameterSmallSTR) ?? 0.0
                                
                            } ///Switch
                            _ = IM.updateValuesShape(shapeAbr: IM.shapeAbr)
                        }, ///onCommit


                        onTAB: {
                            withAnimation {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                let sequence = tabSequence(for: shapeAbr)
                                if let currentIndex = sequence.firstIndex(of: activeField) {
                                    let nextIndex = (currentIndex + 1) % sequence.count
                                    activeField = sequence[nextIndex]
                                } else {
                                    activeField = sequence.first ?? .HeightACT
                                }
                            }
                        }
                    },
                        path: $navPath
                    ) /// Numeric KeyPad
                    .navigationDestination(for: NavTarget.self) { target in
                        switch target {
                        case .next: Diagram(IM: IM, pickShape: pickShape)
                        case .last: MainMenu(IM: IM)
                            //                 default: EmptyView()
                        } // switch
                    } // NavDestination
                }
            } /// 1
        }  // ZStack
        
        .zIndex(1)
        // Display error messages after the last Vstack and before the last ZStack. Ensures that the  rendering takes precedence over the current display
        
        if IM.showError {
            VStack {
                Spacer()
                Text(IM.errorMessage)
                    .padding()
                    .background(Color.red.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        // Hide after 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                IM.showError = false
                            } /// withAnimation
                        } ///DispatchQueu
                    } ///onAppear
            } ///VStack
            .zIndex(1)
        } ///If Showerror
        
    } /// Body
/// The letters represent the 1st character of the chosen shape. The values correspond to the input fields for that shape.
    func tabSequence(for shapeAbr: String) -> [FocusedField] {
        switch shapeAbr {
        case "C": return [.HeightACT, .LenAAct, .WidthACT]              /// Concrete slab
        case "S": return [.HeightACT, .LenAAct, .WidthACT, .LenBAct]     /// Segment
        case "R", "H": return [.HeightACT, .DiameterACT]                 /// Round or Half-Round
        case "O", "E": return [.HeightACT, .DiameterLargeACT, .DiameterSmallACT] /// Open/Elliptical
        default: return [.HeightACT]
        }
    }
    
} /// Struct

