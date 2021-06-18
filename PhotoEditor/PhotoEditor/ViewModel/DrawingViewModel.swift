//
//  DrawingViewModel.swift
//  PhotoEditor
//
//  Created by Nerimene on 4/6/2021.
//

import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {
    
    @Published var showImgPicker = false
    @Published var imgData: Data = Data(count: 0)
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    @Published var txtBoxes: [TextBox] = []
    @Published var addnewBox = false
    @Published var currentIndex: Int = 0
    @Published var rect: CGRect = .zero
    @Published var showAlert = false
    @Published var msg = ""
    
    func cancelImageEditing() {
        imgData = Data(count: 0)
        canvas = PKCanvasView()
        txtBoxes.removeAll()
    }
    
    func cancelTextView() {
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        withAnimation {
            addnewBox = false
        }
        if txtBoxes[currentIndex].isAdded {
            txtBoxes.removeLast()
        }
    }
    
    func saveImage() {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        let swiftUIView = ZStack {
            ForEach(txtBoxes){[self] box in
                Text(txtBoxes[currentIndex].id == box.id && addnewBox ? "" : box.text)
                    .font(.system(size: 30))
                    .fontWeight(box.isBold ? .bold : .none)
                    .foregroundColor(box.textColor)
                    .offset(box.offset)
            }
        }
        let controller = UIHostingController(rootView: swiftUIView).view!
        controller.frame = rect
        controller.backgroundColor = .clear
        canvas.backgroundColor = .clear
        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let generatedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = generatedImg?.pngData() {
            UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
            self.msg = "Saved Successfully !!!"
            self.showAlert.toggle()
        }
    }
}
