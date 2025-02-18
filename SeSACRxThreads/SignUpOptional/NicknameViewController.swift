//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    // 랜덤 String 배열
    let recommandList = ["뽀로로", "상어", "악어", "고래", "칙촉", "추천"]
    let disposeBag = DisposeBag()
    
    // 이제 등호 안씀. next, completd, error 중에 던져줄 이벤트를 작성
    let nickname = PublishSubject<String>()
    
    func testPublishSubject() {
        let subject = PublishSubject<Int>()
        
        subject.onNext(2)
        subject.onNext(5)
        
        subject
            .subscribe(with: self) { owner, value in
                print(#function, value)
            } onError: { owner, error in
                print(#function, error)
            } onCompleted: { owner in
                print(#function, "onCompleted")
            } onDisposed: { owner in
                print(#function, "onDisposed")
            }
            .disposed(by: disposeBag)
        
        subject.onNext(7)
        subject.onNext(20)
        subject.onNext(30)
        subject.onCompleted()
        subject.onNext(39)
        subject.onNext(60)
    }
    
    func testBehaviorSubject() {
        let subject = BehaviorSubject(value: 1)
        
        subject.onNext(2)
        subject.onNext(5)
        
        subject
            .subscribe(with: self) { owner, value in
                print(#function, value)
            } onError: { owner, error in
                print(#function, error)
            } onCompleted: { owner in
                print(#function, "onCompleted")
            } onDisposed: { owner in
                print(#function, "onDisposed")
            }
            .disposed(by: disposeBag)
        
        subject.onNext(7)
        subject.onNext(20)
        subject.onNext(30)
        subject.onCompleted()
        subject.onNext(39)
        subject.onNext(60)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        testBehaviorSubject()
        testPublishSubject()

        view.backgroundColor = Color.white
        
        configureLayout()
       
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)

        bind()
    }
    
    func bind() {
        nickname
            .subscribe(with: self) { owner, value in
                owner.nicknameTextField.text = value
            } onError: { owner, error in
                print("nickname onError")
            } onCompleted: { owner in
                print("nickname onCompleted")
            } onDisposed: { owner in
                print("nickname onDisposed")
            }
            .disposed(by: disposeBag)

        // 함수 매개변수 안에 함수가 있는 상태
        // map({}) == map { } => @autoclosure
        
        // bind() 실행되는 시점에 이벤트 전달
        nickname.onNext("테스트1")
        nickname.onNext("테스트2")
        nickname.onNext("테스트3")
        
        nextButton.rx.tap
            .map {
                let random = self.recommandList.randomElement()!
                return random
            }
            .subscribe(with: self) { owner, value in
                print("nextButton Next")
                // 버튼이 tab되는 시점에 이벤트 전달
                owner.nickname.onNext(value)
            } onError: { owner, error in
                print("nextButton onError")
            } onCompleted: { owner in
                print("nextButton onCompleted")
            } onDisposed: { owner in
                print("nextButton onDisposed")
            }
            .disposed(by: disposeBag)
        
        // 약한 참조를 통해 self 캡쳐 현상 방지
        // Observable 체인 구독 과정
//        nextButton.rx.tap
//            .debug("==1==")
//            .withUnretained(self)
//            .debug("==2==")
//            .map { owner, _ in
//                let random = owner.recommandList.randomElement()!
//                return random
//            }
//            .debug("==3==")
//            .bind(to: nickname)
//            .disposed(by: disposeBag)
        
        // map을 써도 되지만, 옵저버블 2개를 결합해볼 수도 있음
//        nextButton.rx.tap
//            // .withLatestFrom(Observable.just(recommandList.randomElement()!))
//            // .flatMapLatest(Observable.just(recommandList.randomElement()!))
//            .bind(to: nickname)
//            .disposed(by: disposeBag)
    }
    
//    @objc func nextButtonClicked() {
//        navigationController?.pushViewController(BirthdayViewController(), animated: true)
//    }

    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
