//
//  ContentView.swift
//  ios-firestore-todolist
//
//  Created by Angelica dos Santos on 10/06/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var firebaseViewModel: FirebaseViewModel
    
    init() {
        firebaseViewModel = FirebaseViewModel()
        UITabBar.appearance().isTranslucent = true
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach($firebaseViewModel.taskList, id: \.id) { task in
                        NavigationLink(
                            destination: TaskDetailView(task.wrappedValue)
                        ) {
                            Text(task.wrappedValue.title)
                        }
                    }
                    .onDelete(perform: firebaseViewModel.deleteTask)
                }
                .scrollIndicators(.never)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listStyle(PlainListStyle())
                .padding(.trailing, 16)
                .navigationTitle("Tasks")
                .navigationBarHidden(true)
                
                Divider()
                    .padding(.vertical, 8)
                
                TextField("Enter a new task", text: $firebaseViewModel.text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Save") {
                    firebaseViewModel.saveTask()
                }
                .padding(16)
            }
            .padding(.horizontal)
            .onAppear(perform: {
                firebaseViewModel.fetchAllTasks()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
