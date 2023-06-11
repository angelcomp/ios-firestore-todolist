//
//  TaskDetailView.swift
//  ios-firestore-todolist
//
//  Created by Angelica dos Santos on 10/06/23.
//

import SwiftUI

struct TaskDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var firebaseViewModel: FirebaseViewModel
    private let task: Task
    
    init(_ task: Task) {
        self.task = task
        firebaseViewModel = FirebaseViewModel()
    }
    
    var body: some View {
        VStack {
            TextField(task.title, text: $firebaseViewModel.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Update") {
                if let id = task.id {
                    firebaseViewModel.updateTask(id)
                    presentationMode.wrappedValue.dismiss()
                } else {
                    firebaseViewModel.showAlert = true
                }
            }
            .alert(isPresented: $firebaseViewModel.showAlert, content: {
                Alert(title: Text("Error"), message: Text("Something went wrong :/"))
            })
            .padding(16)
            Spacer()
        }
        .navigationTitle("Edit")
        .ignoresSafeArea()
        .padding()
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(Task(title: "bla"))
    }
}
