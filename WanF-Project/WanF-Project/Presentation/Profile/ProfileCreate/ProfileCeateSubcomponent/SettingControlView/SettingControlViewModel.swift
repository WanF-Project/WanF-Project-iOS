//
//  SettingControlViewModel.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/08/06.
//

import Foundation

import RxSwift
import RxCocoa

struct SettingControlViewModel {
    
    let disposeBag = DisposeBag()
    
    let nameableValue = PublishRelay<any Nameable>()
    let stringValue = PublishRelay<String>()
    let text: Driver<String>
    
    init() {
        
        nameableValue
            .map { $0.name }
            .bind(to: stringValue)
            .disposed(by: disposeBag)
        
        text = stringValue
            .asDriver(onErrorDriveWith: .empty())
    }
    
}
