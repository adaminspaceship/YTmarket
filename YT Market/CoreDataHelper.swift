//
//  CoreDataHelper.swift
//  YT-Market
//
//  Created by Adam Eliezerov on 16/08/2018.
//  Copyright © 2018 adameliezerov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct CoreDataHelper {
    
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newChannel() -> Channel {
        let exercise = NSEntityDescription.insertNewObject(forEntityName: "Channel", into: context) as! Channel
        return exercise
    }
    
    static func retrieveChannel() -> [Channel] {
        do {
            let fetchRequest = NSFetchRequest<Channel>(entityName: "Channel")
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return []
        }
    }
    static func saveChannel() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    static func delete(channel: Channel) {
        context.delete(channel)
        
        saveChannel()
    }
    
}
