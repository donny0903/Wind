import SwiftUI
import FamilyControls
import DeviceActivity

struct PermissionView: View {
    @State private var authorizationCenter = AuthorizationCenter.shared
    @State private var isAuthorized = false
    @AppStorage("permissionsGranted") private var permissionsGranted: Bool = false // 권한 상태 저장

    var body: some View {
        VStack {
            Text("앱을 사용하려면 권한이 필요해요!")
                .font(.title)
                .padding()

            Button("알림 권한 요청") {
                requestNotificationPermission()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            if !isAuthorized {
                Button("스크린 타임 권한 요청") {
                    requestScreenTimePermission()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            } else {
                // 모든 권한이 부여된 경우 완료 버튼 표시
                Button("모든 권한 부여 완료") {
                    permissionsGranted = true // 권한 부여 상태 저장
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .onAppear {
            // 권한 상태 확인
            isAuthorized = authorizationCenter.authorizationStatus == .approved
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
            } else if granted {
                print("알림 권한 부여됨")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("알림 권한 거부됨")
            }
        }
    }
    
    func requestScreenTimePermission() {
        Task {
            do {
                try await authorizationCenter.requestAuthorization(for: .individual)
                DispatchQueue.main.async {
                    isAuthorized = authorizationCenter.authorizationStatus == .approved
                }
            } catch {
                DispatchQueue.main.async {
                    // 권한 요청 실패 시 추가 처리 가능
                }
            }
        }
    }
}
