//
//  TaskDetailView.swift
//  ios-firestore-todolist
//
//  Created by Angelica dos Santos on 10/06/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TaskDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    private var db: Firestore
    private let task: Task
    @State private var title: String = ""
    
    init(_ task: Task) {
        self.task = task
        db = Firestore.firestore()
    }
    
    var body: some View {
        VStack {
            TextField(task.title, text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Update") {
                updateTask()
            }
            .padding(16)
            Spacer()
            
        }
        .navigationTitle("Edit")
        .ignoresSafeArea()
        .padding()
    }
    
    private func updateTask() {
        db.collection("tasks").document(task.id ?? "").updateData([
            "title": title
        ])
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(Task(title: "bla"))
    }
}
