//
//  FileTransferTests.swift
//  ChatSecure
//
//  Created by Chris Ballinger on 3/28/17.
//  Copyright © 2017 Chris Ballinger. All rights reserved.
//

import XCTest
import XMPPFramework
@testable import ChatSecureCore

class FileTransferTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParsingQueryElement() {
        let maxSize: UInt = 1048576
        let queryString = "<query xmlns=\"http://jabber.org/protocol/disco#info\"><identity type=\"file\" name=\"HTTP File Upload\" category=\"store\"/><identity type=\"im\" name=\"Prosody\" category=\"server\"/><feature var=\"urn:xmpp:http:upload\"/><feature var=\"http://jabber.org/protocol/disco#info\"/><feature var=\"http://jabber.org/protocol/disco#items\"/><x xmlns=\"jabber:x:data\" type=\"result\"><field type=\"hidden\" var=\"FORM_TYPE\"><value>urn:xmpp:http:upload</value></field><field type=\"text-single\" var=\"max-file-size\"><value>\(maxSize)</value></field></x></query>"
        let queryElement = try! XMLElement(xmlString: queryString)
        let parsedMaxSize = queryElement.maxHTTPUploadSize()
        
        XCTAssertTrue(queryElement.supportsHTTPUpload())
        XCTAssertEqual(parsedMaxSize, maxSize)
    }
    
    func testIncomingMediaItem() {
        let incomingMessage = OTRIncomingMessage(uniqueId: NSUUID().uuidString)
        // this should be split into four messages
        incomingMessage.text = "i like cheese https://cheese.com https://cheeze.biz/cheddar.jpg aesgcm://example.com/12345.png"
        let downloads = OTRDownloadMessage.downloads(for: incomingMessage)
        XCTAssertEqual(downloads.count, 3)
        
        let noURLsMessage = OTRIncomingMessage(uniqueId: NSUUID().uuidString)
        noURLsMessage.text = "aint no urls here"
        let noDownloads = OTRDownloadMessage.downloads(for: noURLsMessage)
        XCTAssertEqual(noDownloads.count, 0)
        
        

    }
    
}