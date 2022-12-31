import Foundation

protocol SettingConfig: AnyObject {
    /// 학습 타이머 사용 여부
    var useLessonTimer: Bool { get set }
    
    /// 문제당 시간 (초)
    var lessonTime_seconds: Int { get set }
    
    /// 노트 랜덤 여부
    var useShuffleNote: Bool { get set }
}

class SettingConfigConcrete: SettingConfig {
    private static let shared = SettingConfigConcrete()
    
    private init() {}
    
    static func sharedInstance() -> SettingConfig {
        return shared
    }
    
    private let key_useLessonTimer = "key_useLessonTimer"
    var useLessonTimer: Bool {
        get {
            return UserDefaults.standard.bool(forKey: key_useLessonTimer)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key_useLessonTimer)
        }
    }
    
    private let key_lessonTime_seconds = "lessonTime_seconds"
    var lessonTime_seconds: Int {
        get {
            return UserDefaults.standard.integer(forKey: key_lessonTime_seconds) == 0 ? 60: UserDefaults.standard.integer(forKey: key_lessonTime_seconds)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key_lessonTime_seconds)
        }
    }

    private let key_useShuffleNote = "key_useShuffleNote"
    var useShuffleNote: Bool {
        get {
            return UserDefaults.standard.bool(forKey: key_useShuffleNote)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key_useShuffleNote)
        }
    }
    
    /**
     초기값 설정
     */
    func setInitialValue() {
        let userDefaults = [
            key_useLessonTimer: true,
            key_useShuffleNote: false
        ]
        UserDefaults.standard.register(defaults: userDefaults)
    }
}
