//
//  FriendsMultipleSectionModel.swift
//  WanF-Project
//
//  Created by 임윤휘 on 2023/10/26.
//

import UIKit

import RxDataSources

/// FriendsMatchList 화면 다중 Section을 위한 메서드 및 열거형
typealias FriendsMultipleSectionDataSource = RxCollectionViewSectionedReloadDataSource<MultipleSectionModel>

func dataSource(_ viewModel: FriendsMultipleListViewModel) -> FriendsMultipleSectionDataSource {
    return FriendsMultipleSectionDataSource(configureCell: { dataSource, collectionView, indexPath, item in
        switch dataSource[indexPath] {
        case let .BannerItem(banner):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerListCell", for: indexPath) as? BannerListCell else { return UICollectionViewCell() }
            cell.configureCell(banner)
            return cell
        case let .PostItme(post):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsMatchListCell", for: indexPath) as? FriendsMatchListCell else { return UICollectionViewCell() }
            cell.configureCell(post)
            return cell
        }
    }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
        guard let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "BannerListSupplementaryFooterView",
            for: indexPath) as? BannerListSupplementaryFooterView
        else { return UICollectionReusableView() }
        
        footer.bind(viewModel.bannerListSupplementaryFooterViewModel)
        
        return footer
    })
}

enum MultipleSectionModel {
    case BannerSection(items:[SectionItem])
    case PostSection(items:[SectionItem])
}

enum SectionItem {
    case BannerItem(_ banner: BannerEntity)
    case PostItme(_ post: PostListResponseEntity)
}

extension MultipleSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case let .BannerSection(items: items):
            return items
        case let .PostSection(items: items):
            return items
        }
    }
    
    init(original: MultipleSectionModel, items: [SectionItem]) {
        switch original {
        case let .BannerSection(items: items):
            self = .BannerSection(items: items)
        case let .PostSection(items: items):
            self = .PostSection(items: items)
        }
    }
}

enum MultipleSectionType {
    case bannerSection
    case postSection
}
