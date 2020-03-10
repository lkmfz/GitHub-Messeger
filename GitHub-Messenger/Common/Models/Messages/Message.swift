//
//  Message.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 4/3/2020.
//

import Foundation

public enum MessageType {
    case text(String)
    case image
}


public enum MessageDirection {
    case incoming, outgoing

    var assetName: String {
        switch self {
        case .incoming:
            return "ic-left-bubble"
        case .outgoing:
            return "ic-right-bubble"
        }
    }
}


public struct Message {
    let id: String
    let content: MessageType
    let direction: MessageDirection
    let sentAt: Date
}


/// VIPER's model interface
extension Message: MessageContentItemInterface {

    var messageContent: MessageType {
        return content
    }
}


/// Misc
extension Message {

    static func mock(count: Int) -> [Message] {
        var list: [Message] = []
        var i = 1
        while i <= count {
            let textMessage = i.isOddNumber() ? "A message contains a phone number +44623210480\(i)" : "A message contains a URL https://google.com"
            let message = Message(
                id: i.description,
                content: MessageType.text(textMessage),
                direction: i.isOddNumber() ? .incoming : .outgoing,
                sentAt: Date().addingTimeInterval(2)
            )
            list.append(message)
            i += 1
        }
        return list
    }

    static func duplicateOppositeMessage(_ message: Message) -> Message? {
        guard case .text(let textMessage) = message.content else {
            return nil
        }
        return Message(
            id: message.id,
            content: MessageType.text("\(textMessage) \(textMessage)"),
            direction: (message.direction == .incoming) ? .outgoing : .incoming,
            sentAt: Date()
        )
    }
}
