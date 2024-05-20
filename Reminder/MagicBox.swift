//
//  MagicBox.swift
//  Reminder
//
//  Created by Carter Hawkins on 5/18/24.
//

import Foundation
import SwiftData

class MagicBox {
    
    
    private func parseRemoteData(_ url: URL) async -> [Assignment] {
        
        var listOfAssignments = [Assignment]()
        
        do {
            
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
            
        } catch {
            print("error parsing remote data")
        }
        
       return listOfAssignments
        
    }
    
    func work(_ modelContext: ModelContext) async {
        do {
            //Accessing remote data
            
            var listOfAssignments = [Assignment]()
                
                let url = [URL(string: "https://calendar.google.com/calendar/ical/carterhawkins93%40gmail.com/private-aaf5f5c80fdd58e64a12f421a32baa8c/basic.ics")!, URL(string: "https://learn.lcps.org/calendar/feed/ical/1599581327/9336f6d23a186ce170b60460ec33395d/ical.ics")!]
            
            for item in url {
                await listOfAssignments.append(contentsOf: parseRemoteData(item))
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
