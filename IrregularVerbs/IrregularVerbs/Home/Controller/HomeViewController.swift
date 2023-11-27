//
//  HomeViewController.swift
//  IrregularVerbs
//
//  Created by Katerina on 27/11/2023.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.text = "IrregularVerbs".uppercased()
        label.font = .boldSystemFont(ofSize: 28)
        return label
    }()
    
    private lazy var firstButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Verbs".localized, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 20
        return button
    }()
    
    private lazy var secondButton: UIButton = {
       var button = UIButton()
        button.setTitle("Train Verbs".localized, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 20
        return button
    }()
    
        // MARK: - Properties
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(firstButton)
        view.addSubview(secondButton)
    }
    
    // MARK: - Private methods

}

