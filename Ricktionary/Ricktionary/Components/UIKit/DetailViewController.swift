//
//  DetailViewController.swift
//  Ricktionary
//
//  Created by Timothy Obeisun on 5/29/25.
//

import UIKit

class DetailViewController: UIViewController {
    private lazy var characterImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.constrainHeight(constant: 300)
        return view
    }()
    
    private lazy var characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private lazy var speciesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private lazy var episodesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    lazy var scrollView = UIScrollView.createWithVStack(
        spacing: 24,
        alignment: .fill,
        distribution: .fill,
        views: [
            characterImageContainer,
            nameLabel,
            genderLabel,
            statusLabel,
            speciesLabel,
            episodesLabel
        ]
    )
    
    private var viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        title = "viewModel.character.name"
        
        setupScrollView()
        setupCharacterImage()
        setupNameLabel()
        setupGenderLabel()
        setupStatusLabel()
        setupSpeciesLabel()
        setupEpisodesLabel()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
    }
    
    private func setupCharacterImage() {
        characterImageContainer.addSubview(characterImage)
        
        characterImage.constrainHeight(constant: 270)
        characterImage.constrainWidth(constant: 270)
        characterImage.applyCornerRadius(135)
        characterImage.centerInSuperview()
        
        guard let characterImage = viewModel.character.image, let imageURL = URL(string: characterImage) else { return }
        viewModel.fetchCharacterImage(from: imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.characterImage.image = image
            }
        }
    }
    
    private func setupNameLabel() {
        nameLabel.text = viewModel.character.name
    }
    
    private func setupGenderLabel() {
        genderLabel.text = "Gender: \(viewModel.character.gender ?? "-")"
    }
    
    private func setupStatusLabel() {
        statusLabel.text = "Status: \(viewModel.character.status ?? "-")"
    }
    
    private func setupSpeciesLabel() {
        speciesLabel.text = "Species: \(viewModel.character.species ?? "-")"
    }
    
    private func setupEpisodesLabel() {
        let episodes = viewModel.character.episode?.count ?? 0
        if episodes == 0 {
            episodesLabel.isHidden = true
        } else {
            episodesLabel.text = "\(episodes < 2 ? "Episode" : "Episodes"): \(episodes)"
        }
    }
}
