//
//  MapClusterAnnotationView.swift
//  plus15playground3
//
//  Created by Nicholas Lee on 2022-01-23.
//

import Foundation
import MapKit

/// - Tag: ClusterAnnotationView
class ClusterAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Tag: CustomCluster
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            let total = cluster.memberAnnotations.count
            
            image = drawRatio(0, to: total)

            displayPriority = .defaultHigh
            
        }
    }

    private func drawRatio(_ fraction: Int, to whole: Int) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return renderer.image { _ in

            // Fill inner circle with white color
            UIColor.black.setFill()
            UIBezierPath(ovalIn: CGRect(x: 5, y: 5, width: 30, height: 30)).fill()

            // Finally draw count text vertically and horizontally centered
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
            let text = "\(whole)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - (size.width) / 2, y: 20 - (size.height) / 2, width: size.width + 10, height: size.height + 10)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}
