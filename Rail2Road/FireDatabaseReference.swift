//
//  FireDatabaseReference.swift
//  Rail2Road
//
//  Created by Pranav Sai on 4/30/22.
//

import Foundation
import FirebaseDatabase
import MapKit

/// Retrieve and Insert data into a Firebase Realtime Database
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
        if(dataConglomerate.data[tag] == nil && dataConglomerate.queries[tag] == nil) {
            dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.searching
            ref.observeSingleEvent(of: .value, with: { snapshot in
              // This is the snapshot of the data at the moment in the Firebase database
              // To get value from the snapshot, we user snapshot.value
    //            print("INISIDE")
    //            print(snapshot.value!)
    //            print("\(type(of: snapshot.value))")
    //            print(self.data)
                if(snapshot.value! is NSNull) {
                    dataConglomerate.data[tag] = "DNE"
                    dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.empty
                } else {
                    dataConglomerate.data[tag] = ((snapshot.value) as! NSDictionary)[key]
                    dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.result
                }
            })
        }
        return true
    }
    
    func getValues(path: [String], tag: String, dataConglomerate: DataConglomerate) -> Bool {
        let stringPath = path.joined(separator: "/")
        let ref = database.child(stringPath)
//        var data: Any?
//        print(stringPath)
//        print(key)
        if(dataConglomerate.data[tag] == nil && dataConglomerate.queries[tag] == nil) {
            dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.searching
            ref.observeSingleEvent(of: .value, with: { snapshot in
              // This is the snapshot of the data at the moment in the Firebase database
              // To get value from the snapshot, we user snapshot.value
                var data = NSArray()
                for snap in snapshot.children {
                    let value = (snap as! DataSnapshot).key
                    data = data.adding(value) as NSArray
                }
                dataConglomerate.data[tag] = data
                dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.result
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
        if(dataConglomerate.data[tag] == nil && dataConglomerate.queries[tag] == nil) {
            dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.searching
            ref.observeSingleEvent(of: .value, with: { snapshot in
              // This is the snapshot of the data at the moment in the Firebase database
              // To get value from the snapshot, we use snapshot.value
                var data = NSArray()
                //Implement handling of data types that are not an NSArray
                for snap in snapshot.children {
                    let value = (snap as! DataSnapshot).key
                    data = data.adding(value) as NSArray
                }
                dataConglomerate.data[tag] = data
                dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.result
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
        if(dataConglomerate.data[tag] == nil && dataConglomerate.queries[tag] == nil) {
            dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.searching
            ref.observeSingleEvent(of: .value, with: { snapshot in
              // This is the snapshot of the data at the moment in the Firebase database
              // To get value from the snapshot, we user snapshot.value
//                print("INISIDE")
//                print(values)
//                print("\(type(of: values))")
                if(snapshot.value! is NSNull) {
                    dataConglomerate.data[tag] = "DNE"
                    dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.empty
                } else if(snapshot.value! is NSDictionary) {
                    dataConglomerate.data[tag] = (snapshot.value) as! NSDictionary
                    dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.result
                } else {
                    dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.error
                }
            })
        }
        return true
    }
    
//    database.getRailyard(id: id, tag: railyardTag, dataConglomerate: dataConglomerate)
    func getRailyard(id: String, tag: String, dataConglomerate: DataConglomerate) -> Bool {
        var ref = database
        let path = ["railyards"]
        if(!path.isEmpty) {
            let stringPath = path.joined(separator: "/")
            ref  = database.child(stringPath)
        }
        if(dataConglomerate.favoriteRailyards.isEmpty && dataConglomerate.queries[tag] == nil) {
            dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.searching
            ref.queryOrderedByKey()
                .queryEqual(toValue: id)
                .observeSingleEvent(of: .value, with: { snapshot in
                if let snapVal = snapshot.value as? NSDictionary {
                    let railyardDictionary = snapVal.value(forKey: id) as! NSDictionary
    //                    print("adding " + (railyardDictionary["name"] as! String))
                    let railyardUid = UUID(uuidString: id)!
                    let railyard = Railyard(id: railyardUid, dictionary: railyardDictionary)
                        
//                    print("\n\n")
//                    print("starting at value")
//                    print(railyard)
//                    print("ending at value")
                    if(!dataConglomerate.favoriteRailyards.contains(railyard)) {
                        dataConglomerate.favoriteRailyards.append(railyard)
                    }
                    dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.result
                }
                else {
                    if(snapshot.exists()) {
//                        print("\n\n")
//                        print("starting at value")
//                        print("Not dictionary type")
//                        print("ending at value")
                        dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.error
                    } else {
                        dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.empty
    //                        print("\n\n")
    //                        print("starting at value", queryTags.getLeftBound())
    //                        print("No values found")
    //                        print("ending at value", queryTags.getRightBound())
                    }
                }
            })
        }
        return true;
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
// _ = database.queryDatabaseByString(path: ["railyards"], child: "name", query: "test", foundTag: queryFoundTag, tag: railyardsTag, dataConglomerate: dataConglomerate)
    func queryDatabaseByString(path: [String], child: String, query: String, tag: String, dataConglomerate: DataConglomerate) -> Bool {
        var ref = database
        if(path.count > 0) {
            let stringPath = path.joined(separator: "/")
            ref = database.child(stringPath)
        }
        if(dataConglomerate.data[tag] == nil && dataConglomerate.queries[tag] == nil) {
            dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.searching
            ref.queryOrdered(byChild: child).queryEqual(toValue: query).observeSingleEvent(of: .value, with: { snapshot in
                if let snapVal = snapshot.value as? NSDictionary {
//                    print(type(of: snapVal))
                    dataConglomerate.data[tag] = snapVal[query]
                    dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.result
                }
                //Return value does not match structure of Dictionary or is null
                else {
                    dataConglomerate.queries[tag] = DataConglomerate.QueryStatus.empty
                }
            })
        }
        return true
    }
    
    
    //Utlized RailroadRegionQueryTags to sort railyards by latlong lexographically. Uses latlongMinBound and latlongMaxBound with a delta of 2°*2°
    /// Queries the database with respect to latitude and longitude values. Retrives all railyards within the railyard region's longitude bounds. Saves the longitude query into DataConglomerate's SavedRailyards
    /// - Parameters:
    ///   - path: What child to navigate to before beginning the query
    ///   - queryTags: Instance of RailroadRegionQueryTags utlizing protocol QueryTags containing latitude and longitude data.
    ///   - dataConglomerate: An Instance of DataConglomerate
    /// - Returns: WIP True if query published
    func queryDatabaseByRegion(path: [String], queryTags: LongitudeRegionQueryTags, dataConglomerate: DataConglomerate) -> Bool {
        var ref = database
        if(!path.isEmpty) {
            let stringPath = path.joined(separator: "/")
            ref  = database.child(stringPath)
        }
        if(dataConglomerate.storedUserLongitudeRegions[queryTags.longitudeRegion] == nil) {
            ref.queryOrdered(byChild: "longitude")
                .queryStarting(atValue: queryTags.getLeftBound())
                .queryEnding(beforeValue: queryTags.getRightBound())
                .observeSingleEvent(of: .value, with: { snapshot in
                if let snapVal = snapshot.value as? NSDictionary {
                    var railyards: [Railyard] = []
                    let railyardUids = snapVal.allKeys
                    for railyardUid in railyardUids {
                        let railyardDictionary = snapVal.value(forKey: (railyardUid as! String)) as! NSDictionary
    //                    print("adding " + (railyardDictionary["name"] as! String))
                        let railyardUid = UUID(uuidString: railyardUid as! String)!
                        railyards.append(Railyard(id: railyardUid, dictionary: railyardDictionary))
                        
                    }
//                    print("\n\n")
//                    print("starting at value", queryTags.getLeftBound())
//                    print(railyards)
//                    print("ending at value", queryTags.getRightBound())
                    railyards.sort()
                    dataConglomerate.storedUserLongitudeRegions[queryTags.longitudeRegion] = railyards
                }
                else {
                    if(snapshot.exists()) {
//                        print("\n\n")
//                        print("starting at value", queryTags.getLeftBound())
//                        print("Not dictionary type")
//                        print("ending at value", queryTags.getRightBound())
                    } else {
//                        print("\n\n")
//                        print("starting at value", queryTags.getLeftBound())
//                        print("No values found")
//                        print("ending at value", queryTags.getRightBound())
                    }
                }
            })
        }
        return true;
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
