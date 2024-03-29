//
//  MessageNetwork.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/09/06.
//

import Foundation

import RxSwift
import RxCocoa

class MessageNetwork: WanfNetwork {
    
    let api = MessageAPI()
    
    init() {
        super.init()
    }
    
    /// 쪽지 목록 조회
    func getLoadMessageList() -> Single<Result<MessageListResponseEntity, WanfError>> {
        guard let url = api.getLoadMessageList().url else {
            return .just(.failure(.invalidURL))
        }
        
        let request = UserDefaultsManager.accessTokenCheckedObservable
            .compactMap { $0 }
            .map { accessToken in
                var request = URLRequest(url: url)
                request.httpMethod = WanfHttpMethod.get.rawValue
                request.setValue(accessToken, forHTTPHeaderField: "Authorization")
                return request
            }
        
        return request
            .flatMap {
                super.session.rx.data(request: $0)
            }
            .map { data in
                do {
                    let decoded = try JSONDecoder().decode(MessageListResponseEntity.self, from: data)
                    return .success(decoded)
                }
                catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { error in
                    .just(.failure(.networkError))
            }
            .asSingle()
    }
    
    /// 쪽지 상세 목록 조회
    func getLoadMessageDetail(_ id: Int) -> Single<Result<ReceiverMessageResponseEntity, WanfError>> {
        guard let url = api.getLoadMessageDetail(id).url else {
            return .just(.failure(.invalidURL))
        }
        
        let request = UserDefaultsManager.accessTokenCheckedObservable
            .compactMap{ $0 }
            .map { accessToken in
                var request = URLRequest(url: url)
                request.httpMethod = WanfHttpMethod.get.rawValue
                request.setValue(accessToken, forHTTPHeaderField: "Authorization")
                return request
            }
        
        return request
            .flatMap {
                super.session.rx.data(request: $0)
            }
            .map { data in
                do {
                    let decoded = try JSONDecoder().decode(ReceiverMessageResponseEntity.self, from: data)
                    return .success(decoded)
                }
                catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { error in
                    .just(.failure(.networkError))
            }
            .asSingle()
    }
    
    /// 쪽지 전송
    func postSendMessage(_ message: MessageRequestEntity) -> Single<Result<Void, WanfError>> {
        guard let url = api.postSendMessage().url else {
            return .just(.failure(.invalidURL))
        }
        
        let request = UserDefaultsManager.accessTokenCheckedObservable
            .compactMap { $0 }
            .map { accessToken in
                let body = try? JSONEncoder().encode(message)
                var request = URLRequest(url: url)
                request.httpMethod = WanfHttpMethod.post.rawValue
                request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.setValue(accessToken, forHTTPHeaderField: "Authorization")
                request.httpBody = body
                
                return request
            }
        
        return request
            .flatMap {
                super.session.rx.data(request: $0)
            }
            .map { _ in
                    .success(Void())
            }
            .catch { error in
                    .just(.failure(.networkError))
            }
            .asSingle()
    }
}
