//
//  AppView.swift
//  MixMate
//
//  Created by Chris Milne on 30/04/2025.
//
import SwiftUI
import Foundation

enum NavTarget: Hashable {
    case shapeOptions
    case shapeEntry(String)   // shape name
    case next             // Goes to Diagram (final screen)
    case info(String)
    case last             // Returns to MainMenu
}

struct AppView: View {
    @State private var navPath: [NavTarget] = []
    @StateObject var IM = InputModel()

    var body: some View {
        NavigationStack(path: $navPath) {
            ShapeOptions(IM: IM, navPath: $navPath)
                .navigationDestination(for: NavTarget.self) { target in
                    switch target {
                    case .shapeOptions:
                        ShapeOptions(IM: IM, navPath: $navPath)
                    case .shapeEntry(let shape): DataEntry(pickShape: shape, shapeAbr: String(shape.prefix(1)), IM: IM, navPath: $navPath)
                    case .next:
                        Diagram(IM: IM, navPath: $navPath, pickShape: IM.pickShape)
                    case .info(let shape):
                        Info(navPath: $navPath, IM: IM, pickShape: shape)
                    case .last:
                        EmptyView().onAppear {
                       }
                   
                    }
        
                }
        }
    }
}

// Display all the available shapes and allow a choice
struct ShapeOptions: View {
@State private var listView = false
@State private var resetView = false
@Environment(\.dismiss) var dismiss
@ObservedObject var IM: InputModel
@Binding var navPath: [NavTarget]
var shapeSmalls: [String] = ["ConcreteSlab", "Round", "Segment", "Open Round", "Half Round", "Elliptical Round"]
    
var body: some View  {
        Text("Tap a shape to enter your measurements")
            .fontWeight(.bold)
        List {
            ForEach(shapeSmalls, id: \.self) { pickShape in
                NavigationLink {
                    DataEntry(pickShape: pickShape, shapeAbr: String(pickShape.prefix(1)), IM: IM, navPath: $navPath)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    ShapesDisplay(IM: IM, shapeAbr: String(pickShape.prefix(1)), pickShape: pickShape)
               
            } /// ForEach
        } /// List
    }
        .frame(alignment: .center)
        .navigationBarBackButtonHidden(true)
    } /// Body
} /// Struct shapeOptions


// Display an image and text of the shape that has been selected.
struct ShapesDisplay: View {
@ObservedObject var IM: InputModel
var shapeAbr: String
var pickShape: String
var body: some View {

        HStack {
            Image(pickShape)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 60)
            Text(pickShape)
                .frame(width: 120, height: 50)
        }
        .contentShape(Rectangle())  /// Ensures the row is fully tappable
}
} /// struct shapesDisplay

    #Preview {
AppView()
    }
