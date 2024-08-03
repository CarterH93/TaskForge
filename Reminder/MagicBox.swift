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
    private func parseRemoteData(_ url: URL) async -> [Task] {
        
        var listOfTasks = [Task]()
        
        do {
            
            let cals = try await load(url: url)
            
                for cal in cals {
                    for event in cal.subComponents{
                       
                        let eventItems = event.toCal()
                        
                        
                        let id: String = eventItems["UID"] ?? "Error"
                        let startDate: Date = getDate(eventItems["DTSTART"] ?? "Error") ?? Date()
                        let endDate: Date = getDate(eventItems["DTEND"] ?? "Error") ?? Date()
                        let link: URL = URL(string: eventItems["URL;VALUE=URI"] ?? "Error") ?? URL(string: "https://google.com")!
                        let description: String = eventItems["DESCRIPTION"] ?? "N/A"
                        let summary: String = eventItems["SUMMARY"] ?? "N/A"
                        
                        
                        let newTask = Task(id: id, name: summary, info: description, due: startDate)
                        
                        listOfTasks.append(newTask)
                        
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
        
       return listOfTasks
        
    }
    
    //Main Function
    func work() async {
        do {
            
            print("accessing data")
            //Accessing remote data
            
            var listOfTasks = [Task]()
                
                let url = [URL(string: "https://calendar.google.com/calendar/ical/carterhawkins93%40gmail.com/private-aaf5f5c80fdd58e64a12f421a32baa8c/basic.ics")!, URL(string: "https://learn.lcps.org/calendar/feed/ical/1599581327/9336f6d23a186ce170b60460ec33395d/ical.ics")!]
            
            for item in url {
                await listOfTasks.append(contentsOf: parseRemoteData(item))
            }
            

           print("data access complete")
            
            //Program waits to receive remote data below continuing into any code below!!!
                
            //Now able to access all remote data
            print(listOfTasks.count)
            print(listOfTasks.first?.name ?? "nothing")
            
            
            //Accessing saved data
            let descriptor = FetchDescriptor<Task>()
            var existingTasks: [Task] = []
            
            
            try modelContext.enumerate(descriptor) { task in
                existingTasks.append(task)
            }
            
            
            //Now able to access all existing tasks
            print(existingTasks.count)
            print(existingTasks.first?.name ?? "nothing")
            
            
            //Compare data here
            
            
            
            
            
        } catch {
            print("Error updating SwiftData")
        }
    }
    
}
