//
//  Task_Forge_Tests.swift
//  Task Forge Tests
//
//  Created by Carter Hawkins on 12/18/24.
//

import Testing
@testable import Task_Forge

struct TestMagicBox {
    
    @Test func testAutoSpacedRemindersLookForKeyWords() async throws {
        
        #expect(autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkj test lkfjasd;lf") == true)
        #expect(autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkj quiz lkfjasd;lf") == true)
        #expect(autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkj projectlkfjasd;lf") == true)
        #expect(autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkj reporttttlkfjasd;lf") == true)
        #expect(autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkjessayttlkfjasd;lf") == true)
        #expect(autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lpaperttlkfjasd;lf") == true)
        #expect(autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkj repor    final     ttlkfjasd;lf") == true)
        #expect(autoSpacedRemindersLookForKeyWords("hello asdl;fksd;lkfjasd;lfkj repor    fin     ttlkfjasd;lf") == false)
        
        
    }
    

}
