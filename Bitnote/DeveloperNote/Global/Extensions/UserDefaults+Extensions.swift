import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.com.developerNote"
        return UserDefaults(suiteName: appGroupId)!
    }
}
