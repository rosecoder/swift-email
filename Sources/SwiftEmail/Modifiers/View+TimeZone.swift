import Foundation

private struct TimeZoneKey: EnvironmentKey {

    static var defaultValue: TimeZone {
        .current
    }
}

extension EnvironmentValues {

    public var timeZone: TimeZone {
        get { self[TimeZoneKey.self] }
        set { self[TimeZoneKey.self] = newValue }
    }
}
