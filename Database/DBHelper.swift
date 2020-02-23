//
//  DBHelper.swift
//  partyRules
//
//  Created by Salayna Doukoure on 21/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//
import Foundation
import SQLite3
import os.log

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "partyRule.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }


    /**
            This function will create the table after checking if the table exists
            - Throws:"user table could not be created."
                     if sqlite3_step is different from "SQLITE_DONE"
                     "CREATE TABLE statement could not be prepared."
                     if sqlite3_prepare_v2 is different from "SQLITE_OK"
            - Returns: None
     */
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS user(Id INTEGER PRIMARY KEY,name TEXT,mail TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("user table created.")
            } else {
                print("user table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }


    /**
           This function will add entries in the database
           - Throws:"Could not insert row."
                    if sqlite3_step is different from "SQLITE_DONE"
                    "CREATE TABLE statement could not be prepared."
                    if sqlite3_prepare_v2 is different from "SQLITE_OK"
           - Returns: None
    */
    func insert(id:Int, name:String, mail:String)
    {
        let users = readAll()
        for u in users
        {
            if u.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO user (Id, name, mail) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (mail as NSString).utf8String, -1, nil)

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }



    /**
           This Function will read all the Entries in the database
     
           - Throws:"CREATE TABLE statement could not be prepared."
                    if sqlite3_prepare_v2 is different from "SQLITE_OK"
           - Returns: A User table
    */
    func readAll() -> [User] {
        let queryStatementString = "SELECT * FROM user;"
        var queryStatement: OpaquePointer? = nil
        var users : [User] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let mail = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                users.append(User(id: Int(id), name: name, email: mail))
                print("Query Result:")
                print("\(id) | \(name) | \(mail)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return users
    }




    /**
           This Function will read all the Entries in the database having the definied Id
           - Parameter id : The wanted id
           - Throws:"CREATE TABLE statement could not be prepared."
                    if sqlite3_prepare_v2 is different from "SQLITE_OK"
           - Returns: A User table
    */
    func readFromId(id:Int) -> [User] {
        let queryStatementString = "SELECT * FROM user WHERE Id = ? LIMIT 1;"
        var queryStatement: OpaquePointer? = nil
        var users : [User] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(id))
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let mail = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                users.append(User(id: Int(id), name: name, email: mail))
                print("Query Result:")
                print("\(id) | \(name) | \(mail)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return users
    }


    /**
           This Function will read all the Entries in the database having the definied Id
           - Parameter id : The wanted id
           - Throws:"Could not delete row."
                    if sqlite3_step is different from "SQLITE_DONE"
                    "CREATE TABLE statement could not be prepared."
                    if sqlite3_prepare_v2 is different from "SQLITE_OK"
           - Returns: None
    */
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM user WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }

}
