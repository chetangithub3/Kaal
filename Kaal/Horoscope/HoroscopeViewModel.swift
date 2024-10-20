//
//  HoroscopeViewModel.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 6/3/24.
//

import Foundation
import SwiftUI
import SwiftData
@MainActor
class HoroscopeViewModel: ObservableObject {
    @ObservationIgnored
    private let service: PredictionDataSource = PredictionDataSource.shared
    @Published var isLoading: Bool = true
    @AppStorage("birthplace") var birthplace: String = ""
    @AppStorage("birthday") var birthday: String = ""
    @AppStorage("name") var name = ""
    @AppStorage("genderSaved") var genderSaved: Gender?
    @Published var prediction: Prediction?
    @Published var horoscope: String = ""
    var aKi: String {
        "gsk_UAUD9" + "ZvHPIqRY91" + "TjYSYWGdyb3FYtc" + "shBoeaELnOH" + "SMkhIx8TBDE"
    }
    private let endpoint = "https://api.groq.com/openai/v1/chat/completions"
   
    var firstName: String {
        return name.components(separatedBy: " ").first ?? name
    }
    @MainActor
    func fetchPrediction() async {
        isLoading = true
        let date = formatDate(Date())
        let result = await service.searchDatabase(for: date)
        switch result {
            case .success(let prediction):
                let pred = Prediction(dateString: prediction.dateString, general: prediction.general, personal: prediction.personal, finance: prediction.finance, health: prediction.health, luckyNumbers: prediction.luckyNumbers, luckyColors: prediction.luckyColors)
                self.prediction = pred
                isLoading = false
            case .failure(_):
                await fetchpredictionFromAPI()
        }
    }
    
    func needsNewFetch() -> Bool {
        guard let prediction = self.prediction else {return true}
        let savedDate = prediction.dateString
        let currentDate = formatDate(Date())
        return savedDate != currentDate
    }
    
    @MainActor
    func fetchpredictionFromAPI() async {
        guard let request = await createRequest() else {
            self.horoscope = "Error Occured"
            isLoading = false
            return
        }
        do {
            let (data,_) = try await URLSession.shared.data(for: request)
            let result = await decodeDataToPrediction(data)
            switch result {
                case .success(let prediction):
                    Task {
                        await service.savePredictionToLocalDatabase(prediction: prediction)
                        self.prediction = prediction
                        isLoading = false
                    }
                    break
                case .failure(_):
                    Task{
                        if let text = await decodeDataIntoText(data) {
                            self.horoscope = text
                            isLoading = false
                        }
                    }
                    break
            }
        } catch(let error) {
            print(error.localizedDescription)
            isLoading = false
            return
        }
    }
    
    func decodeDataIntoText(_ data: Data) async -> String? {
        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let choices = jsonResponse["choices"] as? [[String: Any]],
           let firstChoice = choices.first,
           let message = firstChoice["message"] as? [String: Any],
           let content = message["content"] as? String {
            let horoscope = await parseHoroscopeContent(content)
            let text = """
                        General: \(horoscope.general)
                
                        Personal: \(horoscope.personal)
                
                        Finance: \(horoscope.finance)
                
                        Health: \(horoscope.health)
                
                        Lucky Numbers: \(horoscope.luckyNumbers.map({ $0.description}).joined(separator: ", "))
                
                        Lucky Colors: \(horoscope.luckyColors.joined(separator: ", "))
                """
            return text
        } else {
           return nil
        }
    }
    func parseHoroscopeContent(_ content: String) async -> (general: String, personal: String, finance: String, health: String, luckyNumbers: [Int], luckyColors: [String]) {
        var general = "N/A"
        var personal = "N/A"
        var finance = "N/A"
        var health = "N/A"
        var luckyNumbers: [Int] = []
        var luckyColors: [String] = []
        
        if let data = content.data(using: .utf8),
           let horoscopeJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            general = horoscopeJSON["General"] as? String ?? "N/A"
            personal = horoscopeJSON["Personal"] as? String ?? "N/A"
            finance = horoscopeJSON["Finance"] as? String ?? "N/A"
            health = horoscopeJSON["Health"] as? String ?? "N/A"
            luckyNumbers = horoscopeJSON["Lucky Numbers"] as? [Int] ?? []
            luckyColors = horoscopeJSON["Lucky Colors"] as? [String] ?? []
            let prediction = Prediction(dateString: formatDate(Date()), general: general, personal: personal, finance: finance, health: health, luckyNumbers: luckyNumbers, luckyColors: luckyColors)
            self.prediction = prediction
        }
        return (general, personal, finance, health, luckyNumbers, luckyColors)
    }
    
    func decodeDataToPrediction(_ data: Data) async -> Result<Prediction, APIError> {
        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let choices = jsonResponse["choices"] as? [[String: Any]],
           let firstChoice = choices.first,
           let message = firstChoice["message"] as? [String: Any],
           let contentString = message["content"] as? String,
           let contentData = contentString.data(using: .utf8),
           let content = try? JSONSerialization.jsonObject(with: contentData, options: []) as? [String: Any] {

            if let general = content["General"] as? String,
               let personal = content["Personal"] as? String,
               let finance = content["Finance"] as? String,
               let health = content["Health"] as? String,
               let luckyNumbers = content["Lucky Numbers"] as? [Int],
               let luckyColors = content["Lucky Colors"] as? [String] {
                
                let prediction = Prediction(dateString: formatDate(Date()), general: general,
                                            personal: personal,
                                            finance: finance,
                                            health: health,
                                            luckyNumbers: luckyNumbers,
                                            luckyColors: luckyColors)
                return .success(prediction)
            }
            return .failure(APIError.badServer)
        } else {
            return .failure(APIError.badServer)
        }
    }
    
    func createRequest() async -> URLRequest? {
        guard let url = URL(string: endpoint) else {
            return nil
        }
        let date = formatDate(Date())
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(aKi)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "messages": [
                ["role": "system", "content": """
                You will be given a name, gender, birthday, birthtime, and location of birth. 
                The details are: Firstname - \(firstName), Gender - \(String(describing: genderSaved?.rawValue)), Birth day - \(birthday), Birthplace - \(birthplace)
                Your job is to give a horoscope for any day the user asks for.
                The response should contain horoscope elements such as General, personal, finance, health, social and list of lucky numbers and a list of lucky colors. It needs to be in the following JSON structure.
                The General section can contain more material, say 200 words. Give responses based on the data provided. Calculate the user's sun - moon sign and analyse how it might be affecting the GIVEN DAY.  Add emojis if applicable and if the user is young(Only in general section).
                {
                  "General": "This is a great day to take a break from your daily routine and indulge in some self-care. Take a relaxing bath, read a book, or practice some yoga to recharge your batteries.",
                  "Personal": "You may feel a sense of restlessness today, but try to channel it into something productive. Use this energy to tackle that pending task or project you've been putting off.",
                  "Finance": "Be cautious with your finances today. Avoid making impulsive decisions, and take your time to think before making any big purchases.",
                  "Health": "Take care of your physical and mental well-being today. Engage in some form of exercise, and prioritize your health.",
                  "Relationship": "Communicate openly and honestly with your loved ones today. Avoid misunderstandings by being clear and concise in your conversations.",
                  "Lucky Numbers": [3, 9, 12, 15, 21],
                  "Lucky Colors": ["Yellow", "Orange", "Pink"]
                }
                """],
                ["role": "user", "content": "give the horoscope for \(date)"]
            ],
            "model": "llama3-8b-8192",
            "response_format": ["type": "json_object"]
        ]
  
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            return nil
        }
        return request
    }
    
     func formatDate(_ date: Date) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "MM-dd-yyyy"
         return dateFormatter.string(from: date)
     }
}

@MainActor
final class PredictionDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = PredictionDataSource()

    private init() {
        self.modelContainer = try! ModelContainer(for: PredictionModel.self)
        self.modelContext = modelContainer.mainContext
     
    }
 
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: date)
    }

    func fetchPrediction(for formattedDate: String) async -> Result<Prediction, APIError> {
        let result = await searchDatabase(for: formattedDate)
        switch result {
            case .success(let model):
                let prediction = Prediction(dateString: model.dateString, general: model.general, personal: model.personal, finance: model.finance, health: model.health, luckyNumbers: model.luckyNumbers, luckyColors: model.luckyColors)
                return .success(prediction)
            case .failure(_):
                return .failure(APIError.notFound)
        }
    }
    
    func searchDatabase(for formattedDate: String) async -> Result<PredictionModel, APIError> {
        
        do {
            let predicate = #Predicate<PredictionModel> { object in
                object.dateString == formattedDate
            }
            let descriptor = FetchDescriptor(predicate: predicate)
            let objects = try modelContext.fetch(descriptor)
            if objects.count > 1 {
                let count = objects.count
                for index in 1..<count {
                    modelContext.delete(objects[index])
                }
            }
            guard let first = objects.first else {return .failure(APIError.notFound)}
            return .success(first)
        } catch {
            return .failure(.notFound)
        }
    }
    
    func savePredictionToLocalDatabase(prediction: Prediction) async {
        let prediction = PredictionModel(dateString: prediction.dateString, general: prediction.general, personal: prediction.personal, finance: prediction.finance, health: prediction.health,  luckyNumbers: prediction.luckyNumbers, luckyColors: prediction.luckyColors)
            modelContext.insert(prediction)
    }
}
