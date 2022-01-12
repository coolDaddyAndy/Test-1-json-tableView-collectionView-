//
//  DataManager.swift
//  Test for ITS
//
//  Created by Andrey Sushkov on 7.01.22.
//

import Foundation


struct User: Decodable {
    var name: String
    var gender: String
    var age: Int
}

var users = [User]()


func readJsonFile(_ name: String) -> Data? {
    do {
        if let filePath = Bundle.main.path(forResource: name,
                                           ofType: "json"),
           let jsonData = try String(contentsOfFile: filePath).data(using: .utf8) {
            return jsonData
        }
    } catch {
        print (error)
    }
    return nil
}


func parseData(jsonData: Data) {
    do {
        let decodedData = try JSONDecoder().decode([User].self,
                                                   from: jsonData)
        users = decodedData
    } catch {
        print ("error while decoding")
    }
}

func getAndParse() {
    if let data = readJsonFile("data") {
        parseData(jsonData: data)
    }
}
