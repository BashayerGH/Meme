//
//  ViewController.swift
//  memeMe
//
//  Created by Bashayer on 2018
//  Copyright © 1440 Bashayer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var TopTextfield: UITextField!
    @IBOutlet weak var BottonTextfield: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var ToolBar: UIToolbar!
    @IBOutlet weak var UpperToolBar: UIToolbar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(tf: TopTextfield, text: "TOP")
        setupTextField(tf: BottonTextfield, text: "BOTTOM")
        shareButton.isEnabled = false

        
    }
    
    
    func setupTextField(tf: UITextField, text: String) {
        
        let memeTextAttributes:[NSAttributedString.Key: Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -4.0]
        
        
        tf.defaultTextAttributes = memeTextAttributes
        tf.textColor = UIColor.white
        tf.tintColor = UIColor.white
        tf.textAlignment = .center
        tf.text = text
        tf.delegate = self
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Clear the TextFields
        textField.text = ""
    }
    
    
    //pick an image from Album
    @IBAction func pickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = .scaleAspectFit
            shareButton.isEnabled = true
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //pick an image from Camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) 
        
        //Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification:Notification) {
        
        if BottonTextfield.isEditing{
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            view.frame.origin.y =  -keyboardSize.cgRectValue.height
        }
        
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        view.frame.origin.y = 0
    }

    
    func save(){
        // Create the meme object
        let memeObject = Meme(topText: TopTextfield.text!, bottomText: BottonTextfield.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    
    @IBAction func ShereAnImage(_ sender: Any) {
        
        let image = generateMemedImage()
        let imageView = [image]
        
        // Create a 'UIActivityViewController', pass it 'image' in an array and present it.
        let share = UIActivityViewController(activityItems: imageView, applicationActivities: nil)
        share.popoverPresentationController?.sourceView = self.view
        self.present(share, animated: true)
        
        
        share.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }else{
                self.save()
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
     ///////////\\\\\\\\\\\\////////////\\\\\\\\\\\\
    func generateMemedImage() -> UIImage {
        ToolBar.isHidden = true
        UpperToolBar.isHidden = true
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        ToolBar.isHidden = false
        UpperToolBar.isHidden = false
        
        return memedImage
    }
    
    @IBAction func Cancel(_ sender: Any) {
        TopTextfield.text = "TOP"
        BottonTextfield.text = "BOTTOM"
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }
    
    
}

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}
