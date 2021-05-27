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

final class MapViewController: UIViewController, MGLMapViewDelegate {
	var presenter: MapPresenter!
    var mapButtonsView: MapButtonsView!
    var routeCreationView: RouteCreationView!
    var navVC: NavVC?
	let mapView: MGLMapView = {
		let mapView = MGLMapView()
		mapView.showsUserLocation = true
        mapView.showsHeading = true
		mapView.setCenter(CLLocationCoordinate2D(latitude: 55.453013, longitude: 48.205561), zoomLevel: 3, animated: false)
		mapView.isHidden = true
		return mapView
	}()
	let activity: UIActivityIndicatorView = {
		let activity = UIActivityIndicatorView(style: .large)
		activity.hidesWhenStopped = true
        activity.startAnimating()
		return activity
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
		presenter = MapPresenter(mapVC: self, mapView: self.mapView)
		routeCreationView = RouteCreationView(presenter: presenter)
        mapButtonsView = MapButtonsView(mapView: mapView)
        mapView.delegate = self
		let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        mapView.addGestureRecognizer(longPress)
        view.addSubview(mapView)
        view.addSubview(activity)
		configureButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getUserData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.pin.all()
        mapButtonsView.pin
            .vCenter()
            .height(160)
            .width(50)
            .right(view.pin.safeArea.right + 10)
        routeCreationView.pin
            .horizontally()
            .bottom()
            .height(150)
        activity.pin.center()
    }
    
    func configureButtons() {
        routeCreationView.createButton.addTarget(self, action: #selector(tappedCreateButton(sender:)), for: .touchUpInside)
    }

    // Implement the delegate method that allows annotations to show callouts when tapped
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return annotation.title != nil
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapView.isHidden = false
        activity.stopAnimating()
        view.addSubview(routeCreationView)
        view.addSubview(mapButtonsView)
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
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if annotation.title != "" {
            if var image = UIImage(named: "userEvents-icon") {
                image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height / 2, right: image.size.width / 2))
                let annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "marker")
                return annotationImage
            }
            else { return nil }
        }
        else {
            if var image = UIImage(named: "points-icon") {
                image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height / 2, right: image.size.width / 2))
                let annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "point")
                return annotationImage
            }
            else { return nil }
        }
    }

    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        let alert = UIAlertController(title: annotation.title!!, message: "Выберите действие", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Начать движение", style: .default, handler: { (action) in
            let navigationViewController = NavigationViewController(for: self.presenter.currentRoute)
            navigationViewController.modalPresentationStyle = .fullScreen
            self.present(navigationViewController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { (action) in
            self.presenter.removeUserEvent(startPoint: annotation.coordinate)
            mapView.deselectAnnotation(annotation, animated: true)
            mapView.removeAnnotation(annotation)
            })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Сохранено", message: "Вы успешно создали событие", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - @objc functions
    @objc private func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        // Converts point where user did a long press to map coordinates
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        routeCreationView.isHidden = false
        presenter.addPoint(coordinate: coordinate)
    }
    
    @objc private func tappedCreateButton(sender: UIButton) {
        navVC = NavVC()
        navVC!.modalPresentationStyle = .fullScreen
        navVC!.presenter = presenter
        present(navVC!, animated: true, completion: nil)
    }
}
