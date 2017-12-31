//
//  ImageCollectionViewCell.swift
//  ios-image-swiping
//
//  Created by OkuderaYuki on 2018/01/01.
//  Copyright © 2018年 OkuderaYuki. All rights reserved.
//

import UIKit

protocol ImageCollectionViewCellEventInput: class {
    func imageSwipeResult(sender: ImageCollectionViewCell, status: ImageSwipeStatus)
}

final class ImageCollectionViewCell: UICollectionViewCell {

    static let identifier = "ImageCollectionViewCell"
    static let nibName = "ImageCollectionViewCell"

    @IBOutlet private weak var swipeableImageView: SwipeableImageView!
    weak var delegate: ImageCollectionViewCellEventInput?

    override func awakeFromNib() {
        super.awakeFromNib()
        swipeableImageView.delegate = self
    }

    func setImage(_ image: UIImage?) {
        swipeableImageView.image = image
    }
}

// MARK: - ImageSwipeDelegate
extension ImageCollectionViewCell: ImageSwipeDelegate {
    func then(_ status: ImageSwipeStatus) {
        delegate?.imageSwipeResult(sender: self, status: status)
    }
}
