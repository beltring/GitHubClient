# _GitHub client_

##### The GitHub client is a mobile application for iOS, designed to work with github.com

## Features

- View the repositories of an authorized user
- View starred repositories of an user
- Creating a new repository in github
- View problems and filtering them
- View user information and the top of their repositories
- Search for repositories and users

## Installation

GitHub client requires IOS v13.3+ to run.
To run the app, install the dependencies using cocoaPods. Open the terminal in the application folder and run the following command
```sh
pod install
```

## Library

GitHub client is currently extended with the following libraries.
Instructions on how to use them are linked below.

| Library | README |
| —--— | —--— |
- | Keychain | https://github.com/evgenyneu/keychain-swift/blob/master/README.md |
- | OAuthSwift | https://github.com/OAuthSwift/OAuthSwift/blob/master/README.md |
- | Reachability | https://github.com/ashleymills/Reachability.swift/blob/master/README.md |

## Instructions for use

To work, you need to log in using github.com. After authorization, the app's start screen appears.
- Authorization screen

![alt tag](https://sun9-34.userapi.com/impf/PBsbb2I6qy_qQY4OmddAMtHCRITjbLtR_5Xz3w/BxPeMHVur5I.jpg?size=470x911&quality=96&sign=6bd2310b9902ec9e7bde1ebc1356cca2&type=album)

On the start screen, we can go to the user's repositories, issues, and star repositories. You can also go to the search for users and repositories on the github site.
- Start screen

![alt tag](https://sun9-48.userapi.com/impf/BAHSCGs8f2eCqflVD-rKj30qLYxIoYU84oXAdw/GBhlLOIgxzQ.jpg?size=463x907&quality=96&sign=5d575f3ff91e9a6c38b28da43f8dc436&type=album)

  #### Repositories
- User repositories screen
On this screen you can also find a specific repository

![alt tag](https://sun9-5.userapi.com/impf/3JNx0q9xht-dnBORTtaryP3vIgl6zfvkrp7eXA/oQ8JK45LEaI.jpg?size=467x909&quality=96&sign=f37eed389ab03063129850f890edce40&type=album)

To create a repository on github.com you need to click on the "Create" button and fill in the information about the repository
- Create repository screen

![alt tag](https://sun9-44.userapi.com/impf/b8lZpN_M_USnFfgdrIXMByOxMQPSNCk960nvFQ/eDmoG2Se3LI.jpg?size=461x909&quality=96&sign=96fcdc738c3391c570c705f9ec9b8e77&type=album)

To view information about the repository, click on the repository cell.
- Repository screen

![alt tag](https://sun9-5.userapi.com/impf/iXpVUtdIPhc-KCkidw0oR90b3yNHhPjMyQysjg/9Tf5jpb5ozc.jpg?size=467x909&quality=96&sign=edca2f56c1f145cf197301382fd8a0c2&type=album)

To view the commits (in the default branch), click on the "Commits" button .
- Commits screen

![alt tag](https://sun9-32.userapi.com/impf/2FzrBilQz0juX-Na3Q-Upy7fKqA5FxKJgOxn_g/9KeDasi5QYI.jpg?size=475x912&quality=96&sign=42dc4b7f042547c70fd9b7f8d24a940d&type=album)

To view the code, click on the "Browse code" button .
- Code in safari browser

![alt tag](https://sun9-38.userapi.com/impf/nvA_AIFV1itpu1h6BETYl5wazX3kO_DDskE-ow/xijcsJPmZKg.jpg?size=466x912&quality=96&sign=0c231bd5b267bd90385f0719d219d501&type=album)

To view the pull request, click on the "Pull requests" button .
- Pull requests screen

![alt tag](https://sun9-45.userapi.com/impf/mkmxs8US-RqR0rJCQYfuD0o7GAAd0IWAWDKs1w/QaCK41F65J4.jpg?size=471x913&quality=96&sign=d8fda1e1326c8df30bf3468a52aecf8b&type=album)
![alt tag](https://sun9-14.userapi.com/impf/ZeMRZgdUi3X35fSTU-7UEro5zEykZhsJnbTSYA/YReBVVDgA5k.jpg?size=464x913&quality=96&sign=68058d56d04180d95c8a2b4013bea1ae&type=album)

  ### Starred repositories
- Starred repositories screen with search (the search field appears when you swipe down)

![alt tag](https://sun9-46.userapi.com/impf/yKhz-623xBIk9OB9G3Otu0cdzpvFsf8cRWFUEQ/OKv_6v991so.jpg?size=460x910&quality=96&sign=d06da0050b30eb959472170e3ac5545b&type=album)

  #### Issues
- Issues screen (sort and search fields appear when you swipe down)

![alt tag](https://sun9-2.userapi.com/impf/ztl1zCLPQqn5X-37twdylumx6aZRX3VEecXRqQ/8epo2Cfah1w.jpg?size=464x907&quality=96&sign=5aead3016d9cffdab6112664abd2510f&type=album)
![alt tag](https://sun9-37.userapi.com/impf/lpwxi_6urtzR3X85_RDBOVQwrE0Sr_0Dp7YFnQ/iUtHxqfDlMU.jpg?size=466x908&quality=96&sign=559b1ed74e3f22decfc3d175cfb2f753&type=album)

  #### Search
To search for users and repositories, click on the search field and enter the text. After entering the text, select the search category.
- Search screen

![alt tag](https://sun9-13.userapi.com/impf/JWE4bzdnJ9cExf3wyEAAf-oxCPg2zYIHI2AOgA/KJ8oSwoUvWc.jpg?size=464x916&quality=96&sign=0b241a1183352fb3b30a68887ce32cf2&type=album)
![alt tag](https://sun9-29.userapi.com/impf/Yp4Qxjxszy4HvoxEtlJWur0oNm86JAaKRYL1mg/8g4gBd2-s3g.jpg?size=478x917&quality=96&sign=28d6cc12e63c6f5e1a09ab4774fffbc9&type=album)

  #### Profile
When you click on the "Profile" button, a screen appears with information about the user and their popular repositories.
- Profile screen

![alt tag](https://sun9-48.userapi.com/impf/WN42SHb5gLWvw9wndImwxg0Mn_P1awuWCb7L_g/2xNMQEdkM-4.jpg?size=463x908&quality=96&sign=eaa1234257602ecebd4441b2a4be1b3a&type=album)

  #### Sign out
To exit the application, click on the "Sign out" button and the exit page will appear.
- Sign out screen

![alt tag](https://sun9-12.userapi.com/impf/ZZCJQ8Wqm3a2L68eBJxMv2DP6g-jqJJ7PFtLbg/jD_fcLDhMCw.jpg?size=475x909&quality=96&sign=2c0324385cfee608ded7b656efa137dd&type=album)
