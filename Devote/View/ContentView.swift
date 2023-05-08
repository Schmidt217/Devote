//
//  ContentView.swift
//  Devote
//
//  Created by Michael Schmidt on 5/5/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    // MARK: PROPERTIES
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.managedObjectContext) private var viewContext
    @State private var task: String = ""
    @State private var showNewTaskItem = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // MARK: FUNCTIONS

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack(spacing: 10) {
                        // TITLE
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        Spacer()
                        
                        // EDIT BUTTON
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(Capsule().stroke(.white, lineWidth: 2))
                        // APPEARANCE BUTTON
                        Button {
                            isDarkMode.toggle()
                            playSound(sound: "sound-tap", type: "mp3")
                            feedback.notificationOccurred(.success)
                        } label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                            
                        }

                    } //: HSTACK
                    .padding()
                    .foregroundColor(.white)

                    Spacer(minLength: 80)

                    // MARK: - NEW TASK BUTTON

                    Button {
                        showNewTaskItem = true
                        playSound(sound: "sound-ding", type: "mp3")
                        feedback.notificationOccurred(.success)
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(LinearGradient(colors: [.pink, .blue], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)

                    // MARK: - TASKS

                    List {
                        ForEach(items) { item in
                            ListRowItemView(item: item)
                        }
                        .onDelete(perform: deleteItems)
                    } //: LIST
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                    .scrollContentBackground(.hidden)
                } //: VSTACK
                .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5))

                // MARK: - NEW TASK ITEM

                if showNewTaskItem {
                    BlankView(backgroundColor: isDarkMode ? .black : .gray, backgroundOpacity: isDarkMode ? 0.3 : 0.5)
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
            } //: ZSTACK
            .navigationBarTitle("DailyTasks")
            .navigationBarHidden(true)
            .background(BackgroundImageView()
                .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false))
            .background(backgroundGradient.ignoresSafeArea(.all))
        } //: NAVIGATION
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
