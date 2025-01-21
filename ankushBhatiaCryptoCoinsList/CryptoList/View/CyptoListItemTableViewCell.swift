//
//  CyptoListItemTableViewCell.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import UIKit

class CyptoListItemTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .Title.light
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private lazy var descriptionLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .Description.semibold
        return label
    }()
    
    private lazy var newCryptoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: Icon.cryptoNew.rawValue)
        return imageView
    }()
    
    private lazy var cryptoTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Initialisers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        cryptoTypeImageView.layer.cornerRadius = 24
        cryptoTypeImageView.clipsToBounds = true
    }
    
    // MARK: -  Methods
    private func commonInit() {
        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        setupViewsHierarchy()
        setupConstraints()
    }
    
    func setupViewsHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(newCryptoImageView)
        contentView.addSubview(cryptoTypeImageView)
    }
    
    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        newCryptoImageView.translatesAutoresizingMaskIntoConstraints = false
        cryptoTypeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            
            newCryptoImageView.topAnchor.constraint(equalTo: topAnchor),
            newCryptoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newCryptoImageView.widthAnchor.constraint(equalToConstant: 32),
            newCryptoImageView.heightAnchor.constraint(equalToConstant: 32),
            
            cryptoTypeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cryptoTypeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cryptoTypeImageView.widthAnchor.constraint(equalToConstant: 48),
            cryptoTypeImageView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    func configure(_ item: CryptoItem) {
        titleLabel.text = item.name
        descriptionLabel.text = item.symbol
        newCryptoImageView.isHidden = !item.isNew
        setCryptoTypeImageView(item: item)
    }
    
    private func setCryptoTypeImageView(item: CryptoItem) {
        guard item.isActive else {
            cryptoTypeImageView.image = UIImage(named: Icon.cryptoInactive.rawValue)
            return
        }
        switch item.type {
            case .coin:
                cryptoTypeImageView.image = UIImage(named: Icon.coinActive.rawValue)
            case .token:
                cryptoTypeImageView.image = UIImage(named: Icon.tokenActive.rawValue)
        }
    }
}
