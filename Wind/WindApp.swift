import SwiftUI

@main
struct WindApp: App {
    @AppStorage("permissionsGranted") private var permissionsGranted: Bool = false

    var body: some Scene {
        WindowGroup {
            if permissionsGranted {
                HomeView() // 권한이 이미 부여된 경우 HomeView로 이동
            } else {
                PermissionView() // 권한 요청 뷰
            }
        }
    }
}
