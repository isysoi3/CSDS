//
//  MailService.swift
//  Server_lab4
//
//  Created by Ilya Sysoi on 11/25/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import SendGrid

class MailService {
    
    let session = Session()
    
    init() {
        guard let myApiKey = ProcessInfo.processInfo.environment["SG_API_KEY"] else {
            print("Unable to retrieve API key")
            return
        }
        session.authentication = Authentication.apiKey(myApiKey)
    }
    
    func sendOTPInMessage(to email: String, message: String) {
        let personalization = Personalization(recipients: email)
        let plainText = Content(contentType: ContentType.plainText,
                                value: message)
        let email = Email(
            personalizations: [personalization],
            from: "test@notes.com",
            content: [plainText],
            subject: "Password to login"
        )
        do {
            try session.send(request: email)
        } catch {
            print(error)
        }
    }

    
}
