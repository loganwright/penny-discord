import Sword
import PennyCore

let DISCORD_BOT_TOKEN = "NDM3Nzg3ODE3NTkxMTc3MjI3.DcuntQ.QNrZi6EO-Os1Av2n-_UTYvDfS2c"

let bot = Sword(token: DISCORD_BOT_TOKEN)

bot.editStatus(to: "online", playing: "fxkn w/ nu0bs")

let processor = MessageProcessor()
bot.on(.messageCreate) { data in
    let msg = data as! Message
    // no author means webhook, which we don't support
    guard let author = msg.author else { return }
    // will sometimes be `nil` if it is not a bot
    guard author.isBot != true else { return }

    // coin parsing
    if processor.shouldGiftCoin(in: msg.content) {
        let from = author.id.description
        let usersToGift = processor.userIdsToGift(in: msg.content, fromId: from)
        try! giveCoins(to: usersToGift, from: from, respond: msg)
//        if !usersToGift.isEmpty {
//            let formatted = usersToGift.map { "<@\($0)>" }
//            let text = "I should gift: " + formatted.joined(separator: ", ")
//            print("Response: \(text)")
//            msg.reply(with: text)
//        }
    } else {
        // other stuff in future
    }
    if msg.content == "!ping" {
        msg.reply(with: "Pong!")
    }
}

bot.connect()
