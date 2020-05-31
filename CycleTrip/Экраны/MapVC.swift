//
//  NavigationViewController.swift
//  Cycle Trip
//
//  Created by Igor Lebedev on 04/05/2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import UIKit
import MapboxNavigation
import Mapbox
import PinLayout

final class MapVC: UIViewController, MGLMapViewDelegate {
    var mapView = MGLMapView()
    var presenter: MapPresenter!
    private var startButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Создать событие", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.addTarget(self, action: #selector(tappedCreateButton(sender:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    var plusButton = RoundButton()
    var minusButton = RoundButton()
    var locationButton = RoundButton()
    var stackView: UIStackView!
    var activity = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        presenter = MapPresenter(mapVC: self)
        mapView.showsUserLocation = true
        mapView.showsHeading = true
        mapView.delegate = self
        mapView.setCenter(CLLocationCoordinate2D(latitude: 55.453013, longitude: 48.205561), zoomLevel: 3, animated: false)
        configureButtons()
        configureStackView()
        // Add a gesture recognizer to the map view
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        mapView.addGestureRecognizer(longPress)
//        let tapRecogniser = UITapGestureRecognizer(target: self, action:#selector(showNavButtons))
        view.addSubview(mapView)
        mapView.isHidden = true
        view.addSubview(activity)
        activity.startAnimating()
        activity.hidesWhenStopped = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getUserData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.pin.all()
        startButton.pin
            .bottom(view.pin.safeArea.bottom + 20)
            .horizontally(30)
            .height(40)
        stackView.pin
            .vCenter()
            .height(160)
            .width(50)
            .right(view.pin.safeArea.right + 10)
        activity.pin.center()
        startButton.layer.cornerRadius = startButton.bounds.midY
        startButton.clipsToBounds = true
    }
    
    
    // Implement the delegate method that allows annotations to show callouts when tapped
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapView.isHidden = false
        view.addSubview(startButton)
        view.addSubview(stackView)
        activity.stopAnimating()
        let camera = MGLMapCamera(lookingAtCenter: mapView.userLocation!.coordinate, fromDistance: 4500, pitch: 30, heading: 0)
        mapView.fly(to: camera, withDuration: 6, peakAltitude: 3000, completionHandler: nil)
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MGLMapView, withError error: Error) {
        activity.stopAnimating()
        let alert = UIAlertController(title: "Ошибка", message: "Невозможно загрузить крату. Проверьте подключение к интернету", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        mapView.setCenter(annotation.coordinate, animated: true)
        for event in presenter.userEvents {
            if event.startPoint == annotation.coordinate {
                presenter.routeFromEvent(event: event)
            }
        }
    }
    
    // Present the navigation view controller when the callout is selected
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let navigationViewController = NavigationViewController(for: presenter.currentRoute)
        navigationViewController.modalPresentationStyle = .fullScreen
        self.present(navigationViewController, animated: true, completion: nil)
    }
    
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let image = UIImage(named: "userEvents-icon") {
            let annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "marker")
            return annotationImage
        }
        else { return nil }
    }
    
    func configureButtons() {
        plusButton.configure(iconName: "plus")
        minusButton.configure(iconName: "minus")
        locationButton.configure(iconName: "location.fill")
        plusButton.addTarget(self, action: #selector(tappedPlusButton(sender:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(tappedMinusButton(sender:)), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(tappedLocationButton(sender:)), for: .touchUpInside)
    }
    func configureStackView() {
        stackView = UIStackView(arrangedSubviews: [plusButton, minusButton, locationButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
    }
    
    //MARK: - @objc functions
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        // Converts point where user did a long press to map coordinates
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        if presenter.coordinates.count > 1 {
            startButton.isHidden = false
        }
        presenter.longPress(coordinate: coordinate)
    }
    
    
    @objc private func tappedCreateButton(sender: UIButton) {
        let navVC = NavVC()
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
        navVC.presenter = presenter
    }
    
    @objc private func tappedPlusButton(sender: RoundButton) {
        mapView.setZoomLevel(mapView.zoomLevel + 2, animated: true)
    }
    
    @objc private func tappedMinusButton(sender: RoundButton) {
        mapView.setZoomLevel(mapView.zoomLevel - 2, animated: true)
    }
    
    @objc private func tappedLocationButton(sender: RoundButton) {
        var mode: MGLUserTrackingMode
        
        switch (mapView.userTrackingMode) {
        case .none:
            mode = .follow
        case .follow:
            mode = .followWithHeading
        case .followWithHeading:
            mode = .followWithCourse
        case .followWithCourse:
            mode = .none
        @unknown default:
            fatalError("Unknown user tracking mode")
        }
        
        mapView.userTrackingMode = mode
    }
}
