import Foundation
import Sword

struct MessageHandler {
    let processor = MessageProcessor()

    func handle(_ msg: Message) {
        do {
            try _handle(msg)
        } catch {
            print("something went wrong:\n\nmsg: \(msg)\n\nerror: \(error)")
        }
    }

    func _handle(_ msg: Message) throws {
        let botId = bot.user?.id.description ?? "<>"
        // no author means webhook, which we don't support
        guard let author = msg.author else { return }
        // will sometimes be `nil` if it is not a bot
        guard author.isBot != true else { return }

        let from = author.id.description

        // coin parsing
        if processor.shouldGiftCoin(in: msg.content) {
            let usersToGift = processor.userIdsToGift(in: msg.content, fromId: from)
            try giveCoins(to: usersToGift, from: from, respond: msg)
        } else if msg.content.contains("<@\(botId)>") {
            if msg.content.lowercased().contains("how many") {
                totalCoins(for: from, respond: msg)
            }
            else if msg.content.lowercased().hasPrefix("connect github") {
                try connectGitHub(msg: msg)
            }
        } else if msg.content == "!ping" {
            msg.reply(with: "pong!")
        }
    }
}
