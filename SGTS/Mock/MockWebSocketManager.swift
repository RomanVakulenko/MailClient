//
//  MockWebSocketManager.swift
// 05.08.2024.
//

final class MockWebSocketManager: WebSocketControlProtocol {
    static let shared = MockWebSocketManager()
    private init() {}
    
    func runWebSocketConnectionIfNeeded() {
        Log.i("MockWebSocketManager runWebSocketConnectionIfNeeded")
    }
}
