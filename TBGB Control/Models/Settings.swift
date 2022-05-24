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
