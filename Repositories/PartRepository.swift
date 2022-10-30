//
//  PartRepository.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/11/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

@MainActor
final class PartRepository: ObservableObject {
    private var firestore = Firestore.firestore()
    private var encoder = Firestore.Encoder()
    private var decoder = Firestore.Decoder()
    @Published var parts = [ABPart]()
    @Published var chairmans = [ABPart]()
    @Published var treasures = [ABPart]()
    @Published var life = [ABPart]()
    @Published var apply = [ABPart]()
    @Published var prayers = [ABPart]()
    @Published var talk = [ABPart]()
    @Published var watchtower = [ABPart]()
    @Published var secondary = [ABPart]()
    @Published var updateError: String?
    
    var listener: ListenerRegistration?
    
    deinit {
        if let listener {
            listener.remove()
        }
    }
    
    func loadParts(_ week: String, congregation: String) {
        self.listener = firestore.collection("congregations/\(congregation)/weeks/\(week)/parts")
            .addSnapshotListener { querySnapshot, error in

                if let querySnapshot {
                    do {
                        let parts: [ABPart] = try querySnapshot.documents.map { try $0.data(as: ABPart.self) }
                        let (prayers, chairmans, treasures, apply, living, watchtower, talk, secondary) =  self.parseParts(parts)
                            self.prayers = prayers
                            self.chairmans = chairmans
                            self.treasures = treasures
                            self.apply = apply
                            self.life = living
                            self.watchtower = watchtower
                            self.talk = talk
                            self.secondary = secondary
                    } catch {
                        print(error.localizedDescription)
                    }
            }
        }
    }
    
    func parseParts(_ weekParts: [ABPart]) -> (prayers: [ABPart], chairmans: [ABPart], treasures: [ABPart], apply: [ABPart], living: [ABPart], watchtower: [ABPart], talk: [ABPart], secondary: [ABPart]) {
           
           var _prayers: [ABPart] {
               var parts = weekParts
               if parts.count > 0 {
                   parts = parts.filter({ part in
                    return part.parent == "prayer"
                   })
                   parts.sort { (a, b) in
                    return a.index! < b.index!
                   }
               }
               return parts
           }
           
           var _chairmans: [ABPart] {
               var parts = weekParts
               if parts.count > 0 {
                   parts = parts.filter({ part in
                    return part.parent == "chairman"
                   })
                   parts.sort { (a, b) in
                    return a.index! < b.index!
                   }
               }
               return parts
           }
        
        var _secondary: [ABPart] {
            var parts = weekParts
            if parts.count > 0 {
                parts = parts.filter({ part in
                 return part.parent == "secondary"
                })
                parts.sort { (a, b) in
                 return a.index! < b.index!
                }
            }
            return parts
        }
           
           
           var _talk: [ABPart] {
               var parts = weekParts
               if parts.count > 0 {
                   parts = parts.filter({ part in
                       return part.parent == "talk"
                   })
                   parts.sort { (a, b) in
                       return a.index! < b.index!
                   }
               }
               return parts
           }


           var _watchtower: [ABPart] {
               var parts = weekParts
               if parts.count > 0 {
                   parts = parts.filter({ part in
                       return part.parent == "watchtower"
                   })
                   parts.sort { (a, b) in
                       return a.index! < b.index!
                   }
               }
            return parts
           }
           
           var _treasures : [ABPart] {
               var parts = weekParts
               if parts.count > 0 {
                   parts = parts.filter({ part in
                       return part.parent == "treasures"
                   })
                   parts.sort { (a, b) in
                       return a.index! < b.index!
                   }
               }
               return parts
           }
           
           var _apply : [ABPart] {
               var parts = weekParts
               if parts.count > 0 {
                   parts = parts.filter({ part in
                       return part.parent == "apply"
                   })
                   parts.sort { (a, b) in
                       return a.index! < b.index!
                   }
               }
               return parts
           }
           
           var _living : [ABPart] {
               var parts = weekParts
               if parts.count > 0 {
                   parts = parts.filter({ part in
                       return part.parent == "life"
                   })
                   parts.sort { (a, b) in
                       return a.index! < b.index!
                   }
               }
               return parts
           }
        return (_prayers, _chairmans, _treasures, _apply, _living, _watchtower, _talk, _secondary)
       }
    
 
    
  
}
