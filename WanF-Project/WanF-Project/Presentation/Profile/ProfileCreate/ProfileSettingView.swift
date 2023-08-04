//
//  ProfileSettingView.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/08/03.
//

import UIKit

class ProfileSettingView: UIView {
    
    //MARK: - View
    let scrollView = UIScrollView()
    let profileInfoStack = UIStackView()
    
    let preImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .wanfMint
        return imageView
    }()
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
        
        preImageView.addSubview(settingPhotoButton)
        
        [
            preImageView,
            profileInfoStack
        ]
            .forEach { scrollView.addSubview($0) }
        
        self.addSubview(scrollView)
        
    }
    
    func layout() {
        
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.bottom.equalToSuperview()
        }
        
        preImageView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(300)
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
        settingPhotoButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileInfoStack.snp.makeConstraints { make in
            make.top.equalTo(preImageView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(15)
        }
    }
}

