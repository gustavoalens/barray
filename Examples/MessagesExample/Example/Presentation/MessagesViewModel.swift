import BArray

final class MessagesViewModel {
    private let service = MessagesService()
    private var messages = BArray<Message>(initialValues: [])
    
    private let chatID: Int
    
    init(chatID: Int) {
        self.chatID = chatID
    }
    
    func getMessages() async {
        messages.insert(contentsOf: await service.getMessages(for: chatID))
    }
    
    func deleteOnList(message: Message) {
        messages.remove(item: message)
    }
    
    func deleteForEveryone(message: Message) {
        message.status = .deleted
    }
    
    func newMessage(message: Message) {
        messages.insert(message)
    }
}
