//
//  MusicCell.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/22/21.
//

import Reusable
import RxSwift
import UIKit

class MusicCell: UITableViewCell, NibLoadable {
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    private(set) var disponseBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disponseBag = DisposeBag()
    }
    
    var musicViewModel: MusicViewModel? {
        didSet {
            bindingToView()
        }
    }
    
    var isLiked: Bool = false {
        didSet {
            updateLikeButton()
        }
    }
    
    private func bindingToView() {
        guard let musicViewModel = musicViewModel else { return }
        
        nameLabel.text = musicViewModel.name
        artistNameLabel.text = musicViewModel.artistName
        thumbnailImageView.kf.setImage(with: URL(string: musicViewModel.artworkUrl100)!)
        isLiked = musicViewModel.lastLikeStatus
        
        // likeButton trigger
        likeButton
            .rx
            .tap
            .do(onNext: { [weak self] _ in
                self?.isLiked.toggle()
            })
                .map { self.isLiked }
                .bind(to: musicViewModel.inputs.likeButtonTrigger)
                .disposed(by: disponseBag)
    }
    
    private func updateLikeButton() {
        likeButton.setTitle(isLiked ? "Liked" : "Like", for: .normal)
        likeButton.setTitleColor(isLiked ? .red : .blue, for: .normal)
    }
}
