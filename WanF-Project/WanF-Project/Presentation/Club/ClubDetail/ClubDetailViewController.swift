//
//  ClubDetailViewController.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/09/22.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class ClubDetailViewController: UIViewController {
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    
    //MARK: - View
    let addBarItem = AddBarButtonItem()
    let postTableview: UITableView = {
        var tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(ClubDetailListImageCell.self, forCellReuseIdentifier: "ClubDetailListImageCell")
        tableView.register(ClubDetailListTextCell.self, forCellReuseIdentifier: "ClubDetailListTextCell")
        
        return tableView
    }()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        layout()
    }
    
    func bind(_ viewModel: ClubDetailViewModel) {
        
        // View -> ViewModel
        viewModel.loadClubDetail.onNext(Void())
        
        addBarItem.rx.tap
            .bind(to: viewModel.didTapAddButton)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { _ in
                viewModel.clubDetailSubject.onNext(viewModel.refreshClubDetail)
                viewModel.refreshClubDetail.onNext(Void())
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        // ViewModel -> View
        viewModel.cellData
            .drive(postTableview.rx.items) { (tableView, row, element) -> UITableViewCell  in
                let viewModel = ClubDetailListCellViewModel()
                
                if element.image != nil { // Image
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClubDetailListImageCell") as? ClubDetailListImageCell
                    else { return UITableViewCell() }
                    
                    cell.bind(viewModel)
                    cell.configureCell(element)
                    cell.selectionStyle = .none
                    return cell
                }
                else { // Text
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClubDetailListTextCell") as? ClubDetailListTextCell
                    else { return UITableViewCell() }
                    
                    cell.bind(viewModel)
                    cell.configureCell(element)
                    cell.selectionStyle = .none
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.clubName
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.presentClubWriting
            .drive(onNext: { viewModel in
                let clubWritingVC = ClubWritingViewController()
                clubWritingVC.bind(viewModel)
                self.present(clubWritingVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

private extension ClubDetailViewController {
    func configure() {
        view.backgroundColor = .wanfBackground
        view.addSubview(postTableview)
        
        navigationItem.rightBarButtonItem = addBarItem
        
        postTableview.refreshControl = refreshControl
    }
    
    func layout() {
        postTableview.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

