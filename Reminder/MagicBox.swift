//
//  MagicBox.swift
//  Reminder
//
//  Created by Carter Hawkins on 5/18/24.
//

import Foundation
import SwiftData



@ModelActor
actor MagicBox {
    
    
    //Retrieves information from remote source based on URL
   private func load(url: URL) async throws -> [Calendar] {
       
       //can ignore the warning from the below line of code. We are certain this wont cause data race issues as the code waits for the result before continuing. Swift isnt smart enough to know that.
       let (data, _) = try await URLSession.shared.data(from: url)
       
        guard let string = String(data: data, encoding: .utf8) else { throw iCalError.encoding }
       return iCal.load(string: string)
    }
    
    //Creates list of tasks
    private func parseRemoteData(_ url: URL) async -> Set<Task> {
        
        var listOfTasks: [Task] = []
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
                        let endDate: Date = getDate(eventItems["DTEND"] ?? "Error") ?? someDateTime
                        let link: URL = URL(string: eventItems["URL;VALUE=URI"] ?? "Error") ?? URL(string: "https://google.com")!
                        let description: String = eventItems["DESCRIPTION"] ?? "N/A"
                        let summary: String = eventItems["SUMMARY"] ?? "N/A"
                        
                        
                        let newTask = Task(oldid: oldid, name: summary, info: description, due: startDate)
                        
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
    func work() async {
        do {
            
            print("accessing data")
            //Accessing remote data
            
            var remoteTasks = Set<Task>()
                
            //retrieving tasks from ICS URL
                let url = [URL(string: "https://calendar.google.com/calendar/ical/carterhawkins93%40gmail.com/private-aaf5f5c80fdd58e64a12f421a32baa8c/basic.ics")!, URL(string: "https://learn.lcps.org/calendar/feed/ical/1599581327/9336f6d23a186ce170b60460ec33395d/ical.ics")!]
            
            for item in url {
                await remoteTasks = remoteTasks.union(parseRemoteData(item))
            }
            

           print("data access complete")
            
            //Program waits to receive remote data below continuing into any code below!!!
                
            //Now able to access all remote data
            print(remoteTasks.count)
            print(remoteTasks.first?.name ?? "nothing")
            
            
            //Accessing saved data
            let descriptor = FetchDescriptor<Task>()
            var swiftDataTasks = Set<Task>()
            
            
            try modelContext.enumerate(descriptor) { task in
                swiftDataTasks.insert(task)
            }
            
            
            //Now able to access all existing tasks
            print(swiftDataTasks.count)
            print(swiftDataTasks.first?.name ?? "nothing")
            
            
            //Compare data here
            
            //Only run if remote ICS data has contents
            if remoteTasks.isEmpty {
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
                print("1")
                print(bothContainSet.count)
                
                //Gives set where task objects are the exact same from both sets
                
                
                
                //currently have an issue where you cannot compare swiftDatamodels within a Set.
                
                var tempSwiftDataTasksMagicBoxIDOnly = Set<(MagicBoxID)>()
                for item in swiftDataTasks {
                    tempSwiftDataTasksMagicBoxIDOnly.insert(item.magicBoxID)
                }
                
                var tempRemoteTasksMagicBoxIDOnly = Set<(MagicBoxID)>()
                for item in remoteTasks {
                    tempRemoteTasksMagicBoxIDOnly.insert(item.magicBoxID)
                }
                
            let bothContainSetAndExactSameObjects = tempSwiftDataTasksMagicBoxIDOnly.intersection(tempRemoteTasksMagicBoxIDOnly)
            print("2")
                print(bothContainSetAndExactSameObjects.count)
                
                
                
                
                
                
                //Convert to ID only
            var bothContainSetAndExactSameObjectsIDOnly = Set<String>()
                
                for item in bothContainSetAndExactSameObjects {
                    bothContainSetAndExactSameObjectsIDOnly.insert(item.oldID)
                }
                
                //Removes exact same objects from same ids to find the ones that have different information but same id
                let bothContainSetDifference = bothContainSet.subtracting(bothContainSetAndExactSameObjectsIDOnly)
                print("3")
                print(bothContainSetDifference.count)
                
                //Can uncomment this out once we fix above issue
                
                
                
                ///NEED TO FIND A WAY TO UPDATE TASKS AFTER FINDING ABOVE SAME IDS BUT DIFFERENT INFORMATION!!!!
                
                //Code below still freezes everything
                /*
                for id in bothContainSetDifference {
                    var remoteTask: Task?
                    for task in remoteTasks {
                        if task.oldid == id {
                            remoteTask = task
                        }
                        
                        for task in swiftDataTasks {
                            if task.oldid == id {
                                
                                if let remoteTask = remoteTask {
                                    
                                    //update information here
                                    task.name = remoteTask.name
                                    task.info = remoteTask.info
                                    task.due = remoteTask.due
                                }
                            }
                        }
                    }
                }
                
                */
                
                
                //Eventually fully remove this code. This is just for reference for now. THIS DOES NOT WORK!!!
                //This code below is freezing up the app
                //(Code)
                
                /*
            //Updating SwiftData to match ICS Data
            for ID in bothContainSet {
                //Create a temp task variable and put the task from the ICS data into it.
                var tempTask: Task?
                
                for task in remoteTasks {
                    if task.id == ID {
                        tempTask = task
                    }
                    
                    //Update swiftdata to match ICS data here
                    for task in swiftDataTasks {
                        if let tempTask = tempTask {
                            if task.id == tempTask.id {
                            
                            //NEED TO CHECK TO MAKE SURE THEY ARE NOT ALREADY THE SAME
                            
                                if task == tempTask {
                                    //Do nothing
                                } else {
                                    //update information here
                                    task.name = tempTask.name
                                    task.info = tempTask.info
                                    task.due = tempTask.due
                                }
                                
                                
                                
                            }
                        }
                       
                    }
                    
                }
            }
            //(Code)
            
           */
                
                
                //Creating set of tasks that are in ICS Data but not in SwiftData
                let inICSDataButNotSwiftData = remoteTasksIDOnly.subtracting(swiftDataTasksIDOnly)
                //Adding these tasks to SwiftData
                for ID in inICSDataButNotSwiftData {
                    for task in remoteTasks {
                        if ID == task.oldid {
                            modelContext.insert(task)
                        }
                    }
                }
                
                
                
                //Creating set of tasks that are in SwiftData but not in ICS Data
                let inSwiftDataButNotICSData = swiftDataTasksIDOnly.subtracting(remoteTasksIDOnly)
                //Removing these tasks from SwiftData
                for ID in inSwiftDataButNotICSData {
                    for task in swiftDataTasks {
                        if ID == task.oldid {
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
