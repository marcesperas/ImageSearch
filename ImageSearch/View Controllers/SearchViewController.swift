//
//  SearchViewController.swift
//  ImageSearch
//
//  Created by Marc Jardine Esperas on 3/13/22.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    private var viewModel: SearchViewModelProtocol = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func fetchImageDataList() {
        ActivityIndicatorView.start(for: view)
        
        viewModel.fetchImageDataList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let searchList):
                    let viewModel = ImagesViewModel(searchList: searchList)
                    self?.goToRepositoryDetailsViewController(with: viewModel)
                case .failure(let error):
                    self?.showAlert(message: error.description)
                }
            }
            ActivityIndicatorView.stop()
        }
    }
    
    private func enableSearchButton() {
        searchButton.isEnabled = viewModel.isSearchButtonEnabled()
    }

    @IBAction func textFieldChanged(_ sender: UITextField) {
        viewModel.searchText = sender.text ?? ""
        enableSearchButton()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        fetchImageDataList()
    }
    
    func goToRepositoryDetailsViewController(with viewModel: ImagesViewModel) {
        let viewController = ImagesViewController.instantiate(with: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fetchImageDataList()
        return true
    }
}
