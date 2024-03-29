//
//  PostUserInfoControlView.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/09/22.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

/// 별명 및 날짜가 포함되어 있는 게시글 상단 Detail Info View
class PostUserInfoControlView: UIControl {
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    
    //MARK: - View
    lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "별명"
        label.font = .wanfFont(ofSize: 16, weight: .bold)
        label.textColor = .wanfLabel
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "2023.05.03"
        label.font = .wanfFont(ofSize: 13, weight: .light)
        label.textColor = .wanfLabel
        
        return label
    }()
    
    //MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureView()
        layout()
    }
    
    //MARK: - Function
    func bind(_ viewModel: PostUserInfoControlViewModel) {
        
        // ViewModel -> View
        viewModel.loadDeatilInfo
            .drive(onNext: { (nickname, date) in
                self.nicknameLabel.text = nickname
                self.dateLabel.text = DateFormatter().wanfDateFormatted(from: date)
            })
            .disposed(by: disposeBag)
        
        self.rx.controlEvent(.touchUpInside)
            .bind(to: viewModel.didTapUserInfo)
            .disposed(by: disposeBag)
        
    }
}

//MARK: - Configure
private extension PostUserInfoControlView {
    
    func configureView() {
        
    }
    
    func layout() {
        
        [
            nicknameLabel,
            dateLabel
        ]
            .forEach { addSubview($0) }
        
        let inset = 10.0
        let offset = 10.0
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(inset)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(offset)
            make.leading.equalTo(nicknameLabel)
            make.bottom.equalToSuperview()
        }
        
    }
}
