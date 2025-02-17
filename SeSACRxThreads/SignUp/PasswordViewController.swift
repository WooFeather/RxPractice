//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let password = BehaviorSubject(value: "1234")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
         
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        bind()
    }
    
//    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(PhoneViewController(), animated: true)
//    }
    
    func bind() {
        password
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                print("버튼 클릭")
                
                // passwordTextField의 내용을 random으로 바꿔주고 싶음
                
                // 1. 등호가 왜 안되지? => 옵저버블은 이벤트 전달만 함, 이벤트를 받을 수 없음
                // owner.password = "4342"
                
                owner.password.onNext("8888")
            }
            .disposed(by: disposeBag)
            
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
