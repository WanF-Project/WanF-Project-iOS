//
//  BannerListSupplementaryFooterView.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/10/28.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class BannerListSupplementaryFooterView: UICollectionReusableView {
    
    private let disposeBag = DisposeBag()
    
    //MARK: - View
    lazy var pageControl = UIPageControl()
    
    //MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure()
        layout()
    }
    
    //MARK: - Function
    func bind(_ viewModel: BannerListSupplementaryFooterViewModel) {
        
        viewModel.currentPage
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: disposeBag)
    }
}

// Configuration
private extension BannerListSupplementaryFooterView {
    func configure() {
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        
        self.addSubview(pageControl)
    }
    
    func layout() {
        pageControl.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().inset(-25)
        }
    }
}
