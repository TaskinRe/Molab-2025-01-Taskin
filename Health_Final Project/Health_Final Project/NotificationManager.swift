//
//  NotificationManager.swift
//  Health_Final Project
//
//  Created by Rehnuma Taskin on 29/04/2025.
//


//  NotificationManager.swift
//  Health_FinalProject
//
//  Created by Rehnuma Taskin on 29/04/2025.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()

    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let err = error {
                print("❗️Notification auth error:", err)
            }
        }
    }

    func scheduleDailyReminder(
        id: String,
        title: String,
        body: String,
        hour: Int,
        minute: Int
    ) {
        center.removePendingNotificationRequests(withIdentifiers: [id])
        var dc = DateComponents(); dc.hour = hour; dc.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body  = body
        content.sound = .default

        let req = UNNotificationRequest(identifier: id,
                                        content: content,
                                        trigger: trigger)
        center.add(req)
    }

    func scheduleOneTimeReminder(
        id: String,
        title: String,
        body: String,
        after seconds: TimeInterval
    ) {
        center.removePendingNotificationRequests(withIdentifiers: [id])
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body  = body
        content.sound = .default

        let req = UNNotificationRequest(identifier: id,
                                        content: content,
                                        trigger: trigger)
        center.add(req)
    }
}
