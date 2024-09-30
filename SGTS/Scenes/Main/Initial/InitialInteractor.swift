//
//  InitialInteractor.swift
// 01.04.2024.
//

import Foundation

protocol InitialBusinessLogic {
    func onDidLoadViews(request: InitialFlow.OnDidLoadViews.Request)
    func onDidAppear(request: InitialFlow.OnDidAppear.Request)
    func onSelectItem(request: InitialFlow.OnSelectItem.Request)
}

protocol InitialDataStore: AnyObject {

}

final class InitialInteractor: InitialBusinessLogic, InitialDataStore {

    var presenter: InitialPresentationLogic?
    var worker: InitialWorkingLogic?
    let storage = DIManager.shared.container.resolve(StorageProtocol.self)!
    let cryptoLayer = DIManager.shared.container.resolve(CryptoLayerProtocol.self)!
    

    func onDidLoadViews(request: InitialFlow.OnDidLoadViews.Request) {
        presenter?.presentUpdate(response: InitialFlow.Update.Response())
    }
    
    func onSelectItem(request: InitialFlow.OnSelectItem.Request) { }

    func onDidAppear(request: InitialFlow.OnDidAppear.Request) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10,
                                          execute: { [weak self] in
                self?.presenter?.presentRouteToTabBar(response: InitialFlow.RoutePayload.Response())
            })
    }
    
    private func isTokenValid(expiryTime: String) -> Bool {
        guard let expiryTimeInterval = TimeInterval(expiryTime)
        else { return false }
        let currentTimeInterval = Date().timeIntervalSince1970
        return currentTimeInterval < expiryTimeInterval
    }
}
