//
//  ChatAPI.swift
//  Cycle Trip
//
//  Created by Vladimir Ovsiannikov on 26.04.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import Foundation

final class ChatAPI{
    
    static let shared = ChatAPI()
    
    func fetchedChatList(onCompletion: @escaping([ChatList]) -> ()){
        let urlString = "https://adw"
        let url = URL(string: urlString)!
        
            let task = URLSession.shared.dataTask(with: url) { (data,response,error) in
                guard let data = data else {
                    print("data was nil")
                    return
                }
                guard let chatList = try? JSONDecoder().decode(Chat.self, from: data ) else {
                    print("couldn't decode json")
                    return
                    }
              //?  onCompletion( Chat.chatList )
            }
        
        task.resume()
    }
}

struct Chat: Codable{
    let chatList: [ChatList]
}

struct ChatList: Codable {
    let chatId:String
    let name: String
    let time: String
    let date: String
    let image: String?
    let latitude: Double
    let longitude: Double
}

/*struct PartyLocation{
    let latitude: Double
    let longitude: Double
} */
