//
//  WebSocketManager.swift
// 02.08.2024.
//

import RealmSwift

protocol WebSocketControlProtocol {
    func runWebSocketConnectionIfNeeded()
}

final class WebSocketManager: WebSocketServiceDelegate, WebSocketControlProtocol {
    static let shared = WebSocketManager()
    private var wsService: WebSocketServiceProtocol = DIManager.shared.container.resolve(WebSocketServiceProtocol.self)!
    private var storage = DIManager.shared.container.resolve(StorageProtocol.self)!

    private init() {
        Log.i("WebSocketManager empty init")
    }

    func runWebSocketConnectionIfNeeded() {
        Log.i("WebSocketManager runWebSocketConnectionIfNeeded")
        if storage.loadToken() != nil {
            wsService.connect()
            Log.i("WebSocketManager connect")
        } else {
            Log.e("WebSocketManager token not loaded")
        }
    }
    
    private func setupWebSocket() {
        wsService.delegate = self
        runWebSocketConnectionIfNeeded()
    }

    func didReceive(text: String) {
        handleTextMessage(text)
    }
    
    func didReceive(data: Data) {
        
    }
    
    private func handleTextMessage(_ string: String) {
        let data = string.data(using: .utf8)
        var handled = false
        
        if let data = data {
            do {
                let message = try JSONDecoder().decode(WSMail.self, from: data)
                Log.i("Received WebSocketMessage: \(string)")
                Log.i("UIDL: \(message.payload.uidl)")
                NotificationCenter.default.post(name: .didReceiveWSMail, object: message)
                handled = true
            } catch {
                Log.e("received message is not WebSocketMessage")
            }
        }
        
        if !handled {
            Log.e("Received text: \(string)")
        }
    }
}

extension Notification.Name {
    static let didReceiveWSMail = Notification.Name("didReceiveWSMail")
}


