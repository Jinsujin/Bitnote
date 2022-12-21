import WidgetKit
import Foundation

struct ReviewListEntry: TimelineEntry {
    var date = Date()
    let reviewNoteList: [Note]
}
