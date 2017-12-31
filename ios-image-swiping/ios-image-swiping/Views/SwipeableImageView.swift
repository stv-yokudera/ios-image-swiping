//
//  SwipeableImageView.swift
//  ios-image-swiping
//
//  Created by OkuderaYuki on 2018/01/01.
//  Copyright © 2018年 OkuderaYuki. All rights reserved.
//

import UIKit

protocol SwipeableProtocol: class {

    var maxVerticalChange: CGFloat { get }
    var minDistance: CGFloat { get }
    var minDuration: CGFloat { get }
    var minSpeed: CGFloat { get }

    var startPoint: CGPoint? { get set }
    var startTime: TimeInterval? { get set }
}

protocol ImageSwipeDelegate: class {
    func then(_ status: ImageSwipeStatus)
}

enum ImageSwipeStatus {
    case success(CGFloat, UIImage?)
    case error(String)
}

class SwipeableImageView: UIImageView, SwipeableProtocol {

    let maxVerticalChange: CGFloat = 150.0
    let minDistance: CGFloat = 50.0
    let minDuration: CGFloat = 0.1
    let minSpeed: CGFloat = 100.0

    var startPoint: CGPoint?
    var startTime: TimeInterval?
    weak var delegate: ImageSwipeDelegate?

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        // Avoid multi-touch gesture
        if touches.count > 1 {
            return
        }

        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        startPoint = location
        startTime = touch.timestamp
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        guard let touch = touches.first, let startPoint = startPoint, let startTime = startTime else {
            return
        }

        let location = touch.location(in: self)

        let dx = location.x - startPoint.x
        let dy = location.y - startPoint.y

        if dy >= 0 {
            delegate?.then(.error("Swiped down."))
            return
        }

        let verticalChange = sqrt(dx * dx)
        if verticalChange >= maxVerticalChange {
            delegate?.then(.error("Vertical change too large."))
            return
        }

        let distance = sqrt(dx * dx + dy * dy)
        if distance >= minDistance {
            // Determine time difference from start of the gesture
            let dt = CGFloat(touch.timestamp - startTime)
            if dt > minDuration {
                // Determine gesture speed in points/sec
                let speed = CGFloat(distance) / dt
                if speed >= minSpeed {
                    // Swipe detected
                    delegate?.then(.success(speed, image))
                } else {
                    delegate?.then(.error("The speed is too slow."))
                }
            } else {
                delegate?.then(.error("The duration of the swipe is too short."))
            }
        } else {
            delegate?.then(.error("The distance is too short."))
        }
    }

    func detectSwiped(speed: CGFloat) {
        print("Swipe detected!")
        print("Swipe speed: \(speed)")
    }
}
