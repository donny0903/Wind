import SwiftUI

struct AddGroupView: View {
    @Binding var isPresented: Bool // 시트 상태를 제어하기 위한 바인딩 변수
    @State private var groupName: String = "" // 그룹 이름
    var addGroup: (String) -> Void // 새로운 그룹을 추가하는 클로저

    var body: some View {
        VStack {
            Text("그룹 추가")
                .font(.headline)
                .padding()

            TextField("그룹 이름을 입력하세요", text: $groupName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("저장") {
                if !groupName.isEmpty {
                    addGroup(groupName) // 그룹 추가 함수 호출
                    isPresented = false // 시트 닫기
                }
            }
            .padding()
            .disabled(groupName.isEmpty) // 입력이 없을 경우 버튼 비활성화

            Spacer()
        }
        .padding()
    }
}
