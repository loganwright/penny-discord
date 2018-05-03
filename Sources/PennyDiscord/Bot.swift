import Sword

let bot: Sword = {
    let bot = Sword(token: DISCORD_BOT_TOKEN)
    bot.editStatus(to: "online", watching: "you")

    let handler = MessageHandler()
    bot.on(.messageCreate) { data in
        let msg = data as! Message
        handler.handle(msg)
    }
    return bot
}()
