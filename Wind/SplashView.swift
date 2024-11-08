import SwiftUI
import Combine

class AppLoader: ObservableObject {
    @Published var isLoadingComplete = false

    func startLoading() {
        // 네트워크 요청과 초기 작업을 동시에 수행하는 예제입니다.
        let group = DispatchGroup()
        
        group.enter()
        performNetworkRequest {
            print("네트워크 요청 완료") // 디버깅용 메시지
            group.leave()
        }
        
        group.enter()
        performInitialWork {
            print("초기 작업 완료") // 디버깅용 메시지
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("모든 작업 완료")
            self.isLoadingComplete = true // 모든 작업이 완료되면 상태 변경
        }
    }

    private func performNetworkRequest(completion: @escaping () -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
            completion() // URL이 유효하지 않으면 즉시 완료
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("네트워크 요청 실패: \(error.localizedDescription)")
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) { // 상태 코드 확인
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("네트워크 응답 데이터: \(jsonString)")
                } else {
                    print("데이터 변환 실패")
                }
            } else {
                print("잘못된 응답 또는 데이터")
            }
            completion() // 네트워크 요청이 끝나면 완료 호출
        }.resume()
    }

    private func performInitialWork(completion: @escaping () -> Void) {
        // 초기화 작업을 시뮬레이션하는 코드 (예시로 1.5초 지연)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            print("초기 작업 완료")
            completion()
        }
    }
}

struct SplashView: View {
    @Binding var showSplash: Bool
    @ObservedObject var appLoader: AppLoader

    var body: some View {
        VStack {
            Text("🌬")
                .font(.system(size: 100))
        }
        .onAppear {
            appLoader.startLoading() // SplashView가 나타날 때 로딩 시작
        }
        .onReceive(appLoader.$isLoadingComplete) { newValue in
            if newValue {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            MainView() // MainView 이름으로 변경하여 충돌 방지
                .opacity(showSplash ? 0 : 1) // SplashView가 보이는 동안 MainView 숨김

            if showSplash {
                SplashView(showSplash: $showSplash, appLoader: AppLoader())
            }
        }
    }
}

struct MainView: View { // 이름을 MainView로 변경
    var body: some View {
        Text("Home View")
            .font(.largeTitle)
            .padding()
    }
}
