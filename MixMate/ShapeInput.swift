//
//  ShapeInput.swift
//  MixMate
//
//  Created by Chris Milne on 11/06/2025.
//

import SwiftUI
import UIKit

struct ShapeInput: View {
    @Environment(\.dismiss) var dismiss
    var shapeSmall: String
    var shapeAbr: String
    // @StateObject prevents re-renders when properties change.
    @ObservedObject var IM: InputModel
    @FocusState private var focusedField: Bool // Used to dismiss the Decimal Keypad
    @AppStorage("preferredUnitSystem") var preferredUnitSystem: String = Locale.current.region?.identifier == "US" ? "imperial" : "metric"
    @State var lenA: String = ""
    @State var width: String = ""
    @State var height: String = ""
    @State var lenB: String = ""
    @State var diameter: String = ""
    @State var diameterLarge: String = ""
    @State var diameterSmall: String = ""
    @State private var activeField: ActiveField = .none
    enum ActiveField {
        case lenA, width, height, lenB, diameter, diameterLarge, diameterSmall, none
    }
    var body: some View {
        ZStack {  // Cover the entire screen
            Color(red: 0.85, green: 0.95, blue: 0.99)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    IM.shapeAbr = shapeAbr
                    IM.shapeSmall = shapeSmall
                }
            VStack(spacing: 1)  {
                NavigationLink(destination: Diagram(IM: IM, shapeSmall: shapeSmall)
//                    .navigationBarBackButtonHidden(true)
//                    .navigationTitle("Bag Configuration")
//                    .navigationBarTitleDisplayMode(.inline)
//                    .foregroundColor(Color(.black))
                ) {
                    CustomButton(label:"See Cement, Sand & Aggregate mix", width: 310, height: 34) }
/*
                
                Button(action: { IM.resetValues();resetLocalInputs() }) {
                    CustomButton(label: "Reset all values", width: 250, height: 34, logo:
                                    Image("circle")) }
                
                Button(action: { dismiss() }) {
                    CustomButton(label:"Return", width: 200,height: 34, logo:
                                    Image("arrow.left.circle")) }
                
                .navigationBarBackButtonHidden(true)
                
                //            } // VStack
                //            VStack {
                //            ScrollView {
                //                   VStack(spacing: 16) {
 */
                Text(shapeSmall)
                    .font(.largeTitle)
            } // VStack
 //                       Text("Enter measurements")
 //                           .fontWidth(.compressed)
            HStack {
                VStack(alignment: .leading, spacing: 12) {
              customInputField(title: "Length A", value: $lenA, active: .lenA)
                customInputField(title: "Width", value: $width, active: .width)
                customInputField(title: "Height", value: $height, active: .height)
                customInputField(title: "Diameter", value: $diameter, active: .diameter)
                customInputField(title: "Small Diameter", value: $diameterSmall, active: .diameterSmall)
                customInputField(title: "Large Diameter", value: $diameterLarge, active: .diameterLarge)
                customInputField(title: "Length B", value: $lenB, active: .lenB)
                                }

                                Spacer()

                                Image("shapeSmall")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150)
                            }
                            .padding()
                        
                        // Amend preferrence of Metric or Imperial
                        Picker("Units", selection: $preferredUnitSystem) {
                            Text("Metric").tag("metric")
                            Text("Imperial").tag("imperial")
                        }.pickerStyle(SegmentedPickerStyle())
                            .frame(width: 300)
                            .onChange(of: preferredUnitSystem) {
                                IM.updateRegion(for: preferredUnitSystem)
                            }
                    } // VStack
                    
                    // Amend preference of Metres, Centimetres or Millimetres
                    HStack {
                        Button {
                        } label: {
                            Picker("Measurement", selection: $IM.measureSelected) {
                                ForEach(IM.measurements, id: \.self) {
                                    Text($0)
                                        .foregroundColor(.black)
                                }/// ForEach
                            }/// Picker
                            .pickerStyle(.segmented)
                            .frame(width: 300)
                            // Use onChange of for Picker
                            .onChange(of: IM.measureSelected) {
                                IM.updateMeasurement(IM.measureSelected,   ratioSelected: IM.ratioSelected)
                            } // onChange of
                        } // Label
                    }     // HStack
                    
                    //MARK: Measurement Input
                    if "COSHER".contains(shapeAbr) {  // All Shapes
                        InputField(label: "Height", value: $height, unit: IM.note)
                            .focused($focusedField)
                            .onChange(of: height) {
                                IM.Height = Double(height) ?? 0
                                _ = IM.updateValuesShape(shapeAbr: shapeAbr) }
                    }
                    
                    if "CS".contains(shapeAbr) {  // Slab or Segment
                        InputField(label: "Length A", value: $lenA, unit: IM.note)
                            .focused($focusedField)
                            .onChange(of:lenA) {
                                IM.Len = Double(lenA) ?? 0
                                _ = IM.updateValuesShape(shapeAbr: shapeAbr) // Validate but do NOT dismiss
                            }
                        
                        InputField(label: "Width", value: $width, unit: IM.note)
                            .focused($focusedField)
                            .onChange(of: width) {
                                IM.Width = Double(width) ?? 0
                                _ = IM.updateValuesShape(shapeAbr: shapeAbr) }
                    } // Concrete & Segment
                    
                    
                    
                    if "S".contains(shapeAbr) {  // Segment
                        InputField(label: "Length B", value: $lenB, unit: IM.note)
                            .focused($focusedField)
                            .onChange(of: lenB) {
                                IM.LenB = Double(lenB) ?? 0
                                _ = IM.updateValuesShape(shapeAbr: shapeAbr)}
                    }
                    
                    if "RH".contains(shapeAbr) { // Round Half-Round
                        InputField(label: "Diameter", value: $diameter, unit: IM.note)
                            .focused($focusedField)
                            .onChange(of: diameter) {
                                IM.Diameter = Double(diameter) ?? 0
                                _ = IM.updateValuesShape(shapeAbr: shapeAbr) }
                    }
                    
                    
                    if "OE".contains(shapeAbr) { // open Round & Elliptical Round
                        InputField(label: " Large \n Diameter", value: $diameterLarge, unit: IM.note)
                            .focused($focusedField)
                            .onChange(of: diameterLarge) {
                                IM.DiameterLarge = Double(diameterLarge) ?? 0
                                _ = IM.updateValuesShape(shapeAbr: shapeAbr) }
                        
                        InputField(label: " Small \n Diameter", value: $diameterSmall, unit: IM.note)
                            .focused($focusedField)
                            .onChange(of: diameterSmall) {
                                IM.Diametersmall = Double(diameterSmall) ?? 0
                                _ = IM.updateValuesShape(shapeAbr: shapeAbr) }
                    } // IF OE
                    //                 Spacer()
// MARK: Area output in a single line
                    HStack {
                        Text("Area")
                            .frame(width: 60, height: 40)
                            .font(.title2)
                        Text("\(String(format: "%.1f",IM.Area))")
                            .frame(width: 50, height: 40)
                            .foregroundColor(.red)
                            .bold()
                            .font(.title2)
                        Text("sq.\(IM.note)")
                            .frame(width: 50, height: 40)
                            .italic()
                        //    .fontWidth(.condensed)
                        Text("Volume")
                            .frame(width: 80, height: 40)
                            .font(.title2)
                        Text("\(String(format: "%.1f",IM.Volume))")
                            .frame(width: 50, height: 40)
                            .foregroundColor(.red)
                            .bold()
                            .font(.title2)
                        Text("cu.\(IM.note)")
                            .frame(width: 50, height: 40)
                            .italic()
                        //      .fontWidth(.condensed)
                    }
   //             } /// VStack
  //          } // ScrollView
  //          Spacer()
            
            
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
                                }
                            }
                        }
                }
                
                .zIndex(1) // <<< reinforces that the error view should have a higher stack order, just in case other views have implicit or higher z-indexes.
//            }
        } /// ZStack
 //       .padding()
        // MARK: Buttons
        
  /*
        VStack(spacing: 1)  {
            NavigationLink(destination: Diagram(IM: IM, shapeSmall: shapeSmall)
                .navigationBarBackButtonHidden(true)
                .navigationTitle("Bag Configuration")
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(Color(.black))
            ) {
                CustomButton(label:"See Cement, Sand & Aggregate mix", width: 310, height: 24) }
            
            
            Button(action: { IM.resetValues();resetLocalInputs() }) {
                CustomButton(label: "Reset all values", width: 250, height: 24, logo:
                                Image("circle")) }
            
            Button(action: { dismiss() }) {
                CustomButton(label:"Return", width: 200,height: 24, logo:
                                Image("arrow.left.circle")) }
            
            .navigationBarBackButtonHidden(true)
            
        } // VStack
  */
   } /// Body
    func resetLocalInputs() {
        lenA = ""
        width = ""
        height = ""
        lenB = ""
        diameter = ""
        diameterLarge = ""
        diameterSmall = ""
    }
@ViewBuilder
    func customInputField(title: String, value: Binding<String>, active: ActiveField) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)

            RoundedRectangle(cornerRadius: 8)
                .stroke(activeField == active ? Color.blue : Color.gray, lineWidth: 2)
                .frame(height: 40)
                .overlay(
                    Text(value.wrappedValue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 8)
                )
                .onTapGesture {
                    activeField = active
                }
        }
    }
//}
} /// Struct

// Incorporate all Input attributes in a struct
struct InputField: View {
    let label: String
    // Binding required because it's an input variable
    @Binding var value: String
    
    let unit: String
    
    var body: some View {
        HStack {
            Text(label)
                .frame(minWidth: 150, alignment: .trailing)
                .font(.title3)
                .foregroundColor(.black)
            TextField("", text: $value)
            //               .focused($focusedField)
                .font(.title)
                .foregroundColor(.black)
                .background(.white)
                .frame(minWidth: 100, alignment: .leading)
                .keyboardType(.decimalPad)
            
            Text(unit)
                .frame(minWidth: 100, alignment: .leading)
                .font(.title3)
                .foregroundColor(.black)
        }
    } // Body
}

