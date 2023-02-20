//
//  RxCLLocationDelegateProxy.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import CoreLocation
import RxSwift
import RxCocoa

class RxCLLocationDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    static func registerKnownImplementations() {
        self.register { manager -> RxCLLocationDelegateProxy in
            RxCLLocationDelegateProxy(parentObject: manager, delegateProxy: self)
        }
    }

    static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
        object.delegate = delegate
    }
}

extension CLLocation {
    public var isValid: Bool {
        guard self.coordinate.longitude != 0 && self.coordinate.latitude != 0 else { return false }
        return CLLocationCoordinate2DIsValid(self.coordinate)
    }
}

extension CLLocationCoordinate2D {
    public var isValid: Bool {
        guard self.longitude != 0 && self.latitude != 0 else { return false }
        return CLLocationCoordinate2DIsValid(self)
    }
}

extension ObservableType where Element == (CLLocation,CLLocation) {
    func distance() -> Observable<CLLocationDistance>  {
        return map { value in
            let from = value.0
            let to   = value.1
            return from.distance(from: to)
        }
    }
}

extension ObservableType where Element == CLLocation {
    func filterValid() -> Observable<CLLocation> {
        return filter { value in
            return value.isValid
        }
    }
}
