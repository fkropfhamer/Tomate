//
//  CallAlarm.swift
//  Tomate
//
//  Created by Fabian Kropfhamer on 22.04.22.
//

import CallKit
import SwiftUI

let callId = UUID()

class ProviderDelegate: NSObject {
      public let provider: CXProvider
      
    override init() {
        
        // 2.
        provider = CXProvider(configuration: ProviderDelegate.providerConfiguration)
        
        super.init()
        // 3.
        provider.setDelegate(self, queue: nil)
      }
      
      // 4.
      static var providerConfiguration: CXProviderConfiguration = {
        let providerConfiguration = CXProviderConfiguration()
          
        
        
        providerConfiguration.supportsVideo = false
        providerConfiguration.maximumCallsPerCallGroup = 1
          providerConfiguration.supportedHandleTypes = [.phoneNumber, .generic]
          providerConfiguration.includesCallsInRecents = false
        
        
        return providerConfiguration
      }()
    
}

extension ProviderDelegate: CXProviderDelegate {
  func providerDidReset(_ provider: CXProvider) {
      print("reset")
  }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("end")
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        let controller = CXCallController()
        let transaction = CXTransaction(action:
        CXEndCallAction(call: callId))
        controller.request(transaction,completion: { error in })
        //self.provider(provider, perform: CXEndCallAction(call: callId))
        action.fulfill()
    }
}

let provider = ProviderDelegate()
var workItem: DispatchWorkItem? = nil

func cancel() {
    workItem!.cancel()
}

func call() {
    print("call")
    
    let update = CXCallUpdate()
    update.remoteHandle = CXHandle(type: .phoneNumber, value: "test")
    
    workItem = DispatchWorkItem {
        provider.provider.reportNewIncomingCall(with: callId, update: update, completion: { (err) in print(err) })
    }
    
     UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem!)
}
