//
//  ProfileSettingView.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/08/03.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class ProfileSettingView: UIView {
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    
    //MARK: - View
    let scrollView = UIScrollView()
    let profileInfoStack = UIStackView()
    let profilePersonalityView = ProfileKeywordSettingView(title: "성격")
    let profileGoalView = ProfileKeywordSettingView(title: "목표")
    
    let settingPhotoButton = ProfileSettingPhotoButton()
    
    let nameContorol = SettingControlView(title: "별명", placeholder: "원프", type: .text)
    let majorControl = SettingControlView(title: "전공", placeholder: "IT융합자율학부", type: .button)
    let studentIdControl = SettingControlView(title: "학번", placeholder: "202312345", type: .number)
    let ageControl = SettingControlView(title: "나이", placeholder: "23", type: .number)
    let genderControl = SettingControlView(title: "성별", placeholder: "성별", type: .button)
    let mbtiControl = SettingControlView(title: "MBTI", placeholder: "MBTI", type: .button)
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        
        configure()
        layout()
    }
    
    func bind(_ viewModel: ProfileSettingViewModel) {
        
        // Bind Subcomponents
        settingPhotoButton.bind(viewModel.settingPhotoButtonViewModel)
        
        nameContorol.bind(viewModel.nameControlViewModel)
        majorControl.bind(viewModel.majorControlViewModel)
        studentIdControl.bind(viewModel.studentIDControlViewModel)
        ageControl.bind(viewModel.ageControlViewModel)
        genderControl.bind(viewModel.genderControlViewModel)
        mbtiControl.bind(viewModel.mbtiControlViewModel)
        
        profilePersonalityView.bind(viewModel.personalitySettingViewModel)
        profileGoalView.bind(viewModel.goalSettingViewModel)
        
        // View -> ViewModel
        viewModel.didLoadProfileSettingView.accept(Void())
        
        settingPhotoButton.rx.tap
            .bind(to: viewModel.photoButtonTapped)
            .disposed(by: disposeBag)
    }
}

//MARK: - Configure
private extension ProfileSettingView {
    func configure() {
        
        profileInfoStack.axis = .vertical
        profileInfoStack.alignment = .leading
        profileInfoStack.distribution = .fill
        profileInfoStack.spacing = 10
        
        [
            nameContorol,
            majorControl,
            studentIdControl,
            ageControl,
            genderControl,
            mbtiControl
        ]
            .forEach { profileInfoStack.addArrangedSubview($0) }
        
        [
            settingPhotoButton,
            profileInfoStack,
            profilePersonalityView,
            profileGoalView
        ]
            .forEach { scrollView.addSubview($0) }
        
        self.addSubview(scrollView)
        
    }
    
    func layout() {
        
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.bottom.equalToSuperview()
        }
        
        settingPhotoButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(300)
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(30)
        }
        
        profileInfoStack.snp.makeConstraints { make in
            make.top.equalTo(settingPhotoButton.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.width.equalToSuperview().inset(30)
        }
        
        profilePersonalityView.snp.makeConstraints { make in
            make.top.equalTo(profileInfoStack.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(profileInfoStack)
        }
        
        profileGoalView.snp.makeConstraints { make in
            make.top.equalTo(profilePersonalityView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(profileInfoStack)
            make.bottom.equalToSuperview().inset(30)
        }
    }
}

