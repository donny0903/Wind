import SwiftUI

struct HomeView: View {
    @State private var groups: [String] = [] // 간단한 String 배열로 그룹 관리
    @State private var isAddGroupViewPresented = false

    var body: some View {
        NavigationView {
            VStack {
                if groups.isEmpty {
                    // app_empty 상태
                    Text("앱 그룹이 없습니다. 새로운 그룹을 추가해보세요!")
                        .foregroundColor(.gray)
                        .padding()

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
                } else {
                    // app_filled 상태
                    List {
                        ForEach(groups.indices, id: \.self) { index in
                            NavigationLink(destination: GroupDetailView(group: $groups[index], groups: $groups)) {
                                Text(groups[index])
                            }
                        }
                        .onDelete(perform: deleteGroup)
                    }
                    .navigationTitle("앱 그룹 관리")
                    .navigationBarItems(trailing: Button(action: {
                        isAddGroupViewPresented = true
                    }) {
                        Image(systemName: "plus")
                    })
                }
            }
            .sheet(isPresented: $isAddGroupViewPresented) {
                AddGroupView(isPresented: $isAddGroupViewPresented, addGroup: { newGroup in
                    groups.append(newGroup)
                })
            }
        }
    }

    func deleteGroup(at offsets: IndexSet) {
        groups.remove(atOffsets: offsets)
    }
}
