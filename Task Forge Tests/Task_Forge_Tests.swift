//
//  Task_Forge_Tests.swift
//  Task Forge Tests
//
//  Created by Carter Hawkins on 12/18/24.
//

import Testing
import SwiftData
@testable import Task_Forge

struct TestMagicBox {
    
    @Test func testAutoSpacedRemindersLookForKeyWords() async throws {
        
        #expect(MagicBox.autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkj test lkfjasd;lf") == true)
        #expect(MagicBox.autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkj quiz lkfjasd;lf") == true)
        #expect(MagicBox.autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkj projectlkfjasd;lf") == true)
        #expect(MagicBox.autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkj reporttttlkfjasd;lf") == true)
        #expect(MagicBox.autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkjessayttlkfjasd;lf") == true)
        #expect(MagicBox.autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lpaperttlkfjasd;lf") == true)
        #expect(MagicBox.autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkj repor    final     ttlkfjasd;lf") == true)
        #expect(MagicBox.autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkj repor    fin     ttlkfjasd;lf") == false)
        
        
    }
    
    struct TestListViewDateFormatter {
        let maxDayRange = 8
        @Test func testFormatDateBasedOnNum() async throws {
            #expect(await ListViewDateFormatter.formatDateBasedOnNum(num: -1, maxDayRange: 8) == "Over Due")
            #expect(await ListViewDateFormatter.formatDateBasedOnNum(num: 0, maxDayRange: 8) == "Today")
            #expect(await ListViewDateFormatter.formatDateBasedOnNum(num: 1, maxDayRange: 8) == "Tomorrow")
            #expect(await ListViewDateFormatter.formatDateBasedOnNum(num: 2, maxDayRange: 8) != "Tomorrow")
            #expect(await ListViewDateFormatter.formatDateBasedOnNum(num: 8, maxDayRange: 8) == "Later")
        }
    }
    

}
