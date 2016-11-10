//
//  ViewController.swift
//  customCellDemo
//
//  Created by Amy Giver on 9/14/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit
import CoreData


class HomeViewController: UITableViewController, CancelButtonDelegate, MemoryDelegate, FancyCellDelegate {
    var imagesArray = [String]()
    var importantMemory = 0
    var importantImage: UIImage?
    var memories = [Memory]()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllMemories()
    }

   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
       
    func fetchAllMemories(){
        let memoryRequest = NSFetchRequest(entityName: "Memory")
        do {
            let results = try managedObjectContext.executeFetchRequest(memoryRequest)
            memories = results as! [Memory]
        }
        catch {
            print("\(error)")
        }
    }
    

    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        print("Adding!")
        performSegueWithIdentifier("addingSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "addingSegue"{
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ImagePickerController
            controller.cancelButtonDelegate = self
            controller.memoriesDelegate = self
            controller.fileNumber = self.memories.count
        }
        if segue.identifier == "detailsSegue"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! DetailsViewController
            controller.cancelButtonDelegate = self
            controller.memoryToStudy = memories[importantMemory]
            if let impimg = importantImage {
                controller.importantImage = impimg
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memories.count
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fancyCell") as! FancyCell
        let correctString = memories[indexPath.row].fileName!
        if getImage(correctString){
            print("display non snail")
            let cellimage = (getDocumentsDirectory() as NSString).stringByAppendingPathComponent(correctString)
            cell.fancyCellImage.image = UIImage(contentsOfFile: cellimage)
        }
        else {
            cell.fancyCellImage.image = UIImage(named: "snail")

        }

        
        cell.fancyCellImage.contentMode = .ScaleAspectFit

        cell.nameOutlet?.text = memories[indexPath.row].name
        cell.buttonDelegate = self
        cell.index = indexPath.row
        return cell
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
    
    func cancelButtonPressedFrom(controller: UIViewController){
        dismissViewControllerAnimated(true, completion: nil)
        fetchAllMemories()
        tableView.reloadData()
        
    }
    
    //////////////////////////////DELEGATE STUFF //////////////////////////////////////
    
    func descriptionButtonPressedFrom(cell: FancyCell) {
        print("Whoopsie!", cell.nameOutlet.text, cell.index, memories[cell.index])
        importantMemory = cell.index
        importantImage = cell.fancyCellImage.image
        performSegueWithIdentifier("detailsSegue", sender: self)
        
    }
    
    func imagePickerController(controller: ImagePickerController, didFinishWritingMemory memoryName: String, memoryDesc: String, memoryFileName: String){
        dismissViewControllerAnimated(true, completion: nil)
        let entity = NSEntityDescription.entityForName("Memory", inManagedObjectContext: managedObjectContext)
        let newMemory = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        newMemory.setValue(memoryName, forKey: "name")
        newMemory.setValue(memoryDesc, forKey: "desc")
        newMemory.setValue(memoryFileName, forKey: "fileName")
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Success")
            }
            catch {
                print("\(error)")
            }
        }
        fetchAllMemories()
        tableView.reloadData()
    }
    


}

