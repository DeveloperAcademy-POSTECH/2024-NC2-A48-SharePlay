import GroupActivities
import SwiftUI
import PencilKit
import Combine

@MainActor
class CanvasController: ObservableObject {
    @Published var groupSession: GroupSession<SharePlay>?
    @Published var receivedDrawingData: Data? = nil
    private var messenger: GroupSessionMessenger?
    private var subscriptions = Set<AnyCancellable>()
    
    func configureGroupSession(_ groupSession: GroupSession<SharePlay>) {
        self.groupSession = groupSession
        let messenger = GroupSessionMessenger(session: groupSession)
        self.messenger = messenger
        
        // groupSession의 상태를 확인한다.
        groupSession.$state
            .sink { state in
                if case .invalidated = state {
                    self.groupSession = nil
                }
            }
            .store(in: &subscriptions)
        
        // 받은 drawing데이터를 messenger를 통하여 보낸다.
        Task {
            for await (message, _) in messenger.messages(of: Data.self){
                receiveDrawingData()
            }
        }
        
        groupSession.join()
    }
    
    // 상대방의 앱으로 drawingData를 보낸다.
    func sendDrawingData(_ drawingData: Data) {
        guard let messenger = messenger else { return }
        messenger.send(drawingData) { error in
            if let error = error {
                print("Error sending drawing data: \(error)")
            }
        }
    }
    
    // 상대방 앱의 drawingData를 받을 때 사용하는 함수
    private func receiveDrawingData() {
        guard let messenger = messenger else { return }
        Task {
            for await (drawingData, _) in messenger.messages(of: Data.self) {
                DispatchQueue.main.async {
                    self.receivedDrawingData = drawingData
                }
            }
        }
    }
}
