//
//  CloudKitHelper.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/25/22.
//

import Foundation
import CloudKit

final class CloudKitHelper {
    func checkAccountStatus() async throws -> CKAccountStatus {
        try await CKContainer.default().accountStatus()
    }
    
    func fetchUser() async throws -> CKUserIdentity? {
        let userID: CKRecord.ID = try await CKContainer.default().userRecordID()
        let user = try await CKContainer.default().userIdentity(forUserRecordID: userID)
        return user
    }
    
}
