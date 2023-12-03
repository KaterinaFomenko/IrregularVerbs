//
//  TrainViewController.swift
//  IrregularVerbs
//
//  Created by Katerina on 28/11/2023.
//

import UIKit
import SnapKit

final class TrainViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
       let view = UIScrollView()
        
        return view
    }()
    
    private lazy var contentView: UIView = UIView()
    
    private lazy var infinitiveLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Read".uppercased()
        
        return label
    }()
    
    private lazy var currentOfTotal: UILabel = {
        var label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "0/0"
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var scoreButton: UIButton = {
        let button = UIButton ()
        button.backgroundColor = .systemGray5
        button.setTitle("Score:".localized + " 0" , for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    private lazy var pastSimpleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "Past Simple"
        
        return label
    }()
   
    private lazy var participleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "Past Participle"
        
        return label
    }()
    
    private lazy var pastSimpleTextField: UITextField = {
       var field = UITextField()
        
        field.borderStyle = .roundedRect
        field.delegate = self
        
        return field
    }()
    
    private lazy var participleTextField: UITextField = {
       var field = UITextField()
        
        field.borderStyle = .roundedRect
        field.delegate = self
        
        return field
    }()
    
    private lazy var checkButton: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("Check".localized, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.addTarget(self,
                         action: #selector(checkAnswer),
                         for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Properties
    private let edgeInsets = 30
    private var dataSource = IrregularVerbs.shared.selectedVerbs
   
    private var currentVerb: Verb? {
        guard dataSource.count > count else { return nil }
        return dataSource[count]
    }
        
    var totalCount = 0
   
    private var count = 0  // нач-ем с 0 индекса глаголы
    private var correctCount = 0
    
    // MARK: - Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Train Verbs".localized
        setupUI()
        hideKeyboardWhenTappedAround()
        setupData()
        updateResult()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotification()
    }
    
    // MARK: - Private methods
    private func setupData() {
        dataSource = dataSource.isEmpty ? IrregularVerbs.shared.verbs : IrregularVerbs.shared.selectedVerbs
        
        totalCount = dataSource.count
        infinitiveLabel.text = dataSource.first?.infinitive
    }
    // Логика проверки глаголов
    private func prepareNextQuestion() {
        infinitiveLabel.text = currentVerb?.infinitive
        pastSimpleTextField.text = ""
        participleTextField.text = ""
    }
    
    private func updateResult() {
        currentOfTotal.text = "\(count + 1)/\(totalCount)"
        scoreButton.setTitle("Score:".localized + " \(correctCount)", for: .normal)
    }
    
    @objc
    private func checkAnswer() {
        if isAnswerCorrect() {
            correctCount += 1
            animateButtonColor(button: checkButton, color: .green)
            
            if currentVerb?.infinitive == dataSource.last?.infinitive {
                showAlert(title: "Training is over", message: "Your result is \(correctCount) from \(totalCount) question".localized)
            } else {
                count += 1
                prepareNextQuestion()
            }
        }
        else {
            if currentVerb?.infinitive == dataSource.last?.infinitive {
                showAlert(title: "Training is over", message: "Your result is \(correctCount) from \(totalCount) question".localized)
            } else {
                animateButtonColor(button: checkButton, color: .red)
                count += 1
                
                prepareNextQuestion()
            }
        }
        updateResult()
    }
    
    private func isAnswerCorrect() -> Bool {
       pastSimpleTextField.text?.lowercased().trimmingCharacters(in: .whitespaces) == currentVerb?.pastSimple &&
            participleTextField.text?.lowercased().trimmingCharacters(in: .whitespaces) == currentVerb?.participle
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func animateButtonColor(button: UIButton, color: UIColor) {
        UIView.transition(with: button, duration: 1.3, options: .curveEaseInOut, animations: {
            button.backgroundColor = color
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.transition(with: button, duration: 1.3, options: .curveEaseInOut, animations: {
                button.backgroundColor = .systemGray5
            })
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(scoreButton)
        scrollView.addSubview(currentOfTotal)

        contentView.addSubviews([
                                    infinitiveLabel,
                                    pastSimpleLabel,
                                    pastSimpleTextField,
                                    participleLabel,
                                    participleTextField,
                                    checkButton])
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.size.edges.equalToSuperview()
        }
        
        scoreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(60)
            make.width.equalTo(150)
        }
        
        currentOfTotal.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scoreButton).inset(50)
            make.width.equalTo(120)
        }
        
        infinitiveLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        pastSimpleLabel.snp.makeConstraints { make in
            make.top.equalTo(infinitiveLabel.snp.bottom).offset(60)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        pastSimpleTextField.snp.makeConstraints { make in
            make.top.equalTo(pastSimpleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        participleLabel.snp.makeConstraints { make in
            make.top.equalTo(pastSimpleTextField.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        participleTextField.snp.makeConstraints { make in
            make.top.equalTo(participleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(participleTextField.snp.bottom).offset(100)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
    }
}

// MARK: - UITextFieldDelegate
extension TrainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if pastSimpleTextField.isFirstResponder {
            participleTextField.becomeFirstResponder()
        } else {
            scrollView.endEditing(true)
        }
        return true
    }
}
 
// MARK: - Keyboard events
extension TrainViewController {
    // подписались
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unregisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
     
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset.bottom = frame.height + 50
    }
    
    @objc
    func keyboardWillHide() {
        scrollView.contentInset.bottom = .zero - 50
    }
    
    func hideKeyboardWhenTappedAround() {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(recognizer)
    }
    
    @objc
    func hideKeyboard() {
        scrollView.endEditing(true)
    }
}
