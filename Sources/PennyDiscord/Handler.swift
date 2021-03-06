import Foundation
import Sword

struct MessageHandler {
    let processor = MessageProcessor()

    func handle(_ msg: Message) {
        do {
            try interalHandle(msg)
        } catch {
            msg.reply(with: "Something happened: \(error)")
        }
    }

    private func interalHandle(_ msg: Message) throws {
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
            } else if msg.content.lowercased().contains("connect github") {
                try connectGitHub(msg: msg)
            } else if msg.content.contains("env") {
                let env = ProcessInfo.processInfo.environment["ENVIRONMENT"]
                    ?? "the void"
                msg.reply(with: "I'm in \(env)")
            }
        } else if msg.content == "!ping" {
            msg.reply(with: "pong!")
        }
    }
}
