//
//  ImagePickerController.swift
//  customCellDemo
//
//  Created by Amy Giver on 9/14/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    let imagePicker = UIImagePickerController()
    weak var cancelButtonDelegate: CancelButtonDelegate?
    weak var memoriesDelegate: MemoryDelegate?
    weak var updatingDelegate: UpdatingDelegate?
    var newNameForMemory: String?
    var newImageToSave: UIImage?
    var fileNumber: Int?
    var imageToUpdate: UIImage?
    var memoryToUpdate: Memory?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        //press the done button, only care if we have a name supplied
       
        if let newName = nameTextField.text, newDesc = descriptionTextArea.text {
            if newName == "" {
                //if there is no name, cancel
                cancelButtonDelegate?.cancelButtonPressedFrom(self)
            }
            else {
                newNameForMemory = newName
                //if we're updating, no need to make a new filename for the memory
                //we'll have to check that the pic is not a snail
                if let updatedMemory = memoryToUpdate {
                    updatedMemory.name = newName
                    updatedMemory.desc = newDesc
                    if chosenImage.image != UIImage(named: "snail"){
                        saveNewImage(chosenImage.image!, filename: updatedMemory.fileName!)
                    }
                    updatingDelegate?.updatingExistingMemory(updatedMemory)
                }
                else {
                    let newMemoryFileName = self.randomFileName() + ".png"
                    if chosenImage.image != UIImage(named: "snail"){
                        print("not a snail")
                        saveNewImage(chosenImage.image!, filename: newMemoryFileName)
                    }
                    memoriesDelegate?.imagePickerController(self, didFinishWritingMemory: newName, memoryDesc: newDesc, memoryFileName: newMemoryFileName)
                }
            }
        }
           }
    
    @IBOutlet weak var descriptionTextArea: UITextView!
    
    @IBOutlet weak var chosenImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenImage.contentMode = .ScaleAspectFit
//        if let currentImage = imageToUpdate {
//            chosenImage.image = currentImage
//        }
        if let currentmemory = memoryToUpdate {
            nameTextField.text = currentmemory.name
            descriptionTextArea.text = currentmemory.desc
            let filename = currentmemory.fileName
            let updatedimage = (getDocumentsDirectory() as NSString).stringByAppendingPathComponent(filename!)
            if UIImage(contentsOfFile: updatedimage) != nil {
                chosenImage.image = UIImage(contentsOfFile: updatedimage)
            }
            else {
                chosenImage.image = UIImage(named: "snail")
            }
        }
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ImagePickerController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ImagePickerController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        imagePicker.delegate = self
    }

    @IBAction func addingButtonPressed(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        print("Want to hunt through pics")
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImageToSave = pickedImage
            chosenImage.contentMode = .ScaleAspectFit
            chosenImage.image = pickedImage
//            if let data = UIImagePNGRepresentation(pickedImage){
//                let filename = getDocumentsDirectory().stringByAppendingPathComponent("mixcopy.png")
//                print("the filename", filename)
//                data.writeToFile(filename, atomically: true)
//            }
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        print("new documents directory", documentsDirectory)
        return documentsDirectory
    }
    
    func getImage(filename:String) -> Bool{
        let fileManager = NSFileManager.defaultManager()
        let imagePath = (getDocumentsDirectory() as NSString).stringByAppendingPathComponent(filename)
        if fileManager.fileExistsAtPath(imagePath){
            return true
        } else {
            print("not found")
            return false
        }
    }
    
    func randomFileName() -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            
        let randomString : NSMutableString = NSMutableString(capacity: 12)
            
        for i in 0...12 {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
            }
        print("new random string made", randomString)
        return String(randomString)
    }

    
    func saveNewImage(image: UIImage, filename: String) {
        print("Something happening here")
        print("inside this")
//            let newFileNamePng = newFileName + ".png"
            if let data = UIImagePNGRepresentation(image){
                let filename = getDocumentsDirectory().stringByAppendingPathComponent(filename)
                print("save new image with filename", filename)
                data.writeToFile(filename, atomically: true)
            }
    }
    
    /////////////////////////////////////////////////////KEYBOARD STUFF//////////////////////////////////////////////////////
    
    /*func keyboardWillShow(sender: NSNotification){
        print("current y", self.view.frame.origin.y)
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= 150
        }
    }
    
    func keyboardWillHide(sender: NSNotification){
        self.view.frame.origin.y += 150
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
     */
}
