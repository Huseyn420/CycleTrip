//
//  RouteCreationView.swift
//  CycleTrip
//
//  Created by Igor Lebedev on 27/05/2021.
//  Copyright © 2021 CycleTrip. All rights reserved.
//

import UIKit

class RouteCreationView: UIView {
    var presenter: MapPresenter!
    let createButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Создать событие", for: .normal)
        btn.backgroundColor = .lightGray
        btn.isEnabled = false
        btn.pin.height(40)
        btn.layer.cornerRadius = btn.bounds.midY
        btn.clipsToBounds = true
        return btn
    }()
    
    let numberOfPoints: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    let distance: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let closeButton: UIButton = {
        let btn = UIButton(type: .close)
        btn.addTarget(self, action: #selector(tappedCloseButton(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrowshape.turn.up.left"), for: .normal)
        btn.addTarget(self, action: #selector(tappedBackButton(sender:)), for: .touchUpInside)
        return btn
    }()
	
	convenience init(presenter: MapPresenter) {
		self.init()
		self.presenter = presenter
		presenter.routeCreationView = self
		self.backgroundColor = .white
        isHidden = true
	}

	override func draw(_ rect: CGRect) {
        addSubview(createButton)
        addSubview(numberOfPoints)
        addSubview(distance)
        addSubview(closeButton)
        addSubview(backButton)
        createButton.pin
            .bottom(50)
            .horizontally(15)
        distance.pin
            .hCenter()
            .bottom(105)
            .height(40)
            .width(100)
        numberOfPoints.pin
            .right(15)
            .bottom(105)
            .width(65)
            .height(40)
        closeButton.pin
            .size(40)
            .left(15)
            .bottom(105)
        backButton.pin
            .size(40)
            .bottom(105)
            .before(of: numberOfPoints)
		layer.cornerRadius = 20
    }

    @objc private func tappedCloseButton(sender: UIButton) {
        isHidden = true
        presenter.cleanCash()
    }
    
    @objc private func tappedBackButton(sender: UIButton) {
        presenter.removePoint()
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
}
