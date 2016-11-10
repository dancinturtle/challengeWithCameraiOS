//
//  Memory+CoreDataProperties.swift
//  customCellDemo
//
//  Created by Amy Giver on 9/15/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Memory {

    @NSManaged var desc: String?
    @NSManaged var name: String?
    @NSManaged var fileName: String?

}
