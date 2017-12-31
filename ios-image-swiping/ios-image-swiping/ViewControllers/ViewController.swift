//
//  ViewController.swift
//  ios-image-swiping
//
//  Created by OkuderaYuki on 2017/12/31.
//  Copyright © 2017年 OkuderaYuki. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var textView: UITextView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Private
    private func setup() {
        registerNib()
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
    }

    private func registerNib() {
        let nib = UINib(nibName: ImageCollectionViewCell.nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier,
                                                            for: indexPath) as? ImageCollectionViewCell else {
                                                                fatalError("ImageCollectionViewCell is nil.")
        }
        cell.delegate = self

        let sampleImage = UIImage(named: String(format: "sample%d", indexPath.row))
        cell.setImage(sampleImage)
        
        return cell
    }

}

// MARK: - ImageCollectionViewCellEventInput
extension ViewController: ImageCollectionViewCellEventInput {
    func imageSwipeResult(sender: ImageCollectionViewCell, status: ImageSwipeStatus) {
        let indexPath = collectionView.indexPath(for: sender)
        let rowStr = indexPath?.row.description ?? "-"
        switch status {
        case .success(let speed, let image):
            print("image width: \(String(describing: image?.size.width))")
            print("image height: \(String(describing: image?.size.height))")

            let speedStr = String(format: "%.1f", speed)

            textView.text = """
            [DEBUG Message]
            indexPath?.row: \(rowStr)
            speed: \(speedStr) [points/sec]
            """
        case .error(let message):
            textView.text = """
            [DEBUG Message]
            indexPath?.row: \(rowStr)
            message: \(message)
            """
        }
    }
}
