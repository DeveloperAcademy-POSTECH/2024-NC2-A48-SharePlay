import GroupActivities
import SwiftUI
import PencilKit
import Combine

@MainActor
class CanvasController: ObservableObject {
    @Published var groupSession: GroupSession<SharePlay>?
    @Published var receivedDrawingData: Data?
    private var messenger: GroupSessionMessenger?
    private var subscriptions = Set<AnyCancellable>()
    private var tasks = Set<Task<Void, Never>>()
    
    func startSharing() {
        Task {
            do {
                _ = try await SharePlay().activate()
            } catch {
                print("Failed to activate SharePlay activity: \(error)")
            }
        }
    }
    
    func configureGroupSession(_ groupSession: GroupSession<SharePlay>) {
        self.groupSession = groupSession
        let messenger = GroupSessionMessenger(session: groupSession)
        self.messenger = messenger
        
        groupSession.$state
            .sink { [weak self] state in
                if case .invalidated = state {
                    self?.groupSession = nil
                    self?.reset()
                }
            }
            .store(in: &subscriptions)
        
        let task = Task {
            await self.receiveDrawingData()
        }
        tasks.insert(task)
        
        groupSession.join()
    }
    
    func sendDrawingData(_ drawingData: Data) {
        guard let messenger = messenger else { return }
        messenger.send(drawingData) { error in
            if let error = error {
                print("Error sending drawing data: \(error)")
            }
        }
    }
    
    private func receiveDrawingData() async {
        guard let messenger = messenger else { return }
        for try await (drawingData, _) in messenger.messages(of: Data.self) {
            self.receivedDrawingData = drawingData
        }
    }
    
    func reset() {
        messenger = nil
        tasks.forEach { $0.cancel() }
        tasks = []
        subscriptions = []
        if groupSession != nil {
            groupSession?.leave()
            groupSession = nil
            self.startSharing()
        }
    }
}
