//
//  Tab.swift
//  AnimatedSFTabBar
//
//  Created by Balaji Venkatesh on 31/08/23.
//

import SwiftUI

/// Tab's
enum Tab: String, CaseIterable {
    case calendar = "calendar"
    case stats = "chart.bar.fill"
    //case achivements = "star.fill"
    case info = "info.circle.fill"

    
    var title: String {
        switch self {
        case .calendar:
            return "Calander"
        case .stats:
            return "Stats"
//        case .achivements:
//            return "Acievements"
        case .info:
            return "Info"
        }
    }
}

/// Animated SF Tab Model
struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}

/*
 struct ContentView: View {
 var body: some View {
 TabView {
 CalendarPage() // Main Calendar page
 .tabItem {
 Image(systemName: "calendar")
 .onTapGesture {
 //yo
 }
 .symbolEffect(.bounce.up.wholeSymbol, options: .nonRepeating)
 
 Text("Calendar")
 }
 
 StatsPage() // Placeholder for Stats page
 .tabItem {
 Image(systemName: "chart.bar")
 Text("Stats")
 }
 
 AchievementsPage() // Placeholder for Achievements page
 .tabItem {
 Image(systemName: "star")
 Text("Achievements")
 }
 
 AboutPage() // Placeholder for About page
 .tabItem {
 Image(systemName: "info.circle")
 Text("About")
 }
 }
 }
 }
 */
