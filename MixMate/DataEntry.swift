//
//  DataEntry.swift
//  MixMate
//
//  Created by Chris Milne on 23/06/2025.
//
import SwiftUI
import Foundation

// Shape has been selected. Now Take input of the variables
    enum FocusedField: Hashable {
        case HeightACT, WidthACT, LenAACT, LenBACT, DiameterACT, DiameterLargeACT, DiameterSmallACT
    }

struct DataEntry: View {
    @Environment(\.dismiss) var dismiss
    var pickShape: String
    var shapeAbr: String
    
    // @StateObject prevents re-renders when properties change.
    @ObservedObject var IM: InputModel
    @AppStorage("preferredUnitSystem") var preferredUnitSystem: String = Locale.current.region?.identifier == "US" ? "imperial" : "metric"
    @State private var Inputvalue: String = ""
    @State var Outputvalue: Double = 0.0
    @State private var activeField: FocusedField = .HeightACT
    @Binding  var navPath: [NavTarget] /// Holds destinations. E.G LastScreen or NextScreen
    @FocusState private var focusedField: Bool /// Used to dismiss the Decimal Keypad
    @State var isStyled: Bool = false /// Style applied to the active input field
    
    var body: some View {
        ZStack {  // Cover the entire screen
            Color(red: 0.85, green: 0.95, blue: 0.99) 
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    IM.shapeAbr = shapeAbr
                    IM.pickShape = pickShape  }
            //           NavigationStack(path: $navPath) {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .center, spacing: 12) {
                        Text("Enter measurements").fontWidth(.compressed)
                        Text(pickShape).font(.largeTitle)
                        Image(pickShape)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 110)
                        
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
                            Text("Area").frame(width: 40)
                            Text(String(format: "%.1f", IM.Area))
                                .foregroundColor(.red)
                                .bold()
                            Text("sq.\(IM.note)").italic()
                                .frame(width: 50)
                    //          Spacer()
                            Text("Vol.").frame(width: 60)
                            Text(String(format: "%.1f", IM.Volume))
                                .foregroundColor(.red)
                                .bold()
                            Text("cu.\(IM.note)").italic()
                                .frame(width: 50)
                        } /// HStack
                    } /// VStack
                    
                    //MARK: Measurement Input
                    /*
                     COSHER:HeightACT, CS:LenAACT, WidthACT, S:LenBACT, RH:DiameterACT, OE:DiameterLargeACT, DiameterSmallACT   */
                    
                    VStack(alignment: .leading, spacing: 2) {
                        
                        if "COSHER".contains(IM.shapeAbr) {  // All Shapes
                            KeyPadInput(text: $IM.heightSTR, isStyled: activeField == .HeightACT, label: "Height",  unit: IM.note)
                                .frame(height: 30)
                                .focused($focusedField)
                                .onChange(of: IM.heightSTR) {
                                    IM.HeightACT = Double(IM.heightSTR) ?? 0
                                    _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                }
                        } /// All Shapes
                        
                        if "CS".contains(IM.shapeAbr) {  // Slab or Segment
                            KeyPadInput(text: $IM.lenASTR, isStyled: activeField == .LenAACT, label: "Length A",  unit: IM.note)
                                .frame(height: 30)
                                .focused($focusedField)
                                .onChange(of: IM.lenASTR) {
                                    IM.LenAACT = Double(IM.lenASTR) ?? 0
                                    _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                }
                            
                            KeyPadInput(text: $IM.widthSTR, isStyled: activeField == .WidthACT, label: "Width",  unit: IM.note)
                                .frame(height: 30)
                                .focused($focusedField)
                                .onChange(of: IM.widthSTR) {
                                    IM.WidthACT = Double(IM.widthSTR) ?? 0
                                    _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                }
                        } // Concrete & Segment
                        
                        if "S".contains(IM.shapeAbr) {  // Segment
                            KeyPadInput(text: $IM.lenBSTR, isStyled: activeField == .LenBACT, label: "Length B",  unit: IM.note)
                                .frame(height: 30)
                                .focused($focusedField)
                                .onChange(of: IM.lenBSTR) {
                                    IM.LenBACT = Double(IM.lenBSTR) ?? 0
                                    _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                }
                        } /// segment
                        
                        if "RH".contains(IM.shapeAbr) { // Round Half-Round
                            KeyPadInput(text: $IM.diameterSTR, isStyled: activeField == .DiameterACT, label: "Diameter",  unit: IM.note)
                                .frame(height: 30)
                                .focused($focusedField)
                                .onChange(of: IM.diameterSTR) {
                                    IM.DiameterACT = Double(IM.diameterSTR) ?? 0
                                    _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                }
                        } ///Round / Half round
                        
                        
                        if "OE".contains(IM.shapeAbr) { // open Round & Elliptical Round
                            KeyPadInput(text: $IM.diameterLargeSTR, isStyled: activeField == .DiameterLargeACT, label: " Large \n Diameter",  unit: IM.note)
                                .frame(height: 30)
                                .focused($focusedField)
                                .onChange(of: IM.diameterLargeSTR) {
                                    IM.DiameterLargeACT = Double(IM.diameterLargeSTR) ?? 0
                                    _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                }
                            
                            KeyPadInput(text: $IM.diameterSmallSTR, isStyled: activeField == .DiameterSmallACT, label: " Small \n Diameter",  unit: IM.note)
                                .frame(height: 30)
                                .focused($focusedField)
                                .onChange(of: IM.diameterSmallSTR) {
                                    IM.DiameterSmallACT = Double(IM.diameterSmallSTR) ?? 0
                                    _ = IM.updateValuesShape(shapeAbr: shapeAbr)
                                }
                        } // open Round & Elliptical Round
                    } /// VStack
                    .padding(.horizontal, 1)
                    .navigationBarBackButtonHidden(true)
                } /// ScrollView
  //              Spacer()
                    .onAppear {
                        activeField = .HeightACT
                    } // on Appear
                
                /// activeInputBinding Lets numeric keypad dynamically update the currently active field
                var activeInputBinding: Binding<String> {
                    switch activeField {
                    case .HeightACT:
                        return $IM.heightSTR
                    case .WidthACT:
                        return $IM.widthSTR
                    case .LenAACT:
                        return $IM.lenASTR
                    case .LenBACT:
                        return $IM.lenBSTR
                    case .DiameterACT:
                        return $IM.diameterSTR
                    case .DiameterLargeACT:
                        return $IM.diameterLargeSTR
                    case .DiameterSmallACT:
                        return $IM.diameterSmallSTR
                    } ///Switch
                } /// var active
                
                NumericKeypad(
                    input: activeInputBinding,
                    onCommit: {
                        IM.syncNumericsFromStrings()  /// Convert the input strings to numbers
                        _ = IM.updateValuesShape(shapeAbr: IM.shapeAbr)  ///Check illegal input
                    }, ///onCommit
                    
                    onTAB: {
                        withAnimation {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                let sequence = tabSequence(for: shapeAbr) /// Select correct input fields for each shape
                                if let currentIndex = sequence.firstIndex(of: activeField) { /// No of current field
                                    let nextIndex = (currentIndex + 1) % sequence.count /// Get remainder of next no / total
                                    activeField = sequence[nextIndex]  /// Get next input field if remainder < 1
                                } else {
                                    activeField = sequence.first ?? .HeightACT /// or go back to 1st input field
                                }
                            }
                        }
                    },
                    path: $navPath
                ) /// Numeric KeyPad
                .navigationDestination(for: NavTarget.self) { target in
                    switch target {
                    case .next: Diagram(IM: IM, navPath: $navPath, pickShape: pickShape)
                    case .last: EmptyView().onAppear {
                           navPath = []  // ← Cleanly reset from root
                             }
                    default: EmptyView()
                    } // switch
                } // NavDestination
            }
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
        case "C": return [.HeightACT, .LenAACT, .WidthACT]              /// Concrete slab
        case "S": return [.HeightACT, .LenAACT, .WidthACT, .LenBACT]     /// Segment
        case "R", "H": return [.HeightACT, .DiameterACT]                 /// Round or Half-Round
        case "O", "E": return [.HeightACT, .DiameterLargeACT, .DiameterSmallACT] /// Open/Elliptical
        default: return [.HeightACT]
        }
    }
    
} /// Struct

