//
//  ModelData.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/21/23.
//

import Foundation
import Combine
import CryptoKit
import SwiftUI

class ModelData: ObservableObject {
    @Published var saves: [Save] = []
    @Published var user: User = User.default
    @Published var residents: [User] = []
//    @Published var mealPlanUsers: [User] = []
//    @Published var loadedMealPlanUsers = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("kerb") var kerb: String = ""

        
    private let baseURL: String = "https://la-casa-app-server.vercel.app"
    
    func GET<T: Codable>(endpoint: String, type: T.Type, defaultValue: T) async -> T {
        
        guard let url = URL(string: self.baseURL + endpoint) else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
            else { return defaultValue }
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        }
        catch {
            return defaultValue
        }
    }
    
    func POST<T: Codable>(endpoint: String, obj: T) async -> POSTResult {
        guard let encoded = try? JSONEncoder().encode(obj) else {
            return POSTResult(successful: false, errorMsg: "Failed to encode request", result: false)
        }

        let url = URL(string: baseURL + endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedResponse = try JSONDecoder().decode(POSTResult.self, from: data)
            return decodedResponse
        } catch {
            return POSTResult(successful: false, errorMsg: "Request failed.", result: false)
        }
    }
    
    func getUser(kerb: String) async {
        let endpoint = "/api/user?kerb=\(kerb)"
        
        let user = await GET(endpoint: endpoint, type: [User].self, defaultValue: [User.default])
        
        if(user.isEmpty){
            self.user = User.default
        }
        else{
            self.user = user[0]
        }
    }
    
    func getResidentInfo() async -> ResidentInfo {
        let dataArr = await GET(endpoint: "/api/residentInfo?kerb=\(self.user.kerb)", type: [ResidentInfoRequest].self, defaultValue: [])
        if(dataArr.isEmpty){
            return ResidentInfo.default
        }
        let data = dataArr[0]
        var residentInfo = ResidentInfo(office: data.office, room: data.room, total_housing_points: data.total_housing_points, gbm_attendance: [], ebm_attendance: [])
        
        for status in [data.status1, data.status2, data.status3, data.status4] {
            residentInfo.gbm_attendance.append(AttendanceStatus(rawValue: status) ?? AttendanceStatus.none)
        }
        
        if (residentInfo.isExec()) {
            let ebmDataArr = await GET(endpoint: "/api/userEbm?kerb=\(self.user.kerb)", type: [EbmAttendanceRequest].self, defaultValue: [])
            if(ebmDataArr.isEmpty){ return residentInfo }
            let ebmData = ebmDataArr[0]
            for status in [ebmData.status1, ebmData.status2, ebmData.status3, ebmData.status4] {
                residentInfo.ebm_attendance.append(AttendanceStatus(rawValue: status) ?? AttendanceStatus.none)
            }
        }
        
        return residentInfo
    }
    
    func getChores() async -> [Chore] {
        return await GET(endpoint: "/api/chores", type: [Chore].self, defaultValue: [])
    }
        
    func getSaves(date: Date) async {
        let stringDate = dateToString(date: date)
        let endpoint = "/api/saves?day=\(stringDate)"
        self.saves = await GET(endpoint: endpoint, type: [Save].self, defaultValue: [])
    }
    
    func getUserSaves() async -> [Save] {
        let endpoint = "/api/userSaves?kerb=\(self.user.kerb)"
        return await GET(endpoint: endpoint, type: [Save].self, defaultValue: [])
    }
    
    func requestSave(date: String, request: String) async -> POSTResult {
        let saveRequest: SaveRequest = SaveRequest(kerb: self.user.kerb, day: date, request: request)
        return await POST(endpoint: "/api/requestSave", obj: saveRequest)
    }
    
    func deleteSave(saveId: Int) async -> POSTResult {
        return await POST(endpoint: "/api/deleteSave", obj: ["id": saveId])
    }
    
    func pushDinner() async -> POSTResult {
        return await POST(endpoint: "/api/sendDinnerPushed", obj: ["kerb": self.user.kerb])
    }
    
    func handleLogin(kerb: String, password: String) async -> POSTResult {
        let encryptedInput = encryptString(text: password)
        return await POST(endpoint: "/api/login", obj: ["kerb": kerb, "password": encryptedInput])
    }
    
    func requestPassword(kerb: String) async -> Bool {
        let endpoint = "/api/forgotPwd"
        guard let encoded = try? JSONEncoder().encode(["kerb": kerb]) else {
            return false
        }
        
        let url = URL(string: baseURL + endpoint)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedResponse = try JSONDecoder().decode(POSTResult.self, from: data)
            return decodedResponse.result
        } catch {
            return false
        }
    }

    func changePassword(newPassword: String) async -> POSTResult {
        let encryptedInput = encryptString(text: newPassword)
        return await POST(endpoint: "/api/changePassword", obj: ["kerb": self.user.kerb, "password": encryptedInput])
    }
    
    func updateProfile(fname: String, lname: String, year: Int, major: String, dietary_restriction: String) async -> POSTResult {
        let updatedUser = User(fname: fname, lname: lname, kerb: self.user.kerb, year: year, major: major, dietary_restriction: dietary_restriction, password: self.user.password, resident: self.user.resident, onMealPlan: self.user.onMealPlan)
        
        return await POST(endpoint: "/api/updateProfile", obj: updatedUser)
    }
    
    func updateDietaryRestriction(restriction: String) async -> POSTResult {
        return await POST(endpoint: "/api/changeDietaryRestriction", obj: ["kerb": self.user.kerb, "dietary_restriction": restriction])
    }
    
    func signupNonresident(fname: String, lname: String, kerb: String, year: Int, major: String, dietary_restriction: String = "", password: String) async -> POSTResult {
        
        let encryptedPassword = encryptString(text: password)
        let isResident = 0 //false
        let isOnMealPlan = 0 //false

        let newUser = User(fname: fname, lname: lname, kerb: kerb, year: year, major: major, dietary_restriction: dietary_restriction, password: encryptedPassword, resident: isResident, onMealPlan: isOnMealPlan)
        
        return await POST(endpoint: "/api/signupNonresident", obj: newUser)
    }
    
    func signupResident(kerb: String, password: String) async -> POSTResult {
        let encryptedPassword = encryptString(text: password)
        return await POST(endpoint: "/api/signupResident", obj: ["kerb": kerb, "password": encryptedPassword])
    }
    
    func doesAccountExist(kerb: String) async -> POSTResult {
        return await POST(endpoint: "/api/accountExists", obj: ["kerb": kerb])
    }
    
    func deleteAccount() async -> POSTResult {
        return await POST(endpoint: "/api/deleteAccount", obj: ["kerb": self.user.kerb])
    }
    
    func getResidents() async {
        self.residents = await GET(endpoint: "/api/residents", type: [User].self, defaultValue: [])
    }
    
//    func getMealPlanUsers() async -> [User] {
//        return await GET(endpoint: "/api/mealPlanUsers", type: [User].self, defaultValue: [])
//    }
    
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
