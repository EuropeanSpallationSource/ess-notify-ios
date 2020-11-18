//
//  LoginUtilities.swift
//  ESS Notify
//
//  Created by Emanuele Laface on 2020-11-18.
//

import Foundation

func loadCredentials() {
    do {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = paths[0].appendingPathComponent("credentials")
        let data = try Data(contentsOf: url)
        userData = try JSONDecoder().decode(UserData.self, from: data)
    } catch {
        print("Load failed")
    }
}

func saveCredentials() {
    do {
        let data = try JSONEncoder().encode(userData)
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = paths[0].appendingPathComponent("credentials")
        try data.write(to: url)
    }
    catch {
        print("Save failed")
    }
}

func checkCredentials() -> String {
    loadCredentials()
    if userData.ESSToken == "" {
        return "login"
    }
    else {
        if checkUserProfile(token: userData.ESSToken) {
            return "notifications"
        }
        else {
            return "login"
        }
        
    }
}

func checkLogin(username: String, password: String) -> Bool {
    let (token, response) = login(username: username, password: password)
    if response == 200 {
        userData.ESSToken = token
        saveCredentials()
        return true
    }
    else {
        return false
    }

}
