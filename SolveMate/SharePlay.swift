import Foundation
import GroupActivities

// 앱 활동 구성하기(Configuring application's custom activity)
struct SharePlay: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = NSLocalizedString("Solve Together", comment: "Title of group activity")
        
        // 커스텀 activity로 설정
        metadata.type = .generic
        return metadata
    }
}
