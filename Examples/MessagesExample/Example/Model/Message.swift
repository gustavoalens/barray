import BArray
import Foundation

final class Message {
    let msgID: Int
    let date: Date
    let text: String
    let authorID: Int
    var status: MessageStatus
    
    init(msgID: Int, date: Date, text: String, authorID: Int, status: MessageStatus) {
        self.msgID = msgID
        self.date = date
        self.text = text
        self.authorID = authorID
        self.status = status
    }
}

enum MessageStatus {
    case sended
    case received
    case readed
    case deleted
}


extension Message: BArrayData {
    var id: Date { date }
}
