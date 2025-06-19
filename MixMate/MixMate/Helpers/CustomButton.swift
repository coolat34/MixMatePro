//
//  CustomButton.swift
//  Buttons and TabItems
//
//  Created by Chris Milne on 24/09/2023.
//

import SwiftUI

struct CustomButton: View {
    let label: String
    let width: Int
    let height: Int
    let altColour: Bool
    let logo: Image?

    init(label: String, width: Int = 300, height: Int = 36, altColour: Bool = false, logo: Image? = nil) {
      self.label = label
      self.width = width
      self.height = height
      self.altColour = altColour
        self.logo = logo
    }

    var body: some View {
    
        Text("\(label) \(logo ?? Image(systemName: "dot.square"))")
            .fontWeight(.regular)
        .foregroundColor(Color.black)
        .frame(width: CGFloat(width), height: CGFloat(height), alignment: .center)
        .background(altColour ? Color.mint: Color.teal)
        .cornerRadius(16, antialiased: true)
      //  .padding()
        .animation(.easeInOut, value: altColour)
    }
  }

  struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
      CustomButton(label: "This is the label", altColour: true)
    }
  }

