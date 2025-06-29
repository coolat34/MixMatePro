//
//  MixMateApp.swift
//  MixMate
//
//  Created by Chris Milne on 30/04/2025.
//
/*
 MixMate.swift
 ├── MixMateApp        ← App entry point
 ├── Views
 │   ├── AppView      ← root container with NavigationStack
 │   ├── ShapeOptions  ← Choose a Shape
 │   ├── ShapesDisplay ← Display all available Shapes
 │   ├── DataEntry     ← Setup calls to make dependent on Shape
 |                       ├── KeyPadInput ← Display Input Field
 |                       ├── NumericKeypad ← Display Number pad. Take Input
 │   ├── Diagram       ← Calls for DiagramContent and displays Mix Strength
 |                       ├── DiagramContent ← Displayresults
 │   ├── GenPDF       ← Create a PDF with options to Copy, Print etc
 ├── Models/
 │   └── MixMateModel ← Class with most variables and global functions
 │   └── DataHandler  ← functions and checks
 ├── Shared/
 │   └── CustomButton ← Display enhanced buttons
 │   └── Size         ← set screen width and country code
 */
import SwiftUI

@main
struct MixMateApp: App {

    
    var body: some Scene {
        WindowGroup {
                AppView()
        }
    }
}


