//
//  RealmManager.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/25/22.
//

import Foundation
import RealmSwift

@MainActor
class RealmManager: ObservableObject {
    let config = Realm.Configuration(schemaVersion: 0, deleteRealmIfMigrationNeeded: true)
    var objectNotificationToken: NotificationToken?
    @Published var weeks: [RMWeek] = [RMWeek]()

    init() {
        Task {
            await fetchWeeks()
        }
    }
    
    deinit {
        if let objectNotificationToken = self.objectNotificationToken {
            objectNotificationToken.invalidate()
        }
    }
    
    
    func save(object: Object) async throws {
        if let realm = object.realm, !object.isInvalidated {
            try realm.write {
                realm.add(object)
                realm.refresh()
            }
        }
    }

    
    // MARK: - Work With Objects
    func resetAll() async throws {
            let realm = try await Realm(configuration: config)
            try realm.write {
                realm.deleteAll()
            }
        }

    func delete(object: Object) throws {
        if let realm = object.realm, !object.isInvalidated {
            try realm.write {
                realm.delete(object)
                realm.refresh()
            }
        }
    }

    

    func fetchWeeks() async {
        do {
            let realm = try await Realm(configuration: config)

            let allWeeks = realm.objects(RMWeek.self)
            self.weeks = allWeeks.map { $0 }
            self.objectNotificationToken = allWeeks.observe { change in
                switch change {
                case .update(let results, _, _, _):
                    self.weeks = results.map { $0 }
                case .error(let error):
                    print(error.localizedDescription)
                case .initial(let results):
                    self.weeks = results.map { $0 }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
