//
//  AddressSearchViewModel.swift
//  Kaal
//
//  Created by Chetan Dhowlaghar on 12/20/23.
//
// https://geocode.maps.co/search?q={String}
import Foundation
import Combine
import SwiftUI

class AddressSearchViewModel: ObservableObject {
    var cancellebles = Set<AnyCancellable>()
    var apiManager: APIManager
    
    @Published var searchText = ""
    @Published var showDropDown = false
    @Published var results = [AddressesListResponseElement]()
    init(apiManager: APIManager){
        self.apiManager = apiManager
        self.searchFieldListener()
        
    }
    
   
    func searchFieldListener(){
        
        $searchText  
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { text in
                print(text)
                if text.count > 2 {
                    self.callAPI(text: text)
                }
            }.store(in: &cancellebles)
    }
    func callAPI(text: String){
        let baseURL = "https://geocode.maps.co/search?q="
        let url = baseURL + "\(text)"
        guard let URL = URL(string: url) else {return}
        fetchData(from: URL)
    }
    
    func fetchData(from url: URL) {
        apiManager.publisher(for: url)
            .sink (receiveCompletion: { (completion) in
                switch completion {
                    case .finished:
                        return
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                        
                }
            }, receiveValue: { (addresses: AddressesListResponse) in
                self.results = addresses
                if addresses.count > 0 {
                    self.showDropDown = true
                }
            })
            .store(in: &cancellebles)
    }
}
