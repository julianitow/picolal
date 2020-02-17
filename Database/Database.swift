//
//  Database.swift
//  partyRules
//
//  Created by Julien Guillan on 08/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation
import SQLite3
import os.log

/*class Database {
    let dbURL: URL
    var db: OpaquePointer?
    
    //Prepared sql statements to prevent sql injection
    var insertEntryStmt: OpaquePointer?
    var readEntryStmt: OpaquePointer?
    var updateEntryStmt: OpaquePointer?
    var deleteEntryStmt: OpaquePointer?
    
    let oslog = OSLog(subsystem: "codewithayush", category: "sqliteUsersPartyRules")

    init() {
        do{
            do {
                self.dbURL = try FileManager.default
                    .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("users.db")
                
            } catch {
                print("An error occured when creating DB")
                self.dbURL = URL(fileURLWithPath: "")
                return
            }
            try openDB()
            try createTables()
        } catch {
            logDbErr("An error occured !")
            return
        }
    }
    
    func openDB() throws {
        if sqlite3_open(dbURL.path, &db) != SQLITE_OK {
            throw SqliteError(message: "Error opening database \(dbURL.absoluteString)")
        }
    }
    
    func createTables() throws {
        let ret =  sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Users (id INTEGER UNIQUE PRIMARY KEY, Name TEXT NOT NULL, Email TEXT UNIQUE NOT NULL)", nil, nil, nil)
        if (ret != SQLITE_OK) { // corrupt database.
            throw SqliteError(message: "unable to create table Users")
        }
    }
    
    // INSERT/CREATE operation prepared statement
    func prepareInsertEntryStmt() -> Int {
        guard insertEntryStmt == nil else { return SQLITE_OK }
        let sql = "INSERT INTO Users (id, Name, Email) VALUES (?,?,?)"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &insertEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare insertEntryStmt \(r)")
        }
        return r
    }
    
    
    //"INSERT INTO Users (Name, EmployeeID, Designation) VALUES (?,?)"
    func create(user: User) {
        // ensure statements are created on first usage if nil
        guard self.prepareInsertEntryStmt() == SQLITE_OK else { return }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.insertEntryStmt)
        }
        
        //  At some places (esp sqlite3_bind_xxx functions), we typecast String to NSString and then convert to char*,
        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift's sqlite3 bridging. this conversion resolves it.
        
        //Inserting id in insertEntryStmt prepared statement
        if sqlite3_bind_int64(self.insertEntryStmt, 1, Int64(user.id)) != SQLITE_OK {
            logDbErr("sqlite3_bind_int64(insertEntryStmt)")
            return
        }
        
        //Inserting name in insertEntryStmt prepared statement
        if sqlite3_bind_text(self.insertEntryStmt, 1, (user.name as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        
        //Inserting employeeID in insertEntryStmt prepared statement
        if sqlite3_bind_text(self.insertEntryStmt, 2, (user.email as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(insertEntryStmt)")
            return
        }
        
        //executing the query to insert values
        let r = sqlite3_step(self.insertEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(insertEntryStmt) \(r)")
            return
        }
    }
    
    //"SELECT * FROM Users WHERE Id = ? LIMIT 1"
    func read(id: Int) throws -> User {
        // ensure statements are created on first usage if nil
        guard self.prepareReadEntryStmt() == SQLITE_OK else { throw SqliteError(message: "Error in prepareReadEntryStmt") }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.readEntryStmt)
        }
        
        //  At some places (esp sqlite3_bind_xxx functions), we typecast String to NSString and then convert to char*,
        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift's sqlite3 bridging. this conversion resolves it.
        
        //Inserting UserId in readEntryStmt prepared statement
        if sqlite3_bind_text(self.readEntryStmt, 1, (String(id) as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(readEntryStmt)")
            throw SqliteError(message: "Error in inserting value in prepareReadEntryStmt")
        }
        
        //executing the query to read value
        if sqlite3_step(readEntryStmt) != SQLITE_ROW {
            logDbErr("sqlite3_step COUNT* readEntryStmt:")
            throw SqliteError(message: "Error in executing read statement")
        }
        
        return User(id: Int(String(cString: sqlite3_column_text(readEntryStmt, 2)))!, name: String(cString: sqlite3_column_text(readEntryStmt, 2)),
                      email: String(cString: sqlite3_column_text(readEntryStmt, 3)))
    }
    
    //"UPDATE Users SET Name = ?, Designation = ? WHERE EmployeeID = ?"
    func update(user: User) {
        // ensure statements are created on first usage if nil
        guard self.prepareUpdateEntryStmt() == SQLITE_OK else { return }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.updateEntryStmt)
        }
        
        //  At some places (esp sqlite3_bind_xxx functions), we typecast String to NSString and then convert to char*,
        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift's sqlite3 bridging. this conversion resolves it.
        
        //Inserting name in updateEntryStmt prepared statement
        if sqlite3_bind_text(self.updateEntryStmt, 1, (user.name as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(updateEntryStmt)")
            return
        }
        
        //Inserting Username in updateEntryStmt prepared statement
        if sqlite3_bind_text(self.updateEntryStmt, 3, (user.email as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(updateEntryStmt)")
            return
        }
        
        //executing the query to update values
        let r = sqlite3_step(self.updateEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(updateEntryStmt) \(r)")
            return
        }
    }
    
    //"DELETE FROM Users WHERE EmployeeID = ?"
    func delete(email: String) {
        // ensure statements are created on first usage if nil
        guard self.prepareDeleteEntryStmt() == SQLITE_OK else { return }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_reset(self.deleteEntryStmt)
        }
        
        //  At some places (esp sqlite3_bind_xxx functions), we typecast String to NSString and then convert to char*,
        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift's sqlite3 bridging. this conversion resolves it.
        
        //Inserting name in deleteEntryStmt prepared statement
        if sqlite3_bind_text(self.deleteEntryStmt, 1, (email as NSString).utf8String, -1, nil) != SQLITE_OK {
            logDbErr("sqlite3_bind_text(deleteEntryStmt)")
            return
        }
        
        //executing the query to delete row
        let r = sqlite3_step(self.deleteEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(deleteEntryStmt) \(r)")
            return
        }
    }
    
    // READ operation prepared statement
    func prepareReadEntryStmt() -> Int32 {
        guard readEntryStmt == nil else { return SQLITE_OK }
        let sql = "SELECT * FROM Users WHERE Email = ? LIMIT 1"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &readEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare readEntryStmt")
        }
        return r
    }
    
    // UPDATE operation prepared statement
    func prepareUpdateEntryStmt() -> Int32 {
        guard updateEntryStmt == nil else { return SQLITE_OK }
        let sql = "UPDATE Users SET Name = ?, Email = ? WHERE Email = ?"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &updateEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare updateEntryStmt")
        }
        return r
    }
    
    // DELETE operation prepared statement
    func prepareDeleteEntryStmt() -> Int32 {
        guard deleteEntryStmt == nil else { return SQLITE_OK }
        let sql = "DELETE FROM Users WHERE Email = ?"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &deleteEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare deleteEntryStmt")
        }
        return r
    }
    
    func logDbErr(_ msg: String) {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        os_log("ERROR %s : %s", log: oslog, type: .error, msg, errmsg)
    }
}

class SqliteError : Error {
    var message = ""
    var error = SQLITE_ERROR
    init(message: String = "") {
        self.message = message
    }
    init(error: Int32) {
        self.error = error
    }
}*/
