//
//  MagicBox.swift
//  Reminder
//
//  Created by Carter Hawkins on 5/18/24.
//

import Foundation
import SwiftData

class MagicBox {
    @MainActor
    
    func work(_ modelContext: ModelContext) async {
        do {
            //Accessing remote data
            
            var listOfAssignments = [Assignment]()
                
                let url = URL(string: "https://calendar.google.com/calendar/ical/carterhawkins93%40gmail.com/private-aaf5f5c80fdd58e64a12f421a32baa8c/basic.ics")!
               
                
            //IMPORTANT NOTE https://www.notion.so/carterhawkins/Retrieving-ics-information-in-on-a-background-task-eda6730290e04a0999a4c76286570c79?pvs=4
            let cals = try await iCal.load(url: url)
                

                for cal in cals {
                    for event in cal.subComponents{
                       
                        let eventItems = event.toCal()
                        
                        
                        let id: String = eventItems["UID"] ?? "Error"
                        let startDate: Date = getDate(eventItems["DTSTART"] ?? "Error") ?? Date()
                        let endDate: Date = getDate(eventItems["DTEND"] ?? "Error") ?? Date()
                        let link: URL = URL(string: eventItems["URL;VALUE=URI"] ?? "Error") ?? URL(string: "https://google.com")!
                        let description: String = eventItems["DESCRIPTION"] ?? "N/A"
                        let summary: String = eventItems["SUMMARY"] ?? "N/A"
                        
                        
                        let newAssignment = Assignment(id: id, name: summary, info: description, due: startDate)
                        
                        listOfAssignments.append(newAssignment)
                        
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
            
            //Program waits to receive remote data below continuing into any code below!!!
                
            //Now able to access all remote data
            print(listOfAssignments.count)
            print(listOfAssignments.first?.name ?? "nothing")
            
            
            //Accessing saved data
            let descriptor = FetchDescriptor<Assignment>()
            var existingAssignments: [Assignment] = []
            // existingAssignments = try container.mainContext.fetch(descriptor)
            
            try modelContext.enumerate(descriptor) { assignment in
                existingAssignments.append(assignment)
            }
            //Now able to access all existing assignments
            print(existingAssignments.count)
            print(existingAssignments.first?.name ?? "nothing")
            
            
            //Compare data here
            
            
            
            
            
        } catch {
            print("Error updating SwiftData")
        }
    }
    
}
