import Foundation

public final class Coin: Codable {
    public var id: UUID?

    /// ie: GitHub, Slack, other future sources
    public let source: String

    /// ie: who should receive the coin
    /// the id here will correspond to the source
    public let to: String

    /// ie: who gave the coin
    /// the id here will correspond to the source, for example, if source is GitHub, it
    /// will be a GitHub identifier
    public let from: String

    /// An indication of the reason to possibly begin categorizing more
    public let reason: String

    /// The value of a given coin, for potentially allowing more coins in future
    public let value: Int

    /// Date created
//    public let createdAt: Date

    /// Any more info you might want
    public let meta: String?

    //
    public init(
        source: String,
        to: String,
        from: String,
        reason: String,
        value: Int = 1,
        createdAt: Date? = nil,
        meta: String? = nil
    ) {
        self.source = source
        self.to = to
        self.from = from
        self.reason = reason
        self.value = value
//        self.createdAt = createdAt ?? Date()
        self.meta = meta
    }
}
