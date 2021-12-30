//
//  ViewController.swift
//  plus15playground3
//
//  Created by Nicholas Lee on 2021-12-28.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        mapView.delegate = self
        
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.045000, longitude: -114.069000), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        
        parseJSON()
        
        super.viewDidLoad()
    }
    
    func parseJSON() {
        guard let path = Bundle.main.path(forResource: "PointsOfInterest", ofType: "json") else {
            fatalError("unable to get json")
        }
        
        let url = URL(fileURLWithPath: path)
        
        var result: [PointOfInterest]
        
        do {
            let jsonData = try Data(contentsOf: url)
            result = try! JSONDecoder().decode([PointOfInterest].self, from: jsonData)
            
            for poi in result {
                addPin(poi: poi)
            }
        } catch {
           print("data is messed")
        }
    }
    
    func addPin(poi: PointOfInterest){
        
        let pin = Pin()
        pin.title = poi.title
        pin.type = poi.type
        pin.key = poi.key
        pin.coordinate = CLLocationCoordinate2D(latitude: poi.lat, longitude: poi.lon)
        
        if(poi.type != "coffee" && poi.type != "restaurant" && poi.type != "buisness" && poi.type != "poi"){
            print(poi.key)
            print("Point of intereset with key " + poi.key + " has a wrong type")
        }
        
        mapView.addAnnotation(pin)
    }
    
    


}

struct PointOfInterest: Codable {
    let key: String
    let title: String
    var type: String = "poi"
    let lat: Double
    let lon: Double
}

class Pin: MKPointAnnotation {
    var type: String
    var key: String
    
    override init() {
        type = ""
        key = ""
        super.init()
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pointOfInterest")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pointOfInterest")
        } else {
            annotationView?.annotation = annotation
        }
        
        
        
        
        if let pin = annotation as? Pin {
            
            // figure out how to cluster
//            let generalPinImage = UIImage(named: "generalPinLogo")
//            generalPinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//            let resizedGeneralPinImage = UIGraphicsGetImageFromCurrentImageContext()

//            annotationView?.clusteringIdentifier = "pin"
//            annotationView?.cluster?.image = resizedGeneralPinImage
            var size = CGSize(width: 200, height: 200)
            UIGraphicsBeginImageContext(size)
            
            let calloutImage = UIImage(named: pin.key)
            calloutImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedcalloutImage = UIGraphicsGetImageFromCurrentImageContext()
            
            annotationView?.canShowCallout = true
            annotationView?.detailCalloutAccessoryView = UIImageView(image: resizedcalloutImage)
            
            
            size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            
            if pin.type == "buisness" {
                let buisnessImage = UIImage(named: "buisnessLogo")
                buisnessImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedBuisnessImage = UIGraphicsGetImageFromCurrentImageContext()
                
                annotationView?.image = resizedBuisnessImage
            } else if pin.type == "coffee" {
                let coffeeImage = UIImage(named: "coffeeLogo")
                coffeeImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedCoffeeImage = UIGraphicsGetImageFromCurrentImageContext()
                
                annotationView?.image = resizedCoffeeImage
            } else if pin.type == "restaurant" {
                let restaurantImage = UIImage(named: "restaurantLogo")
                restaurantImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedRestaurantImage = UIGraphicsGetImageFromCurrentImageContext()
                
                annotationView?.image = resizedRestaurantImage
            } else {
                let poiImage = UIImage(named: "poiLogo")
                poiImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedPoiImage = UIGraphicsGetImageFromCurrentImageContext()
                
                annotationView?.image = resizedPoiImage
            }
        }
        
        return annotationView
    }
}


