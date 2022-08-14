//
//  ViewController.swift
//  FindRoute
//
//  Created by Aleksandr Pimanov on 14.08.2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let addressButton: UIButton = {
        let addressButton = UIButton()
        addressButton.setTitle("Add Adress", for: .normal)
        addressButton.layer.cornerRadius = 180
        addressButton.backgroundColor = .red
        addressButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBoldItalic", size: 24)
        let color: UIColor = .black
        addressButton.setTitleColor(color, for: .normal)
        addressButton.translatesAutoresizingMaskIntoConstraints = false
        return addressButton
    }()
    
    let routeButton: UIButton = {
        let routeButton = UIButton()
        routeButton.setTitle("Route", for: .normal)
        routeButton.layer.cornerRadius = 180
        routeButton.backgroundColor = .red
        routeButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBoldItalic", size: 24)
        let color: UIColor = .black
        routeButton.setTitleColor(color, for: .normal)
        routeButton.translatesAutoresizingMaskIntoConstraints = false
        routeButton.isHidden = true
        return routeButton
    }()
    
    let resetButton: UIButton = {
        let resetButton = UIButton()
        resetButton.setTitle("Reset", for: .normal)
        resetButton.layer.cornerRadius = 180
        resetButton.backgroundColor = .red
        resetButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBoldItalic", size: 24)
        let color: UIColor = .black
        resetButton.setTitleColor(color, for: .normal)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.isHidden = true
        return resetButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraints()
        
        addressButton.addTarget(self, action: #selector(tappedAdressButton), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(tappedRouteButton), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(tappedresetButton), for: .touchUpInside)
    }
    
    @objc func tappedAdressButton() {
        print("tapped 1")
    }
    
    @objc func tappedRouteButton() {
        print("tapped 2")
    }
    
    @objc func tappedresetButton() {
        print("tapped 3")
    }
}

extension ViewController {
    
    func setConstraints() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor
                                              , constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        mapView.addSubview(addressButton)
        NSLayoutConstraint.activate([
            addressButton.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 60),
            addressButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -40)
        ])
        
        mapView.addSubview(routeButton)
        NSLayoutConstraint.activate([
            routeButton.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            routeButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 40)
        ])
        
        mapView.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            resetButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -40)
        ])
    }
}
