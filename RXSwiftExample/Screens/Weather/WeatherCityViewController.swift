//
//  WeatherCityViewController.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import CoreLocation
import MapKit
import RxCocoa
import RxSwift
import RxSwiftExt
import UIKit
 
class WeatherCityViewController: BaseViewController {
    // MARK: - Outlets

    @IBOutlet private var searchCityName: UITextField!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var iconLabel: UILabel!
    @IBOutlet private var cityNameLabel: UILabel!
    @IBOutlet private var containerView: UIStackView!
    @IBOutlet private var locationButton: UIButton!
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var mapButton: UIButton!
    
    // MARK: - Properties

    var presenter: WeatherCityPresenter?
    
    // MARK: - Private properties

    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private let locationTracker = LocationTracker(threshold: 30)
    
    // MARK: - Life cycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        locationTracker.stopUpdatingLocation()
    }
    
    override func setupUI() {
        navigationItem.title = "Weather City"
    }
    
    override func bindingPresenterInputs() {
        guard let presenter = presenter else {
            return
        }
        
        // textSearch trigger
        searchCityName
            .rx
            .controlEvent(.editingDidEndOnExit)
            .map { [searchCityName] in searchCityName?.text ?? "" }
            .filter { !$0.isEmpty }
            .bind(to: presenter.inputs.textSearchTrigger)
            .disposed(by: disposeBag)

        // mapview change center trigger
        let mapViewChangeCenterTrigger = mapView.rx
            .didChangeCenter
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
        
        // location button tap trigger
        let userTap = locationButton.rx.tap.asObservable()
            .do(onNext: { [weak self] in
                // locationTracker.startTracking()
                self?.locationManager.requestWhenInUseAuthorization()
                self?.locationManager.startUpdatingLocation()
            })
        let locationUpdated = locationManager
            .rx
            .didUpdateLocations
            .map { locations in locations[0] }
            .filter { location in
                location.horizontalAccuracy < kCLLocationAccuracyHundredMeters
            }
        
        let userLocationChangeTrigger = userTap.flatMap { locationUpdated }
            .map { $0.coordinate }
        
        Observable.merge([mapViewChangeCenterTrigger, userLocationChangeTrigger])
        
            .bind(to: presenter.inputs.locationSearchTrigger)
            .disposed(by: disposeBag)
    }
    
    override func bindingPresenterOutputs() {
        // isLoading trigger
        presenter?.outputs
            .isLoading
            .bind(to: self.view.rx.isLoadingHUD)
            .disposed(by: disposeBag)
        
        let isLoadingDriver = presenter?.outputs
            .isLoading
            .asDriver(onErrorJustReturn: false)
        isLoadingDriver?
            .drive(containerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        isLoadingDriver?
            .drive(iconLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        // weather trigger
        let weatherDriver = presenter?.outputs
            .weather
            .asDriver(onErrorJustReturn: .dummy)
        
        weatherDriver?.map { "\($0.temperature) °C" }
            .drive(tempLabel.rx.text)
            .disposed(by: disposeBag)
        
        weatherDriver?.map { $0.cityName }
            .drive(cityNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        weatherDriver?.map { "\($0.humidity) %" }
            .drive(humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
        weatherDriver?.map { $0.icon }
            .drive(iconLabel.rx.text)
            .disposed(by: disposeBag)
        
        weatherDriver?.map { $0.cityName }
            .drive(rx.title)
            .disposed(by: disposeBag)
        
        weatherDriver?
            .map { weather -> MKPointAnnotation in
                let pin = MKPointAnnotation()
                pin.title = weather.cityName
                pin.subtitle = "\(weather.temperature) °C - \(weather.humidity) % - \(weather.icon)"
                pin.coordinate = weather.coordinate
                return pin
            }
            .drive(mapView.rx.pin)
            .disposed(by: disposeBag)
        
        // error trigger
        presenter?.outputs
            .error
            .bind(to: self.rx.errorAlert)
            .disposed(by: disposeBag)
        
        // mapview trigger
        mapView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        // mapButton trigger
        mapButton.rx.tap
            .subscribe(onNext: { [mapView] in
                mapView?.isHidden.toggle()
            })
            .disposed(by: disposeBag)
    }
    
    override func setupData() {}
}

// MARK: - Custom Binder

extension Reactive where Base: WeatherCityViewController {
    var title: Binder<String> {
        return Binder(self.base) { vc, value in
            vc.title = value
        }
    }
}

// MARK: - MapView Delegate

extension WeatherCityViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.animatesDrop = true
        pin.pinTintColor = .red
        pin.canShowCallout = true
        return pin
    }
}

extension CLLocation {
    /// Get distance between two points
    ///
    /// - Parameters:
    ///   - from: first point
    ///   - to: second point
    /// - Returns: the distance in meters
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
