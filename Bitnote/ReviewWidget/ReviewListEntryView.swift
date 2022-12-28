import SwiftUI

struct ReviewListEntryView: View {
    let entry: ReviewListEntry

    @Environment(\.widgetFamily) var family
    
    var maxCount: Int {
        switch family {
        case .systemMedium:
            return 3
        default:
            return 5
        }
    }
    
    let headerHeight = CGFloat(24)
    var body: some View {
            if (entry.reviewNoteList.count == 1) && entry.reviewNoteList[0].title == "" {
                VStack {
                    if family == .systemLarge {
                        ReviewHeader(noteCount: 0)
                            .padding([.leading, .trailing])
                    }
                    NoDateView()
                }
            } else {
                VStack {
                    if family == .systemLarge {
                        ReviewHeader(noteCount: entry.reviewNoteList.count)
                            .padding([.leading, .trailing])
                    }
                    
                    ForEach(0..<min(maxCount, entry.reviewNoteList.count), id: \.self) { index in
                        let note = entry.reviewNoteList[index]
                        
                        let url = URL(string: "widget://review?noteid=\(note.id)")!
                        Link(destination: url) {
                            ReviewView(note: note)
                            Divider()
                        }
                    }
                }.padding()
        }
    }
}

struct ReviewHeader: View {
    let noteCount: Int
    var body: some View {
        VStack {
            HStack {
                Text(Date().getFormattedDate(style: .medium))
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                CirCleTextView(noteCount: noteCount)
            }
            CustomDivider()
        }
    }
}

struct CirCleTextView: View {
    let noteCount: Int
    var body: some View {
        Text("\(noteCount)")
            .font(.system(size: 16))
            .frame(width: 22, height: 22, alignment: .center)
            .background(Color.gray)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}


struct CustomDivider: View {
    var color: Color = .black
    var multiflier: CGFloat = 1.0
    let width: CGFloat = 1
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width * multiflier)
            .edgesIgnoringSafeArea(.horizontal)
    }
}


struct ReviewView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black)
            
//            Spacer()
//                .frame(height: 4)
            
            //TODO: log 를 가져올 수 없음
//            HStack {
//                let log = note.recentlyUpdatedLog()
//                Text(log?.understandLevel.keyString ?? "")
//                    .font(.system(size: 14, weight: .regular))
//                    .foregroundColor(.gray)
//
//                Divider()
//
//                let dateString = log?.createdAt.getFormattedDate(style: .medium) ?? ""
//                Text(dateString)
//                    .font(.system(size: 14, weight: .regular))
//                    .foregroundColor(.gray)
//            }.frame(height: 20)
        }
    }
}


struct NoDateView: View {
    var body: some View {
        Text("widget_review_nodata".localized()).multilineTextAlignment(.center)
    }
}
