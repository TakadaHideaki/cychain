# App introduction ![](https://img.shields.io/static/v1?label=swift&message=5.3&color=green) 

 ```
 過去に出会っているけど縁が切れてしまった人と、再び繋がる為のマッチングアプリです
 ```

![Group(1)](https://user-images.githubusercontent.com/56917581/75443708-547a5280-59a5-11ea-9abd-8e2095d6159c.png)

#### Reason for creation
```
 『再会』がテーマのアプリです。  
新しい出会い目的のマッチングアプリは沢山有りますが、過去に出会っている人と  
再び繋がる事に特化したマッチングサービスが世の中になかったので、自分で作りました。  
 ```
#### AppName
```
サービス名称は、中国語の再会「サイチェン」の響きから、Cyber + Chain = cychain と命名しました
```
#### AppealPoint
```
#技術面
・ArchitectureにMVVMを採用し、RxSwiftを利用しました。

#UI/UX
① signup/Loginの切り替えをスライドで切り替えられる仕様にしました。
　　NewsPicksアプリを見て使いやすいと感じ、既存サービスの機能を自身でも実装出来るかチャレンジしました。

② マッチング後マッチデータ表示前に、ユーザーの気持ちを盛り上げる為、アニメーションViewを表示させました
　　データ表示の際imagデータの表示が、url変換処理の為textに比べてコンマ数秒遅れてしまいました
   この弱点を表示時間を揃えるのではなく、フロントでアニメーションを表示させ、その間にバックエンドでurl変換処理
   を行う対策によりUXが向上しました。
```

<br />
<br />
  
## Introduction Some function 
![ezgif com-gif-maker](https://user-images.githubusercontent.com/56917581/104749492-3886c780-5796-11eb-9584-cfe046e0f769.gif)

![ezgif com-gif-maker](https://user-images.githubusercontent.com/56917581/104927059-4fbaf480-59e4-11eb-9dfb-2d839c4c007d.gif)



<br />
<br />
![2348 (1)](https://user-images.githubusercontent.com/56917581/104788817-87ece800-57d6-11eb-88e5-774121002ddd.png)



## Usage
開発用TARGET：cychain copy  
※TARGET：cychainはリリース用の為機能しません。  

テスト用ログインメールアカウント  
adress：test@mail.com  
password：testuser1  

## Compatibility

This project is written in Swift 5.3 and requires Xcode 12.3 to build and run.

MarketApp is compatible with iOS 14.2+.


## Technologies

**Architecture**  
    MVVM - RxSwif  
    https://github.com/ReactiveX/RxSwift

**mBaaS**  
Firebase
 - RealtimeDataBase(textData, imagurl)
 - Firebase Authentication(UserEmailAdress + GoogleAccount)
 - FireStorage(imgData)

**License**   
LicensePlist  
https://github.com/mono0926/LicensePlist

**Logger**   
XCGLogger  
https://github.com/DaveWoodCom/XCGLogger

**Photo processing**    
RSKImageCropper  
https://github.com/ruslanskorb/RSKImageCropper

**UX/UI**   
XLPagerTabStrip  
https://github.com/xmartlabs/XLPagerTabStrip

**CodeManagementGUI**  
SourceTree

**Advertisement**  
Google AdMob

**Design**
- LTMorphingLabel(labelAnimation)  
https://github.com/lexrus/LTMorphingLabel  
- XLPagerTabStrip(Signup/Login切り替え)  
https://github.com/xmartlabs/XLPagerTabStrip  
- NVActivityIndicatorView(indicator)  
https://github.com/ninjaprox/NVActivityIndicatorView  

**Deploy**
- GoogleFormsAppStore
- Figma
- MakeAppIcon
- GitHubPages

## Functions list
**Auth**  
 - SignUp/Login (UserEmailAdress, GoogleAcount) 
 - SignOut/LogOut
 - パスワード忘れ再設定
  
 **投稿機能**  
 - 投稿（Text + Img）
 - 投稿リスト表示  
 - 投稿データ編集 
  
**検索機能**  
**Ather**  
 - UserBlock機能
 - お問い合わせ機能
 - Privacy policy 
 - Terms of service



## author
Hideaki Takada (高田英明)
- [wantedly](https://www.wantedly.com/user/profile/edit)
- [Twitter](https://twitter.com/HideakiTakada/)
- [Portfolio](https://takadahideaki.github.io/Portfolio.github.io/)

