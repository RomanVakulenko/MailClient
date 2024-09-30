//
//  WebSocketService.swift
// 02.08.2024.
//

import UIKit
import Starscream

protocol WebSocketServiceProtocol {
    func connect()
    func disconnect()
    var delegate: WebSocketServiceDelegate? { get set }
}

protocol WebSocketServiceDelegate: AnyObject {
    func didReceive(text: String)
    func didReceive(data: Data)
}

final class WebSocketService: WebSocketDelegate, WebSocketServiceProtocol {
    private let secretStorage = DIManager.shared.container.resolve(SecretStorageProtocol.self)!
    private let storage = DIManager.shared.container.resolve(StorageProtocol.self)!
    private var socket: WebSocket!
    private var token: String = ""
    private var pingTimer: Timer?
    weak var delegate: WebSocketServiceDelegate?

    init() {
        if let token = storage.loadToken() {
            self.token = token
            setupWebSocket()
        } else {
            Log.e("Token is empty")
        }
    }

    private func setupWebSocket() {
        guard let url = URL(string: "wss://" + secretStorage.serverTrustManagerEvaluators + "/somehost/push/") else {
            Log.e("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.addValue(getUserAgent(), forHTTPHeaderField: "User-Agent")

        let pinner = FoundationSecurity(allowSelfSigned: true)
        socket = WebSocket(request: request, certPinner: pinner)
        socket.callbackQueue = DispatchQueue.main
        socket.delegate = self
        Log.i("WebSocket setup completed with URL: \(url)")
    }

    func connect() {
        if socket == nil {
            if let token = storage.loadToken() {
                self.token = token
                setupWebSocket()
                socket.connect()
            } else {
                Log.e("WebSocket is no connect without token")
            }
        } else {
            socket.connect()
            Log.i("WebSocket is connecting...")
        }
    }

    func disconnect() {
        socket.disconnect()
        Log.i("WebSocket is disconnecting...")
    }

    private func tryToReconnect() {
        Log.i("WebSocket try to reconnect after 5 sec ...")
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5, execute: DispatchWorkItem(block: { [weak self] in
            self?.connect()
        }))
    }
    
    // MARK: - WebSocketDelegate

    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            Log.i("WebSocket is connected: \(headers)")
            startPing()
        case .disconnected(let reason, let code):
            Log.i("WebSocket is disconnected: \(reason) with code: \(code)")
            tryToReconnect()
        case .text(let textMessage):
            Log.i("Received text: \(textMessage)")
            delegate?.didReceive(text: textMessage)
        case .binary(let data):
            Log.i("Received data: \(data.count)")
            delegate?.didReceive(data: data)
        case .ping(_):
            print("WebSocket ping")
            break
        case .pong(_): //let data):
            print("WebSocket pong")
            break
        case .viabilityChanged(_):
            print("WebSocket viability changed")
            break
        case .reconnectSuggested(_):
            print("WebSocket reconnect suggested")
            break
        case .cancelled:
            Log.i("WebSocket connection cancelled")
            tryToReconnect()
        case .error(let error):
            handleError(error)
            tryToReconnect()
        case .peerClosed:
            Log.i("WebSocket connection closed")
            tryToReconnect()
        }
    }

    private func handleError(_ error: Error?) {
        if let e = error as? WSError {
            Log.e("WebSocket encountered an error: \(e.message)")
        } else if let e = error {
            Log.e("WebSocket encountered an error: \(e.localizedDescription)")
        } else {
            Log.e("WebSocket encountered an error")
        }
    }

    // MARK: - Utility
    
    private func getUserAgent() -> String {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "UnknownApp"
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let device = UIDevice.current.model
        let osVersion = UIDevice.current.systemVersion
        let locale = Locale.current.identifier

        return "\(appName)/\(appVersion) (\(device); iOS \(osVersion); \(locale))"
    }
    
    private func startPing() {
        stopPing() // Ensure no previous timer is running
        pingTimer = Timer.scheduledTimer(timeInterval: 45.0, target: self, selector: #selector(sendPing), userInfo: nil, repeats: true)
        pingTimer?.tolerance = 5
    }
    
    private func stopPing() {
        pingTimer?.invalidate()
        pingTimer = nil
    }
    
    @objc private func sendPing() {
        socket.write(ping: Data())
        let timestamp = Date().timeIntervalSince1970
        print("WebSocket Ping sent at \(timestamp)")
    }
}
