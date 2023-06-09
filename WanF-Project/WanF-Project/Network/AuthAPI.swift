//
//  AuthAPI.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/05/09.
//

import Foundation

class AuthAPI: WanfAPI {
    
    //MARK: - Properties
    let path = "/api/v1/auth/"
    
    init() {
        super.init()
    }
    
    //MARK: - Function
    // 로그인
    func signIn() -> URLComponents {
        var components = URLComponents()
        components.scheme = super.scheme
        components.host  = super.host
        components.path = self.path + "login"
        
        return components
    }
}

//MARK: - JWT Task
extension AuthAPI {
    
    // AT 만료 여부 확인
    final func checkAuthorizationExpired() -> URLComponents {
        var components = URLComponents()
        components.scheme = super.scheme
        components.host = super.host
        components.path = self.path + "validate"
        
        return components
    }
    
    // 토큰 재발급
    func reissueAuthorization() -> URLComponents {
        var components = URLComponents()
        components.scheme = super.scheme
        components.host = super.host
        components.path = self.path + "reissue"
        
        return components
    }
}
