//
// Created for LocalNotifications
// by Stewart Lynch on 2022-05-22
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import Foundation
import NotificationCenter

@Observable
class LocalNotificationManager: NSObject {
    let notificationCenter = UNUserNotificationCenter.current()
    var isGranted = false
    var pendingRequests: [UNNotificationRequest] = []
    var nextView: NextView?
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    @MainActor
    func requestAuthorization() async throws {
        try await notificationCenter
            .requestAuthorization(options: [.sound, .badge, .alert])
        registerActions()
        await getCurrentSettings()
    }
    
    func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
    
    func schedule(localNotification: LocalNotification) async {
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        content.body = localNotification.body
        if let subtitle = localNotification.subtitle {
            content.subtitle = subtitle
        }
        if let bundleImageName = localNotification.bundleImageName {
            if let url = Bundle.main.url(forResource: bundleImageName, withExtension: "") {
                if let attachment = try? UNNotificationAttachment(identifier: bundleImageName, url: url) {
                    content.attachments = [attachment]
                }
            }
        }
        if let userInfo = localNotification.userInfo {
            content.userInfo = userInfo
        }
        if let categoryIdentifier = localNotification.categoryIdentifier {
            content.categoryIdentifier = categoryIdentifier
        }
        
        content.sound = .default
        if localNotification.scheduleType == .time {
        guard let timeInterval = localNotification.timeInterval else { return }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,
                                                        repeats: localNotification.repeats)
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        } else {
            guard let dateComponents = localNotification.dateComponents else { return }
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: localNotification.repeats)
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        }
        await getPendingRequests()
    }
    
    func getPendingRequests() async {
        pendingRequests = await notificationCenter.pendingNotificationRequests()
        print("Pending: \(pendingRequests.count)")
    }
    
    func removeRequest(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        if let index = pendingRequests.firstIndex(where: {$0.identifier == identifier}) {
            pendingRequests.remove(at: index)
            print("Pending: \(pendingRequests.count)")
        }
    }
    
    func clearRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
        pendingRequests.removeAll()
        print("Pending: \(pendingRequests.count)")
    }
}

extension LocalNotificationManager: UNUserNotificationCenterDelegate {
   
    func registerActions() {
        let complete = UNNotificationAction(identifier: "complete", title: "Complete")
        let oneHourRemind = UNNotificationAction(identifier: "1hour", title: "Remind in 1 hour")
        let fourHourRemind = UNNotificationAction(identifier: "4hour", title: "Remind in 4 hours")
        let twentyFourHourRemind = UNNotificationAction(identifier: "24hour", title: "Remind in 24 hours")
        let reminderCategory = UNNotificationCategory(identifier: "reminderNotification",
                                                    actions: [complete, oneHourRemind, fourHourRemind, twentyFourHourRemind],
                                                    intentIdentifiers: [])
        notificationCenter.setNotificationCategories([reminderCategory])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await getPendingRequests()
        return [.sound, .banner]
    }
    
    @MainActor
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        if let value = response.notification.request.content.userInfo["nextView"] as? String {
            nextView = NextView(id: value)
        }
        
        // Respond to snooze action
        var snoozeInterval: Double?
        
        switch response.actionIdentifier {
        case "complete":
            //complete reminder
            if let value = response.notification.request.content.userInfo["nextView"] as? String {
                //Complete reminder based on id
            }
            break
            //fix numbers below. Messed with them for testing purposes.
        case "1hour":
            snoozeInterval = 60
            break
        case "4hour":
            snoozeInterval = 30
            break
        case "24hour":
            snoozeInterval = 24
            break
        default:
            //Do nothing
            break
            
        }
        
    
        
        if let snoozeInterval = snoozeInterval {
            let content = response.notification.request.content
            let newContent = content.mutableCopy() as! UNMutableNotificationContent
            //Need to multiply snoozeinterval value below by 3600. Not doing this right now for testing purposes.
            let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: snoozeInterval , repeats: false)
            
            var UUIDReminder = UUID().uuidString
            
            if let value = response.notification.request.content.userInfo["nextView"] as? String {
                UUIDReminder = value
            }
            
            let request = UNNotificationRequest(identifier: UUIDReminder,
                                                content: newContent,
                                                trigger: newTrigger)
            
            
            //Change reminder date and time based on time and id
            //Still need to do
            
            do {
                try await notificationCenter.add(request)
            } catch {
                print(error.localizedDescription)
            }
            
            await getPendingRequests()
        }
    }
    
}
