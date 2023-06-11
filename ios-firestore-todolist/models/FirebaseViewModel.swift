//
//  FirebaseViewModel.swift
//  ios-firestore-todolist
//
//  Created by Angelica dos Santos on 11/06/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseViewModel: ObservableObject {
    
    private var db: Firestore
    
    @Published var text: String = ""
    @Published var taskList: [Task] = []
    @Published var showAlert = false
    @Published var title: String = ""
    
    init() {
        db = Firestore.firestore()
    }
    
    func saveTask() {
        let task = Task(title: text)
        
        do {
            try db.collection("tasks").addDocument(from: task) { err in
                if let error = err {
                    print(error.localizedDescription)
                } else {
                    print("Document has been saved!")
                    self.text = ""
                    self.fetchAllTasks()
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetchAllTasks() {
        db.collection("tasks").getDocuments { snapshot, error in
            if let snapshot = snapshot {
                self.taskList = snapshot.documents.compactMap { doc in
                    var task = try? doc.data(as: Task.self)
                    if task != nil {
                        task!.id = doc.documentID
                    }
                    return task
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func deleteTask(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let task = self.taskList[index]
            db.collection("tasks").document(task.id ?? "").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.fetchAllTasks()
                }
            }
        }
    }
    
    func updateTask(_ id: String) {
        db.collection("tasks").document(id)
            .updateData([
                "title": title
            ])
    }
}
