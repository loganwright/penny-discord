import Sword
import Foundation

let base = "https://penny.ngrok.io"

func giveCoins(to: [String], from: String, respond: Message) throws {
    let url = base + "/coins"

    let coins = to.map { id in Coin(source: "discord", to: id, from: from, reason: "twas but a gift") }
    try Request.post(url, coins).run { resp in
        let resp = try resp.map(to: [CoinResponse].self)
        let messages = resp.map { "<@\($0.coin.to)> now has \($0.total) coins." }
        let message = messages.joined(separator: "\n")
        respond.reply(with: message)
    }
}

func totalCoins(for id: String, respond: Message) {
    let url = base + "/coins/total?id=\(id)&source=discord"
    Request.get(url).run { run in
        let response = try run.map(to: TotalResponse.self)
        let message = "<@\(id)> has \(response.total) coins."
        respond.reply(with: message)
    }
}

