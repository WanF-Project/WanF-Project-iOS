//
//  ClubListViewModel.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/08/16.
//

import Foundation

import RxSwift
import RxCocoa

struct ClubListViewModel {
    
    // Properties
    let disposeBag = DisposeBag()
    
    // Subcomponent ViewModel
    let clubListTableViewModel = ClubListTableViewModel()
    
    // View -> ViewModel
    let loadAllClubs = PublishRelay<Void>()
    let addButtonTapped = PublishRelay<Void>()
    let createActionTapped = PublishRelay<Void>()
    let joinActionTapped = PublishRelay<Void>()
    let createClubTapped = PublishRelay<ClubRequestEntity>()
    let joinClubTapped = PublishRelay<ClubPwdRequestEntity>()
    
    let clubsSubject = PublishSubject<Observable<Void>>()
    let loadClubsSubject = PublishSubject<Void>()
    let refreshClubsSubject = PublishSubject<Void>()
    
    // ViewModel -> View
    let presentAddActionSheet: Driver<Void>
    let presentCreateAlert: Driver<Void>
    let presentJoinAlert: Driver<Void>
    let presentShareActivity: Driver<ClubShareInfoEntity>
    let pushToClubDetail: Driver<(info: ClubInfo, viewModel: ClubDetailViewModel)>
    
    init(_ model: ClubListModel = ClubListModel()) {
        
        // Load All Clubs
        let loadResult = clubsSubject
            .switchLatest()
            .flatMap(model.getAllClubs)
            .share()
        
        let loadValue = loadResult
            .compactMap(model.getAllClubsValue)
        
        let loadError = loadResult
            .compactMap(model.getAllClubsError)
        
        // Bind ClubListTableView
        loadValue
            .bind(to: clubListTableViewModel.shoulLoadClubs)
            .disposed(by: disposeBag)
        
        presentAddActionSheet = addButtonTapped
            .asDriver(onErrorDriveWith: .empty())
        
        presentCreateAlert = createActionTapped
            .asDriver(onErrorDriveWith: .empty())
        
        presentJoinAlert = joinActionTapped
            .asDriver(onErrorDriveWith: .empty())
        
        // Create the Club
        let createResult = createClubTapped
            .flatMap(model.createClub)
            .share()
        
        let createValue = createResult
            .compactMap(model.createClubValue)
        
        createValue
            .subscribe()
            .disposed(by: disposeBag)
        
        let createError = createResult
            .compactMap(model.createClubError)
        
        createError
            .subscribe(onNext: {
                print("ERROR: \($0)")
            })
            .disposed(by: disposeBag)
            
        // Join the Club
        let joinResult = joinClubTapped
            .flatMap(model.joinClub)
            .share()
        
        let joinValue = joinResult
            .compactMap(model.joinClubValue)
        
        let joinError = joinResult
            .compactMap(model.joinClubError)
        
        joinValue
            .subscribe()
            .disposed(by: disposeBag)
        
        joinError
            .subscribe(onNext: {
                print("ERROR: \($0)")
            })
            .disposed(by: disposeBag)
        
        // Get Club Password
        let clubInfo = clubListTableViewModel.shareButtonTapped
            .share()
        
        let pwdResult = clubInfo
            .map { $0.id }
            .flatMap(model.getClubPassword)
            .share()
        
        let pwdValue = pwdResult
            .compactMap(model.getClubPasswordValue)
        
        let pwdError = pwdResult
            .compactMap(model.getClubPasswordError)
        
         // Create ClubShareInfo
        let clubShareInfo = Observable
            .combineLatest(clubInfo, pwdValue){
                (name: $0.name, ID: $1.clubId, password: $1.password)
            }
            .map {
                ClubShareInfoEntity(clubName: $0.name, clubID: $0.ID.description, clubPassword: $0.password)
            }

        
        // Present ShareActivity
        presentShareActivity = clubShareInfo
            .asDriver(onErrorDriveWith: .empty())
        
        // Push to ClubDetail
        pushToClubDetail = clubListTableViewModel.shouldPushToClubDetail
            .map {
                let viewModel = ClubDetailViewModel()
                viewModel.id.accept($0.id)
                return ($0, viewModel)
            }
            .asDriver(onErrorDriveWith: .empty())
        
        // Initialize Data
        clubsSubject.onNext(loadClubsSubject)
    }
}
