//
//  DrawingScreen.swift
//  PhotoEditor
//
//  Created by Nerimene on 4/6/2021.
//

import SwiftUI
import PencilKit

struct DrawingScreen: View {
    
    @EnvironmentObject var model: DrawingViewModel
    
    var body: some View {
        ZStack {
            GeometryReader{proxy -> AnyView in
                let size = proxy.frame(in: .global)
                DispatchQueue.main.async {
                    if model.rect == .zero {
                        model.rect = size
                    }
                }
                return AnyView(
                    ZStack {
                        CanvasView(canvas: $model.canvas, imageData: $model.imgData, toolPicker: $model.toolPicker, rect: size.size)
                        
                        ForEach(model.txtBoxes){box in
                            Text(model.txtBoxes[model.currentIndex].id == box.id && model.addnewBox ? "" : box.text)
                                .font(.system(size: 30))
                                .fontWeight(box.isBold ? .bold : .none)
                                .foregroundColor(box.textColor)
                                .offset(box.offset)
                                .gesture(DragGesture().onChanged({ (value) in
                                    let current = value.translation
                                    let lastOffset = box.lastOffset
                                    let newTranslation = CGSize(width: lastOffset.width + current.width, height: lastOffset.height + current.height)
                                    model.txtBoxes[getIndex(txtBox: box)].offset = newTranslation
                                }).onEnded({ (value) in
                                    model.txtBoxes[getIndex(txtBox: box)].lastOffset = model.txtBoxes[getIndex(txtBox: box)].offset
                                }))
                                .onLongPressGesture {
                                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                                    model.canvas.resignFirstResponder()
                                    model.currentIndex = getIndex(txtBox: box)
                                    withAnimation{
                                        model.addnewBox = true
                                    }
                                }
                        }
                    }
                )
            }
        }.toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: model.saveImage, label: {
                    Text("Save")
                })
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    model.txtBoxes.append(TextBox())
                    model.currentIndex = model.txtBoxes.count - 1
                    withAnimation{
                        model.addnewBox.toggle()
                    }
                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                    model.canvas.resignFirstResponder()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        })
    }
    
    func getIndex(txtBox: TextBox) -> Int {
        let index = model.txtBoxes.firstIndex {(box) -> Bool in
            return txtBox.id == box.id
        } ?? 0
        return index
    }
}
