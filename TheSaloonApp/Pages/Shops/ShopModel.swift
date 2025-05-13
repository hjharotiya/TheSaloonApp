
import Foundation

struct Shop: Identifiable, Codable {
    var id: String
    var name: String
    var address: String
    var location: String?
    var imageUrl: String?
    var contactNumber: String?
    var ownerId: String
    var createdAt: Date

//    enum CodingKeys: String,CodingKey {
//        case id = "id"
//        case name = "name"
//        case address = "address"
//        case location = "location"
//        case imageUrl = "image_url"
//        case contactNumber = "contact_number"
//        case ownerId = "owner_id"
//        case createdAt = "created_at"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//        address = try container.decode(String.self, forKey: .address)
//        location = try container.decodeIfPresent(String.self, forKey: .location)
//        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
//        contactNumber = try container.decodeIfPresent(String.self, forKey: .contactNumber)
//        ownerId = try container.decode(String.self, forKey: .ownerId)
//        createdAt = try container.decode(Date.self, forKey: .createdAt)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(address, forKey: .address)
//        try container.encodeIfPresent(location, forKey: .location)
//        try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
//        try container.encodeIfPresent(contactNumber, forKey: .contactNumber)
//        try container.encode(ownerId, forKey: .ownerId)
//        try container.encode(createdAt, forKey: .createdAt)
//    }
}


