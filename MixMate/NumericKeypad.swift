//
//  NumericKeypad.swift
//  MixMate
//
//  Created by Chris Milne on 20/06/2025.
//

import SwiftUI

struct NumericKeypad: View {
    @Binding var input: String
    var onCommit: () -> Void
    var onTAB: () -> Void

    @Binding var path: [NavTarget]
 //   @Binding  var navPath: [NavTarget]
    
    private let buttons = [
        ["1", "2", "3", "TAB"],
        ["4", "5", "6", "Clear"],
        ["7", "8", "9", "Next"],
        [".", "0", "⌫", "Last"]
    ]

    var body: some View {
        VStack(spacing: 5) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 5) {
                    ForEach(row, id: \.self) { symbol in
                        Button(action: { handleTap(symbol) }) {
                            Text(symbol)
                                .font(.title2)
                                .foregroundStyle(.black)
                                .frame(width: 65, height: 35)
                                .background(Color.blue.opacity(0.1))
                                .border(Color.black, width: 1)
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }

    private func handleTap(_ symbol: String) {
        switch symbol {
        case "⌫":
            if !input.isEmpty { input.removeLast() }
        case ".":
            if !input.contains(".") { input.append(".") }
        case "Clear":
            input = ""
        case "TAB":
            onTAB()
        case "Next":
            path.append(.next)
        case "Last":
          path.append(.last)   // alternative method of voiding the stack
           path = []
        default:
            input.append(symbol)
        }
    }
}
