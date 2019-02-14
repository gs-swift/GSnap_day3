// User.swift
// ユーザーを表現する構造体.
struct User: Codable {
    let id: Int
    let name: String
    let avatar_url: String
    let api_token: String
}
