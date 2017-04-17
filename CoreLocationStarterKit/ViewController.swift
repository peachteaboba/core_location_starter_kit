//
//  ViewController.swift
//  CoreLocationStarterKit
//
//  Created by Andy Feng on 4/14/17.
//  Copyright © 2017 Andy Feng. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {


    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapKit: MKMapView!
    let newPin = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // add gesture recognizer
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.mapLongPress(_:))) // colon needs to pass through info
        longPress.minimumPressDuration = 1 // In seconds
        mapKit.addGestureRecognizer(longPress)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            mapKit.showsUserLocation = true
        }
    }
    
 
    func mapLongPress(_ recognizer: UIGestureRecognizer) {
        
        print("A long press has been detected.")
        
        let touchedAt = recognizer.location(in: self.mapKit) // adds the location on the view it was pressed
        let touchedAtCoordinate : CLLocationCoordinate2D = mapKit.convert(touchedAt, toCoordinateFrom: self.mapKit) // will get coordinates
        
        newPin.coordinate = touchedAtCoordinate
        mapKit.addAnnotation(newPin)
 
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        print("Location has been updated.")
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
//        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapKit.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        mapKit.addAnnotation(myAnnotation)
    }

}

