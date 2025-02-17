//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    // Observable => 이걸로 무슨일을 할지는 모르겠지만, 일단 텍스트임
    let emailText = Observable.just("a@a.com")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
//        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        
        signUpButton
            .rx
            .tap
            .bind { _ in
                self.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        signUpButton
            .rx
            .tap // Observable => 어떤 동작인지는 모르겠는데 일단 클릭은 됨
            .subscribe { _ in // 버튼을 탭했을 때 뭐해줄건데?
                self.navigationController?.pushViewController(SignUpViewController(), animated: true)
                print("button tap onNext")
            }
            .disposed(by: disposeBag) // 항상 마지막에 써줘야 함

        
        emailText
            .subscribe { value in // 텍스트로 어떤 동작을 할건데?
                self.emailTextField.text = value
                print("emailText onNext")
            } onError: { error in
                print("emailText onError")
            } onCompleted: { // 완벽하게 데이터를 받았을 때
                print("emailText onCompleted")
            } onDisposed: { // 리소스를 정리했을때를 명시적으로 보기 위함
                print("emailText onDisposed")
            }
            .disposed(by: disposeBag) // 일을 끝냈으면 더이상 리소스를 차지하고 있을 필요가 없어서 dispose

    }
    
//    @objc func signUpButtonClicked() {
//        navigationController?.pushViewController(SignUpViewController(), animated: true)
//    }
    
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
