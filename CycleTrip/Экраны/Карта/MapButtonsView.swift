//
//  MapButtonsView.swift
//  CycleTrip
//
//  Created by Igor Lebedev on 27/05/2021.
//  Copyright © 2021 CycleTrip. All rights reserved.
//

import UIKit
import Mapbox

class MapButtonsView: UIView {
    var mapView: MGLMapView!
    var stackView: UIStackView!
    let plusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "plus")!, for: .normal)
        button.addTarget(self, action: #selector(tappedPlusButton(sender:)), for: .touchUpInside)
        return button
    }()
    let minusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "minus")!, for: .normal)
        button.addTarget(self, action: #selector(tappedMinusButton(sender:)), for: .touchUpInside)
        return button
    }()
    let locationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "location.fill")!, for: .normal)
        button.addTarget(self, action: #selector(tappedLocationButton(sender:)), for: .touchUpInside)
        return button
    }()
	
	convenience init(mapView: MGLMapView) {
		self.init()
		self.mapView = mapView
	}
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureStackView()
        addSubview(stackView)
        stackView.pin.all()
    }
    
    func configureStackView() {
        stackView = UIStackView(arrangedSubviews: [plusButton, minusButton, locationButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
    }
    
    @objc private func tappedPlusButton(sender: UIButton) {
        mapView.setZoomLevel(mapView.zoomLevel + 2, animated: true)
    }
    
    @objc private func tappedMinusButton(sender: UIButton) {
        mapView.setZoomLevel(mapView.zoomLevel - 2, animated: true)
    }
    
    @objc private func tappedLocationButton(sender: UIButton) {
        switch (mapView.userTrackingMode) {
        case .none:
            mapView.userTrackingMode = .follow
        case .follow:
            mapView.userTrackingMode = .followWithHeading
        case .followWithHeading:
            mapView.userTrackingMode = .followWithCourse
        case .followWithCourse:
            mapView.userTrackingMode = .none
        @unknown default:
            fatalError("Unknown user tracking mode")
        }
    }

}
