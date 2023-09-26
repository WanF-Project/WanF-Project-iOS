//
//  ClubDetailViewModel.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/09/22.
//

import Foundation

import RxSwift
import RxCocoa

struct ClubDetailViewModel {
    
    let disposeBag = DisposeBag()
    let id = PublishRelay<Int>()
    
    // View -> ViewModel
    let loadClubDetail = PublishRelay<Void>()
    
    // ViewModel -> View
    let cellData: Driver<ClubPostListResponseEntity>
    let clubName = PublishRelay<String>()
    
    init(_ model: ClubDetailModel = ClubDetailModel()) {
        
        // Load ClubDetail
        let loadResult = loadClubDetail
            .withLatestFrom(id)
            .flatMap(model.loadAllClubPosts)
            .share()
        
        let loadValue = loadResult
            .compactMap(model.loadAllClubPostValue)
        
        let loadError = loadResult
            .compactMap(model.loadAllClubPostError)
        
        loadError
            .subscribe(onNext: {
                print("ERROR: \($0)")
            })
            .disposed(by: disposeBag)
        
        cellData = loadValue
            .asDriver(onErrorDriveWith: .empty())
    }
}
