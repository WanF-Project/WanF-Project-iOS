//
//  FriendsMatchSearchModel.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/08/01.
//

import Foundation

import RxSwift
import RxCocoa

struct FriendsMatchSearchModel {
    
    let network = FriendsMatchNetwork()
    
    // 게시글 검색
    func searchPosts(_ searchWord: String, pageable: PageableEntity) -> Single<Result<SlicePageableResponseEntity<PostListResponseEntity>, WanfError>> {
        return network.searchPosts(searchWord, pageable: pageable)
    }
    
    func searchValue(_ result: Result<SlicePageableResponseEntity<PostListResponseEntity>, WanfError>) -> SlicePageableResponseEntity<PostListResponseEntity>? {
        guard case .success(let value) = result else {
            return nil
        }
        return value
    }
    
    func searchError(_ result: Result<SlicePageableResponseEntity<PostListResponseEntity>, WanfError>) -> Void? {
        guard case .failure(let error) = result else {
            return nil
        }
        print("ERROR: \(error)")
        return Void()
    }
}
