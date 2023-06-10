//
//  ContentView.swift
//  ios-firestore-todolist
//
//  Created by Angelica dos Santos on 10/06/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ContentView: View {
    
    let db: Firestore
    @State private var text: String = ""
    @State private var taskList: [Task] = []
    
    init() {
        self.db = Firestore.firestore()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter a task", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Save") {
                    saveTask()
                }
                .padding(16)
                
                Divider()
                
                List {
                    ForEach(taskList, id: \.id) { task in
                        NavigationLink(
                            destination: TaskDetailView(task)
                        ) {
                            Text(task.title)
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                .frame( maxWidth: .infinity)
                .listStyle(PlainListStyle())
                .padding(.trailing, 16)
                
            }
            .ignoresSafeArea()
            .onAppear(perform: {
                fetchAllTasks()
            })
            
        }
        .padding()
        .navigationTitle("Tasks")
    }
    
    private func saveTask() {
        let task = Task(title: text)
        
        do {
            try db.collection("tasks").addDocument(from: task) { err in
                if let error = err {
                    print(error.localizedDescription)
                } else {
                    print("Document has been saved!")
                    text = ""
                    fetchAllTasks()
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    private func fetchAllTasks() {
        db.collection("tasks").getDocuments { snapshot, error in
            if let snapshot = snapshot {
                taskList = snapshot.documents.compactMap { doc in
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
    
    private func deleteTask(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let task = taskList[index]
            db.collection("tasks").document(task.id ?? "").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    fetchAllTasks()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
