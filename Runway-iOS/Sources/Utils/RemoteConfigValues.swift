//
//  RemoteConfigValues.swift
//  Runway-iOS
//
//  Created by 김인환 on 4/26/24.
//

import UIKit
import FirebaseRemoteConfig
import OSLog

enum ValueKey: String {
    case initialScreen = "initial_screen"
}

final class RemoteConfigValues {
    static let shared = RemoteConfigValues()

    private init() {
        loadDefaultValue()
        Task {
            await fetchCloudValues()
        }
    }

    private func loadDefaultValue() {
        let appDefaults: [String: Any?] = [
            ValueKey.initialScreen.rawValue: "home"
        ]

        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }

    private func fetchCloudValues() async {
        do {
            try await RemoteConfig.remoteConfig().fetch()
            try await RemoteConfig.remoteConfig().activate()
        } catch {
            os_log(.error, "%@", error.localizedDescription)
        }
    }

    func string(forKey key: ValueKey) -> String {
        RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
    }
}
