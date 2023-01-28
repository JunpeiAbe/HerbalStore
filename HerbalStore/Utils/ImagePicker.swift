//
//  ImagePicker.swift
//  HerbalStore
//
//  Created by Junpei  on 2023/01/17.
//

import SwiftUI

struct ImagePicker:UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Environment (\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent:self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {return}
            self.parent.image = image
            self.parent.dismiss()
        }
    }
}
