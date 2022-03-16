//
//  ViewModelBased.swift
//  ImageSearch
//
//  Created by Marc Jardine Esperas on 3/13/22.
//

import UIKit

protocol ViewModelBased: AnyObject {
    associatedtype ViewModel
    var viewModel: ViewModel! { get set }
}

extension ViewModelBased where Self: UIViewController {
    
    static func instantiate(with viewModel: ViewModel) -> Self {
        let viewController = instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
    
}
