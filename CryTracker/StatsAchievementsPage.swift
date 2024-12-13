import SwiftUI

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let isCompleted: Bool
}

struct StatsAchievementsPage: View {
    // Sample data for achievements
    @State private var achievements = [
        Achievement(title: "First Cry Logged", isCompleted: true),
        Achievement(title: "One Week Streak", isCompleted: false),
        Achievement(title: "One Month Streak", isCompleted: false),
        Achievement(title: "Daily Logger", isCompleted: true),
        Achievement(title: "First Note Added", isCompleted: true),
        Achievement(title: "Reflective Logger", isCompleted: false)
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                // Collapsible header
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        
                        Text("Stats & Achievements")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.primary)
                            .padding(.top, max(0, geometry.safeAreaInsets.top))
                            .scaleEffect(max(0.7, 1 - geometry.frame(in: .global).minY / 200))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipped()
                    
                    Spacer()
                }
                .frame(height: 120)
                
                
                Spacer()

                // Achievements list
                VStack(alignment: .leading, spacing: 15) {
                    Text("Achievements")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                    ForEach(achievements) { achievement in
                        HStack {
                            Text(achievement.title)
                                .font(.body)
                                .padding(.leading)
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                if achievement.isCompleted {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 24))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 24))
                                }
                            }
                            .padding(.trailing)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
                
                
                
                // Achievements list
                VStack(alignment: .leading, spacing: 15) {
                    Text("Achievements")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                    ForEach(achievements) { achievement in
                        HStack {
                            Text(achievement.title)
                                .font(.body)
                                .padding(.leading)
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                if achievement.isCompleted {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 24))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 24))
                                }
                            }
                            .padding(.trailing)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
                
                
                // Achievements list
                VStack(alignment: .leading, spacing: 15) {
                    Text("Achievements")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                    ForEach(achievements) { achievement in
                        HStack {
                            Text(achievement.title)
                                .font(.body)
                                .padding(.leading)
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                if achievement.isCompleted {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 24))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 24))
                                }
                            }
                            .padding(.trailing)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
        }
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.top)
    }
}

struct StatsAchievementsPage_Previews: PreviewProvider {
    static var previews: some View {
        StatsAchievementsPage()
    }
}
