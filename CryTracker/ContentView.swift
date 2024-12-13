import SwiftUI
import SwiftData

struct ContentView: View {
    /// View Properties
    @State private var activeTab: Tab = .stats
    /// All Tab's
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    /// Bounce Property
    @State private var bouncesDown: Bool = true
    @State private var isAnimating = false
    
    @State private var animationPhase = false
        
        let columns = [
            GridItem(.fixed(20)),
            GridItem(.fixed(20)),
            GridItem(.fixed(20))
        ]
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                /// YOUR TAB VIEWS
                NavigationStack {
                    VStack {
                        CalendarPage()
                    }
                    //.navigationTitle(Tab.photos.title)
                }
                .setUpTab(.calendar)
                .symbolRenderingMode(.multicolor)
                
                NavigationStack {
                    VStack {
                        StatsAchievementsPage()
                    }
                    //.navigationTitle(Tab.stats.title)
                }
                .setUpTab(.stats)
                
//                NavigationStack {
//                    VStack {
//                        Circle()
//                            .trim(from: 0.2, to: 1)
//                            .stroke(Color.blue, lineWidth: 4)
//                            .frame(width: 40, height: 40)
//                            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
//                            .onAppear {
//                                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
//                                    isAnimating = true
//                            }
//                        }
//                    }
//                    .navigationTitle(Tab.achivements.title)
//                }
//                .setUpTab(.achivements)
//                .symbolRenderingMode(.multicolor)
                
                NavigationStack {
                    VStack {
                        LazyVGrid(columns: columns, spacing: 10) {
                                   ForEach(0..<9) { index in
                                       RoundedRectangle(cornerRadius: 4)
                                           .fill(Color.blue)
                                           .frame(width: 20, height: 20)
                                           .scaleEffect(animationPhase ? 1 : 0.5)
                                           .opacity(animationPhase ? 1 : 0.5)
                                           .animation(
                                               Animation
                                                   .easeInOut(duration: 0.5)
                                                   .repeatForever()
                                                   .delay(Double(index) * 0.1),
                                               value: animationPhase
                                           )
                                   }
                               }
                               .onAppear {
                                   animationPhase.toggle()
                               }
                    }
                    .navigationTitle(Tab.info.title)
                    
                }
                .setUpTab(.info)
                .symbolRenderingMode(.multicolor)
                
            }
            
            CustomTabBar()
        }
    }
    
    /// Custom Tab Bar
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                        .symbolEffect(bouncesDown ? .bounce.down.byLayer : .bounce.up.byLayer, value: animatedTab.isAnimating)
                        .symbolRenderingMode(activeTab == tab ? .multicolor : .monochrome)
                        
                    
                    Text(tab.title)
                        .font(.caption2)
                        .textScale(.secondary)
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(activeTab == tab ? Color.primary : Color.gray.opacity(0.8))
                .padding(.top, 15)
                .padding(.bottom, 10)
                .contentShape(.rect)
                /// You Can Also Use Button, If you Choose to
                .onTapGesture {
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete, {
                        activeTab = tab
                        animatedTab.isAnimating = true
                    }, completion: {
                        var trasnaction = Transaction()
                        trasnaction.disablesAnimations = true
                        withTransaction(trasnaction) {
                            animatedTab.isAnimating = nil
                        }
                    })
                }
            }
        }
        .background(.bar)
    }
}

extension View {
    @ViewBuilder
    func setUpTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}

// Placeholder views for Stats, Achievements, and About pages
struct StatsPage: View {
    var body: some View {
        Text("Stats Page")
            .font(.largeTitle)
            .padding()
    }
}

struct AchievementsPage: View {
    var body: some View {
        Text("Achievements Page")
            .font(.largeTitle)
            .padding()
    }
}

struct AboutPage: View {
    var body: some View {
        Text("About Page")
            .font(.largeTitle)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CalendarPage: View {
    @Environment(\.modelContext) private var modelContext

    @State private var cryLogs: [CryLog] = []
    @State private var selectedDay: Int?
    @State private var selectedColor: Color?
    @State private var showCrySelection = false

    @State private var currentMonth: Int
    @State private var currentYear: Int
    @State private var todayCryType: CryType? // Track today's selected cry type
    @State private var selectedTab: Int = 1 // Middle tab index for the current month

    let daysInMonth = Array(1...31)

    init() {
        let calendar = Calendar.current
        self._currentMonth = State(initialValue: calendar.component(.month, from: Date()))
        self._currentYear = State(initialValue: calendar.component(.year, from: Date()))
    }

    var body: some View {
        VStack {
            // Month Navigation
            HStack {
                Button(action: {
                    withAnimation(.easeInOut) {
                        changeMonth(by: -1)
                    }
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text("\(monthYearString())")
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut) {
                        changeMonth(by: 1)
                    }
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            // Days of the Week Headers
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)

            // Calendar Grid with Swiping Support
            TabView(selection: $selectedTab) {
                ForEach(-1...1, id: \.self) { offset in
                    let displayMonth = monthOffset(by: offset)
                    let displayYear = yearOffset(by: offset)
                    VStack {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                            // Blank days before the first day of the month
                            ForEach(0..<firstWeekday(month: displayMonth, year: displayYear), id: \.self) { _ in
                                Color.clear
                                    .frame(width: 40, height: 40)
                            }
                            // Days of the month
                            ForEach(1...daysInCurrentMonth(month: displayMonth, year: displayYear), id: \.self) { day in
                                let color = cryColor(for: day, month: displayMonth, year: displayYear)
                                DayView(day: day, color: color)
                                    .contextMenu {
                                        Button(action: { saveCryLog(day: day, color: Color.yellow) }) {
                                            Text("Happy & Big")
                                                .padding()
                                                .background(Color.yellow.opacity(0.8))
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        }
                                        Button(action: { saveCryLog(day: day, color: Color.green) }) {
                                            Text("Happy & Small")
                                                .padding()
                                                .background(Color.green.opacity(0.8))
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        }
                                        Button(action: { saveCryLog(day: day, color: Color.blue) }) {
                                            Text("Sad & Big")
                                                .padding()
                                                .background(Color.blue.opacity(0.8))
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        }
                                        Button(action: { saveCryLog(day: day, color: Color.purple) }) {
                                            Text("Sad & Small")
                                                .padding()
                                                .background(Color.purple.opacity(0.8))
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        }
                                        Button(action: { saveCryLog(day: day, color: Color.gray.opacity(0.2)) }) {
                                            Text("No Cry")
                                                .padding()
                                                .background(Color.gray.opacity(0.8))
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        }
                                    } preview: {
                                        Image("stopsign")
                                    
                                }
                            }
                        }
                        .padding()
                    }
                    .tag(offset + 1) // Tags: -1 -> previous, 1 -> current, 2 -> next
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 300)
            .onChange(of: selectedTab) { newTab in
                if newTab == 0 {
                    changeMonth(by: -1)
                    selectedTab = 1 // Reset to middle
                } else if newTab == 2 {
                    changeMonth(by: 1)
                    selectedTab = 1 // Reset to middle
                }
            }
            
            
            // "Today's Cry" Selection
            VStack(alignment: .leading, spacing: 10) {
                Text("Today's Cry")
                    .font(.headline)
                    .padding(.leading)
                
                ForEach(CryType.allCases, id: \.self) { cryType in
                    HStack {
                        Text(cryType.rawValue)
                            .foregroundColor(.primary)
                            .padding()
                        Spacer()
                        if todayCryType == cryType {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .padding()
                        }
                    }
                    .background(RoundedRectangle(cornerRadius: 8)
                                    .fill(cryType.color.opacity(0.2)))
                    .onTapGesture {
                        selectTodayCry(cryType)
                    }
                }
            }
            .padding()
            
        }
        .onAppear(perform: loadCryLogs)
        .sheet(isPresented: $showCrySelection, onDismiss: {
            showCrySelection = false
        }) {
            if let selectedDay = selectedDay {
                CrySelectionView(day: selectedDay, onSelect: { color in
                    saveCryLog(day: selectedDay, color: color)
                    showCrySelection = false
                })
            }
        }
    }
    
    private func saveCryLog(day: Int, color: Color) {
        // Find an existing log for this day, if any
        if let existingLog = cryLogs.first(where: { $0.day == day && $0.month == currentMonth && $0.year == currentYear }) {
            existingLog.color = color // Update color if log exists
        } else {
            // Create a new log if one doesn’t exist
            let newLog = CryLog(day: day, month: currentMonth, year: currentYear, color: color)
            modelContext.insert(newLog)
            cryLogs.append(newLog) // Add to local array for immediate UI update
        }

        // Save changes to SwiftData
        do {
            try modelContext.save()
        } catch {
            print("Failed to save CryLog: \(error)")
        }
    }

    private func loadCryLogs() {
        let request = FetchDescriptor<CryLog>(
            predicate: #Predicate { log in
                log.month == currentMonth && log.year == currentYear
            }
        )
        
        do {
            cryLogs = try modelContext.fetch(request)
        } catch {
            print("Failed to fetch CryLogs: \(error)")
        }
        
        // Check if the current month and year match today's date, and if so, update `todayCryType`
        let today = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        if currentMonth == today.month && currentYear == today.year {
            if let todayLog = cryLogs.first(where: { $0.day == today.day }) {
                todayCryType = CryType.allCases.first(where: { $0.color == todayLog.color })
            } else {
                todayCryType = nil // Reset if there's no cry log for today
            }
        } else {
            todayCryType = nil // Clear `todayCryType` if not viewing the current month
        }
    }
    
    private func selectTodayCry(_ cryType: CryType) {
        todayCryType = cryType
        let today = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        
        // Update or create today's cry log
        if let existingLog = cryLogs.first(where: { $0.day == today.day && $0.month == today.month && $0.year == today.year }) {
            existingLog.color = cryType.color
        } else {
            let newLog = CryLog(day: today.day ?? 1, month: today.month ?? 1, year: today.year ?? 1, color: cryType.color)
            modelContext.insert(newLog)
            cryLogs.append(newLog)
        }

        // Save changes to SwiftData
        do {
            try modelContext.save()
        } catch {
            print("Failed to save CryLog: \(error)")
        }
    }

    private func changeMonth(by offset: Int) {
        var newMonth = currentMonth + offset
        var newYear = currentYear
        
        if newMonth < 1 {
            newMonth = 12
            newYear -= 1
        } else if newMonth > 12 {
            newMonth = 1
            newYear += 1
        }
        
        currentMonth = newMonth
        currentYear = newYear
        loadCryLogs()
    }

    private func monthYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let dateComponents = DateComponents(year: currentYear, month: currentMonth)
        let date = Calendar.current.date(from: dateComponents) ?? Date()
        return dateFormatter.string(from: date)
    }

    private func firstWeekday(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month, day: 1)
        let firstDayOfMonth = Calendar.current.date(from: dateComponents)!
        let weekday = Calendar.current.component(.weekday, from: firstDayOfMonth)
        return weekday - 1 // Adjust to 0-based (Sunday as 0)
    }

    private func daysInCurrentMonth(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let date = Calendar.current.date(from: dateComponents)!
        return Calendar.current.range(of: .day, in: .month, for: date)!.count
    }

    private func cryColor(for day: Int, month: Int, year: Int) -> Color {
        return cryLogs.first(where: { $0.day == day && $0.month == month && $0.year == year })?.color ?? Color.gray.opacity(0.2)
    }
    
    private func monthOffset(by offset: Int) -> Int {
        var month = currentMonth + offset
        if month < 1 { month = 12 }
        if month > 12 { month = 1 }
        return month
    }
    
    private func yearOffset(by offset: Int) -> Int {
        var year = currentYear
        let month = currentMonth + offset
        if month < 1 { year -= 1 }
        if month > 12 { year += 1 }
        return year
    }
    
    private func isToday(day: Int, month: Int, year: Int) -> Bool {
        let today = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        return day == today.day && month == today.month && year == today.year
    }
}
struct CrySelectionView: View {
    let day: Int
    var onSelect: (Color) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Cry Type for Day \(day)")
                .font(.title2)
                .fontWeight(.bold)
            
            Button(action: { onSelect(Color.yellow) }) {
                Text("Happy & Big")
                    .padding()
                    .background(Color.yellow.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: { onSelect(Color.green) }) {
                Text("Happy & Small")
                    .padding()
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: { onSelect(Color.blue) }) {
                Text("Sad & Big")
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: { onSelect(Color.purple) }) {
                Text("Sad & Small")
                    .padding()
                    .background(Color.purple.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: { onSelect(Color.gray.opacity(0.2)) }) {
                Text("No Cry")
                    .padding()
                    .background(Color.gray.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct DayView: View {
    let day: Int
    var color: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 40, height: 40)

            Text("\(day)")
                .font(.system(size: 16))
                .foregroundColor(color == Color.gray.opacity(0.2) ? .black : .white)
        }
    }
}

enum CryType: String, CaseIterable {
    case happyBig = "Happy & Big"
    case happySmall = "Happy & Small"
    case sadBig = "Sad & Big"
    case sadSmall = "Sad & Small"
    
    var color: Color {
        switch self {
        case .happyBig: return .yellow
        case .sadBig: return .blue
        case .happySmall: return .green
        case .sadSmall: return .purple
        }
    }
}
