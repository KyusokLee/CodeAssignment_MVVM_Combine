//
//  SceneDelegate.swift
//  CodeAssignment_MVVM_Combine
//
//  Created by gyusoku.i on 2024/05/02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // UIWindowsのアンラップ
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Window生成
        // Storyboardを使わないときは、Windowのインスタンスを直接生成して設定する必要がある
        let window = UIWindow(windowScene: windowScene)
        // UINavigationControllerでembeddedしたViewをRoot Viewとして設定
        window.rootViewController = UINavigationController(rootViewController: HomeViewController())
        self.window = window
        // Key Window生成
        // makeKeyAndVisible: 指定したWindowを他の同一レベルもしくは以下のレベルのすべてのWindowより最前面に表示する
        // 表示中のWindowの上から新たな画面を表示させることができる
        // これを利用して、表示中の画面に関わらずモーダル表示ができる（全てのユーザにお知らせを表示したい場合などに有用らしい）
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

