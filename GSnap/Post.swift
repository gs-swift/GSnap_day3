// Post.swift
// 投稿を表現する構造体.
struct Post: Codable {
    let id: Int
    let body: String
    let image_url: String
    let liked: Bool
    let user: User
}
