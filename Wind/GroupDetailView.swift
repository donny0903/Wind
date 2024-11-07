import SwiftUI

struct GroupDetailView: View {
    @Binding var group: String // 그룹 이름을 관리하기 위한 바인딩 변수
    @Binding var groups: [String] // 전체 그룹 목록에 대한 바인딩 (리스트 업데이트)

    @State private var newGroupName: String = "" // 그룹 이름 변경용 임시 저장소
    @Environment(\.presentationMode) var presentationMode // 뷰 닫기 위해 사용

    var body: some View {
        VStack {
            Text("그룹 상세 설정")
                .font(.title)
                .padding()

            // 그룹 이름 변경
            TextField("그룹 이름 변경", text: $newGroupName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onAppear {
                    // 초기값 설정
                    newGroupName = group
                }

            Button("저장") {
                // 그룹 이름 변경 로직
                if let index = groups.firstIndex(of: group) {
                    groups[index] = newGroupName
                }
                group = newGroupName
                presentationMode.wrappedValue.dismiss() // 뷰 닫기
            }
            .padding()
            .disabled(newGroupName.isEmpty) // 이름이 비어 있으면 저장 버튼 비활성화

            // 그룹 삭제
            Button("삭제") {
                // 그룹 삭제 로직
                if let index = groups.firstIndex(of: group) {
                    groups.remove(at: index)
                }
                presentationMode.wrappedValue.dismiss() // 뷰 닫기
            }
            .padding()
            .foregroundColor(.red)

            Spacer()
        }
        .padding()
    }
}
