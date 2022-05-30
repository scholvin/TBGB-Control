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
    @Published var svcPort: String
    @Published var isValid = true
    @Published var addressMsg: String = ""
    
    init() {
        let defaults = UserDefaults.standard
        self.olaEnabled = defaults.bool(forKey: "olaEnabled")
        self.olaAddress = defaults.string(forKey: "olaAddress") ?? "192.168.0.100"
        self.olaPort = defaults.string(forKey: "olaPort") ?? "9090"
        self.svcPort = defaults.string(forKey: "svcPort") ?? "5000"
    }
    
    func persist_settings() {
        let defaults = UserDefaults.standard
        defaults.set(olaEnabled, forKey: "olaEnabled")
        defaults.set(olaAddress, forKey: "olaAddress")
        defaults.set(olaPort, forKey: "olaPort")
        defaults.set(svcPort, forKey: "svcPort")
    }
    
    func get_ola_addr() -> String {
        return olaAddress + ":" + olaPort
    }
    
    func get_svc_addr() -> String {
        return olaAddress + ":" + svcPort
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    // https://peterfriese.dev/posts/swift-combine-love/
    // TODO: something in the delta where I added cpuinfo broke these :-(
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
    
    private var isOlaPortValidPublisher: AnyPublisher<Bool, Never> {
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
    
    private var isSvcPortValidPublisher: AnyPublisher<Bool, Never> {
        $svcPort
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
        Publishers.CombineLatest3(isAddressValidPublisher, isOlaPortValidPublisher, isSvcPortValidPublisher)
            .map { addressIsValid, olaPortIsValid, svcPortIsValid in
                return addressIsValid && olaPortIsValid && svcPortIsValid
            }
            .eraseToAnyPublisher()
    }
    
    init(olaEnabled: Bool, olaAddress: String, olaPort: String, svcPort: String) {
        self.olaEnabled = olaEnabled
        self.olaAddress = olaAddress
        self.olaPort = olaPort
        self.svcPort = svcPort
        
        isAddressValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Invalid IP address"
            }
            .assign(to: \.addressMsg, on: self)
            .store(in: &cancellableSet)
        
        isOlaPortValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Invalid OLA port"
            }
            .assign(to: \.addressMsg, on: self)
            .store(in: &cancellableSet)
        
        isSvcPortValidPublisher
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Invalid svc port"
            }
            .assign(to: \.addressMsg, on: self)
            .store(in: &cancellableSet)
        
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
}
