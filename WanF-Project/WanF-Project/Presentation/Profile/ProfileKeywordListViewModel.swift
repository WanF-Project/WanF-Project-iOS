//
//  ProfileKeywordListViewModel.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/04/30.
//

import UIKit

import RxSwift
import RxCocoa

struct ProfileKeywordListViewModel {
    
    // View -> ViewModel
    let doneButtonTapped = PublishRelay<Void>()
    let keywordIndexList = PublishRelay<[IndexPath]>()
    let viewWillDismiss = PublishSubject<Void>()
    
    // ViewModel -> View
    let cellData: Driver<[String]>
    let dismissAfterDoneButtonTapped: Driver<Void>
    
    // ViewModel -> ParentViewModel
    let didSelectKeywords: Signal<[String]>
    
    init(_ model: ProfileKeywordListModel = ProfileKeywordListModel()) {

        // 키워드 목록
        cellData = Observable
            .just(
                [
                    "1",
                    "2",
                    "3",
                    "4"
                ]
            )
            .asDriver(onErrorDriveWith: .empty())
        
        // 선택 된 아이템 정리
        let keywordsSelected = keywordIndexList
            .withLatestFrom(cellData) { indexList, keywords in
                var keywordsSelected: [String] = []
                
                for index in indexList {
                    keywordsSelected.append(keywords[index.row])
                }
                return keywordsSelected
            }
        
        // 완료 버튼 Tap 시 서버 전달
        let saveResult = doneButtonTapped
            .withLatestFrom(keywordsSelected)
            .flatMap { keywords in
                model.saveProfileKeywordList(keywords, type: .personality)
            }
            .share()
        
        let saveValue = saveResult
            .compactMap(model.getSavedProfileKeywordListValue)
        
        let saveError = saveResult
            .compactMap(model.getSavedProfileKeywordListError)
        
        // 서버 전달 성공 시 Dismiss
        dismissAfterDoneButtonTapped = saveValue
            .map{ _ in }
            .asDriver(onErrorDriveWith: .empty())
        
        didSelectKeywords = viewWillDismiss
            .withLatestFrom(keywordsSelected)
            .asSignal(onErrorJustReturn: [])
    }
}
