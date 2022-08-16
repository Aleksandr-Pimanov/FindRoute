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
        let addressButton = UIButton(type: .system)
        addressButton.setTitle("Add Adress", for: .normal)
        let color: UIColor = .white
        addressButton.setTitleColor(color, for: .normal)
        addressButton.backgroundColor = .red
        addressButton.layer.cornerRadius = 15
        addressButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBoldItalic", size: 24)
        addressButton.translatesAutoresizingMaskIntoConstraints = false
        return addressButton
    }()
    
    let routeButton: UIButton = {
        let routeButton = UIButton(type: .system)
        routeButton.setTitle("Route", for: .normal)
        let color: UIColor = .white
        routeButton.setTitleColor(color, for: .normal)
        routeButton.backgroundColor = .red
        routeButton.layer.cornerRadius = 15
        routeButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBoldItalic", size: 24)
        routeButton.translatesAutoresizingMaskIntoConstraints = false
        routeButton.isHidden = true
        return routeButton
    }()
    
    let resetButton: UIButton = {
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset", for: .normal)
        let color: UIColor = .white
        resetButton.setTitleColor(color, for: .normal)
        resetButton.backgroundColor = .red
        resetButton.layer.cornerRadius = 15
        resetButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBoldItalic", size: 24)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.isHidden = true
        return resetButton
    }()
    
    var annotationsArray = [MKPointAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setConstraints()
        
        addressButton.addTarget(self, action: #selector(tappedAdressButton), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(tappedRouteButton), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(tappedResetButton), for: .touchUpInside)
    }
    
    @objc func tappedAdressButton() {
        alertAddAddress(title: "Добавить", placeHoler: "Введите адресс") { [self] text in
            setupPlacemark(adress: text)
        }
    }
    
    @objc func tappedRouteButton() {
        for index in 0...annotationsArray.count - 2 {
            createDirectionRequest(startCoordinate: annotationsArray[index].coordinate, destinationCoordinate: annotationsArray[index + 1].coordinate)
        }
        
        mapView.showAnnotations(annotationsArray, animated: true)
    }
    
    @objc func tappedResetButton() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationsArray = [MKPointAnnotation]()
        routeButton.isHidden = true
        resetButton.isHidden = true
    }

    private func setupPlacemark(adress: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adress) { [self] placemarks, error in
            if let error = error {
                print(error)
                alertError(title: "Ошибка", message: "Сервер недоступен. Попробуйте добавить адресс еще раз")
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(adress)"
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            
            self.annotationsArray.append(annotation)
            
            if annotationsArray.count > 2 {
                routeButton.isHidden = false
                resetButton.isHidden = false
            }
            
            mapView.showAnnotations(annotationsArray, animated: true)
        }
    }
    
    private func createDirectionRequest(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let startLocation = MKPlacemark(coordinate: startCoordinate)
        let destinationLocation = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: request)
        direction.calculate { [self] response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response else {
                alertError(title: "Ошибка", message: "Маршрут недоступен")
                return
            }
            
            var minRoute = response.routes[0]
            for route in response.routes {
                
                minRoute = (route.distance < minRoute.distance) ? route : minRoute
            }
            
            self.mapView.addOverlay(minRoute.polyline)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .red
        return render
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
