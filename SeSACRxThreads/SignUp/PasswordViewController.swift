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
    
    var disposeBag = DisposeBag()
    
    // scheduler == Main. Global == GCD
    let timer  = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    
    deinit {
        // self 캡쳐, 순환참조, 메모리 누수로 인해서 deinit 되지 않고 인스턴스가 계속 남아있음. Rx의 모든 코드가 살아있는 상태.
        // Deinit이 될 때 구독이 정상적으로 해제된다. Dispose된 상태
        print("password Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
         
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        bind()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.disposeBag = DisposeBag()
//        }
    }
    
//    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(PhoneViewController(), animated: true)
//    }
    
    func bind() {
        
         let incrementTimer = timer
            .subscribe(with: self) { owner, value in
                print("Timer", value) // Next
            } onError: { owner, error in
                print("Timer onError")
            } onCompleted: { owner in
                print("Timer onCompleted")
            } onDisposed: { owner in
                print("Timer onDisposed")
            }

        
        
        password
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap // 이벤트 전달. 옵저버블. next이벤트만 방출. UI관련 -> inifinit
            .bind(with: self) { owner, _ in
                print("버튼 클릭")
                
//                incrementValue.dispose()
                // passwordTextField의 내용을 random으로 바꿔주고 싶음
                
                // 1. 등호가 왜 안되지? => 옵저버블은 이벤트 전달만 함, 이벤트를 받을 수 없음
                // owner.password = "4342"
                
                owner.password.onNext("8888")
                
                // 명시적으로 타이머 옵저버블 구독 해제
                incrementTimer.dispose()
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
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
