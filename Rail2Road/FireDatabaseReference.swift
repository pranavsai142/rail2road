//
//  FireDatabaseReference.swift
//  Rail2Road
//
//  Created by Pranav Sai on 4/30/22.
//

import Foundation
import FirebaseDatabase
import MapKit

final class FireDatabaseReference: ObservableObject {
    @Published var database: DatabaseReference = Database.database().reference()
    
    func getReference() -> DatabaseReference {
        return database
    }
    
    func setValue(path: [String], value: Any) {
        let stringPath = path.joined(separator: "/")
        database.child(stringPath).setValue(value)
    }
    func removeValue(path: [String]) {
        let stringPath = path.joined(separator: "/")
        database.child(stringPath).removeValue()
    }
    
    //Finds a value in the database given a path
    //path: path to follow to data
    //key: key of the value being extracted
    //tag: string to save the data under in the dataConglomerate
    //dataConglomerate: dataCongromerate instance to save data
    //path and key values must contain content
    //returns: value as a dictionary under a key. If there are multiple values returns them all
    //in dictionary
    func getValue(path: [String], key: String, tag: String, dataConglomerate: DataConglomerate) -> Bool {
        let stringPath = path.joined(separator: "/")
        let ref = database.child(stringPath)
//        var data: Any?
//        print("Query")
//        print(stringPath)
//        print(key)
        if(dataConglomerate.data[tag] == nil) {
            ref.observeSingleEvent(of: .value, with: { snapshot in
              // This is the snapshot of the data at the moment in the Firebase database
              // To get value from the snapshot, we user snapshot.value
    //            print("INISIDE")
    //            print(snapshot.value!)
    //            print("\(type(of: snapshot.value))")
    //            print(self.data)
                if(snapshot.value! is NSNull) {
                    dataConglomerate.data[tag] = "DNE"
                } else {
                    dataConglomerate.data[tag] = ((snapshot.value) as! NSDictionary)[key]
                }
            })
        }
        return true
    }
    
    //Returns an array of keys under a given path
    //path: path to return keys under
    //tag: string to save data under in dataConglomerate
    //dataConglomerate: dataConglomerate instance
    func getKeys(path: [String], tag: String, dataConglomerate: DataConglomerate) -> Bool {
        let stringPath = path.joined(separator: "/")
        let ref = database.child(stringPath)
//        var data: Any?
//        print(stringPath)
//        print(key)
        if(dataConglomerate.data[tag] == nil) {
            ref.observeSingleEvent(of: .value, with: { snapshot in
              // This is the snapshot of the data at the moment in the Firebase database
              // To get value from the snapshot, we user snapshot.value
                var data = NSArray()
                for snap in snapshot.children {
                    let value = (snap as! DataSnapshot).key
                    data = data.adding(value) as NSArray
                }
                dataConglomerate.data[tag] = data
            })
        }
        return true
    }
    
    //Does the same thing getValue does?
    func getList(path: [String], tag: String, dataConglomerate: DataConglomerate) -> Bool {
        let stringPath = path.joined(separator: "/")
        let ref = database.child(stringPath)
//        var data: Any?
//        print(stringPath)
        if(dataConglomerate.data[tag] == nil) {
            ref.observeSingleEvent(of: .value, with: { snapshot in
              // This is the snapshot of the data at the moment in the Firebase database
              // To get value from the snapshot, we user snapshot.value
//                print("INISIDE")
//                print(values)
//                print("\(type(of: values))")
                if(snapshot.value! is NSNull) {
                    dataConglomerate.data[tag] = "DNE"
                }
                else {
                    dataConglomerate.data[tag] = (snapshot.value) as! NSDictionary
                }
            })
        }
        return true
    }
    
    
    //Query functions search for a value in child nodes (not grandchild or greatgrandchild nodes) of all nodes at given path.
    //ex:
//    cats {
//        3241knkl2 {
//            name: "jeff"
//            age: "200"
//        }
//        9205h3n {
//            name: "meep"
//            age: "13"
//        }
//    }
// to get cat(s) [multiple returns not implemented]
// queryDatabaseByString(["cats"], "name", "jeff", "query_jeff_found", "cat_data", dataConglomerate)
    func queryDatabaseByString(path: [String], child: String, query: String, foundTag: String, tag: String, dataConglomerate: DataConglomerate) -> Bool {
        var ref = database
        if(path.count > 0) {
            let stringPath = path.joined(separator: "/")
            ref = database.child(stringPath)
        }
        ref.queryOrdered(byChild: child).queryEqual(toValue: query).observeSingleEvent(of: .value, with: { snapshot in
            if let snapVal = snapshot.value as? NSDictionary {
                dataConglomerate.query[foundTag] = true
                print(type(of: snapVal))
                dataConglomerate.query[tag] = snapVal
            }
            //Return value does not match structure of Dictionary or is null
            else {
                dataConglomerate.query[foundTag] = false
                dataConglomerate.query[tag] = false
            }
        })
        return true
    }
    
    func queryDatabaseByRegion(path: [String], child: String, region: MKCoordinateRegion, foundTag: String, tag: String, dataConglomerate: DataConglomerate) -> Bool {
        var ref = database
        if(!path.isEmpty) {
            let stringPath = path.joined(separator: "/")
            ref  = database.child(stringPath)
        }
        //If map region is wrapping around to negative values of longitude
        if(region.center.longitude + (region.span.longitudeDelta/2) > 180.0) {
            ref.queryOrdered(byChild: child).queryStarting(atValue: region.center.longitude - (region.span.longitudeDelta/2)).queryEnding(atValue: 180.0).observeSingleEvent(of: .value, with: { snapshot in
                if let snapVal = snapshot.value as? NSDictionary {
                    dataConglomerate.query[foundTag] = true
                    dataConglomerate.query[tag] = snapVal
                }
                else {
                    dataConglomerate.query[foundTag] = false
                    dataConglomerate.query[tag] = false
                }
            })
            
//            ref.queryOrdered(byChild: child).queryStarting(atValue: -180.0).queryEnding(atValue: -180.0 + (region.center.longitude + region.span.longitudeDelta - 180)).observeSingleEvent(of: .value, with: { snapshot in
//                if let snapVal = snapshot.value as? NSArray {
//                    dataConglomerate.query[foundTag] = true
//                    var authorUUID = ""
//                    for snap in snapshot.children {
//                        authorUUID = (snap as! DataSnapshot).key
//                    }
//                    let authorData = NSArray(array: [authorUUID]).addingObjects(from: [snapVal[1]])
//                    dataConglomerate.query[tag] = (dataConglomerate.query[tag] as! NSArray).addingObjects(from: authorData) as [Any]
//                }
//                else if let snapVal = snapshot.value as? NSDictionary {
//                    dataConglomerate.query[foundTag] = true
//                    dataConglomerate.query[tag] = dataConglomerate.query[tag]
//                }
//                else {
//                    dataConglomerate.query[foundTag] = false
//                    dataConglomerate.query[tag] = false
//                }
        //            for snap in snapshot.children {
        //                print((snap as! DataSnapshot).key)
        //            }
//            })
        }
        //If map region is mapping around to positive values of longitude
        else if(region.center.longitude - region.span.longitudeDelta < -180.0) {
            print("hit2")
        }
        else {
            print("hit")
            ref.queryOrdered(byChild: child).queryStarting(atValue: -180.0).queryEnding(atValue: -110.0).observeSingleEvent(of: .value, with: { snapshot in
                print("snapshot", snapshot)
                if let snapVal = snapshot.value as? NSArray {
                    dataConglomerate.query[foundTag] = true
                    let authorData = NSArray().addingObjects(from: [snapVal[1]])
                    dataConglomerate.query[tag] = authorData
                }
                else if let snapVal = snapshot.value as? NSDictionary {
                    print(type(of: snapVal))
                    dataConglomerate.query[foundTag] = true
                    NSMutableDictionary(dictionary: snapVal)
                    dataConglomerate.query[tag] = snapVal
                }
                else {
                    dataConglomerate.query[foundTag] = false
                    dataConglomerate.query[tag] = false
                }
                for snap in snapshot.children {
                    print((snap as! DataSnapshot).key)
                }
            })
//            ref.queryOrdered(byChild: child).observeSingleEvent(of: .value, with: { snapshot in
//                if let snapVal = snapshot.value as? NSArray {
//                    dataConglomerate.query[foundTag] = true
//                    var authorUUID = ""
//                    for snap in snapshot.children {
//                        authorUUID = (snap as! DataSnapshot).key
//                    }
//                    let authorData = NSArray(array: [authorUUID]).addingObjects(from: [snapVal[1]])
//                    dataConglomerate.query[tag] = authorData
//                }
//                else if let snapVal = snapshot.value as? NSDictionary {
//                    dataConglomerate.query[foundTag] = true
//                    dataConglomerate.query[tag] = snapVal
//                }
//                else {
//                    dataConglomerate.query[foundTag] = false
//                    dataConglomerate.query[tag] = false
//                }
//                for snap in snapshot.children {
//                    print((snap as! DataSnapshot).key)
//                }
//            })
        }
//
//        ref.queryOrdered(byChild: child).queryStarting(atValue: lowerBound).queryEnding(beforeValue: upperBound).observeSingleEvent(of: .value, with: { snapshot in
//            if let snapVal = snapshot.value as? NSArray {
//    //                print("cauht array")
//                dataConglomerate.query[foundTag] = true
//                var authorUUID = ""
//                //There is only one snap. This loop is for when trying to show multiple values.
//                for snap in snapshot.children {
//                    authorUUID = (snap as! DataSnapshot).key
//                }
//    //                print("found tag", foundTag)
//    //                print("AUTHOr UUID", authorUUID)
//    //                print("snapVAl", snapVal[1])
//                let authorData = NSArray(array: [authorUUID]).addingObjects(from: [snapVal[1]])
//    //                print("AUTHOr DATA", authorData)
//                dataConglomerate.query[tag] = authorData
//            }
//            else if let snapVal = snapshot.value as? NSDictionary {
//    //                print("cauht dictionary")
//                dataConglomerate.query[foundTag] = true
//    //                print("found tag", foundTag)
//                dataConglomerate.query[tag] = snapVal
//            }
//            else {
//    //                print("NO DICE")
//                dataConglomerate.query[foundTag] = false
//                dataConglomerate.query[tag] = false
//            }
//    //            for snap in snapshot.children {
//    //                print((snap as! DataSnapshot).key)
//    //            }
//        })
        return true
    }
    
    func queryDatabaseByValueInRange(path: [String], child: String, key: String, lowerBound: Double, upperBound: Double, foundTag: String, tag: String, dataConglomerate: DataConglomerate) -> Bool {
//        var ref = database
//        if(!path.isEmpty) {
//            let stringPath = path.joined(separator: "/")
//            ref  = database.child(stringPath)
//        }
//        ref.queryOrdered(byChild: child).queryStarting(atValue: lowerBound).queryEnding(beforeValue: upperBound).observeSingleEvent(of: .value, with: { snapshot in
//            if let snapVal = snapshot.value as? NSArray {
////                print("cauht array")
//                dataConglomerate.query[foundTag] = true
//                var authorUUID = ""
//                //There is only one snap. This loop is for when trying to show multiple values.
//                for snap in snapshot.children {
//                    authorUUID = (snap as! DataSnapshot).key
//                }
////                print("found tag", foundTag)
////                print("AUTHOr UUID", authorUUID)
////                print("snapVAl", snapVal[1])
//                let authorData = NSArray(array: [authorUUID]).addingObjects(from: [snapVal[1]])
////                print("AUTHOr DATA", authorData)
//                dataConglomerate.query[tag] = authorData
//            }
//            else if let snapVal = snapshot.value as? NSDictionary {
////                print("cauht dictionary")
//                dataConglomerate.query[foundTag] = true
////                print("found tag", foundTag)
//                dataConglomerate.query[tag] = snapVal
//            }
//            else {
////                print("NO DICE")
//                dataConglomerate.query[foundTag] = false
//                dataConglomerate.query[tag] = false
//            }
////            for snap in snapshot.children {
////                print((snap as! DataSnapshot).key)
////            }
//        })
        return true
    }
}
