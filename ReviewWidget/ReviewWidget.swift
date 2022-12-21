//
//  ReviewWidget.swift
//  ReviewWidget
//
//  Created by jsj on 2021/11/13.
//  Copyright © 2021 Tomatoma. All rights reserved.
//

import WidgetKit
import SwiftUI


let snapshotEntry = ReviewListEntry(reviewNoteList: [
    .init(id: UUID().uuidString, title: "What is the better way to get to know each other better", isDone: false, createdAt: Date(), inputItems: []),
    .init(id: UUID().uuidString, title: "Do you agree or disagree with the following statement?", isDone: false, createdAt: Date(), inputItems: []),
    .init(id: UUID().uuidString, title: "What would you choose among the two choices", isDone: false, createdAt: Date(), inputItems: []),
    .init(id: UUID().uuidString, title: "Children should not have cell phones. Give reasons and details.", isDone: false, createdAt: Date(), inputItems: []),
    .init(id: UUID().uuidString, title: "Should your government build a library or a parking lot in your community?", isDone: false, createdAt: Date(), inputItems: [])
])

private func connectToDB() {
  RealmManager.connect {
      success in
      if success {
          print("Connecting DB succes!")
      } else {
          print("Connecting DB failed...")
      }
  }
}

struct Provider: TimelineProvider {
    typealias Entry = ReviewListEntry
    
    func placeholder(in context: Context) -> ReviewListEntry {
        snapshotEntry
    }

    // 위젯 갤러리 열때 호출- 미리보기 데이터
    func getSnapshot(in context: Context, completion: @escaping (ReviewListEntry) -> ()) {
        completion(snapshotEntry)
    }

    // 실제 보여지는 데이터
    func getTimeline(in context: Context, completion: @escaping (Timeline<ReviewListEntry>) -> ()) {
        let currentDate = Date()
        var entries: [ReviewListEntry] = []

        // 20분마다 refresh
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 20, to: currentDate)!
        
        connectToDB()
        
        // 오늘 복습해야하는 노트 리스트 들고오기
        let noteList = ReviewLessonViewModel().getNoteList()
        if (noteList.count > 0) {
            let entry = Entry(date: currentDate, reviewNoteList: noteList)
            entries = [entry]
        } else {
            let entry = Entry(reviewNoteList: [.init(title: "", inputItems: [])])
            entries = [entry]
        }
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }
}


@main
struct ReviewWidget: Widget {
    let kind: String = "ReviewWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ReviewListEntryView(entry: entry)
        }
        .configurationDisplayName("Bitnote")
        .description("widget_review_description".localized())
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct ReviewWidget_Previews: PreviewProvider {
    static var previews: some View {
        ReviewListEntryView(entry: snapshotEntry)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
