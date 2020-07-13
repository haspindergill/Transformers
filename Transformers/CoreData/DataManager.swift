//
//  DataManager.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-10.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataManager {

    static let sharedInstance = DataManager()
    
    func storeTransformerInDatabase(transformers: [Transformer]) {
        for item in transformers {
            let mirror = Mirror(reflecting: item)
            let managedObject = NSEntityDescription.insertNewObject(forEntityName: "TransformerModel", into: DatabaseHelper.getContext())
            for case let (label?, anyValue) in mirror.children {
                managedObject.setValue(anyValue, forKey: label)
            }
        }
        DatabaseHelper.saveContext()
    }
    
    
    func getListOfTransformers() -> [Transformer] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TransformerModel")
        var transformers = [Transformer]()
        do {
            let searchResults = try DatabaseHelper.getContext().fetch(request)
            for result in (searchResults as? [TransformerModel] ?? []) {
                let invade = result.convertToModel()
                transformers.append(invade)
            }
    

        } catch {
            print ("error: \(error)")
        }
        return transformers
    }
    
    func deleteTransformer(withID: String) {
        let fetchRequest: NSFetchRequest<TransformerModel> = TransformerModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", withID)
        do {
            let result = try DatabaseHelper.getContext().fetch(fetchRequest)
            for object in result {
                DatabaseHelper.getContext().delete(object)
                try DatabaseHelper.getContext().save()
            }
        } catch {
            print ("error: \(error)")
        }
    }
    
    func updateTransformer(transformer: Transformer) {
        let fetchRequest: NSFetchRequest<TransformerModel> = TransformerModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", transformer.id)
        do {
            let result = try DatabaseHelper.getContext().fetch(fetchRequest)
            for object in result {
                let mirror = Mirror(reflecting: object)
                for case let (label?, anyValue) in mirror.children {
                    object.setValue(anyValue, forKey: label)
                }
                DatabaseHelper.saveContext()
            }
        } catch {
            print ("error: \(error)")
        }
    }
    
}

extension TransformerModel {
    
    func convertToModel() -> Transformer {
        return Transformer(courage: Int(self.courage),
                           endurance: Int(self.endurance),
                           firepower: Int(self.firepower),
                           id: self.id ?? "",
                           intelligence: Int(self.intelligence),
                           rank: Int(self.rank),
                           skill: Int(self.skill),
                           speed: Int(self.speed),
                           strength: Int(self.strength),
                           team: self.team ?? "",
                           name: self.name ?? "",
                           teamIcon: self.teamIcon ?? "")
    }
}
