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
    
    func getSaves() {
        let endpoint = "/api/saves"
        
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
    
    func requestSave(date: Date) async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let stringDate = dateFormatter.string(from: date)

        let saveRequest: SaveRequest = SaveRequest(name: "TestApp5", day: stringDate, request: "did this work?")
        
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
            self.saves.append(Save(name: saveRequest.name, request: saveRequest.request))
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
        let inputtedPasswordData = Data(password.utf8)
        let hashedInput = SHA512.hash(data: inputtedPasswordData).compactMap { String(format: "%02x", $0) }.joined()
        
        guard let encoded = try? JSONEncoder().encode(["kerb": kerb, "password": hashedInput]) else {
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
}
