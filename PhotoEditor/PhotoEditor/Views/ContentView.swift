//
//  ContentView.swift
//  PhotoEditor
//
//  Created by Nerimene on 4/6/2021.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var model = DrawingViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    if let _ = UIImage(data: model.imgData) {
                        DrawingScreen()
                            .environmentObject(model)
                            .toolbar(content: {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button(action: model.cancelImageEditing, label: {
                                        Image(systemName: "xmark")
                                    })
                                }
                            })
                    } else {
                        Button(action: {
                            model.showImgPicker.toggle()
                        }, label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.black)
                                .frame(width: 70, height: 70)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.07), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: -5)
                        })
                    }
                }.navigationTitle("Pic Art: Photo Editor")
            }
            if model.addnewBox {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                TextField("Type Here", text: $model.txtBoxes[model.currentIndex].text)
                    .font(.system(size: 35, weight: model.txtBoxes[model.currentIndex].isBold ? .bold : .regular))
                    .colorScheme(.dark)
                    .foregroundColor(model.txtBoxes[model.currentIndex].textColor)
                    .padding()
                
                HStack {
                    Button(action: {
                        model.txtBoxes[model.currentIndex].isAdded = true
                        model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                        model.canvas.becomeFirstResponder()
                        withAnimation{
                            model.addnewBox = false
                        }
                    }, label: {
                        Text("Add")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                    Spacer()
                    Button(action: model.cancelTextView, label: {
                        Text("Cancel")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                }.overlay(
                    HStack(spacing: 15) {
                        ColorPicker("", selection: $model.txtBoxes[model.currentIndex].textColor)
                            .labelsHidden()
                        
                        Button(action: {
                            model.txtBoxes[model.currentIndex].isBold.toggle()
                        }, label: {
                            Text(model.txtBoxes[model.currentIndex].isBold ? "Normal" : "Bold")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        })
                    }
                ).frame(maxHeight: .infinity, alignment: .top)
            }
        }.sheet(isPresented: $model.showImgPicker, content: {
            ImagePicker(showPicker: $model.showImgPicker, imgData: $model.imgData)
        }).alert(isPresented: $model.showAlert, content: {
            Alert(title: Text("Message"), message: Text(model.msg), dismissButton: .destructive(Text("OK")))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
