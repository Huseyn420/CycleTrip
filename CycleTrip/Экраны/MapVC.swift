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
    var stackView: UIStackView!
    let plusButton = RoundButton()
    let minusButton = RoundButton()
    let locationButton = RoundButton()
    let activity = UIActivityIndicatorView(style: .large)
    let routeCreationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    let createButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Создать событие", for: .normal)
        btn.backgroundColor = .lightGray
        btn.addTarget(self, action: #selector(tappedCreateButton(sender:)), for: .touchUpInside)
        btn.isEnabled = false
        btn.isHidden = true
        return btn
    }()
    let numberOfPoints: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.isHidden = true
        return label
    }()
    let distance: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.isHidden = true
        return label
    }()
    let closeButton: UIButton = {
        let btn = UIButton(type: .close)
        btn.isHidden = true
        return btn
    }()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        presenter = MapPresenter(mapVC: self)
        
        mapView.showsUserLocation = true
        mapView.showsHeading = true
        mapView.delegate = self
        mapView.setCenter(CLLocationCoordinate2D(latitude: 55.453013, longitude: 48.205561), zoomLevel: 3, animated: false)

        view.addSubview(mapView)
        mapView.isHidden = true
        
        configureButtons()
        configureStackView()
        
        // Add a gesture recognizer to the map view
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        mapView.addGestureRecognizer(longPress)


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
        createButton.pin
            .bottom(view.pin.safeArea.bottom + 10)
            .horizontally(15)
            .height(40)
        stackView.pin
            .vCenter()
            .height(160)
            .width(50)
            .right(view.pin.safeArea.right + 10)
        routeCreationView.pin
            .horizontally()
            .bottom()
            .height(150)
        activity.pin.center()
        numberOfPoints.pin
            .right(15)
            .bottom(105)
            .width(100)
            .height(40)
        distance.pin
            .hCenter()
            .bottom(105)
            .height(40)
            .width(100)
        closeButton.pin
            .size(30)
            .left(15)
            .bottom(105)
        createButton.layer.cornerRadius = createButton.bounds.midY
        createButton.clipsToBounds = true
    }
    
    func configureButtons() {
        plusButton.configure(iconName: "plus")
        minusButton.configure(iconName: "minus")
        locationButton.configure(iconName: "location.fill")
        plusButton.addTarget(self, action: #selector(tappedPlusButton(sender:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(tappedMinusButton(sender:)), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(tappedLocationButton(sender:)), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(tappedCloseButton(sender:)), for: .touchUpInside)
    }
    func configureStackView() {
        stackView = UIStackView(arrangedSubviews: [plusButton, minusButton, locationButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
    }
    

    // Implement the delegate method that allows annotations to show callouts when tapped
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapView.isHidden = false
        activity.stopAnimating()
        
        view.addSubview(stackView)
        view.addSubview(routeCreationView)
        view.addSubview(createButton)
        view.addSubview(numberOfPoints)
        view.addSubview(distance)
        view.addSubview(closeButton)
        

        let camera = MGLMapCamera(lookingAtCenter: mapView.userLocation!.coordinate, acrossDistance: 4500, pitch: 30, heading: 0)
        mapView.fly(to: camera, withDuration: 6, peakAltitude: 3000, completionHandler: nil)
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MGLMapView, withError error: Error) {
        activity.stopAnimating()
        let alert = UIAlertController(title: "Ошибка", message: "Невозможно загрузить карту. Проверьте подключение к интернету", preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        mapView.setCenter(annotation.coordinate, animated: true)
        for (_,event) in presenter.userEvents {
            if event.startPoint == annotation.coordinate {
                presenter.showEventRoute(event: event)
                break
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

    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
    return UIButton(type: .detailDisclosure)
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        let alert = UIAlertController(title: annotation.title!!, message: "Выберите действие", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { (action) in
            self.presenter.removeUserEvent(startPoint: annotation.coordinate)
            mapView.deselectAnnotation(annotation, animated: true)
            mapView.removeAnnotation(annotation)
            })
//        alert.addAction(UIAlertAction(title: "Начать движение", style: .default, handler: {
//
//        }))
            self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Сохранено", message: "Вы успешно создали событие", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideCreateStuff(_ flag: Bool) {
        routeCreationView.isHidden = flag
        numberOfPoints.isHidden = flag
        distance.isHidden = flag
        createButton.isHidden = flag
        closeButton.isHidden = flag
    }
    
    func makeCreateButtonActive(_ flag: Bool) {
        createButton.isEnabled = flag
        switch flag {
        case true:
            createButton.backgroundColor = .systemBlue
        case false:
            createButton.backgroundColor = .lightGray
        }
    }
    
    //MARK: - @objc functions
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        // Converts point where user did a long press to map coordinates
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        presenter.addPoint(coordinate: coordinate)
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
    @objc private func tappedCloseButton(sender: UIButton) {
        hideCreateStuff(true)
        presenter.cleanCash()
    }
    
}
