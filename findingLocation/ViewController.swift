//
//  ViewController.swift
//  findingLocation
//
//  Created by Shan on 08/05/2018.
//  Copyright © 2018 Shan. All rights reserved.
//


import UIKit
import MapKit
protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}
final class myLocation:NSObject,MKAnnotation{
    
   
    
      //MARK:-- Declaring variable
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(coordinate:CLLocationCoordinate2D,title:String?,subtitle:String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
}
class ViewController: UIViewController ,CLLocationManagerDelegate,UISearchControllerDelegate{
   
        var selectedPin:MKPlacemark? = nil
        var resultSearchController:UISearchController? = nil
        let locationManger = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
        override func viewDidLoad() {
        super.viewDidLoad()
        addMapTrackingButton()
        
        //MARK:--Creating search bar on the navigation bar
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar

        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self

        
        
        
        //MARK:-- Setting annotation
        
        locationManger.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier:                                                          MKMapViewDefaultAnnotationViewReuseIdentifier)
        let myloc = CLLocationCoordinate2D(latitude: 33.721083, longitude: 73.079813)
        let mylocAnnotation = myLocation(coordinate: myloc, title: "My current Location", subtitle: "Mushtaq Menssion Islamabad")
        mapView.addAnnotation(mylocAnnotation)
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        
            }
          //MARK:-- Delegate function
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
            }
        //MARK:-- Getting direction
            func getDirections(){
            if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
                                    }
                                }
                            }

    extension ViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        if let myLocationAnnotaion = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            myLocationAnnotaion.animatesWhenAdded = true
            myLocationAnnotaion.titleVisibility = .adaptive
            myLocationAnnotaion.titleVisibility = .adaptive
            return myLocationAnnotaion
        }
        return nil
    }
    
          //MARK:-- Tracking button
        func addMapTrackingButton(){
        let image = UIImage(named: "trackme") as UIImage?
        let button   = UIButton(type: UIButtonType.system) as UIButton
        button.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(ViewController.centerMapOnUserButtonClicked), for:.touchUpInside)
        self.mapView.addSubview(button)
    }
    
    @objc func centerMapOnUserButtonClicked() {
        self.mapView.setUserTrackingMode( MKUserTrackingMode.follow, animated: true)
        }
    }


            //MARK:-- Handling map search
        extension ViewController: HandleMapSearch {
        func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "\(city)  \(state)"
                                }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
            }
        }





