//
//  MessageAPI.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/09/05.
//

import Foundation

class MessageAPI: WanfAPI {
    
    let path = "/api/v1/messages"
    
    init() {
        super.init()
    }
    
    /// 쪽지 목록 조회
    func getLoadMessageList() -> URLComponents {
        var components = URLComponents()
        components.scheme = super.scheme
        components.host = super.host
        components.path = self.path + "/senders"
        
        return components
    }
    
    /// 쪽지 상세 목록 조회
    func getLoadMessageDetail(_ id: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = super.scheme
        components.host = super.host
        components.path = self.path + "/senders/\(id)"
        
        return components
    }
    
    /// 쪽지 전송
    func postSendMessage() -> URLComponents {
        var components = URLComponents()
        components.scheme = super.scheme
        components.host = super.host
        components.path = self.path
        
        return components
    }
}
