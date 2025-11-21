import Foundation
import SwiftUI

extension Date {
    static func fromISO8601(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: string)
    }
}

extension String {
    func toDate() -> Date? {
        return Date.fromISO8601(self)
    }
}

