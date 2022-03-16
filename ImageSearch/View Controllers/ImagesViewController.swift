//
//  ImagesViewController.swift
//  ImageSearch
//
//  Created by Marc Jardine Esperas on 3/13/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImagesViewController: UICollectionViewController, ViewModelBased {
    
    var viewModel: ImagesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private func loadImage(row: Int, completion: @escaping (UIImage?) -> ()) {
        let urlString = viewModel.ImageAtIndex(row).previewURL
        viewModel.fetchImageData(with: urlString) { result in
            if case let .success(data) = result {
                completion(UIImage(data: data))
            } else {
                completion(UIImage(named: "ImageNotAvailable"))
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            fatalError("ImageCollectionViewCell not found")
        }
    
        loadImage(row: indexPath.row) { image in
            DispatchQueue.main.async {
                cell.thumbnailImageView.image = image
            }
        }
    
        return cell
    }
    


}

extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace - 20) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
}
