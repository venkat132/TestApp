//
//  DateExt.swift
//  kPoint
//
//  Created by Mego Developer on 10/06/20.
//  Copyright © 2020 Mego Developer. All rights reserved.
//

import Foundation
extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    func timeAgoSimple() -> String? {
        let now = Date()
        let deltaSeconds = Double(abs(Float(timeIntervalSince(now))))
        let deltaMinutes = deltaSeconds / 60.0
        let remSeconds = deltaSeconds.truncatingRemainder(dividingBy: 60)

        var value: Int

        if deltaSeconds < 60 {
            return string(fromFormat: "%%d%@s", withValue: Int(deltaSeconds))
        } else if deltaMinutes < 60 {
            return string(fromFormat: "%%d%@m%%d%@s", withValue: Int(deltaMinutes), val2: Int(remSeconds))
        } else if deltaMinutes < (24 * 60) {
            value = Int(floor(deltaMinutes / 60))
            return string(fromFormat: "%%d%@h", withValue: value)
        } else if deltaMinutes < (24 * 60 * 7) {
            value = Int(floor(deltaMinutes / (60 * 24)))
            return string(fromFormat: "%%d%@d", withValue: value)
        } else if deltaMinutes < (24 * 60 * 31) {
            value = Int(floor(deltaMinutes / (60 * 24 * 7)))
            return string(fromFormat: "%%d%@w", withValue: value)
        } else if deltaMinutes < (24 * 60 * 365.25) {
            value = Int(floor(deltaMinutes / (60 * 24 * 30)))
            return string(fromFormat: "%%d%@mo", withValue: value)
        }

        value = Int(floor(deltaMinutes / (60 * 24 * 365)))
        return string(fromFormat: "%%d%@yr", withValue: value)
    }

    func timeAgo() -> String? {
        let now = Date()
        let deltaSeconds = Double(abs(Float(timeIntervalSince(now))))
        let deltaMinutes = deltaSeconds / 60.0

        var minutes: Int

        if deltaSeconds < 5 {
            return "Just now"
        } else if deltaSeconds < 60 {
            return string(fromFormat: "%%d %@seconds ago", withValue: Int(deltaSeconds))
        } else if deltaSeconds < 120 {
            return "A minute ago"
        } else if deltaMinutes < 60 {
            return string(fromFormat: "%%d %@minutes ago", withValue: Int(deltaMinutes))
        } else if deltaMinutes < 120 {
            return "An hour ago"
        } else if deltaMinutes < (24 * 60) {
            minutes = Int(floor(deltaMinutes / 60))
            return string(fromFormat: "%%d %@hours ago", withValue: minutes)
        } else if deltaMinutes < (24 * 60 * 2) {
            return "Yesterday"
        } else if deltaMinutes < (24 * 60 * 7) {
            minutes = Int(floor(deltaMinutes / (60 * 24)))
            return string(fromFormat: "%%d %@days ago", withValue: minutes)
        } else if deltaMinutes < (24 * 60 * 14) {
            return "Last week"
        } else if deltaMinutes < (24 * 60 * 31) {
            minutes = Int(floor(deltaMinutes / (60 * 24 * 7)))
            return string(fromFormat: "%%d %@weeks ago", withValue: minutes)
        } else if deltaMinutes < (24 * 60 * 61) {
            return "Last month"
        } else if deltaMinutes < (24 * 60 * 365.25) {
            minutes = Int(floor(deltaMinutes / (60 * 24 * 30)))
            return string(fromFormat: "%%d %@months ago", withValue: minutes)
        } else if deltaMinutes < (24 * 60 * 731) {
            return "Last year"
        }

        minutes = Int(floor(deltaMinutes / (60 * 24 * 365)))
        return string(fromFormat: "%%d %@years ago", withValue: minutes)
    }

    func dateTimeAgo() -> String? {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents(
            [Calendar.Component.year, Calendar.Component.month, Calendar.Component.weekOfYear, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second],
            from: self as Date,
            to: now)

        if components.year! >= 1 {
            if components.year == 1 {
                return "1 year ago"
            }
            return string(fromFormat: "%%d %@years ago", withValue: components.year!)
        } else if components.month! >= 1 {
            if components.month == 1 {
                return "1 month ago"
            }
            return string(fromFormat: "%%d %@months ago", withValue: components.month!)
        } else if components.weekOfYear! >= 1 {
            if components.weekOfYear == 1 {
                return "1 week ago"
            }
            return string(fromFormat: "%%d %@weeks ago", withValue: components.weekOfYear!)
        } else if components.day! >= 1 {
            if components.day == 1 {
                return "1 day ago"
            }
            return string(fromFormat: "%%d %@days ago", withValue: components.day!)
        } else if components.hour! >= 1 {
            if components.hour == 1 {
                return "An hour ago"
            }
            return string(fromFormat: "%%d %@hours ago", withValue: components.hour!)
        } else if components.minute! >= 1 {
            if components.minute == 1 {
                return "A minute ago"
            }
            return string(fromFormat: "%%d %@minutes ago", withValue: components.minute!)
        } else if components.second! < 5 {
            return "Just now"
        }

        // between 5 and 59 seconds ago
        return string(fromFormat: "%%d %@seconds ago", withValue: components.second!)
    }

    func dateTimeUntilNow() -> String? {
        let now = Date()
        let calendar = Calendar.current

        let components = calendar.dateComponents(
            [Calendar.Component.hour],
        from: self as Date,
        to: now)

        if components.hour! >= 6 {
            let startDay = calendar.ordinality(
                of: .day,
                in: .era,
                for: self as Date)
            let endDay = calendar.ordinality(
                of: .day,
                in: .era,
                for: now)

            let diffDays = endDay! - startDay!

            if diffDays == 0 {
                let startHourComponent = calendar.dateComponents([Calendar.Component.hour], from: self as Date)
                let endHourComponent = calendar.dateComponents([Calendar.Component.hour], from: self as Date)
                if startHourComponent.hour! < 12 && endHourComponent.hour! > 12 {
                    return "This morning"
                } else if startHourComponent.hour! >= 12 && startHourComponent.hour! < 18 && endHourComponent.hour! >= 18 {
                    return "This afternoon"
                }
                return "Today"
            } else if diffDays == 1 {
                return "Yesterday"
            } else {
                let startWeek = calendar.ordinality(
                    of: .weekOfYear,
                    in: .era,
                    for: self as Date)
                let endWeek = calendar.ordinality(
                    of: .weekOfYear,
                    in: .era,
                    for: now)
                let diffWeeks = endWeek! - startWeek!
                if diffWeeks == 0 {
                    return "This week"
                } else if diffWeeks == 1 {
                    return "Last week"
                } else {
                    let startMonth = calendar.ordinality(
                        of: .month,
                        in: .era, for: self)

                    let endMonth = calendar.ordinality(
                    of: .month,
                    in: .era, for: now)
                    let diffMonth = endMonth! - startMonth!
                    if diffMonth == 0 {
                        return "This month"
                    } else if diffMonth == 1 {
                        return "Last month"
                    } else {
                        let startYear = calendar.ordinality(
                            of: .year,
                            in: .era, for: self)

                        let endYear = calendar.ordinality(
                        of: .year,
                        in: .era, for: now)
                        let diffYears = endYear! - startYear!
                        if diffYears == 0 {
                            return "This year"
                        } else if diffYears == 1 {
                            return "Last year"
                        }
                    }
                }
            }
        }
        return self.dateTimeAgo()
    }

    func string(fromFormat format: String?, withValue value: Int, val2: Int? = nil) -> String? {
        if val2 != nil {
            let localeFormat = String(format: format ?? "", getLocaleFormatUnderscores(withValue: Double(value)) ?? "", getLocaleFormatUnderscores(withValue: Double(val2!)) ?? "")
            return String(format: localeFormat, value, val2!)
        }
        let localeFormat = String(format: format ?? "", getLocaleFormatUnderscores(withValue: Double(value)) ?? "")
        return String(format: localeFormat, value)
    }

    func timeAgo(withLimit limit: TimeInterval) -> String? {
        return timeAgo(withLimit: limit, dateFormat: .full, andTimeFormat: .full)
    }

    func timeAgo(withLimit limit: TimeInterval, dateFormat dFormatter: DateFormatter.Style, andTimeFormat tFormatter: DateFormatter.Style) -> String? {
        if abs(Float(timeIntervalSince(Date()))) <= Float(limit) {
            return self.timeAgo()
        }

        return DateFormatter.localizedString(
            from: self as Date,
            dateStyle: dFormatter,
            timeStyle: tFormatter)
    }

    func timeAgo(withLimit limit: TimeInterval, dateFormatter formatter: DateFormatter?) -> String? {
        if abs(Float(timeIntervalSince(Date()))) <= Float(limit) {
            return self.timeAgo()
        }

        return formatter?.string(from: self as Date)
    }

    // Helper functions

// #pragma clang diagnostic push
// #pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
    func getLocaleFormatUnderscores(withValue value: Double) -> String? {
        let localeCode = NSLocale.preferredLanguages[0]

        // Russian (ru)
        if localeCode.isEqual("ru") {
            let XY = Int(floor(value)) % 100
            let Y = Int(floor(value)) % 10

            if Y == 0 || Y > 4 || (XY > 10 && XY < 15) {
                return ""
            }
            if Y > 1 && Y < 5 && (XY < 10 || XY > 20) {
                return "_"
            }
            if Y == 1 && XY != 11 {
                return "__"
            }
        }

        // Add more languages here, which are have specific translation rules...

        return ""
    }
}

class DateUtils {
    static let dateFormat: String = "dd-MMM-yyyy"
    static let dateFormatShort: String = "dd MMM"
    static let dateFormatDetail: String = "dd MMM yyyy HH:mm"
    static func returnDate(_ date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: date)
        return date
    }
    
    static func returnString(_ date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    static func returnStringDetail(_ date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatDetail
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    static func returnStringShort(_ date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatShort
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
}
