import SwiftUI

struct HomeView: View {
    @State private var groups: [String] = []
    @State private var isAddGroupViewPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                if groups.isEmpty {
                    Text("앱 그룹이 없습니다. 새로운 그룹을 추가해보세요!")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(groups, id: \.self) { group in
                        NavigationLink(destination: GroupDetailView(group: .constant(group), groups: $groups)) {
                            Text(group)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    isAddGroupViewPresented = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                }
                .padding()
                .sheet(isPresented: $isAddGroupViewPresented) {
                    AddGroupView(isPresented: $isAddGroupViewPresented, groups: $groups)
                }
            }
            .navigationTitle("앱 그룹 관리")
        }
    }
}
