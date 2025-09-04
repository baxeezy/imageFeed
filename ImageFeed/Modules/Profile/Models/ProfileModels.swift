import UIKit

public struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

public struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    public enum CodingKeys: String, CodingKey {
        case username, bio
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
