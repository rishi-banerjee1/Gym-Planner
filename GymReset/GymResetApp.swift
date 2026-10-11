import SwiftUI
import Combine
#if os(macOS)
import AppKit
#endif

private extension Color {
    static let gymInk = Color(red: 0.06, green: 0.09, blue: 0.16)
    static let gymMint = Color(red: 0.15, green: 0.39, blue: 0.92)
    static let gymCanvas = Color(red: 0.97, green: 0.98, blue: 1.0)
    static let gymCard = Color.white
    static let gymWarm = Color(red: 0.86, green: 0.39, blue: 0.05)

    static var gymSurface: Color {
        #if os(macOS)
        Color(nsColor: .windowBackgroundColor)
        #else
        Color(uiColor: .secondarySystemBackground)
        #endif
    }
}

private extension View {
    @ViewBuilder
    func gymInlineNavigationTitle() -> some View {
        #if os(iOS)
        navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}

@main
struct GymResetApp: App {
    @StateObject private var store = WorkoutStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .environmentObject(planner)
                .tint(.gymMint)
                .preferredColorScheme(.light)
        }
    }

    @StateObject private var planner = WeekPlannerStore()
}

// MARK: - Program

enum WorkoutDay: String, CaseIterable, Identifiable, Codable {
    case foundation = "Push"
    case pullHinge = "Pull + Hinge"
    case legsPress = "Legs + Core"
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case lowerBody = "Lower body"
    case forearms = "Forearms"

    var id: String { rawValue }

    static let foundationDays: [WorkoutDay] = [.foundation, .pullHinge, .legsPress]
    static let advancedDays: [WorkoutDay] = [.chest, .back, .shoulders, .biceps, .triceps, .forearms, .lowerBody]

    var subtitle: String {
        switch self {
        case .foundation: "Chest, shoulders, triceps"
        case .pullHinge: "Back, hamstrings, biceps"
        case .legsPress: "Quads, glutes, core"
        case .chest: "Pressing strength and control"
        case .back: "Rows, lats and upper back"
        case .shoulders: "Pressing and side delts"
        case .biceps: "Elbow flexion and forearm control"
        case .triceps: "Pressing lockout and elbow extension"
        case .lowerBody: "Quads, glutes and hamstrings"
        case .forearms: "Grip, wrists and lower arms"
        }
    }

    var symbol: String {
        switch self {
        case .foundation: "figure.strengthtraining.traditional"
        case .pullHinge: "figure.rower"
        case .legsPress: "figure.strengthtraining.functional"
        case .chest: "figure.strengthtraining.functional"
        case .back: "figure.rower"
        case .shoulders: "arrow.up"
        case .biceps: "dumbbell"
        case .triceps: "arrow.up"
        case .lowerBody: "figure.strengthtraining.traditional"
        case .forearms: "dumbbell"
        }
    }

    var accent: Color {
        switch self {
        case .foundation: .teal
        case .pullHinge: .indigo
        case .legsPress: .orange
        case .chest: .red
        case .back: .indigo
        case .shoulders: .orange
        case .biceps: .green
        case .triceps: .purple
        case .lowerBody: .teal
        case .forearms: .brown
        }
    }

    var workout: Workout {
        switch self {
        case .foundation:
            Workout(day: self, warmup: "5 minutes: easy walk, shoulder circles, wall push-ups and light presses.", exercises: [
                Exercise(name: "Dumbbell overhead press", equipment: "Two dumbbells", sets: 3, reps: "8–10", rest: 75, symbol: "arrow.up", cues: ["Start dumbbells at shoulder height with wrists stacked.", "Brace your ribs down and press overhead.", "Finish with biceps beside ears, then lower slowly."], watchOut: "Use a seated version if your lower back arches."),
                Exercise(name: "Dumbbell floor press", equipment: "Two dumbbells", sets: 3, reps: "8–10", rest: 75, symbol: "figure.strengthtraining.functional", cues: ["Lie down with knees bent and dumbbells over your chest.", "Lower elbows until upper arms lightly touch the floor.", "Press up smoothly, keeping wrists stacked over elbows."], watchOut: "Avoid flaring your elbows straight out to the sides.", swap: "Optional swap: barbell bench press if a safe bench and rack are available."),
                Exercise(name: "Dumbbell lateral raise", equipment: "Two light dumbbells", sets: 3, reps: "12–15", rest: 45, symbol: "arrow.up.and.down", cues: ["Stand tall with a slight elbow bend.", "Raise arms out to the sides until about shoulder height.", "Lower slowly and keep shoulders away from ears."], watchOut: "Use very light weight. This should not become a swing."),
                Exercise(name: "Incline push-up", equipment: "Bench or wall", sets: 2, reps: "8–12", rest: 60, symbol: "arrow.up", cues: ["Place hands on a bench or wall and make a straight line from head to heel.", "Lower your chest toward your hands.", "Push the surface away to return."], watchOut: "Use a higher surface if your lower back sags."),
                Exercise(name: "Dumbbell triceps extension", equipment: "One dumbbell", sets: 2, reps: "10–12", rest: 45, symbol: "arrow.up", cues: ["Hold one dumbbell above your head with both hands.", "Lower it behind your head by bending your elbows.", "Straighten elbows without arching your back."], watchOut: "Keep elbows pointing forward, not wide apart." )
            ])
        case .pullHinge:
            Workout(day: self, warmup: "5 minutes: easy walk, bandless pull-aparts, hip hinges and light rows.", exercises: [
                Exercise(name: "Dumbbell Romanian deadlift", equipment: "Two dumbbells", sets: 3, reps: "8–10", rest: 75, symbol: "figure.walk", cues: ["Keep the weights close to your legs.", "Send your hips behind you with a long, neutral spine.", "Stand by driving hips forward and squeezing glutes."], watchOut: "Stop before your back position changes.", swap: "Optional swap: barbell Romanian deadlift, 3 × 6–8."),
                Exercise(name: "Supported dumbbell row", equipment: "Two dumbbells", sets: 3, reps: "10–12", rest: 75, symbol: "arrow.left.and.right", cues: ["Place chest against an incline bench, or hinge with both feet planted.", "Pull elbows back toward your hips.", "Lower slowly until shoulders feel stretched but controlled."], watchOut: "Do not shrug your shoulders toward your ears."),
                Exercise(name: "Dumbbell rear-delt fly", equipment: "Two light dumbbells", sets: 2, reps: "12–15", rest: 45, symbol: "arrow.left.and.right", cues: ["Hinge forward with a long back and a soft knee bend.", "Raise arms out and back with a slight elbow bend.", "Lower slowly without shrugging."], watchOut: "Use a very light weight and keep your neck relaxed."),
                Exercise(name: "Hammer curl", equipment: "Two dumbbells", sets: 2, reps: "10–12", rest: 45, symbol: "dumbbell", cues: ["Keep palms facing in and elbows close to your ribs.", "Curl without swinging your torso.", "Lower for a controlled count of two."], watchOut: "Choose a weight you can lower slowly."),
                Exercise(name: "Suitcase carry", equipment: "One dumbbell", sets: 2, reps: "30–40 sec each side", rest: 45, symbol: "figure.walk", cues: ["Hold one dumbbell at your side and stand tall.", "Walk slowly without leaning toward or away from the weight.", "Breathe normally and keep shoulders level."], watchOut: "Use less weight if your posture changes.")
            ])
        case .legsPress:
            Workout(day: self, warmup: "5 minutes: easy walk, ankle rocks, bodyweight squats and hip bridges.", exercises: [
                Exercise(name: "Goblet squat", equipment: "One dumbbell", sets: 3, reps: "8–10", rest: 75, symbol: "figure.strengthtraining.traditional", cues: ["Hold one dumbbell vertically against your chest.", "Sit between your hips with your whole foot on the floor.", "Keep your chest tall, then stand by pushing the floor away."], watchOut: "Do not let your knees collapse inward.", swap: "Optional swap: barbell back squat, 3 × 6–8."),
                Exercise(name: "Dumbbell split squat", equipment: "Two dumbbells", sets: 3, reps: "8 each side", rest: 75, symbol: "figure.strengthtraining.functional", cues: ["Set feet hip-width apart, one foot forward and one back.", "Lower straight down while keeping the front foot flat.", "Drive through the front foot to stand."], watchOut: "Start bodyweight only until you feel stable."),
                Exercise(name: "Dumbbell Romanian deadlift", equipment: "Two dumbbells", sets: 3, reps: "8–10", rest: 75, symbol: "figure.walk", cues: ["Keep the weights close to your legs.", "Send your hips behind you with a long, neutral spine.", "Stand by driving hips forward and squeezing glutes."], watchOut: "Stop before your back position changes.", swap: "Optional swap: barbell Romanian deadlift, 3 × 6–8."),
                Exercise(name: "Dumbbell glute bridge", equipment: "One dumbbell", sets: 3, reps: "10–12", rest: 60, symbol: "figure.core.training", cues: ["Lie on your back with feet flat and a dumbbell across your hips.", "Drive through your heels to lift hips.", "Squeeze glutes briefly at the top, then lower with control."], watchOut: "Keep ribs down instead of over-arching your lower back."),
                Exercise(name: "Dead bug", equipment: "Bodyweight", sets: 2, reps: "8 each side", rest: 45, symbol: "figure.core.training", cues: ["Lie on your back with knees and arms pointing up.", "Gently press your lower back into the floor.", "Slowly extend opposite arm and leg, then return."], watchOut: "Make the range smaller if your back lifts off the floor.")
            ])
        case .chest:
            Workout(day: self, warmup: "5 minutes: shoulder circles, wall push-ups and very light presses.", exercises: [
                Exercise(name: "Dumbbell floor press", equipment: "Two dumbbells", sets: 4, reps: "6–10", rest: 90, symbol: "figure.strengthtraining.functional", cues: ["Set shoulders firmly on the floor.", "Lower until upper arms touch the floor softly.", "Press up with wrists stacked over elbows."], watchOut: "Keep elbows about 45 degrees from your ribs.", swap: "Optional swap: barbell bench press."),
                Exercise(name: "Dumbbell squeeze press", equipment: "Two dumbbells", sets: 3, reps: "10–12", rest: 75, symbol: "arrow.up", cues: ["Press the dumbbells together over your chest.", "Keep them touching as you lower.", "Squeeze them together as you press."], watchOut: "Use a moderate load and move slowly."),
                Exercise(name: "Incline push-up", equipment: "Bench or wall", sets: 3, reps: "8–15", rest: 60, symbol: "arrow.up", cues: ["Keep your body in one long line.", "Lower your chest toward your hands.", "Push the surface away."], watchOut: "Raise the surface if form breaks."),
                Exercise(name: "Dumbbell floor fly", equipment: "Two light dumbbells", sets: 2, reps: "10–12", rest: 60, symbol: "arrow.left.and.right", cues: ["Keep a soft bend in both elbows.", "Open arms until upper arms reach the floor.", "Bring weights together using your chest."], watchOut: "Use light weights and a controlled range.")
            ])
        case .back:
            Workout(day: self, warmup: "5 minutes: easy walk, shoulder circles and light rows.", exercises: [
                Exercise(name: "One-arm dumbbell row", equipment: "One dumbbell", sets: 4, reps: "8–12 each side", rest: 75, symbol: "arrow.left.and.right", cues: ["Brace one hand on a bench or thigh.", "Pull the weight toward your back pocket.", "Lower under control."], watchOut: "Do not twist your torso to lift."),
                Exercise(name: "Supported dumbbell row", equipment: "Two dumbbells", sets: 3, reps: "10–12", rest: 75, symbol: "arrow.left.and.right", cues: ["Support your chest on an incline bench or hinge firmly.", "Pull elbows toward hips.", "Lower slowly."], watchOut: "Keep shoulders away from your ears."),
                Exercise(name: "Dumbbell pullover", equipment: "One dumbbell", sets: 3, reps: "10–12", rest: 60, symbol: "arrow.up.and.down", cues: ["Hold one dumbbell above your chest.", "Lower it behind your head only as far as shoulders allow.", "Bring it back over your chest."], watchOut: "Keep your ribs from flaring up."),
                Exercise(name: "Dumbbell rear-delt fly", equipment: "Two light dumbbells", sets: 2, reps: "12–15", rest: 45, symbol: "arrow.left.and.right", cues: ["Hinge forward with a long spine.", "Raise arms out and back.", "Lower with control."], watchOut: "Use light weight and avoid shrugging.")
            ])
        case .shoulders:
            Workout(day: self, warmup: "5 minutes: arm circles, wall slides and light presses.", exercises: [
                Exercise(name: "Dumbbell overhead press", equipment: "Two dumbbells", sets: 4, reps: "6–10", rest: 90, symbol: "arrow.up", cues: ["Begin at shoulder height.", "Brace your ribs down as you press.", "Finish with biceps beside ears."], watchOut: "Sit down if your lower back arches."),
                Exercise(name: "Dumbbell lateral raise", equipment: "Two light dumbbells", sets: 3, reps: "12–15", rest: 60, symbol: "arrow.up.and.down", cues: ["Keep a small bend in your elbows.", "Raise to shoulder height.", "Lower slowly."], watchOut: "Do not swing or shrug."),
                Exercise(name: "Dumbbell front raise", equipment: "Two light dumbbells", sets: 2, reps: "10–12", rest: 45, symbol: "arrow.up", cues: ["Raise one or both dumbbells to shoulder height.", "Keep ribs down.", "Lower slowly."], watchOut: "Use very light weight."),
                Exercise(name: "Dumbbell rear-delt fly", equipment: "Two light dumbbells", sets: 3, reps: "12–15", rest: 45, symbol: "arrow.left.and.right", cues: ["Hinge forward with a long spine.", "Raise arms out and back.", "Lower with control."], watchOut: "Keep your neck relaxed.")
            ])
        case .biceps:
            Workout(day: self, warmup: "3 minutes: light curls and shoulder circles.", exercises: [
                Exercise(name: "Alternating dumbbell curl", equipment: "Two dumbbells", sets: 3, reps: "8–12 each side", rest: 60, symbol: "dumbbell", cues: ["Keep elbows near your ribs.", "Turn your palm up as you curl.", "Lower for a controlled count of two."], watchOut: "Do not lean back to lift."),
                Exercise(name: "Hammer curl", equipment: "Two dumbbells", sets: 3, reps: "10–12", rest: 60, symbol: "dumbbell", cues: ["Keep palms facing in.", "Curl without moving your upper arms.", "Lower slowly."], watchOut: "Avoid swinging."),
                Exercise(name: "Concentration curl", equipment: "One dumbbell", sets: 3, reps: "10–12 each side", rest: 60, symbol: "dumbbell", cues: ["Brace your elbow inside your thigh.", "Curl smoothly.", "Lower fully with control."], watchOut: "Keep your shoulder quiet."),
                Exercise(name: "Reverse curl", equipment: "Two light dumbbells", sets: 2, reps: "12–15", rest: 45, symbol: "dumbbell", cues: ["Keep palms facing down.", "Curl with elbows close.", "Lower slowly."], watchOut: "Use less weight than a normal curl.")
            ])
        case .triceps:
            Workout(day: self, warmup: "3 minutes: light presses and arm circles.", exercises: [
                Exercise(name: "Dumbbell triceps extension", equipment: "One dumbbell", sets: 3, reps: "10–12", rest: 60, symbol: "arrow.up", cues: ["Hold one dumbbell above your head.", "Bend elbows to lower it behind your head.", "Straighten elbows without arching."], watchOut: "Keep elbows pointing forward."),
                Exercise(name: "Dumbbell kickback", equipment: "Two light dumbbells", sets: 3, reps: "12–15", rest: 45, symbol: "arrow.up.and.down", cues: ["Hinge forward and pin elbows to your sides.", "Straighten elbows until arms are long.", "Return slowly."], watchOut: "Do not swing the dumbbells."),
                Exercise(name: "Close-grip dumbbell floor press", equipment: "Two dumbbells", sets: 3, reps: "8–12", rest: 75, symbol: "figure.strengthtraining.functional", cues: ["Keep dumbbells close together.", "Lower elbows close to your ribs.", "Press up smoothly."], watchOut: "Use a controlled tempo."),
                Exercise(name: "Bench triceps dip", equipment: "Bench", sets: 2, reps: "8–12", rest: 60, symbol: "arrow.down", cues: ["Keep hips close to the bench.", "Bend elbows only as far as shoulders feel good.", "Press the bench away."], watchOut: "Skip this if it bothers your shoulders.")
            ])
        case .lowerBody:
            Workout(day: self, warmup: "5 minutes: easy walk, ankle rocks, bodyweight squats and hip bridges.", exercises: [
                Exercise(name: "Goblet squat", equipment: "One dumbbell", sets: 4, reps: "8–10", rest: 90, symbol: "figure.strengthtraining.traditional", cues: ["Hold one dumbbell at your chest.", "Sit between your hips with feet planted.", "Stand by pushing the floor away."], watchOut: "Keep knees tracking over toes.", swap: "Optional swap: barbell back squat."),
                Exercise(name: "Dumbbell split squat", equipment: "Two dumbbells", sets: 3, reps: "8–10 each side", rest: 75, symbol: "figure.strengthtraining.functional", cues: ["Use a stable staggered stance.", "Lower straight down.", "Drive through the front foot."], watchOut: "Start bodyweight only if balance is limiting."),
                Exercise(name: "Dumbbell Romanian deadlift", equipment: "Two dumbbells", sets: 3, reps: "8–10", rest: 90, symbol: "figure.walk", cues: ["Push hips back with soft knees.", "Keep weights close to your legs.", "Stand by squeezing glutes."], watchOut: "Do not round through the lower back.", swap: "Optional swap: barbell Romanian deadlift."),
                Exercise(name: "Dumbbell glute bridge", equipment: "One dumbbell", sets: 3, reps: "10–15", rest: 60, symbol: "figure.core.training", cues: ["Place a dumbbell across your hips.", "Drive through heels to lift hips.", "Pause and squeeze glutes at the top."], watchOut: "Keep ribs down.")
            ])
        case .forearms:
            Workout(day: self, warmup: "3 minutes: wrist circles, open and close your hands, then do a few very light curls.", exercises: [
                Exercise(name: "Seated dumbbell wrist curl", equipment: "One very light dumbbell", sets: 3, reps: "12–15", rest: 45, symbol: "dumbbell", cues: ["Sit with your forearm supported on your thigh and palm facing up.", "Move only your wrist to curl the weight upward.", "Lower slowly through a comfortable range."], watchOut: "Use a very light weight and stop if you feel sharp wrist pain."),
                Exercise(name: "Seated reverse wrist curl", equipment: "One very light dumbbell", sets: 3, reps: "12–15", rest: 45, symbol: "dumbbell", cues: ["Support your forearm on your thigh with palm facing down.", "Lift the back of your hand by moving only your wrist.", "Lower slowly and keep the weight easy to control."], watchOut: "Use less weight than you think you need. Keep the movement pain-free."),
                Exercise(name: "Hammer curl", equipment: "Two light dumbbells", sets: 3, reps: "10–12", rest: 60, symbol: "dumbbell", cues: ["Stand tall with palms facing in and elbows near your ribs.", "Curl without swinging your torso.", "Lower slowly for a controlled count of two."], watchOut: "Choose a load you can lower smoothly."),
                Exercise(name: "Farmer carry", equipment: "Two dumbbells", sets: 3, reps: "30–40 sec", rest: 60, symbol: "figure.walk", cues: ["Hold one dumbbell at each side and stand tall.", "Walk slowly with shoulders level and ribs stacked over hips.", "Set the weights down safely before your grip fails."], watchOut: "Use a lighter load if you lean, shrug or lose your grip.")
            ])
        }
    }
}

struct Workout: Identifiable {
    let id = UUID()
    let day: WorkoutDay
    var title: String? = nil
    let warmup: String
    let exercises: [Exercise]
    var displayName: String { title ?? day.rawValue }
    var estimatedMinutes: Int { 45 }
}

struct Exercise: Identifiable {
    var id: String { name }
    let name: String
    let equipment: String
    let sets: Int
    let reps: String
    let rest: Int
    let symbol: String
    let cues: [String]
    let watchOut: String
    var swap: String? = nil
}

struct CompletedWorkout: Codable, Identifiable {
    let id: UUID
    let day: WorkoutDay
    let date: Date
    let duration: Int
    var name: String? = nil
}

@MainActor
final class WorkoutStore: ObservableObject {
    @Published private(set) var history: [CompletedWorkout] = [] {
        didSet { save() }
    }

    private let key = "gymResetHistory"

    init() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([CompletedWorkout].self, from: data) else { return }
        history = saved.sorted { $0.date > $1.date }
    }

    var nextDay: WorkoutDay {
        guard let last = history.first(where: { WorkoutDay.foundationDays.contains($0.day) })?.day,
              let index = WorkoutDay.foundationDays.firstIndex(of: last) else { return .foundation }
        return WorkoutDay.foundationDays[(index + 1) % WorkoutDay.foundationDays.count]
    }

    func complete(_ day: WorkoutDay, duration: Int, name: String? = nil, date: Date = .now) {
        history.append(CompletedWorkout(id: UUID(), day: day, date: date, duration: max(duration, 1), name: name))
        history.sort { $0.date > $1.date }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(history) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}

// MARK: - Home

struct RootView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "figure.strengthtraining.traditional") }
            PlanView()
                .tabItem { Label("Plan", systemImage: "list.clipboard") }
            PlannerView()
                .tabItem { Label("My week", systemImage: "calendar") }
            ProgressView()
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
        }
        .tint(.gymMint)
    }
}

struct TodayView: View {
    @EnvironmentObject private var store: WorkoutStore
    @EnvironmentObject private var planner: WeekPlannerStore
    @State private var showingSession = false

    private var plannedSession: (workout: Workout, daysAway: Int)? { planner.nextWorkout() }
    private var nextWorkout: Workout { plannedSession?.workout ?? store.nextDay.workout }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("GYM RESET").font(.caption.bold()).tracking(1.4).foregroundStyle(Color.gymMint)
                            Text("Ready when you are.").font(.title2.weight(.bold))
                        }
                        Spacer()
                        Image(systemName: "dumbbell.fill")
                            .font(.title2).foregroundStyle(Color.gymInk)
                            .frame(width: 46, height: 46)
                            .background(Color.gymMint.opacity(0.22), in: Circle())
                    }

                    VStack(alignment: .leading, spacing: 22) {
                        HStack {
                            Label(plannedSession.map { $0.daysAway == 0 ? "TODAY'S SESSION" : "NEXT SESSION · \($0.workout.day.rawValue.uppercased())" } ?? "SUGGESTED SESSION", systemImage: "bolt.fill")
                                .font(.caption.bold()).tracking(1)
                            Spacer()
                            Text("45 MIN").font(.caption.bold()).tracking(1)
                        }
                        .foregroundStyle(Color.gymMint)
                        HStack(alignment: .center, spacing: 16) {
                            Image(systemName: nextWorkout.day.symbol)
                                .font(.system(size: 34, weight: .semibold))
                                .frame(width: 66, height: 66)
                                .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 20))
                            VStack(alignment: .leading, spacing: 5) {
                                Text(nextWorkout.displayName).font(.system(size: 30, weight: .bold, design: .rounded))
                                Text(nextWorkout.day.subtitle).font(.subheadline).foregroundStyle(.white)
                            }
                        }
                        Button { showingSession = true } label: {
                            HStack { Text("Start workout"); Spacer(); Image(systemName: "arrow.right") }
                                .font(.headline).foregroundStyle(.white)
                                .padding(.horizontal, 18).padding(.vertical, 16)
                                .background(Color.gymMint, in: Capsule())
                        }
                    }
                    .padding(22)
                    .foregroundStyle(.white)
                    .background {
                        ZStack {
                            Image("WorkoutHero")
                                .resizable()
                                .scaledToFill()
                                .opacity(0.34)
                            LinearGradient(colors: [Color.gymInk.opacity(0.98), Color(red: 0.08, green: 0.18, blue: 0.38).opacity(0.88)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    }

                    HStack(spacing: 12) {
                        InsightTile(value: "\(planner.days.filter { planner.workout(for: $0) != nil }.count)", label: "planned\nsessions", icon: "calendar")
                        InsightTile(value: "2", label: "reps in reserve\ntarget", icon: "gauge.with.dots.needle.50percent")
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Label("Your reset rule", systemImage: "sparkles")
                            .font(.headline)
                        Text("Leave two clean reps in reserve. The win is showing up again, not exhausting yourself on day one.")
                            .font(.subheadline).foregroundStyle(.secondary)
                    }
                    .padding(18).background(Color.gymCard, in: RoundedRectangle(cornerRadius: 22))

                    if let last = store.history.first {
                        Label("Last: \(last.day.rawValue) · \(last.date.formatted(date: .abbreviated, time: .omitted))", systemImage: "clock.arrow.circlepath")
                            .font(.footnote).foregroundStyle(.secondary).padding(.horizontal, 4)
                    }
                }
                .padding(.horizontal, 20).padding(.top, 12).padding(.bottom, 26)
            }
            .background(Color.gymCanvas)
            .gymInlineNavigationTitle()
            .sheet(isPresented: $showingSession) {
                WorkoutSessionView(workout: nextWorkout)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
            }
        }
    }
}

private struct InsightTile: View {
    let value: String
    let label: String
    let icon: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon).font(.subheadline.weight(.bold)).foregroundStyle(Color.gymMint)
            VStack(alignment: .leading, spacing: 2) {
                Text(value).font(.title2.bold().monospacedDigit())
                Text(label).font(.caption).foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(15).frame(maxWidth: .infinity, minHeight: 78, alignment: .leading)
        .background(Color.gymCard, in: RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Workout session

struct WorkoutSessionView: View {
    @EnvironmentObject private var store: WorkoutStore
    @Environment(\.dismiss) private var dismiss
    let day: WorkoutDay
    let workout: Workout
    @State private var exerciseIndex = 0
    @State private var setsFinished = 0
    @State private var elapsedSeconds = 0
    @State private var restSeconds = 0
    @State private var isResting = false
    @State private var showExitAlert = false
    @State private var showFinished = false
    @State private var showSkippedEnd = false

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var exercise: Exercise { workout.exercises[exerciseIndex] }
    private var isLastSet: Bool { setsFinished + 1 == exercise.sets }
    private var isLastExercise: Bool { exerciseIndex + 1 == workout.exercises.count }

    init(day: WorkoutDay) {
        self.day = day
        self.workout = day.workout
    }

    init(workout: Workout) {
        self.day = workout.day
        self.workout = workout
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SwiftUI.ProgressView(value: Double(exerciseIndex), total: Double(workout.exercises.count))
                    .tint(day.accent)
                    .padding(.horizontal)
                    .padding(.top, 8)
                HStack {
                    Text("Exercise \(exerciseIndex + 1) of \(workout.exercises.count)")
                    Spacer()
                    Text(time(elapsedSeconds)).monospacedDigit()
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
                .padding()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Image(systemName: exercise.symbol)
                            .font(.system(size: 42))
                            .foregroundStyle(Color.gymInk)
                            .frame(width: 80, height: 80)
                            .background(Color.gymMint, in: RoundedRectangle(cornerRadius: 24))
                        Text(exercise.name)
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                        HStack(spacing: 8) {
                            MetricPill(label: "SETS", value: "\(exercise.sets)")
                            MetricPill(label: "REPS", value: exercise.reps)
                            MetricPill(label: "REST", value: "\(exercise.rest)s")
                        }
                        Text(exercise.equipment)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white)

                        VStack(alignment: .leading, spacing: 12) {
                            Label("How to do it", systemImage: "figure.walk")
                                .font(.headline)
                            ForEach(Array(exercise.cues.enumerated()), id: \.offset) { index, cue in
                                HStack(alignment: .top, spacing: 10) {
                                    Text("\(index + 1)").font(.caption.bold()).foregroundStyle(.white).frame(width: 22, height: 22).background(day.accent, in: Circle())
                                    Text(cue).fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            Label(exercise.watchOut, systemImage: "exclamationmark.triangle")
                                .font(.subheadline)
                                .foregroundStyle(.orange)
                            if let swap = exercise.swap {
                                Label(swap, systemImage: "arrow.triangle.swap")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(16)
                        .background(Color.gymCard, in: RoundedRectangle(cornerRadius: 22))
                    }
                    .padding(20)
                }

                VStack(spacing: 12) {
                    if isResting {
                        HStack {
                            Image(systemName: "timer")
                            Text("Rest \(time(restSeconds))")
                                .monospacedDigit()
                                .font(.headline)
                            Spacer()
                            Button("Skip") { restSeconds = 0; isResting = false }
                        }
                        .padding(.horizontal, 18)
                    }
                    Button(action: completeSet) {
                        Label(isLastSet ? (isLastExercise ? "Finish workout" : "Finish exercise") : "Complete set \(setsFinished + 1) of \(exercise.sets)", systemImage: "checkmark.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.gymMint)
                    .foregroundStyle(.white)
                    .disabled(isResting)
                    Button("Skip this exercise") { skipExercise() }
                        .buttonStyle(.bordered)
                        .tint(.secondary)
                }
                .padding()
                .background(Color.gymInk)
            }
            .background(Color.gymInk)
            .navigationTitle(workout.displayName)
            .gymInlineNavigationTitle()
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarLeading) {
                    Button("End") { showExitAlert = true }
                }
                #else
                ToolbarItem(placement: .cancellationAction) {
                    Button("End") { showExitAlert = true }
                }
                #endif
            }
            #if os(iOS)
            .toolbarBackground(Color.gymInk, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            #endif
            .onReceive(ticker) { _ in
                guard !showFinished && !showSkippedEnd else { return }
                elapsedSeconds += 1
                if isResting { restSeconds -= 1 }
                if restSeconds <= 0 { isResting = false }
            }
            .alert("End this workout?", isPresented: $showExitAlert) {
                Button("Keep training", role: .cancel) {}
                Button("Log workout") { logWorkout() }
                Button("End without logging", role: .destructive) { dismiss() }
            } message: { Text("Did some or all of this workout? You can save it to your history now.") }
            .alert("Workout complete", isPresented: $showFinished) {
                Button("Done") { dismiss() }
            } message: { Text("Nice work. Your next session is ready whenever you are.") }
            .alert("Log this workout?", isPresented: $showSkippedEnd) {
                Button("Log workout") { logWorkout() }
                Button("Don't log", role: .cancel) { dismiss() }
            } message: { Text("If you did this workout, save it to your history even though you skipped the last exercise.") }
        }
    }

    private func completeSet() {
        if isLastSet {
            if isLastExercise {
                store.complete(day, duration: elapsedSeconds / 60, name: workout.displayName)
                showFinished = true
            } else {
                exerciseIndex += 1
                setsFinished = 0
                isResting = false
            }
        } else {
            setsFinished += 1
            restSeconds = exercise.rest
            isResting = true
        }
    }

    private func skipExercise() {
        if isLastExercise {
            restSeconds = 0
            isResting = false
            showSkippedEnd = true
            return
        }
        exerciseIndex += 1
        setsFinished = 0
        restSeconds = 0
        isResting = false
    }

    private func logWorkout() {
        store.complete(day, duration: elapsedSeconds / 60, name: workout.displayName)
        dismiss()
    }

    private func time(_ seconds: Int) -> String {
        String(format: "%02d:%02d", max(seconds, 0) / 60, max(seconds, 0) % 60)
    }
}

struct MetricPill: View {
    let label: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label).font(.caption2.bold()).foregroundStyle(.white.opacity(0.86))
            Text(value).font(.subheadline.bold()).foregroundStyle(.white).lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Plan and progress

struct PlanView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("PROGRAMS").font(.caption.bold()).tracking(1.3).foregroundStyle(Color.gymMint)
                        Text("Train with intent.").font(.system(size: 32, weight: .bold, design: .rounded))
                        Text("Choose a gentle restart or focus on one muscle group. Every session is built for about 45 minutes.")
                            .font(.subheadline).foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 2)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("FOUNDATION").font(.caption.bold()).tracking(1).foregroundStyle(.secondary)
                        Text("Three dumbbell-first sessions. Do them in order, with rest days between.")
                            .font(.subheadline).foregroundStyle(.secondary)
                        ForEach(WorkoutDay.foundationDays) { day in ProgramCard(day: day, isFoundation: true) }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("ADVANCED FOCUS").font(.caption.bold()).tracking(1).foregroundStyle(.secondary)
                        Text("One muscle group per session, for the days you want more focus.")
                            .font(.subheadline).foregroundStyle(.secondary)
                        ForEach(WorkoutDay.advancedDays) { day in ProgramCard(day: day, isFoundation: false) }
                    }
                }
                .padding(20).padding(.bottom, 24)
            }
            .background(Color.gymCanvas)
            .navigationTitle("Plan")
            .gymInlineNavigationTitle()
        }
    }
}

private struct ProgramCard: View {
    let day: WorkoutDay
    let isFoundation: Bool
    var body: some View {
        NavigationLink { WorkoutPlanDetail(day: day) } label: {
            HStack(spacing: 14) {
                Image(systemName: day.symbol)
                    .font(.title3.weight(.semibold)).foregroundStyle(day.accent)
                    .frame(width: 48, height: 48)
                    .background(day.accent.opacity(0.13), in: RoundedRectangle(cornerRadius: 16))
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(day.rawValue).font(.headline).foregroundStyle(.primary)
                        if isFoundation { Text("RESET").font(.caption2.bold()).foregroundStyle(Color.gymMint).padding(.horizontal, 6).padding(.vertical, 3).background(Color.gymMint.opacity(0.14), in: Capsule()) }
                    }
                    Text(day.subtitle).font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.leading)
                }
                Spacer()
                VStack(spacing: 4) {
                    Text("45").font(.headline.monospacedDigit()).foregroundStyle(.primary)
                    Text("MIN").font(.caption2.bold()).foregroundStyle(.secondary)
                }
                Image(systemName: "chevron.right").font(.caption.bold()).foregroundStyle(.tertiary)
            }
            .padding(16).background(Color.gymCard, in: RoundedRectangle(cornerRadius: 22))
        }
        .buttonStyle(.plain)
    }
}

struct WorkoutPlanDetail: View {
    let day: WorkoutDay
    @State private var showingSession = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Label("45 MINUTES", systemImage: "clock").font(.caption.bold()).tracking(1)
                        Spacer()
                        Image(systemName: day.symbol).font(.title2)
                    }
                    Text(day.rawValue).font(.system(size: 34, weight: .bold, design: .rounded))
                    Text(day.subtitle).font(.subheadline).foregroundStyle(.white.opacity(0.7))
                }
                .padding(22).foregroundStyle(.white)
                .background(LinearGradient(colors: [Color.gymInk, day.accent.opacity(0.72)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 28))

                VStack(alignment: .leading, spacing: 8) {
                    Label("WARM UP", systemImage: "flame.fill").font(.caption.bold()).tracking(1).foregroundStyle(Color.gymMint)
                    Text(day.workout.warmup).font(.subheadline).foregroundStyle(.secondary)
                }
                .padding(18).background(Color.gymCard, in: RoundedRectangle(cornerRadius: 20))

                Text("WORKOUT").font(.caption.bold()).tracking(1).foregroundStyle(.secondary).padding(.horizontal, 2)
                ForEach(Array(day.workout.exercises.enumerated()), id: \.element.id) { offset, exercise in
                    DisclosureGroup {
                        VStack(alignment: .leading, spacing: 11) {
                            Text(exercise.equipment).font(.subheadline.weight(.medium)).foregroundStyle(.secondary)
                            ForEach(Array(exercise.cues.enumerated()), id: \.offset) { cue in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("\(cue.offset + 1)").font(.caption2.bold()).foregroundStyle(Color.gymInk).frame(width: 20, height: 20).background(Color.gymMint, in: Circle())
                                    Text(cue.element).font(.subheadline)
                                }
                            }
                            Label(exercise.watchOut, systemImage: "exclamationmark.triangle.fill").font(.caption).foregroundStyle(.orange)
                            if let swap = exercise.swap { Text(swap).font(.caption).foregroundStyle(.secondary) }
                        }.padding(.top, 10)
                    } label: {
                        HStack(spacing: 12) {
                            Text("\(offset + 1)").font(.caption.bold()).foregroundStyle(day.accent).frame(width: 28, height: 28).background(day.accent.opacity(0.12), in: Circle())
                            VStack(alignment: .leading, spacing: 3) {
                                Text(exercise.name).font(.headline)
                                Text("\(exercise.sets) sets × \(exercise.reps)  ·  \(exercise.rest)s rest").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(16).background(Color.gymCard, in: RoundedRectangle(cornerRadius: 18))
                }

                Button { showingSession = true } label: {
                    Label("Start this workout", systemImage: "play.fill").frame(maxWidth: .infinity).padding(.vertical, 5)
                }
                .buttonStyle(.borderedProminent).tint(.gymMint).foregroundStyle(.white).padding(.top, 4)
            }
            .padding(20).padding(.bottom, 28)
        }
        .background(Color.gymCanvas)
        .navigationTitle(day.rawValue)
        .gymInlineNavigationTitle()
        .sheet(isPresented: $showingSession) {
            WorkoutSessionView(day: day)
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
        }
    }
}

struct PlannedDay: Codable, Identifiable {
    let id: String
    var primary: WorkoutDay?
    var secondary: WorkoutDay?
    var selectedExercises: [String]

    static let recommended: [PlannedDay] = [
        PlannedDay(id: "Monday", primary: .chest, secondary: .triceps, selectedExercises: []),
        PlannedDay(id: "Tuesday", primary: .back, secondary: .biceps, selectedExercises: []),
        PlannedDay(id: "Wednesday", primary: nil, secondary: nil, selectedExercises: []),
        PlannedDay(id: "Thursday", primary: .shoulders, secondary: nil, selectedExercises: []),
        PlannedDay(id: "Friday", primary: .lowerBody, secondary: nil, selectedExercises: []),
        PlannedDay(id: "Saturday", primary: nil, secondary: nil, selectedExercises: []),
        PlannedDay(id: "Sunday", primary: nil, secondary: nil, selectedExercises: [])
    ]
}

@MainActor
final class WeekPlannerStore: ObservableObject {
    @Published var days: [PlannedDay] = [] {
        didSet { save() }
    }
    private let key = "gymResetWeeklyPlan"

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode([PlannedDay].self, from: data),
           saved.count == PlannedDay.recommended.count,
           saved.map(\.id) == PlannedDay.recommended.map(\.id) {
            days = Self.migratePreviousDefault(saved)
        } else {
            days = Self.withSelectedExercises(PlannedDay.recommended)
        }
    }

    func setFocus(_ focus: WorkoutDay?, for index: Int, secondary: Bool) {
        let previous = days[index]
        let removedFocus = secondary ? previous.secondary : previous.primary
        if secondary { days[index].secondary = focus } else { days[index].primary = focus }
        let available = Set(exercises(for: days[index]))
        let retained = Set(previous.selectedExercises).intersection(available)
        let removed = Set(removedFocus?.workout.exercises.map(\.name) ?? [])
        let added = Set(focus?.workout.exercises.map(\.name) ?? []).subtracting(removed)
        days[index].selectedExercises = Array(retained.union(added).intersection(available)).sorted()
    }

    func setSelected(_ name: String, selected: Bool, for index: Int) {
        var names = Set(days[index].selectedExercises)
        if selected {
            names.insert(name)
        } else {
            names.remove(name)
        }
        days[index].selectedExercises = Array(names).sorted()
    }

    func reset() { days = Self.withSelectedExercises(PlannedDay.recommended) }

    func workout(for day: PlannedDay) -> Workout? {
        let focuses = [day.primary, day.secondary].compactMap { $0 }
        guard let lead = focuses.first else { return nil }
        let available = focuses.flatMap { $0.workout.exercises }
        var seen = Set<String>()
        let selected = available.filter { exercise in
            day.selectedExercises.contains(exercise.name) && seen.insert(exercise.name).inserted
        }
        guard !selected.isEmpty else { return nil }
        let focusNames = focuses.map(\.rawValue).joined(separator: " + ")
        return Workout(day: lead, title: "\(day.id) · \(focusNames)", warmup: focuses.map(\.workout.warmup).joined(separator: " "), exercises: selected)
    }

    func nextWorkout(from date: Date = .now) -> (workout: Workout, daysAway: Int)? {
        let weekday = Calendar.current.component(.weekday, from: date)
        let todayIndex = (weekday + 5) % 7 // Monday = 0, Sunday = 6
        guard days.count == 7 else { return nil }
        for daysAway in 0..<7 {
            let index = (todayIndex + daysAway) % 7
            guard let workout = workout(for: days[index]) else { continue }
            return (workout, daysAway)
        }
        return nil
    }

    func exercises(for day: PlannedDay) -> [String] {
        var names: [String] = []
        for focus in [day.primary, day.secondary].compactMap({ $0 }) {
            names += focus.workout.exercises.map(\.name)
        }
        return Array(NSOrderedSet(array: names)) as? [String] ?? names
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(days) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private static func withSelectedExercises(_ days: [PlannedDay]) -> [PlannedDay] {
        days.map { day in
            var updated = day
            var names: [String] = []
            for focus in [day.primary, day.secondary].compactMap({ $0 }) {
                names += focus.workout.exercises.map(\.name)
            }
            updated.selectedExercises = Array(NSOrderedSet(array: names)) as? [String] ?? names
            return updated
        }
    }

    private static func migratePreviousDefault(_ saved: [PlannedDay]) -> [PlannedDay] {
        let previousFocus: [(WorkoutDay?, WorkoutDay?)] = [
            (.chest, .triceps), (.back, .biceps), (nil, nil), (.lowerBody, nil), (.shoulders, nil), (nil, nil), (nil, nil)
        ]
        guard saved.enumerated().allSatisfy({ index, day in
            day.primary == previousFocus[index].0 && day.secondary == previousFocus[index].1
        }) else { return saved }

        var migrated = saved
        migrated[3].primary = .shoulders
        migrated[4].primary = .lowerBody
        let previousThursday = Set(saved[3].selectedExercises)
        let previousFriday = Set(saved[4].selectedExercises)
        migrated[3].selectedExercises = Array(previousFriday.intersection(WorkoutDay.shoulders.workout.exercises.map(\.name))).sorted()
        migrated[4].selectedExercises = Array(previousThursday.intersection(WorkoutDay.lowerBody.workout.exercises.map(\.name))).sorted()
        return migrated
    }
}

struct PlannerView: View {
    @EnvironmentObject private var store: WeekPlannerStore
    @State private var activeWorkout: Workout?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("YOUR WEEK").font(.caption.bold()).tracking(1.3).foregroundStyle(Color.gymMint)
                        Text("Built around your life.").font(.system(size: 31, weight: .bold, design: .rounded))
                        Text("Start balanced. Change any day. Your changes save automatically on this device.").font(.subheadline).foregroundStyle(.secondary)
                    }.padding(.bottom, 4)

                    Button { store.reset() } label: { Label("Restore balanced week", systemImage: "arrow.counterclockwise").font(.subheadline.weight(.semibold)) }
                        .buttonStyle(.bordered).tint(.gymMint)

                    ForEach(store.days.indices, id: \.self) { index in
                        let day = store.days[index]
                        WeekDayCard(day: day, index: index, store: store) {
                            activeWorkout = store.workout(for: day)
                        }
                    }
                }
                .padding(20).padding(.bottom, 28)
            }
            .background(Color.gymCanvas)
            .navigationTitle("My week")
            .gymInlineNavigationTitle()
            .sheet(item: $activeWorkout) { workout in
                WorkoutSessionView(workout: workout)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
            }
        }
    }
}

private struct WeekDayCard: View {
    let day: PlannedDay
    let index: Int
    @ObservedObject var store: WeekPlannerStore
    let onStart: () -> Void
    @State private var selectedExercise: Exercise?

    private var isRestDay: Bool { day.primary == nil && day.secondary == nil }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(day.id).font(.headline)
                    Text(isRestDay ? "Recovery day" : "Workout day").font(.caption).foregroundStyle(isRestDay ? .secondary : Color.gymMint)
                }
                Spacer()
                Image(systemName: isRestDay ? "bed.double.fill" : "bolt.fill")
                    .foregroundStyle(isRestDay ? .secondary : Color.gymMint)
                    .frame(width: 34, height: 34).background((isRestDay ? Color.gray : Color.gymMint).opacity(0.12), in: Circle())
            }

            HStack(spacing: 10) {
                focusMenu(title: day.primary?.rawValue ?? "Rest", secondary: false)
                focusMenu(title: day.secondary?.rawValue ?? "Add focus", secondary: true)
            }

            if isRestDay {
                Text("A walk or gentle mobility is optional.").font(.subheadline).foregroundStyle(.secondary)
            } else {
                Divider()
                ForEach(store.exercises(for: day), id: \.self) { exercise in
                    HStack(spacing: 10) {
                        Button {
                            selectedExercise = [day.primary, day.secondary]
                                .compactMap { $0 }
                                .flatMap { $0.workout.exercises }
                                .first { $0.name == exercise }
                        } label: {
                            HStack(spacing: 7) {
                                Text(exercise).multilineTextAlignment(.leading)
                                Image(systemName: "info.circle").font(.caption).foregroundStyle(Color.gymMint)
                            }
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Shows exercise instructions")

                        Toggle("Include \(exercise)", isOn: Binding(
                            get: { store.days[index].selectedExercises.contains(exercise) },
                            set: { store.setSelected(exercise, selected: $0, for: index) }
                        ))
                        .labelsHidden()
                        .tint(.gymMint)
                    }
                    .padding(.vertical, 4)
                }
                if store.workout(for: day) != nil {
                    Button(action: onStart) {
                        Label("Start this day", systemImage: "play.fill")
                            .frame(maxWidth: .infinity).padding(.vertical, 5)
                    }
                    .buttonStyle(.borderedProminent).tint(.gymMint).foregroundStyle(.white)
                } else {
                    Text("Select at least one exercise to start this workout.")
                        .font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .padding(18).background(Color.gymCard, in: RoundedRectangle(cornerRadius: 22))
        .sheet(item: $selectedExercise) { exercise in
            PlannerExerciseInfoView(exercise: exercise)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    @ViewBuilder
    private func focusMenu(title: String, secondary: Bool) -> some View {
        Menu {
            Button(secondary ? "None" : "Rest") { store.setFocus(nil, for: index, secondary: secondary) }
            ForEach(WorkoutDay.advancedDays) { focus in
                Button(focus.rawValue) { store.setFocus(focus, for: index, secondary: secondary) }
            }
            if !secondary {
                ForEach(WorkoutDay.foundationDays) { focus in
                    Button("Foundation: \(focus.rawValue)") { store.setFocus(focus, for: index, secondary: false) }
                }
            }
        } label: {
            HStack {
                Text(title).lineLimit(1)
                Image(systemName: "chevron.down").font(.caption.bold())
            }
            .font(.caption.weight(.semibold)).foregroundStyle(Color.gymInk)
            .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 12).padding(.vertical, 10)
            .background(Color.gymMint.opacity(0.15), in: Capsule())
        }
    }
}

private struct PlannerExerciseInfoView: View {
    @Environment(\.dismiss) private var dismiss
    let exercise: Exercise

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("\(exercise.sets) sets × \(exercise.reps) reps  ·  \(exercise.rest)s rest")
                        .font(.subheadline.weight(.semibold))
                    Label(exercise.equipment, systemImage: "dumbbell.fill")
                        .font(.subheadline).foregroundStyle(.secondary)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How to do it").font(.headline)
                        ForEach(Array(exercise.cues.enumerated()), id: \.offset) { index, cue in
                            HStack(alignment: .top, spacing: 10) {
                                Text("\(index + 1)").font(.caption.bold()).foregroundStyle(.white)
                                    .frame(width: 22, height: 22).background(Color.gymMint, in: Circle())
                                Text(cue).font(.subheadline)
                            }
                        }
                    }
                    .padding(16).background(Color.gymCard, in: RoundedRectangle(cornerRadius: 20))
                    Label(exercise.watchOut, systemImage: "exclamationmark.triangle.fill")
                        .font(.subheadline).foregroundStyle(.orange)
                    if let swap = exercise.swap {
                        Text(swap).font(.subheadline).foregroundStyle(.secondary)
                    }
                }
                .padding(20)
            }
            .background(Color.gymCanvas)
            .navigationTitle(exercise.name)
            .gymInlineNavigationTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct ProgressView: View {
    @EnvironmentObject private var store: WorkoutStore
    @EnvironmentObject private var planner: WeekPlannerStore
    @State private var showingManualLog = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("YOUR MOMENTUM").font(.caption.bold()).tracking(1.3).foregroundStyle(Color.gymMint)
                        Text("Keep the chain going.").font(.system(size: 31, weight: .bold, design: .rounded))
                        Text("This is your record of showing up.").font(.subheadline).foregroundStyle(.secondary)
                    }
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("SESSIONS COMPLETED").font(.caption.bold()).tracking(1).foregroundStyle(.white.opacity(0.84))
                            Text("\(store.history.count)").font(.system(size: 64, weight: .bold, design: .rounded))
                        }
                        Spacer()
                        Image(systemName: "checkmark").font(.system(size: 27, weight: .bold)).foregroundStyle(Color.gymInk).frame(width: 60, height: 60).background(Color.gymMint, in: Circle())
                    }
                    .padding(22).foregroundStyle(.white).background(Color.gymInk, in: RoundedRectangle(cornerRadius: 28))

                    Button { showingManualLog = true } label: {
                        Label("Log a past workout", systemImage: "calendar.badge.plus")
                            .frame(maxWidth: .infinity).padding(.vertical, 5)
                    }
                    .buttonStyle(.borderedProminent).tint(.gymMint).foregroundStyle(.white)

                    Text("HISTORY").font(.caption.bold()).tracking(1).foregroundStyle(.secondary).padding(.top, 4)
                    if store.history.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "figure.strengthtraining.traditional").font(.system(size: 34)).foregroundStyle(Color.gymMint)
                            Text("Your history starts here").font(.headline)
                            Text("Finish a workout or log one later. It stays saved on this device.").font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity).padding(28).background(Color.gymCard, in: RoundedRectangle(cornerRadius: 22))
                    } else {
                        VStack(spacing: 0) {
                            ForEach(store.history) { session in
                                HStack(spacing: 12) {
                                    Image(systemName: session.day.symbol).foregroundStyle(session.day.accent).frame(width: 40, height: 40).background(session.day.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 13))
                                    VStack(alignment: .leading, spacing: 3) {
                                    Text(session.name ?? session.day.rawValue).font(.headline)
                                        Text(session.date.formatted(date: .abbreviated, time: .omitted)).font(.caption).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text("\(session.duration) min").font(.caption.weight(.bold)).foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 13)
                                if session.id != store.history.last?.id { Divider() }
                            }
                        }
                        .padding(.horizontal, 16).background(Color.gymCard, in: RoundedRectangle(cornerRadius: 22))
                    }
                }
                .padding(20).padding(.bottom, 28)
            }
            .background(Color.gymCanvas)
            .navigationTitle("Progress")
            .gymInlineNavigationTitle()
            .sheet(isPresented: $showingManualLog) {
                ManualWorkoutLogView()
            }
        }
    }
}

private struct ManualWorkoutLogOption: Identifiable {
    let id: String
    let title: String
    let day: WorkoutDay
}

private struct ManualWorkoutLogView: View {
    @EnvironmentObject private var store: WorkoutStore
    @EnvironmentObject private var planner: WeekPlannerStore
    @Environment(\.dismiss) private var dismiss
    @State private var selectedID = "focus-\(WorkoutDay.foundation.rawValue)"
    @State private var date = Calendar.current.startOfDay(for: .now)
    @State private var duration = 45

    private var options: [ManualWorkoutLogOption] {
        let focusOptions = WorkoutDay.allCases.map {
            ManualWorkoutLogOption(id: "focus-\($0.rawValue)", title: $0.rawValue, day: $0)
        }
        let plannedOptions = planner.days.compactMap { plannedDay -> ManualWorkoutLogOption? in
            guard let workout = planner.workout(for: plannedDay) else { return nil }
            return ManualWorkoutLogOption(id: "planned-\(plannedDay.id)", title: workout.displayName, day: workout.day)
        }
        return focusOptions + plannedOptions
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Workout") {
                    Picker("Session", selection: $selectedID) {
                        ForEach(options) { option in
                            Text(option.title).tag(option.id)
                        }
                    }
                    DatePicker("Date", selection: $date, in: ...Date.now, displayedComponents: .date)
                    Stepper("Duration: \(duration) minutes", value: $duration, in: 1...180, step: 5)
                }
                Section {
                    Text("Saved on this device. You can log it now even if you did not track the workout live.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Log a workout")
            .gymInlineNavigationTitle()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveLog() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func saveLog() {
        guard let option = options.first(where: { $0.id == selectedID }) else { return }
        store.complete(option.day, duration: duration, name: option.title, date: date)
        dismiss()
    }
}

#Preview {
    RootView().environmentObject(WorkoutStore())
}
