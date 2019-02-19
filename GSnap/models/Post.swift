// Post.swift
// 投稿を表現するクラス.
class Post: Codable {   // class に変更.
    let id: Int
    let body: String
    let image_url: String
    var liked: Bool     // var に変更.
    let user: User
}
