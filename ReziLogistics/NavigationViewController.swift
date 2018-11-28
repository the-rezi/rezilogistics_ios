//
//  NavigationViewController.swift
//  ReziLogistics
//
//  Created by Husein Kareem on 11/15/18.
//  Copyright © 2018 Rezi Logistics. All rights reserved.
//

import UIKit

import NMAKit

class NavigationViewController: UIViewController, NMARouteManagerDelegate {
    
    class MapDefaults {
        static let chiLatitude = 41.8924
        static let chiLongitude = -87.6341
        static let momaNMACoord = NMAGeoCoordinates(latitude: 41.8972278, longitude: -87.6213424)
        static let artInstituteNMACoord = NMAGeoCoordinates(latitude: 41.8804153, longitude: -87.6237284)
        
        static let momaAddr = "111+S+Michigan+Ave+Chicago+IL+60603"
        static let artInstituteAddr = "220+E+Chicago+Ave+Chicago+IL+60611"
        
        static let zoomLevel: Float = 13.7
        
        static let frame = CGRect(x: 110, y: 200, width: 220, height: 120)
        
        static let durationInterval = 2.0
    }
    
    @IBOutlet weak var mapView: NMAMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupMapView()
        self.setupRouteManager()
    }
    
    private func setupNavigationBar() {
        self.title = "The Rezi"
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                 target: self,
                                                                 action: #selector(cancelTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                                target: self,
                                                                action: #selector(openInMapsTapped))
    }
    
    private func setupMapView() {
        self.mapView.useHighResolutionMap = true
        self.mapView.zoomLevel = MapDefaults.zoomLevel
        self.mapView.set(geoCenter: NMAGeoCoordinates(latitude: MapDefaults.chiLatitude, longitude: MapDefaults.chiLongitude), animation: .linear)
        self.mapView.copyrightLogoPosition = NMALayoutPosition.bottomCenter
    }
    
    @objc private func cancelTapped() {
        let alertController = UIAlertController(title: "Cancel Trip", message: "State reason for cancellation:", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Customer cancelled"
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            print("Reason for cancellation: \(String(describing: textField.text))")
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func openInMapsTapped() {
        let actionSheet = UIAlertController(title: "Navigate",
                                            message: nil,
                                            preferredStyle: UIAlertController.Style.actionSheet)
        
        let appleMapsDirectionsURLString = "http://maps.apple.com/?address=\(MapDefaults.artInstituteAddr)"
        guard let appleMapsDirectionsURL = URL(string: appleMapsDirectionsURLString) else {
            return
        }
        let openAppleMapsAction = UIAlertAction(title: "Open in Apple Maps",
                                                style: UIAlertAction.Style.default,
                                                handler: { (action) in
                                                    UIApplication.shared.open(appleMapsDirectionsURL,
                                                                              options: [:],
                                                                              completionHandler: nil)
        })
        actionSheet.addAction(openAppleMapsAction)
        
        let googleMapsDirectionsURLString = "https://www.google.com/maps?saddr=My+Location&daddr=\(MapDefaults.artInstituteAddr)"
        guard let googleMapsDirectionsURL = URL(string: googleMapsDirectionsURLString) else {
            return
        }
        let openGoogleMapsAction = UIAlertAction(title: "Open in Google Maps",
                                                 style: UIAlertAction.Style.default,
                                                 handler: { (action) in
                                                    UIApplication.shared.open(googleMapsDirectionsURL,
                                                                              options: [:],
                                                                              completionHandler: nil)
        })
        actionSheet.addAction(openGoogleMapsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: UIAlertAction.Style.cancel,
                                         handler: nil)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func setupRouteManager() {
        let routeManager = NMARouteManager.shared()
        routeManager.delegate = self
        
        var stops = [NMAGeoCoordinates]()
        stops.append(MapDefaults.momaNMACoord)
        stops.append(MapDefaults.artInstituteNMACoord)
        
        guard let routingMode = NMARoutingMode(routingType: NMARoutingType.fastest, transportMode: NMATransportMode.car, routingOptions: 0) else {
            return
        }
        
        routeManager.calculateRoute(stops: stops, mode: routingMode)
    }
    
    func routeManagerDidCalculate(_ routeManager: NMARouteManager, routes: [NMARoute]?, error: NMARouteManagerError, violatedOptions: [NSNumber]?) {
        
        guard let routes = routes else {
            return
        }
        
        let route = routes[0]
        let mapRoute = NMAMapRoute(route: route)
        self.mapView.add(mapRoute)
    }
    
}
