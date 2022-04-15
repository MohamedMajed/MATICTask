//
//  RepositoryViewModel.swift
//  MATICTask
//
//  Created by Mohamed Maged on 13/04/2022.
//

import Foundation

class RepositoryViewModel {
    
    var repositoryService: APIService
    var currentPage: Int = 1
    var isFetchingRepositories = false
    var repositoryData: [Repository] = [] {
        didSet {
            
            self.bindRepositoriesViewModelToView()
        }
    }
    
    var showError: String! {
        didSet {
            
            self.bindViewModelErrorToView()
        }
    }
    
    var bindRepositoriesViewModelToView: (()->()) = {}
    var bindViewModelErrorToView: (()->()) = {}
    
    init() {
        self.repositoryService = APIService()
        self.fetchRepositoriesFromAPI()
    }
    
    func prefetchRows(at indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row >= repositoryData.count - 5 && !isFetchingRepositories && currentPage < 34 {
                fetchRepositoriesFromAPI()
                break
            }
        }
    }

    func fetchRepositoriesFromAPI() {
        
        isFetchingRepositories = true
        repositoryService.fetchRepositories(atPage: currentPage, completion: { (repositoryData, error) in
            if let error = error {
                
                let message = error.localizedDescription
                self.showError = message
                
            } else {
                print("Page Number : \(self.currentPage)")
                self.repositoryData.append(contentsOf: repositoryData ?? [])
                if self.currentPage < 34 {
                   self.currentPage += 1
                }
            }
            self.isFetchingRepositories = false
        })
    }
}


