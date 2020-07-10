//
//  UserDataViewModel.swift
//  cychain
//
//  Created by takadahideaki007 on 2020/05/24.
//  Copyright © 2020 高田英明. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserDataViewModel {

    private let disposeBag = DisposeBag()
    
    // Input: View => ViewModel
    let onRegisterButtonClick = PublishRelay<Void>()
    let onIcButtonClick = PublishRelay<Void>()
    let myNameRelay = BehaviorRelay<String>(value: "")
    let targetRelay = BehaviorRelay<String>(value: "")
    let onImageSelected = BehaviorRelay<UIImage>(value: R.image.user10()!)

        
    // Output: ViewModel => View
    let buttonImage: Driver<UIImage>?
    let isInputTextValid: Observable<Bool>
    let postsCountCheck: Observable<Bool>
    let goToNext: Observable<String>
    

    init() {
 
        //textField文字数check
        let charactorCheck = Observable
            .combineLatest(myNameRelay.asObservable(),
                           targetRelay.asObservable())
            .map { my, target in
                return (my.count > 0 && my.count < 13 ) && ( target.count > 0 && target.count < 13)
        }
        self.isInputTextValid = onRegisterButtonClick
            .withLatestFrom(charactorCheck) { _, isValid in isValid }
        
        
        
        //投稿数Check
        self.postsCountCheck = { () -> Observable<Bool> in
            
            if let UDData = UD.object(forKey: Name.KeyName.uniqueNmame.rawValue) as? [[String : String]]  {
                switch UDData.count {
                case 0 ... 10: return Observable.of(true)
                default: return Observable.of(false)
                    //  userDataModel.setUserDefault()
                    //  userDataModel.setFirebase()
                }
            } else {
                //投稿値歴無し
                return Observable.of(true)
                //  userDataModel.setUserDefault()
                //  userDataModel.setFirebase()
            }
        }()
        
        //文字数と投稿数が両方check
        let postPossibleCheck = Observable
            .combineLatest(isInputTextValid, postsCountCheck) {
                $0 && $1
        }
        self.goToNext = onRegisterButtonClick
            .withLatestFrom(postPossibleCheck) { _, isValid in isValid }
            .filter { $0 }
            .withLatestFrom(myNameRelay) { _, text1 in text1 }
        
        

        self.buttonImage = self.onImageSelected
               .asDriver(onErrorDriveWith: Driver<UIImage>.empty())
           /*
            self.onRegisterButtonClick
            .withLatestFrom(self.buttonImage)
            .subscribe(onNext: { selectedImage in
            // 画像をアップロードする処理...
            })
            .disposed(by: disposeBag)
            */
    }
        
        




/*
struct UserViewModelInputs {
    let onImageSelected = PublishRelay<UIImage>()
    let onRegisterButtonClick = PublishRelay<Void>()
    let onIcButtonClick = PublishRelay<Void>()
    let myNameRelay = BehaviorRelay<String>(value: "")
    let targetRelay = BehaviorRelay<String>(value: "")
}

protocol UserViewModelOutputs {
    var buttonImage: Driver<UIImage> { get }
    var postPossibleFlag: Observable<Bool> { get }
    var charactersCheckFlag: Observable<Bool> { get }
    var postFlag: Observable<Bool> { get }
    var postOverFlag: BehaviorRelay<Bool> { get }
}

protocol viewModelType {
    var input: UserViewModelInputs { get }
    var outputs: UserViewModelOutputs { get }
}

class UserDataViewModel: UserViewModelInputs, UserViewModelInputs, viewModelType {
    var input: UserViewModelInputs
    var outputs: UserViewModelOutputs
    var inptus: UserViewModelInputs { return self }
    var outPuts: UserViewModelOutputs { return self }
*/

    

}
