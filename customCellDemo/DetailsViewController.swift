//
//  DetailsViewController.swift
//  customCellDemo
//
//  Created by Amy Giver on 9/14/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, CancelButtonDelegate, UpdatingDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    weak var memoryToStudy: Memory?
    weak var cancelButtonDelegate: CancelButtonDelegate?
    weak var importantImage: UIImage?
    var importantImageFile: String?
    
    @IBOutlet weak var imageToStudy: UIImageView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
   
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func updateButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("updatingSegue", sender: self)
        print("updating!")
    }
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "updatingSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ImagePickerController
            controller.cancelButtonDelegate = self
            controller.updatingDelegate = self
            if let impimg = importantImage {
                controller.imageToUpdate = impimg
            }
            if let impmem = memoryToStudy {
                controller.memoryToUpdate = impmem
            }
        }
    }
    
    func cancelButtonPressedFrom(controller: UIViewController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if let memory = memoryToStudy {
            nameLabel.text = memory.name
            descriptionTextView.text = memory.desc
           
        }
        if let impimg = importantImage {
            imageToStudy.image = impimg
        }
        imageToStudy.contentMode = .ScaleAspectFit

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
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    
    func updatingExistingMemory(memory: Memory) {
        
        dismissViewControllerAnimated(true, completion: nil)
        print("in the updating existing memory")
        if managedObjectContext.hasChanges {
            do { try managedObjectContext.save()
                print("success in updating")
            }
            catch {
                print("\(error)")
            }
        }
        nameLabel.text = memory.name
        descriptionTextView.text = memory.desc
        if let correctString = memory.fileName {
            print("the new correct String", correctString)
            imageToStudy.contentMode = .ScaleAspectFit
            if getImage(correctString){
                print("display non snail for update")
                let updatedimage = (getDocumentsDirectory() as NSString).stringByAppendingPathComponent(correctString)
                imageToStudy.image = UIImage(contentsOfFile: updatedimage)
                importantImage = UIImage(contentsOfFile: updatedimage)
            }
            else {
            imageToStudy.image = UIImage(named: "snail")
            }
        }
    }
}

