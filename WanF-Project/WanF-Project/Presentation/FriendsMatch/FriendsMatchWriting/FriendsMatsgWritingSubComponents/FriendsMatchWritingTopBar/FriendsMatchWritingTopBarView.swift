//
//  FriendsMatchWritingTopBarView.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/04/14.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class FriendsMatchWritingTopBarView: UIView {
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    
    //MARK: -  View
    private lazy var cancelButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "xmark")
        configuration.baseForegroundColor = .wanfMint
        
        return UIButton(configuration: configuration)
    }()
    
    lazy var doneButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "checkmark")
        configuration.baseForegroundColor = .wanfMint
        
        let button = UIButton(configuration: configuration)
        button.isEnabled = false
        
        return button
    }()
    
    //MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureView()
        layout()
        
    }
    
    //MARK: - Function
    func bind(_ viewModel: FriendsMatchWritingTopBarViewModel) {
        
        // View -> ViewModel
        cancelButton.rx.tap
            .bind(to: viewModel.cancelButtonTapped)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .bind(to: viewModel.doneButtonTapped)
            .disposed(by: disposeBag)
        
        // ViewModel -> View
        
    }
}

//MARK: - Configure
private extension FriendsMatchWritingTopBarView {
    func configureView() {
        
        [
            cancelButton,
            doneButton
        ]
            .forEach { self.addSubview($0) }
        
    }
    
    func layout() {
        
        let inset = 0
        
        cancelButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(inset)
            make.leading.equalToSuperview().inset(inset)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(cancelButton)
            make.trailing.equalToSuperview().inset(inset)
        }
    }
}
