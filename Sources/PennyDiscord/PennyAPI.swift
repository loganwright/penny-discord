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

struct GitHubLinkInput: Codable {
    let githubUsername: String
    let source: String
    let id: String
    let username: String
}

struct GitHubLinkResponse: Codable {
    let message: String
}

func connectGitHub(msg: Message) throws {
    let eater = Eater(msg)
    eater.eat {
        guard let githubUsername = msg.content.components(separatedBy: " ").last else {
            throw "unable to parse github username, use format `connect github YOUR_NAME_HERE`"
        }
        guard let id = msg.author?.id.description else {
            throw "unable to find discord author"
        }
        guard let username = msg.author?.username else {
            throw "unable to find discord username"
        }

        let url = base + "/links/github"
        let content = GitHubLinkInput(
            githubUsername: githubUsername,
            source: "discord",
            id: id,
            username: username
        )
        try Request.post(url, content).run { resp in
            let resp = try resp.map(to: GitHubLinkResponse.self)
            msg.reply(with: resp.message)
        }
    }
}

struct Eater {
    let msg: Message
    init(_ msg: Message) {
        self.msg = msg
    }

    func eat(_ thing: () throws -> Void) {
        do {
            try thing()
        } catch {
            msg.reply(with: "Error: \(error)")
        }
    }
}
