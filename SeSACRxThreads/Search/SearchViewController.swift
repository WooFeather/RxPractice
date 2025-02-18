//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
   
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
    let items = Observable.just([
        "첫 번째 Item",
        "두 번째 Item",
        "세 번째 Item"
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
//        test()
    }
    
    func test() {
        
        let mentor = Observable.of("Hue", "Jack", "dd", "ddss")
        let age = Observable.of(10, 10, 10, 13)
        
        Observable.combineLatest(mentor, age)
            .bind(with: self) { owner, value in
                print(value.0, value.1)
            }
            .disposed(by: disposeBag)
    }
    
    func bind() {
        
        // 서치바 리턴 클릭
//        searchBar.rx.searchButtonClicked
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .withLatestFrom(searchBar.rx.text.orEmpty)
//            .distinctUntilChanged()
//            .bind(with: self) { owner, value in
//                print("리턴키 클릭", value)
//            }
//            .disposed(by: disposeBag)
        
        // 실시간 검색
        searchBar.rx.text.orEmpty
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                print("실시간 글자", value)
            }
            .disposed(by: disposeBag)
        
        
        items
        .bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
            cell.appNameLabel.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        // 두 개 이상의 옵저버블을 하나로 합쳐줌!
        // zip vs combineLatest
        Observable.combineLatest(
            tableView.rx.modelSelected(String.self),
            tableView.rx.itemSelected
            
        )
        .map{
            "\($0.1.row) 번째 인덱스에는 \($0.0)데이터가 있습니다."
        }
        .bind(with: self) { owner, value in
            print(value) // map으로 반환된 String
        }
        .disposed(by: disposeBag)
    }
     
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        print("추가 버튼 클릭")
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
