//
//  CourseInfoListViewController.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/04/15.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class CourseInfoListViewController: UIViewController {
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    
    //MARK: - View
    lazy var searchBar = CSSearchBarView()
    
    lazy var lectureInfoTableView: UITableView = {
        var tableView = UITableView()
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .singleLine
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LectureInfoListCell")
        
        return tableView
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        layout()
    }
    
    //MARK: - Function
    func bind(_ viewModel: CourseInfoListViewModel) {
        
        //Load
        viewModel.shouldLoad.accept(Void())
        
        // Subcomponent Bind
        searchBar.bind(viewModel.searchBarViewModel)
        
        // View -> ViewModel
        lectureInfoTableView.rx.itemSelected
            .bind(to: viewModel.lectureInfoListItemSelected)
            .disposed(by: disposeBag)
        
        // ViewModel -> View
        bindTableView(viewModel)
        
        viewModel.dismissAfterItemSelected
            .drive(onNext: { lectureInfo in
                //강의정보 데이터 전달
                Observable.just(lectureInfo)
                    .bind(to: viewModel.viewWillDismiss)
                    .disposed(by: self.disposeBag)
                
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func bindTableView(_ viewModel: CourseInfoListViewModel) {
        viewModel.cellData
            .drive(lectureInfoTableView.rx.items) { tv, row, element in
                
                let cell = tv.dequeueReusableCell(withIdentifier: "LectureInfoListCell", for: IndexPath(row: row, section: 0))
                
                var configuration = UIListContentConfiguration.valueCell()
                configuration.text = element.name
                configuration.secondaryText = element.professor
                
                let attributedKey = NSAttributedString.Key.self
                let attributes = [
                    attributedKey.font : UIFont.wanfFont(ofSize: 15, weight: .regular),
                    attributedKey.foregroundColor : UIColor.wanfLabel
                ]
                let attributedTitle = NSAttributedString(string: element.name, attributes: attributes)
                let attributedSubtitle = NSAttributedString(string: element.professor, attributes: attributes)
                
                configuration.attributedText = attributedTitle
                configuration.secondaryAttributedText = attributedSubtitle
                
                cell.contentConfiguration = configuration
                
                let backgroundView = UIView()
                backgroundView.backgroundColor = .wanfLightMint
                
                cell.selectedBackgroundView = backgroundView
                
                return cell
            }
            .disposed(by: disposeBag)
    }
}

private extension CourseInfoListViewController {
    func configureView() {
        
        view.backgroundColor = .wanfBackground
        
        [
            searchBar,
            lectureInfoTableView
        ]
            .forEach { view.addSubview($0) }
    }
    
    func layout() {
        
        let verticalInset = 30.0
        let horizontalInset = 15.0
        
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(verticalInset)
            make.horizontalEdges.equalToSuperview().inset(horizontalInset)
        }
        
        lectureInfoTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(horizontalInset)
        }
    }
}

