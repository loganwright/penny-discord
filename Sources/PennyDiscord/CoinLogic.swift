// MARK: Coin Suffix

public let validSuffixes = [
    "++",
    ":coin:",
    "+= 1",
    "+ 1",
    "advance(by: 1)",
    "successor()",
    "👍",
    ":+1:",
    ":thumbsup:",
    "🙌",
    ":raised_hands:",
    "🚀",
    ":rocket:",
    "thanks",
    "thanks!",
    "thank you",
    "thank you!",
    "thx",
    "thx!"
]

extension String {
    var hasCoinSuffix: Bool {
        for suffix in validSuffixes where hasSuffix(suffix) {
            return true
        }
        return false
    }
}

open class MessageProcessor {
    public init() {}

    /// Defaults to Slack and Discord tags of `<@USER_ID>`
    /// to extract USER_ID
    public func userIdsToGift(in msg: String, fromId: String) -> [String] {
        let lets = msg.split(separator: "<")
        let separate = lets.flatMap { $0.split(separator: ">") }
        let this = separate.filter { $0.first == "@" }
        let logic = this.map { $0.dropFirst() }
        let help = logic.map { String($0) }
        let compiler = help.filter { $0 != fromId }

        return Array(Set(compiler))
    }

    /// As of now, defaults to a standard coin suffix
    public func shouldGiftCoin(in msg: String) -> Bool {
        return msg.trimmedWhitespace().hasCoinSuffix
    }
}
