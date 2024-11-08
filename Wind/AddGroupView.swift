import SwiftUI

struct AddGroupView: View {
    @Binding var isPresented: Bool
    @Binding var groups: [String]
    
    @State private var groupName: String = ""
    
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
                    groups.append(groupName) // 그룹 추가
                    isPresented = false // 뷰 닫기
                }
            }
            .padding()
            .disabled(groupName.isEmpty) // 입력이 없을 경우 버튼 비활성화
        }
        .padding()
    }
}
