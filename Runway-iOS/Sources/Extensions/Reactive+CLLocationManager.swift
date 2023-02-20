//
//  Reactive+CLLocationManager.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/21.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

extension Reactive where Base: CLLocationManager {
    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationDelegateProxy.proxy(for: self.base)
    }

    var updateLocations: Observable<CLLocation> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))).map { ($0.last! as! NSArray).lastObject as! CLLocation }
    }
}
