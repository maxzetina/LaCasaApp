//
//  ModelData.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/21/23.
//

import Foundation
import Combine
import CryptoKit

class ModelData: ObservableObject {
    @Published var chores: [Chore] = []
    @Published var currentTeam: Int = 0
    @Published var loadingChores: Bool = true
    @Published var saves: [Save] = []
    @Published var user: User = User.default
    @Published var residents: [User] = []
        
    let baseURL: String = "https://la-casa-app-server.vercel.app"

    func getChores() {
        let endpoint = "/api/chores"
        
        guard let url = URL(string: baseURL + endpoint) else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedChores = try JSONDecoder().decode([Chore].self, from: data)
                        self.chores = decodedChores
                        self.currentTeam = decodedChores[0].team
                        self.loadingChores = false
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func getSaves(date: Date) {
        let stringDate = dateToString(date: date)

        let endpoint = "/api/saves?day=\(stringDate)"
        
        guard let url = URL(string: baseURL + endpoint) else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedSaves = try JSONDecoder().decode([Save].self, from: data)
                        self.saves = decodedSaves
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    //to fix
    func requestSave(kerb: String, date: Date, request: String) async {
        let stringDate = dateToString(date: date)

        let saveRequest: SaveRequest = SaveRequest(kerb: "zetina", day: stringDate, request: request)
        
        guard let encoded = try? JSONEncoder().encode(saveRequest) else {
            print("Failed to encode request")
            return
        }
        
        let endpoint = "/api/requestSave"
        
        let url = URL(string: baseURL + endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            // (data, response)
            let (_, _) = try await URLSession.shared.upload(for: request, from: encoded)
//            self.saves.append(Save(id: 19, name: saveRequest.name, request: saveRequest.request))
        } catch {
            print("Request failed.")
        }
    }
    
    func pushDinner() async {
        guard let encoded = try? JSONEncoder().encode(["test": "hi"]) else {
            print("Failed to encode request")
            return
        }
        let endpoint = "/api/sendDinnerPushed"
        
        let url = URL(string: baseURL + endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            // (data, response)
            let (_, _) = try await URLSession.shared.upload(for: request, from: encoded)
        } catch {
            print("Request failed.")
        }
    }
    
    func handleLogin(kerb: String, password: String) async -> Bool {
        let encryptedInput = encryptString(text: password)
        
        guard let encoded = try? JSONEncoder().encode(["kerb": kerb, "password": encryptedInput]) else {
            print("Failed to encode request")
            return false
        }
        
        let endpoint = "/api/login"
        
        let url = URL(string: baseURL + endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            // (data, response)
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedResponse = try JSONDecoder().decode(Bool.self, from: data)

            return decodedResponse
        } catch {
            print("Request failed.")
        }
        return false
    }
    
    func requestPassword(kerb: String) async -> Bool {
//        Change this and add api
        return true
    }

    func signupNonresident(fname: String, lname: String, kerb: String, year: Int, major: String, dietary_restriction: String = "", password: String) async {
        
        let encryptedPassword = encryptString(text: password)
        let isResident = 0 //false

        let newUser = User(fname: fname, lname: lname, kerb: kerb, year: year, major: major, dietary_restriction: dietary_restriction, password: encryptedPassword, resident: isResident)
        
        guard let encoded = try? JSONEncoder().encode(newUser) else {
            print("Failed to encode request")
            return
        }
        let endpoint = "/api/signupNonresident"
        
        let url = URL(string: baseURL + endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            // (data, response)
            let (_, _) = try await URLSession.shared.upload(for: request, from: encoded)
        } catch {
            print("Request failed.")
        }
    }
    
    func signupResident(kerb: String, password: String) async {
        
        let encryptedPassword = encryptString(text: password)
                
        guard let encoded = try? JSONEncoder().encode(["kerb": kerb, "password": encryptedPassword]) else {
            print("Failed to encode request")
            return
        }
        let endpoint = "/api/signupResident"
        
        let url = URL(string: baseURL + endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            // (data, response)
            let (_, _) = try await URLSession.shared.upload(for: request, from: encoded)
        } catch {
            print("Request failed.")
        }
    }
    
    func doesAccountExist(kerb: String) async -> Bool {
        guard let encoded = try? JSONEncoder().encode(["kerb": kerb]) else {
            print("Failed to encode request")
            return false
        }
        
        let endpoint = "/api/accountExists"
        
        let url = URL(string: baseURL + endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            // (data, response)
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedResponse = try JSONDecoder().decode(Bool.self, from: data)

            return decodedResponse
        } catch {
            print("Request failed.")
        }
        return false
    }
    
    func getResidents() {
        let endpoint = "/api/residents"
        
        guard let url = URL(string: baseURL + endpoint) else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedResidents = try JSONDecoder().decode([User].self, from: data)
                        self.residents = decodedResidents
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func getUser(kerb: String) {
        let endpoint = "/api/user?kerb=\(kerb)"

        guard let url = URL(string: baseURL + endpoint) else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedUser = try JSONDecoder().decode([User].self, from: data)
                        if(decodedUser.isEmpty){
                            self.user.kerb = kerb
                        }
                        else{
                            self.user = decodedUser[0]
                        }
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func resetUser() {
        self.user = User.default
    }
    
    func encryptString(text: String) -> String {
        let inputtedTextData = Data(text.utf8)
        let hashedInput = SHA512.hash(data: inputtedTextData).compactMap { String(format: "%02x", $0) }.joined()
        return hashedInput
    }
    
    // returns date as YYYY-MM-dd
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
    }
}
