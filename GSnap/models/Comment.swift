// Comment.swift
// コメントを表現するクラス.
class Comment: Codable {
    let id: Int
    let post_id: Int
    let user_id: Int
    let comment: String
}
