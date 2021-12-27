//
//  MKMapView+RxDelegateProxy.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/26/21.
//

import CoreLocation
import Foundation
import RxCocoa
import RxSwift
import UIKit
import MapKit

extension MKMapView: HasDelegate {
    public typealias Delegate = MKMapViewDelegate
}

class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, DelegateProxyType, MKMapViewDelegate {
    public private(set) weak var mapView: MKMapView?
    public init(mapView: ParentObject) {
        self.mapView = mapView
        super.init(parentObject: mapView, delegateProxy: RxMKMapViewDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxMKMapViewDelegateProxy(mapView: $0) }
    }
}

extension Reactive where Base: MKMapView {
    var delegate: DelegateProxy<MKMapView, MKMapViewDelegate> {
        return RxMKMapViewDelegateProxy.proxy(for: base)
    }
    
    public var pin: Binder<MKPointAnnotation> {
        return Binder(self.base) { mapView, pin in
            mapView.addAnnotation(pin)
        }
    }
    
    func setDelegate(_ delegate: MKMapViewDelegate) -> Disposable {
        return RxMKMapViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: base)
    }
    
    public var didChangeCenter: Observable<CLLocationCoordinate2D> {
        return delegate.methodInvoked(#selector(MKMapViewDelegate.mapViewDidChangeVisibleRegion(_:)))
            .map { params in (params[0] as! MKMapView).centerCoordinate }
    }
}

