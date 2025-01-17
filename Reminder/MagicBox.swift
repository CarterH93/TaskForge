//
//  MagicBox.swift
//  Reminder
//
//  Created by Carter Hawkins on 5/18/24.
//

import Foundation
import SwiftData





/// Handles retrieving information from remote ICS calendar sources and converting and storing them into the SwiftData database.
@ModelActor
actor MagicBox {
    
    
    static func cleanName(_ input: String) -> String {
        return input.components(separatedBy: "[")[0]
    }

    static let defaultSpacedRemindersKeyWords = ["test", "project", "report", "essay", "paper", "final"]

    static func autoSpacedRemindersLookForKeyWords(_ input: String) -> Bool {
        
        var doesContain = false
        for keyWord in defaultSpacedRemindersKeyWords {
            if let _ = input.range(of: keyWord, options: .caseInsensitive) {
                doesContain = true
            }
        }
        
        return doesContain
    }
    
    /// Determines if to mark a task as deleted1 if it is from the canvas general engineering calendar spam.
    /// Should replace this with something more permenent
    /// - Parameter input: text to anaylize to determine if to delete
    /// - Returns: Should this task be deleted
    static func shouldDeleteGeneralEngineering(_ input: String) -> Bool {
        if let _ = input.range(of: "[General]") {
            return true
        }
        
        return false
    }
    
    
    //Retrieves information from remote source based on URL
   private func load(url: URL) async throws -> [CalendarICS] {
       
       //can ignore the warning from the below line of code. We are certain this wont cause data race issues as the code waits for the result before continuing. Swift isnt smart enough to know that.
       let (data, _) = try await URLSession(configuration: .ephemeral).data(from: url)
       
        guard let string = String(data: data, encoding: .utf8) else { throw iCalError.encoding }
       return iCal.load(string: string)
    }
    
    /// Creates list of tasks from remote URL source
    /// - Parameters:
    ///   - url: input .ICS URL to retrieve tasks from
    ///   - deleteRemoteDeletedTasks: automatically delete tasks that are deleted from remote .ICS source
    /// - Returns: Returns a set of ``TaskObject`` converted from remote URL source
    private func parseRemoteData(_ url: URL, deleteRemoteDeletedTasks: Bool) async -> Set<TaskObject> {
        
        var listOfTasks: [TaskObject] = []
        //used to check for duplicates. Normal Set duplicate checking does not work because they are an @model.
        var listOfIDs = Set<String>()
        
        do {
            
            let cals = try await load(url: url)
            
                for cal in cals {
                    for event in cal.subComponents{
                       
                        let eventItems = event.toCal()
                        
                        
                        //Creating fallback date
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy/MM/dd HH:mm"
                        let someDateTime = formatter.date(from: "2016/10/08 22:31")!
                        
                        let oldid: String = eventItems["UID"] ?? "Error"
                        let startDate: Date = getDate(eventItems["DTSTART"] ?? "Error") ?? someDateTime
                        //let endDate: Date = getDate(eventItems["DTEND"] ?? "Error") ?? someDateTime
                        //let link: URL = URL(string: eventItems["URL;VALUE=URI"] ?? "Error") ?? URL(string: "https://google.com")!
                        let description: String = eventItems["DESCRIPTION"] ?? "N/A"
                        
                        //Need to cleanup summary (name) data
                        let tempSummary: String = eventItems["SUMMARY"] ?? "N/A"
                        let summary: String = MagicBox.cleanName(tempSummary)
                        
                        var tempDeleted = false
                        
                        //Deletes any tasks before todays date. Removes clutter.
                       
                            if startDate < Calendar.current.startOfDay(for: Date.now) {
                                tempDeleted = true
                            } else {
                                tempDeleted = false
                            }
                        
                        
                        //Deletes spam tasks from general engineering calendar
                        if MagicBox.shouldDeleteGeneralEngineering(tempSummary) {
                            tempDeleted = true
                        }
                        
                        
                        let newTask = TaskObject(oldid: oldid, name: summary, info: description, due: startDate, deleted1: tempDeleted)
                        
                        
                        if listOfIDs.contains(oldid) {
                            //This is a duplicate task
                            //DO NOTHING
                            
                        } else {
                            
                           
                              
                                listOfTasks.append(newTask)
                                listOfIDs.insert(oldid)
                            
                        }
                        
                        
                        
                        func getDate(_ dateString: String) -> Date? {

                            // Create String
                            let string = dateString

                            // Create Date Formatter
                            let dateFormatter = DateFormatter()

                            // Set Date Format
                            dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
                            dateFormatter.timeZone = .gmt
                            // Convert String to Date
                            return (dateFormatter.date(from: string))
                            
                        }
                    }
                }
            
        } catch {
            print("error parsing remote data")
        }
        
       return Set(listOfTasks)
        
    }
    
    //Main Function
    func work(deleteRemoteDeletedTasks: Bool = false, inputURLS: [URL]? = nil) async {
        
        do {
            
            //Accessing Settings
            let descriptorSettings = FetchDescriptor<Settings1>()
            var settingsHold: Settings1?
            
            
            
            try modelContext.enumerate(descriptorSettings) { settings in
                
                if let settingsHoldWrapped = settingsHold {
                    
                    if settings.Date1 < settingsHoldWrapped.Date1 {
                        settingsHold = settings
                    }
                } else {
                    settingsHold = settings
                }
            }
            
            
            let settings: Settings1 = settingsHold ?? Settings1()
            
            print("accessing data")
            //Accessing remote data
            
            var remoteTasks = Set<TaskObject>()
                
            //retrieving tasks from ICS URL
            var url: [URL] = []
            
            if let inputURLS = inputURLS {
                url = inputURLS
            } else {
                url = settings.icsSources
            }
            
            for item in url {
                await remoteTasks = remoteTasks.union(parseRemoteData(item, deleteRemoteDeletedTasks: deleteRemoteDeletedTasks))
            }
            

           print("data access complete")
            
            //Program waits to receive remote data below continuing into any code below!!!
                
            //Now able to access all remote data
            //print(remoteTasks.count)
           // print(remoteTasks.first?.name ?? "nothing")
            
            
            //Accessing saved data
            let descriptor = FetchDescriptor<TaskObject>()
            var swiftDataTasks = Set<TaskObject>()
            
            
            try modelContext.enumerate(descriptor) { task in
                swiftDataTasks.insert(task)
            }
            
           
            
            //Now able to access all existing tasks
           // print(swiftDataTasks.count)
            //print(swiftDataTasks.first?.name ?? "nothing")
            
            
            //Compare data here
            
            //Only run if remote ICS data has contents
            if remoteTasks.isEmpty && !url.isEmpty {
                //DO NOTHING. No internet connection.
            } else {
                //valid items are in the remote set
                
                
            //removes any existing tasks that were created by the user
            //We dont want to compare any user generated tasks. The comparisons below are only for remote data tasks.
            for item in swiftDataTasks {
                if item.inAppGenerated == true {
                    swiftDataTasks.remove(item)
                }
            }
            
            //Creating sets with only ids for both data sets
            var swiftDataTasksIDOnly = Set<String>()
            for item in swiftDataTasks {
                swiftDataTasksIDOnly.insert(item.oldid)
            }
            
            var remoteTasksIDOnly = Set<String>()
            for item in remoteTasks {
                remoteTasksIDOnly.insert(item.oldid)
            }
            
            
            
            //Comparing the two ID Only sets
                
                
            
            //Creating set where both sets contain the same tasks
                
                //Gives set where ID are the same from both sets
            let bothContainSet = swiftDataTasksIDOnly.intersection(remoteTasksIDOnly)
               // print("1")
                //print(bothContainSet.count)
                
                //Gives set where task objects are the exact same from both sets
                
                
                
            
                
                var tempSwiftDataTasksMagicBoxIDOnly = Set<(MagicBoxID)>()
                for item in swiftDataTasks {
                    tempSwiftDataTasksMagicBoxIDOnly.insert(item.magicBoxID)
                }
                
                var tempRemoteTasksMagicBoxIDOnly = Set<(MagicBoxID)>()
                for item in remoteTasks {
                    tempRemoteTasksMagicBoxIDOnly.insert(item.magicBoxID)
                }
                
            let bothContainSetAndExactSameObjects = tempSwiftDataTasksMagicBoxIDOnly.intersection(tempRemoteTasksMagicBoxIDOnly)
          //  print("2")
               // print(bothContainSetAndExactSameObjects.count)
                
                
                
                
                
                
                //Convert to ID only
            var bothContainSetAndExactSameObjectsIDOnly = Set<String>()
                
                for item in bothContainSetAndExactSameObjects {
                    bothContainSetAndExactSameObjectsIDOnly.insert(item.oldID)
                }
                
                //Removes exact same objects from same ids to find the ones that have different information but same id
                let bothContainSetDifference = bothContainSet.subtracting(bothContainSetAndExactSameObjectsIDOnly)
              //  print("3")
               // print(bothContainSetDifference.count)
                
               //Updates old swift data tasks with new information
                
                for id in bothContainSetDifference {
                    if let swiftDataTaskItem = swiftDataTasks.first(where: {$0.oldid == id}) {
                        
                        
                        if let remoteTaskItem = remoteTasks.first(where: {$0.oldid == id}) {
                            
                            
                            swiftDataTaskItem.name = remoteTaskItem.name
                            swiftDataTaskItem.info = remoteTaskItem.info
                            swiftDataTaskItem.due = remoteTaskItem.due
                        }
                        
                    }
                }
                
               
                
                
                //Creating set of tasks that are in ICS Data but not in SwiftData
                let inICSDataButNotSwiftData = remoteTasksIDOnly.subtracting(swiftDataTasksIDOnly)
                //Adding these tasks to SwiftData

                
                for ID in inICSDataButNotSwiftData {
                    
                    if let task = remoteTasks.first(where: {$0.oldid == ID}) {
                        
                        //Identify if we should create spaced reminders
                        if task.deleted1 == false && settings.defaultSpacedRemindersEnabled && MagicBox.autoSpacedRemindersLookForKeyWords(task.name)
                        {
                            let generateSpacedReminders = generateSpacedReminders(task: task)
                            
                            var timePeriod = generateSpacedReminders.timePeriod
                            
                            //Change to be lower if default user setting is lower
                            if settings.defaultSpacedRemindersTimeSpan < timePeriod {
                                timePeriod = settings.defaultSpacedRemindersTimeSpan
                            }
                            
                        
                            
                            var sessions = generateSpacedReminders.defaultSessions(timePeriod)
                            //Change to be lower if default user setting is lower
                            if settings.defaultSpacedRemindersSessions < sessions {
                                sessions = settings.defaultSpacedRemindersSessions
                            }
                            
                            //created auto spaced reminders and added them to task
                            let newReminders = generateSpacedReminders.generate(number: sessions, timePeriod: timePeriod)
                            task.reminders = newReminders
                            
                            
                            
                        }
                        //Makes sure the user has automatic reminders enabled
                       else if settings.defaultReminderEnabled {
                            //Auto creates a reminder based on the information given in settings
                            
                            task.reminders = [Reminder(id: UUID().uuidString, name: "Work on \(task.name)", due: task.due.addingTimeInterval(-settings.defaultReminderWrapper))]
                            print(task.deleted1.description)
                            
                            
                        
                    }
                        
                        
                        
                        
                        modelContext.insert(task)
                    }
                
                }
                
                
                //Only run if deleting past tasks. (This code below is causing problems by randomly wiping out all canvas tasks. Related to caching from URLSession when there is no internet connection. But implementing this safety feature to make sure it can't happen in the first place).
                //This means this code will only run when a new link is added or deleted.
                if deleteRemoteDeletedTasks {
                    
                    //Creating set of tasks that are in SwiftData but not in ICS Data
                    let inSwiftDataButNotICSData = swiftDataTasksIDOnly.subtracting(remoteTasksIDOnly)
                    //Removing these tasks from SwiftData
                    for ID in inSwiftDataButNotICSData {
                        
                        if let task = swiftDataTasks.first(where: {$0.oldid == ID}) {
                            for reminder in task.reminders! {
                                modelContext.delete(reminder)
                            }
                            
                            modelContext.delete(task)
                        }
                        
                    }
                    
                    
                    
                }
                
                //save data at the end
                try? modelContext.save()
                
            }
            
            
            
            
            
        } catch {
            print("Error updating SwiftData")
        }
    }
    
}
