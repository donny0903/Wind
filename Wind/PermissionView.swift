import SwiftUI
import UserNotifications
import FamilyControls
import DeviceActivity

struct PermissionView: View {
    @State private var authorizationCenter = AuthorizationCenter.shared
    @State private var isAuthorized = false
    @AppStorage("permissionsGranted") private var permissionsGranted: Bool = false
    @Environment(\.colorScheme) var colorScheme // 현재 컬러 스킴(라이트/다크 모드) 가져오기

    var body: some View {
        VStack {
            Text("앱 사용을 위한 권한을 설정해주세요.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            Button(action: {
                requestScreenTimePermission()
            }) {
                Text("Screen Time 권한 요청")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .dark ? Color.white : Color.blue) // 다크 모드일 때는 흰색, 라이트 모드일 때는 파란색
                    .foregroundColor(colorScheme == .dark ? .black : .white) // 다크 모드일 때 검은색 글자, 라이트 모드일 때 흰색 글자
                    .cornerRadius(8)
                    .padding()
            }
            .padding(.bottom, 20) // 하단에 버튼 배치
        }
        .onAppear {
            requestNotificationPermission() // 화면에 나타나자마자 알림 권한 요청
        }
    }

    private func requestNotificationPermission() {
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

    private func requestScreenTimePermission() {
        Task {
            do {
                try await authorizationCenter.requestAuthorization(for: .individual)
                DispatchQueue.main.async {
                    isAuthorized = authorizationCenter.authorizationStatus == .approved
                    if isAuthorized {
                        permissionsGranted = true
                    }
                }
            } catch {
                print("스크린 타임 권한 요청 실패")
            }
        }
    }
}
