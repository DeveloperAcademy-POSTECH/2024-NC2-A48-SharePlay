import Foundation
import GroupActivities

struct SharePlay: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = NSLocalizedString("I am your solving mate!", comment: "Let's solve together!")
        
        metadata.type = .generic
        return metadata
    }
}
