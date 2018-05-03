// MARK: WhiteSpace

extension String {
    internal func trimmedWhitespace() -> String {
        var characters = Substring(self)
        while characters.first?.isWhitespace == true {
            characters.removeFirst()
        }
        while characters.last?.isWhitespace == true {
            characters.removeLast()
        }

        return String(characters)
    }
}

extension Character {
    fileprivate var isWhitespace: Bool {
        switch self {
        case " ", "\t", "\n", "\r":
            return true
        default:
            return false
        }
    }
}
