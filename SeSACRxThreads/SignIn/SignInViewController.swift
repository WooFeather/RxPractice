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
    
    let backgroundColor = Observable.just(UIColor.lightGray)
    
    let signUpTitle = Observable.just("회원이 아직 아니십니까?")
    let signUpTitleColor = Observable.just(UIColor.red)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        bindBackgroundColor()
        
//        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        
        signUpButton
            .rx
            .tap
            .bind { _ in
                self.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
//        signUpButton
//            .rx
//            .tap // Observable => 어떤 동작인지는 모르겠는데 일단 클릭은 됨
//            .subscribe { _ in // 버튼을 탭했을 때 뭐해줄건데?
//                self.navigationController?.pushViewController(SignUpViewController(), animated: true)
//                print("button tap onNext")
//            }
//            .disposed(by: disposeBag) // 항상 마지막에 써줘야 함

        
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
    
    func bindBackgroundColor() {
        // 기본 형태
//        backgroundColor
//            .subscribe { value in
//                self.view.backgroundColor = value
//            } onError: { error in
//                print(#function, error)
//            } onCompleted: {
//                print(#function, "onCompleted")
//            } onDisposed: {
//                print(#function, "onDisposed")
//            }
//            .disposed(by: disposeBag)
//        
//        // 순환참조 이슈 해결
//        backgroundColor
//            // with를 통해 순환참조를 해결해서 나온 친구 => owner
//            .subscribe(with: self) { owner, value in
//                owner.view.backgroundColor = value
//            } onError: { owner, error in
//                print(#function, error)
//            } onCompleted: { owner in
//                print(#function, "onCompleted")
//            } onDisposed: { owner in
//                print(#function, "onDisposed")
//            }
//            .disposed(by: disposeBag)
//        
//        // 호출되지 않는 이벤트 생략
//        backgroundColor
//            // with를 통해 순환참조를 해결해서 나온 친구 => owner
//            .subscribe(with: self) { owner, value in
//                owner.view.backgroundColor = value
//            }
//            .disposed(by: disposeBag)
//
//        // 이벤트를 받지 못하는 bind로, next만 동작되면 되는 기능이라면 bind로 구현
//        // 보통 UI와 관련된 코드에서 사용됨
//        backgroundColor
//            // with를 통해 순환참조를 해결해서 나온 친구 => owner
//            .bind(with: self) { owner, value in
//                owner.view.backgroundColor = value
//            }
//            .disposed(by: disposeBag)
//        
        backgroundColor
            .bind(to: view.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    
//    @objc func signUpButtonClicked() {
//        navigationController?.pushViewController(SignUpViewController(), animated: true)
//    }
    
    
    func configure() {
//        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
//        signUpButton.setTitleColor(Color.black, for: .normal)
        
        signUpTitle
            .bind(to: signUpButton.rx.title())
            .disposed(by: disposeBag)
        
        signUpTitleColor
            .bind(with: self, onNext: { owner, color in
                owner.signUpButton.setTitleColor(color, for: .normal)
            })
            .disposed(by: disposeBag)
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
