//
//  LendObjectController.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 13/11/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import Foundation

class LendObjectController {
    
    static func lendobjects(fromJSON userJSON: [String: Any], usingCollection: String) -> [LendObject] {
        var objects: [LendObject] = []
        
        if let lendingJSON = userJSON[usingCollection] as? [[String: Any]] {
            for objectJSON in lendingJSON {
                // Find the owner of the object
                if let ownerJSON = objectJSON["owner"] as? [String: Any],
                    let owner = extractOwnerFromJSON(ownerJSON),
                    let id = objectJSON["_id"] as? String,
                    let waitinglistJSON = objectJSON["waitinglist"] as? [[String: Any]],
                    let waitinglist = extractWaitingListFromJSON(waitinglistJSON),
                    let name = objectJSON["name"] as? String,
                    let description = objectJSON["description"] as? String,
                    let rules = objectJSON["rules"] as? String,
                    let typeString = objectJSON["type"] as? String,
                    let type = extractTypeFromString(typeString) {
                        let newObject = LendObject(id: id, owner: owner, waitinglist: waitinglist, name: name, description: description, type: type, rules: rules)
                        objects.append(newObject)
                }
            }
        }
        
        return objects
    }
    
    private static func extractOwnerFromJSON(_ ownerJSON: [String: Any]) -> ObjectOwner? {
        if let ownerId = ownerJSON["id"] as? String,
            let ownerName = ownerJSON["name"] as? String {
            return ObjectOwner(userId: ownerId, userName: ownerName)
        }
    
        return nil
    }
    
    private static func extractWaitingListFromJSON(_ listJSON: [[String: Any]]) ->
        [ObjectOwner]? {
        if listJSON.isEmpty {
            return []
        }
            
        var waitingList: [ObjectOwner] = []
        for ownerJSON in listJSON {
            if let waitingUser = extractOwnerFromJSON(ownerJSON) {
                waitingList.append(waitingUser)
            }
        }

        return waitingList
    }
    
    private static func extractTypeFromString(_ type: String) -> LendObjectType? {
        switch type {
        case "transport":
            return LendObjectType.Transport
        case "tool":
            return LendObjectType.Tool
        case "service":
            return LendObjectType.Service
        default:
            return nil
        }
    }
}


