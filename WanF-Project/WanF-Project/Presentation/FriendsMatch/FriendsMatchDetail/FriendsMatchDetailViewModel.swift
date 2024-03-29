//
//  FriendsMatchDetailViewModel.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/04/11.
//

import UIKit

import RxSwift
import RxCocoa

struct FriendsMatchDetailViewModel {
    
    let disposeBag = DisposeBag()
    
    let detailInfoViewModel = PostUserInfoControlViewModel()
    let lectureInfoViewModel = FriendsMatchDetailLectureInfoViewModel()
    let detailTextViewModel = FriendsMatchDetailTextViewModel()
    let commentListViewModel = FriendsMatchCommentListViewModel()
    
    // View -> ViewModel
    let shouldLoadDetail = PublishSubject<Void>()
    let menueButtonTapped = PublishRelay<Void>()
    let deleteButtonTapped = BehaviorRelay(value: Void())
    let loadFriendsMatchDetail = PublishRelay<Void>()
    let shouldPresentCommentAlert = PublishRelay<Void>()
    let shouldSaveComment = PublishRelay<CommentRequestEntity>()
    let shouldRefreshDetail = PublishRelay<Void>()
    
    let commentSubject = PublishSubject<Observable<Int>>()
    let presentDetailProfileSubject = PublishSubject<Int>()
    let presentCommentProfileSubject = PublishSubject<Int>()
    
    let detailSubject = PublishSubject<Observable<Void>>()
    let loadDetailSubject = PublishSubject<Void>()
    let refreshDetailSubject = PublishSubject<Void>()
    
    // ViewModel -> View
    let detailData: Observable<PostResponseEntity>
    let presentMenueActionSheet: Signal<Void>
    let popToRootViewController: Driver<Void>
    let presentProfilePreview: Driver<(Int, ProfilePreviewViewModel)>
    let presentCommentAlert: Driver<Void>
    
    // ViewModel -> ChildViewModel
    let detailInfo: Observable<(String, String)>
    let detailLectureInfo: Observable<CourseEntity>
    let detailText: Observable<(String, String)>
    let detailComments: Observable<[CommentResponseEntity]>
    
    init(_ model: FriendsMatchDetailModel = FriendsMatchDetailModel(), id: Int) {
        
        //글 상세 데이터 받기
        let loadDetailResult = detailSubject
            .switchLatest()
            .flatMap { _ in
                model.loadDetail(id)
            }
            .share()
        loadDetailResult.subscribe().disposed(by: disposeBag)
        
        // 성공 - 각 SubView에 데이터 전달
        let loadDetailValue = loadDetailResult
            .compactMap(model.getDetailValue)
        
        detailData = loadDetailValue
            .share()
        
        presentProfilePreview = commentSubject
            .switchLatest()
            .map { ($0, ProfilePreviewViewModel()) }
            .asDriver(onErrorDriveWith: .empty())
        
        detailInfo = detailData
            .map({ data in
                (data.profile.nickname ?? "", data.date ?? "")
            })
        
        detailInfo
            .bind(to: detailInfoViewModel.detailInfo)
            .disposed(by: disposeBag)


        detailLectureInfo = detailData
            .map({ data in
                data.lectureInfo
            })

        detailLectureInfo
            .bind(to: lectureInfoViewModel.detailLectureInfo)
            .disposed(by: disposeBag)

        detailText = detailData
            .map({ data in
                (data.title, data.content)
            })

        detailText
            .bind(to: detailTextViewModel.detailText)
            .disposed(by: disposeBag)
        
        detailComments = detailData
            .map({ data in
                return data.comments
            })
        
        detailComments
            .bind(to: commentListViewModel.detailComments)
            .disposed(by: disposeBag)
        
        // TODO: - 추후 구현
        // 실패 -
        let loadDetailError = loadDetailResult
            .compactMap(model.getDetailError)
        
        // Tap the MenueButton
        presentMenueActionSheet = menueButtonTapped
            .asSignal(onErrorSignalWith: .empty())
        
        //Tap the Delete Button
        let deleteDetailResult = deleteButtonTapped
            .flatMap({ _ in
                model.deleteDetail(id)
            })
            .share()
        
        let deleteDetailValue = deleteDetailResult
            .compactMap(model.getDeleteDetailValue)
        
        let deleDetailError = deleteDetailResult
            .compactMap(model.getDeleteDetailError)
        
        popToRootViewController = deleteDetailValue
            .asDriver(onErrorDriveWith: .empty())
        
        // Present Comment Alert
        presentCommentAlert = shouldPresentCommentAlert
            .asDriver(onErrorDriveWith: .empty())
        
        // Save the Comment
        let commentSavedResult = shouldSaveComment
            .withLatestFrom(detailData) { content, data in
                return (postId: data.id, content: content)
            }
            .flatMap {
                model.postComment($0.postId, content: $0.content)
            }
            .share()
        
        let commentSavedValue = commentSavedResult
            .compactMap(model.getDeleteDetailValue)
        
        commentSavedResult.subscribe().disposed(by: disposeBag)
        
        let commentSavedError = commentSavedResult
            .compactMap(model.getDeleteDetailError)
        
        // Present Profile
        detailInfoViewModel.didTapUserInfo
            .withLatestFrom(detailData)
            .subscribe(onNext: { [self] data in
                self.commentSubject.onNext(self.presentDetailProfileSubject)
                self.presentDetailProfileSubject.onNext(data.profile.id)
            })
            .disposed(by: disposeBag)
        
        commentListViewModel.shouldPresentCommentProfile
            .withLatestFrom(detailData, resultSelector: { indexPath, data in
                data.comments[indexPath.row].profile.id
            })
            .subscribe(onNext: { [self] id in
                self.commentSubject.onNext(self.presentCommentProfileSubject)
                self.presentCommentProfileSubject.onNext(id)
            })
            .disposed(by: disposeBag)
        
        loadFriendsMatchDetail
            .subscribe(onNext: { [self] in
                self.detailSubject.onNext(self.loadDetailSubject)
                self.loadDetailSubject.onNext(Void())
            })
            .disposed(by: disposeBag)
        
        shouldRefreshDetail
            .subscribe(onNext: { [self] in
                self.detailSubject.onNext(self.refreshDetailSubject)
                self.refreshDetailSubject.onNext(Void())
                
            })
            .disposed(by: disposeBag)
    }
}
