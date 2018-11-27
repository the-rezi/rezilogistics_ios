//
//  NavigationViewController.swift
//  ReziLogistics
//
//  Created by Husein Kareem on 11/15/18.
//  Copyright © 2018 Rezi Logistics. All rights reserved.
//

import UIKit

import NMAKit

class NavigationViewController: UIViewController {
    
    class MapDefaults {
        static let latitude = 41.8781
        static let longitude = -87.6298
        static let zoomLevel: Float = 13.2
        
        static let frame = CGRect(x: 110, y: 200, width: 220, height: 120)
        
        static let durationInterval = 2.0
    }
    
    @IBOutlet weak var mapView: NMAMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupMapView()
    }
    
    private func setupNavigationBar() {
        self.title = "The Rezi"
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                 target: self,
                                                                 action: #selector(cancelTapped))
    }
    
    private func setupMapView() {
        self.mapView.useHighResolutionMap = true
        self.mapView.zoomLevel = 13.2
        self.mapView.set(geoCenter: NMAGeoCoordinates(latitude: 41.8781, longitude: -87.6298), animation: .linear)
        self.mapView.copyrightLogoPosition = NMALayoutPosition.bottomCenter
    }
    
    @objc private func cancelTapped() {
        
    }
    
}
