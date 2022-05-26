//
//  Settings.swift
//  TBGB Control
//
//  Created by John Scholvin on 5/10/22.
//

import Foundation
import Combine
import Network

class Settings: ObservableObject {
    
    @Published var olaEnabled: Bool
    @Published var olaAddress: String
    @Published var olaPort: String // probably should be an Int but let's just get this done
    @Published var isValid = true
    @Published var addressMsg: String = ""
    
    init() {
        let defaults = UserDefaults.standard
        self.olaEnabled = defaults.bool(forKey: "olaEnabled")
        self.olaAddress = defaults.string(forKey: "olaAddress") ?? "192.168.1.100"
        self.olaPort = defaults.string(forKey: "olaPort") ?? "9090"
    }
    
    func persist_settings() {
        let defaults = UserDefaults.standard
        defaults.set(olaEnabled, forKey: "olaEnabled")
        defaults.set(olaAddress, forKey: "olaAddress")
        defaults.set(olaPort, forKey: "olaPort")
    }
    
    func get_ola_addr() -> String {
        return olaAddress + ":" + olaPort
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    // https://peterfriese.dev/posts/swift-combine-love/
    
    private var isAddressValidPublisher: AnyPublisher<Bool, Never> {
        $olaAddress
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                if let _ = IPv4Address(input) {
                    return true
                }
                return false
            }
            .eraseToAnyPublisher()
    }
    
    private var isPortValidPublisher: AnyPublisher<Bool, Never> {
        $olaPort
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                if let _ = Int(input) {
                    return true
                }
                return false
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isAddressValidPublisher, isPortValidPublisher)
            .map { addressIsValid, portIsValid in
                return addressIsValid && portIsValid
            }
            .eraseToAnyPublisher()
    }
    
    init(olaEnabled: Bool, olaAddress: String, olaPort: String) {
        self.olaEnabled = olaEnabled
        self.olaAddress = olaAddress
        self.olaPort = olaPort
        
        isAddressValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Invalid IP address"
            }
            .assign(to: \.addressMsg, on: self)
            .store(in: &cancellableSet)
        
        isPortValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Invalid port"
            }
            .assign(to: \.addressMsg, on: self)
            .store(in: &cancellableSet)
        
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
}
