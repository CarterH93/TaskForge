//
//  deleteListOfTasks.swift
//  Task Forge
//
//  Created by Carter Hawkins on 8/26/24.
//

import SwiftUI
import SwiftData

struct deleteListOfTasks: View {
    @Query(sort: \TaskObject.due) var tasks: [TaskObject]
    
    var body: some View {
        Form {
            Section {
                Text("Select assignments to hide")
            }
            Section {
                ForEach(tasks.indices,  id:\.self) { index in

                                            HStack {
                                                Image(
                                                    systemName:
                                                        tasks[index].deleted1 ? "checkmark.circle" : "circle"
                                                )
                                                HStack {
                                                    Text(tasks[index].name)
                                                    Text(tasks[index].due.formatted())
                                                }
                                            }
                                            .onTapGesture {
                                                tasks[index].deleted1.toggle()
                                                
                                                
                                            }
                                        }
                                    
                                
            }
        }
    }
}

#Preview {
    deleteListOfTasks()
}
