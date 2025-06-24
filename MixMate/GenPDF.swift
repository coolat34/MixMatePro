//
//  GenPDF.swift
//  MixMate
//
//  Created by Chris Milne on 04/06/2025.
//

import SwiftUI
import PDFKit

struct GenPDF: View {
    @EnvironmentObject var IM: InputModel
    @Environment(\.dismiss) var dismiss
    @State private var pdfURL: URL? = nil
    @State private var hasShared = false
    @State private var pdfWrapper: IdentifiableURL? = nil
    var pickShape: String

    var body: some View {
        Color.clear // invisible view

           .onAppear {
                 if !hasShared {
                     let url = generatePDF(
                        weightSmall: IM.weightSmall,
                        BagsCementSmall: IM.BagsCementSmall,
                        BagsSandSmall: IM.BagsSandSmall,
                        BagsAggregateSmall: IM.BagsAggregateSmall,
                        weightMed: IM.weightMed,
                        BagsCementMed: IM.BagsCementMed,
                        BagsSandMed: IM.BagsSandMed,
                        BagsAggregateMed: IM.BagsAggregateMed,
                        weightLarge: IM.weightLarge,
                        BagsCementLarge: IM.BagsCementLarge,
                        BagsSandLarge: IM.BagsSandLarge,
                        BagsAggregateLarge: IM.BagsAggregateLarge
                     )
                     pdfWrapper = IdentifiableURL(url: url)
                     hasShared = true
                 }
             }
             .sheet(item: $pdfWrapper) { wrapper in
                 ShareSheet(activityItems: [wrapper.url]) {
                     dismiss()
                 }
             }
             }
   
 /// 1: Generate pdf from given view
          @MainActor
 private func generatePDF(
    weightSmall: String,
    BagsCementSmall: Double,
    BagsSandSmall: Double,
    BagsAggregateSmall: Double,
    weightMed: String,
    BagsCementMed: Double,
    BagsSandMed: Double,
    BagsAggregateMed: Double,
    weightLarge: String,
    BagsCementLarge: Double,
    BagsSandLarge: Double,
    BagsAggregateLarge: Double) -> URL {
         ///  1; Select UI View to render as pdf
        let renderer = ImageRenderer(content: DiagramContent(IM:IM, pickShape: pickShape))
                 
         /// 2: Save it to our documents directory
              let url = URL.documentsDirectory.appending(path: "MixMate.pdf")
         /// 3: Start the rendering process. Make the pageSize - A4 if it won't fit.
             renderer.render { size, context in
             let pageSize = size.width > 0 && size.height > 0 ? size : CGSize(width: 595, height: 842)
                 
         /// 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
                 var pdfRect = CGRect(origin: .zero, size: pageSize)
         /// 5: Create the CGContext for our PDF pages
                 guard let pdf = CGContext(url as CFURL, mediaBox: &pdfRect, nil) else { return }
         /// 6: Start at Page 1. Required else Fatal Error
                 pdf.beginPDFPage(nil)
         /// 7: Render the SwiftUI view data onto the page.
               context(pdf)   /// Parts of new page displayed but PDF is displayed & printed
         /// 8: End the page and close the file
                 pdf.endPDFPage()
                 pdf.closePDF()
              }  /// Renderer
           return url
         } /// func
 } /// struct
             
 //MARK: PDF Viewer
             struct PDFKitView: UIViewRepresentable {
                 let url: URL
                 func makeUIView(context: Context) -> PDFView {
                     let pdfView = PDFView()
                     pdfView.document = PDFDocument(url: self.url)
                     pdfView.autoScales = true
                     return pdfView
                 } /// func

                 /// Update pdf if needed
                 func updateUIView(_ pdfView: PDFView, context: Context) {
                 }

 } /// struct
 struct ShareSheet: UIViewControllerRepresentable {
     let activityItems: [Any]
     let applicationActivities: [UIActivity]? = nil
     var onComplete: (() -> Void)? = nil

     func makeUIViewController(context: Context) -> UIActivityViewController {
         let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
         controller.completionWithItemsHandler = { _, _, _, _ in
             onComplete?()
         }
         return controller
     }

     func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
 }

 struct IdentifiableURL: Identifiable {
     let id = UUID()
     let url: URL
 }


 #Preview {
     GenPDF(pickShape: "")
 }
