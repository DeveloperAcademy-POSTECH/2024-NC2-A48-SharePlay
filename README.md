# 2024-NC2-A48-SharePlay
## 🎥 Youtube Link
(추후 만들어진 유튜브 링크 추가)

## 💡 About SharePlay
SharePlay는 FaceTime 통화 중에 참여하는 모든 기기에서 **앱 재생을** **동기화**하여 모든 사람이 **동시에 경험**을 즐길 수 있는 원활한 미디어 및 콘텐츠 공유를 도와줍니다. 
Apple Music, Apple TV, Apple Fitness+와 같은 다양한 Apple 앱에서도 사용할 수 있고, SharePlay API를 통해 개발자들이 자신의 앱에 SharePlay 기능을 통합할 수 있도록 지원하고 있습니다.

대표적인 예시로는 FaceTime 통화하면서 영화 보기, 음악 듣기, 또는 화이트보드에서 아이디어 스케치와 같은 활동을 공유할 수 있습니다.

![[함께 보기] 영화와 TV 프로그램을 동기화해 스트리밍하면서 FaceTime으로 소통](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A48-SharePlay/assets/144869234/d525acc9-e9de-4c74-abcb-8c7de4e70f53 "[함께 보기] 영화와 TV 프로그램을 동기화해 스트리밍하면서 FaceTime으로 소통")
![[함께 운동하기] Apple Fitness+를 통해 함께 운동하거나 명상](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A48-SharePlay/assets/144869234/52629ec1-e8c9-4cf1-bfab-f4cc9b18f969 "[함께 운동하기] Apple Fitness+를 통해 함께 운동하거나 명상")
![[함께 듣기] FaceTime 통화에 음악, 앨범, 플레이리스트를 곧바로 불러와 음악 감상 경험을 공유](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A48-SharePlay/assets/144869234/587d05c5-117b-4749-a9bc-ffbf1b9698b0 "[함께 듣기] FaceTime 통화에 음악, 앨범, 플레이리스트를 곧바로 불러와 음악 감상 경험을 공유")

[SharePlay HIG 바로가기](https://developer.apple.com/kr/design/human-interface-guidelines/shareplay/)

### What is GroupActivities?
Group Activities는 SharePlay를 통해 여러 참여자가 함께 사용할 수 있는 콘텐츠와 애플리케이션의 협업 환경을 제공하는 프레임워크입니다. 앱에 Group Activities 프레임워크를 추가하면 FaceTime, Messages, AirDrop을 통해 앱의 기능을 공유할 수 있습니다. 

[GroupActivities Developer Doc 바로가기](https://developer.apple.com/documentation/groupactivities/defining-your-apps-shareplay-activities)

## 🎯 What we focus on
SharePlay는 다양한 기능을 제공하기보다는 하나의 기술로서 매우 명확하고 특정한 목적을 가지고 있으며, **실시간 상호작용**과 **미디어 감상**에 중점을 둔 기술입니다.

화면 미러링이 단순히 화면을 공유하는 것이라면, **SharePlay**는 한 단계 더 나아가 **실시간으로 콘텐츠를 제어하고 동기화하는 기능을 제공**합니다. 이를 통해 모든 참가자가 동시에 콘텐츠를 재생하고, 일시 정지하며, 되감기 등의 작업을 수행할 수 있어 각자의 디바이스에서 동일한 경험을 즐길 수 있습니다.

> 처음에는 SharePlay의 기능을 서로의 화면을 실시간으로 공유하는 것이라고 이해하고, UseCase를 서로의 화면을 실시간으로 공유하고 볼 수 있는 ‘모각공’을 떠올렸습니다.
그러나 SharePlay에 대해 더 깊이 조사한 결과, 실시간 화면 공유를 넘어 미디어나 음악 등의 콘텐츠를 제어하고, 이를 서로의 화면에 동기화하는 기능을 제공한다는 것을 알게 되었습니다. 그래서 저희는 ‘실시간 상호작용’과 ‘동기화’에 집중하게 되었습니다.

## 💼 Use Case
**💡 SharePlay를 활용한 실시간 수학 문제 풀이 공유 캔버스**
> ***PencilKit***을 이용해 수학 문제를 풀 수 있는 캔버스를 개발하고, ***SharePlay***를 활용하여 사용자들이 실시간으로 캔버스에 문제 풀이를 작성하고, 공유할 수 있도록 구현하는 것을 목표로 합니다.

## 🖼️ Prototype
(프로토타입과 설명 추가)

## 🛠️ About Code
```Swift
// SharePlay를 구성하고, 커스텀 SharePlay를 사용하기 위한 설정입니다.
// GroupActivity 프로토콜은 metadata와 activityIdentifier(default 값)를 필수적으로 가져야 한다.
struct SharePlay: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = NSLocalizedString("I am your solving mate!", comment: "Let's solve together!")
        metadata.type = .generic
        return metadata
    }
}
```
```Swift
// SharePlay 시작 지점
func startSharing() {
    Task {
        do {
            _ = try await SharePlay().activate()
        } catch {
            print("Failed to activate SharePlay activity: \(error)")
        }
    }
}
```
```Swift
// GroupSession을 받기 위한 async task
HStack { 
	Text("Hello World!")
}
.task {
    for await session in SharePlay.sessions() {
        canvas.configureGroupSession(session)
    }
}
```
```Swift
// GroupSession을 생성하고 구성하는 함수입니다.
func configureGroupSession(_ groupSession: GroupSession<SharePlay>) {
    self.groupSession = groupSession
    let messenger = GroupSessionMessenger(session: groupSession)
    self.messenger = messenger
    
    // session의 상태가 유효하지 않을 때 실행됩니다.
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
}

// 작은 크기의 데이터를 보낼 때 messenger를 사용합니다.
func sendDrawingData(_ drawingData: Data) {
    guard let messenger = messenger else { return }
    messenger.send(drawingData) { error in
       if let error = error {
           print("Error sending drawing data: \(error)")
        }
     }
}
    
// 변화된 데이터를 받아옵니다.
private func receiveDrawingData() async {
    guard let messenger = messenger else { return }
    for try await (drawingData, _) in messenger.messages(of: Data.self) {
        self.receivedDrawingData = drawingData
    }
}
```
