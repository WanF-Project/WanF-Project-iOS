//
//  ProfileEditViewModel.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/09/19.
//

import Foundation

import RxSwift
import RxCocoa

struct ProfileEditViewModel {
    
    let disposeBag = DisposeBag()
    
    // Subcomponent ViewModel
    let profileSettingViewModel = ProfileSettingViewModel()
    
    // ViewModel ->View
    let profile = PublishRelay<ProfileResponseEntity>()
    let data = PublishRelay<ProfileResponseEntity>()
    
    init() {
        data
            .bind(to: profileSettingViewModel.data)
            .disposed(by: disposeBag)
    }
}
