//
//  ChangeAvatarViewController.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

class ChangeAvatarViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    private let avatars: Observable<[String]> = Observable.just(Array(1 ... 12).map { "avatar_\($0)" })
    
    private let selectedPhotosSubject = PublishSubject<UIImage?>()
    var selectedPhotos: Observable<UIImage?> {
        return selectedPhotosSubject.asObservable()
    }
    
    deinit {
        selectedPhotosSubject.onCompleted()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView.register(cellType: AvatarCell.self)
        setupCellConfiguration()
        setupCellTapHandling()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let screenWidth = collectionView.bounds.width - 30
            flowLayout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
            flowLayout.invalidateLayout()
        }
    }
}

// MARK: - Rx Setup

private extension ChangeAvatarViewController {
    func setupCellConfiguration() {
        avatars.bind(to: collectionView.rx.items(cellIdentifier: AvatarCell.reuseIdentifier, cellType: AvatarCell.self)) { _, avatarName, cell in
            cell.thumbnailImageView.image = UIImage(named: avatarName)
        }.disposed(by: disposeBag)
    }

    func setupCellTapHandling() {
        collectionView.rx.modelSelected(String.self).subscribe { [weak self] avatarName in
            if let selectedRowIndexPaths = self?.collectionView.indexPathsForSelectedItems {
                for indexPath in selectedRowIndexPaths {
                    self?.collectionView.deselectItem(at: indexPath, animated: true)
                }
            }
            self?.selectedPhotosSubject.onNext(UIImage(named: avatarName))
            self?.navigationController?.popViewController(animated: true)
        } onError: { _ in }.disposed(by: disposeBag)
    }
}
