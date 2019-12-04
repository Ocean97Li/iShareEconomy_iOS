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
                if let newObject = lendObject(fromJSON:  objectJSON) {
                    objects.append(newObject)
                }
            }
        }
        
        return objects
    }
    
    static func lendObject(fromJSON objectJSON: [String: Any]) -> LendObject? {
        if let ownerJSON = objectJSON["owner"] as? [String: Any],
            let owner = extractObjectOwnerFromJSON(ownerJSON),
            let id = objectJSON["_id"] as? String,
            let waitinglistJSON = objectJSON["waitinglist"] as? [[String: Any]],
            let waitinglist = extractWaitingListFromJSON(waitinglistJSON),
            let name = objectJSON["name"] as? String,
            let description = objectJSON["description"] as? String,
            let typeString = objectJSON["type"] as? String,
            let type = extractTypeFromString(typeString) {
                let rules = objectJSON["rules"] as? String ?? ""
                var currentUser: ObjectUser? = nil
                
                if let currentUserJSON = objectJSON["user"] as? [String: Any] {
                    currentUser = extractObjectUserFromJSON(currentUserJSON)
                }
                let newObject = LendObject(id: id, owner: owner, waitinglist: waitinglist, currentUser: currentUser, name: name, description: description, type: type, rules: rules)
        
               return newObject
        }
        
        return nil
    }
    
    public static func extractObjectOwnerFromJSON(_ ownerJSON: [String: Any]) -> ObjectOwner? {
        if let ownerId = ownerJSON["id"] as? String,
            let ownerName = ownerJSON["name"] as? String {
            return ObjectOwner(userId: ownerId, userName: ownerName)
        }
    
        return nil
    }
    
    private static func extractObjectUserFromJSON(_ ownerJSON: [String: Any]) -> ObjectUser? {
        if let ownerId = ownerJSON["id"] as? String,
            let ownerName = ownerJSON["name"] as? String,
            let stringFromDate = ownerJSON["fromdate"] as? String,
            let stringToDate = ownerJSON["todate"] as? String,
            let fromDate = Date.fromUTCString(stringFromDate),
            let toDate = Date.fromUTCString(stringToDate) {
            return ObjectUser(userId: ownerId, userName: ownerName, fromDate: fromDate, toDate: toDate)
        }
        return nil
    }
    
    private static func extractWaitingListFromJSON(_ listJSON: [[String: Any]]) ->
        [ObjectUser]? {
        if listJSON.isEmpty {
            return []
        }
            
        var waitingList: [ObjectUser] = []
        for userJSON in listJSON {
            if let waitingUser = extractObjectUserFromJSON(userJSON) {
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


