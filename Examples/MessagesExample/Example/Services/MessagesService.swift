import Foundation

/// Simulate a service to get messages
final class MessagesService {
    let manager = Network()
    
    func getMessages(for chatID: Int) async -> [Message] {
        return await manager.request(request: .getMessages(chatID: chatID)) as? [Message] ?? []
    }
}

final class Network {
    func request(request: RequestType) async -> Any {
        try? await Task.sleep(for: .seconds(1))
        switch request {
            case let .getMessages(chatID):
                switch chatID {
                    case 1:
                        return MockMessages.chat1
                    default:
                        return [Message].init()
                }
        }
    }
    
    enum RequestType {
        case getMessages(chatID: Int)
    }
}

private struct MockMessages {
    static let chat1: [Message] = [
        Message(msgID: 0, date: Date(timeIntervalSince1970: Double.random(in: 1000.0..<9000000000.0)), text: "msgID: 0", authorID: 0, status: .received),
        Message(msgID: 1, date: Date(timeIntervalSince1970: Double.random(in: 1000.0..<9000000000.0)), text: "msgID: 1", authorID: 1, status: .received),
        Message(msgID: 2, date: Date(timeIntervalSince1970: Double.random(in: 1000.0..<9000000000.0)), text: "msgID: 2", authorID: 1, status: .received),
        Message(msgID: 3, date: Date(timeIntervalSince1970: Double.random(in: 1000.0..<9000000000.0)), text: "msgID: 3", authorID: 0, status: .received),
        Message(msgID: 4, date: Date(timeIntervalSince1970: Double.random(in: 1000.0..<9000000000.0)), text: "msgID: 4", authorID: 0, status: .received),
        Message(msgID: 5, date: Date(timeIntervalSince1970: Double.random(in: 1000.0..<9000000000.0)), text: "msgID: 5", authorID: 1, status: .received),
        Message(msgID: 6, date: Date(timeIntervalSince1970: Double.random(in: 1000.0..<9000000000.0)), text: "msgID: 6", authorID: 0, status: .received),
        Message(msgID: 7, date: Date(timeIntervalSince1970: Double.random(in: 1000.0..<9000000000.0)), text: "msgID: 7", authorID: 1, status: .received),
        Message(msgID: 8, date: Date(timeIntervalSince1970: Double.random(in: 1000.0..<9000000000.0)), text: "msgID: 8", authorID: 0, status: .received),
        Message(msgID: 9, date: Date(timeIntervalSince1970: Double.random(in: 1000.0..<9000000000.0)), text: "msgID: 9", authorID: 1, status: .received)
    ]
}
