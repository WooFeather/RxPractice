//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SignUpViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    let emailPlaceholder = Observable.just("이메일을 입력해주세요")
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        bind()
        OperatorExample()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)

    }
    
    func OperatorExample() {
        let itemA = [3, 5, 23, 6, 23, 1, 32]
        
        Observable
            .repeatElement(itemA)
            .take(10)
            .subscribe(with: self) { owner, value in
                print("take \(value)")
            } onError: { owner, error in
                print("take \(error)")
            } onCompleted: { owner in
                print("take onCompleted")
            } onDisposed: { owner in
                print("take onDisposed")
            }
            .disposed(by: disposeBag)

    }
    
    func bind() {
        // 4자리 이상: 다음버튼 나타나고, 중복확인 버튼이 탭되게 하고 싶음
        let validation =  emailTextField
            .rx
            .text
            .orEmpty // 옵셔널 처리
            .map { $0.count >= 4 }
        
//        validation.bind(to: validationButton.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        validation
            .subscribe(with: self) { owner, value in
                owner.validationButton.isEnabled = value
                print("validation onNext")
            } onDisposed: { owner in
                print("validation onDisposed")
            }
            .disposed(by: disposeBag)

        
        validationButton.rx.tap
            .bind(with: self) { owner, value in
                print("중복확인 버튼 눌림")
                owner.disposeBag = DisposeBag()
            }
            .disposed(by: disposeBag)
        
//        validation
//            .bind(with: self) { owner, value in
//                if value.count < 4 {
//                    owner.nextButton.isHidden = true
//                    owner.validationButton.isEnabled = false
//                } else {
//                    owner.nextButton.isHidden = false
//                    owner.validationButton.isEnabled = true
//                }
//            }
//            .disposed(by: disposeBag)
        
        emailPlaceholder
            .bind(to: emailTextField.rx.placeholder)
            .disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
