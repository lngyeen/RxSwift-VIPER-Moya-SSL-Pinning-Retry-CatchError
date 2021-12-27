//
//  MusicDetailViewController.swift
//  RXSwiftExample
//
//  Created by Nguyen Truong Luu on 12/25/21.
//

import RxSwift
import UIKit

class MusicDetailViewController: BaseViewController {
    // MARK: - Outlets

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    // MARK: - Properties

    var presenter: MusicDetailPresenter?

    // MARK: - Private properties

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func bindingPresenterOutputs() {
        presenter?
            .outputs
            .music
            .subscribe { (music: MusicViewModel) in
                self.titleLabel.text = music.name
                self.descriptionLabel.text = music.artistName
                self.imageView.kf.setImage(with: URL(string: music.artworkUrl100)!)
            }
            .disposed(by: disposeBag)
    }
}
