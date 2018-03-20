//
//  FrameViewController.swift
//  Nano2
//
//  Created by Felipe Melo on 1/30/18.
//  Copyright © 2018 Felipe Melo. All rights reserved.
//

import UIKit

final class FrameViewController: BaseMVVMViewController, BaseMVVMViewControllerProtocol, UINavigationControllerDelegate {
    // Statics
    let LIMIT_LENGTH = 30
    let KEYBOARD_SIZE: CGFloat = 200
    
    // Outlets
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var pictureText: UITextField!
    
    // ViewModel
    typealias MVVMProtocol = FrameViewModelProtocol
    var viewModel: MVVMProtocol!
    
    // Variables
    private var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func takePictureClicked(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func finishFrameClicked(_ sender: Any) {
        viewModel.saveFrame()
        navigationController?.popViewController(animated: true)
    }
    
    private func setup() {
        viewModel = FrameViewModel(image: pictureImage.image!, text: pictureText.text!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

extension FrameViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imagePicker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pictureImage.image = image
            viewModel.setFrameImage(image: image)
        }
    }
    
}

extension FrameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= LIMIT_LENGTH
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if let text = textField.text {
            viewModel.setFrameText(text: text)
        }
    }
}

extension FrameViewController
{
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 2, delay: 0.05, options: .curveEaseOut, animations: {
            self.view.frame.origin.y -= self.KEYBOARD_SIZE
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += self.KEYBOARD_SIZE
    }
}
