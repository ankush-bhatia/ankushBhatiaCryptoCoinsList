//
//  CoinFilterItemCollectionViewCell.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import UIKit

class CoinFilterItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var checkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.font = .Title.lightSmall
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = bounds.size.height / 2
    }
    
    // MARK: - Methods
    private func setupViewHierarchy() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews(
            checkImage,
            titleLabel
        )
    }
    
    private func setupConstraints() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        checkImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            checkImage.widthAnchor.constraint(equalToConstant: 16),
            checkImage.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    func configure(with item: CoinListFilterItem) {
        contentView.backgroundColor = UIColor(red: 229 / 255, green: 229 / 255, blue: 229 / 255, alpha: 1)
        titleLabel.text = item.type.name
        checkImage.isHidden = !item.isSelected
    }
}
