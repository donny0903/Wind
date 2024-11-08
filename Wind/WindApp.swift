import SwiftUI

@main
struct WindApp: App {
    @AppStorage("permissionsGranted") private var permissionsGranted: Bool = false
    @State private var showSplash = true // SplashView 제어

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView(showSplash: $showSplash, appLoader: AppLoader()) // appLoader 인스턴스 추가
            } else if permissionsGranted {
                HomeView() // 권한이 부여된 경우 HomeView로 이동
            } else {
                PermissionView() // 권한이 없는 경우 PermissionView로 이동
            }
        }
    }
}
