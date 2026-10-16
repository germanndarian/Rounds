import SwiftUI

struct HomeSafeView: View {
    @Environment(AppState.self) private var app

    private var members: [(Person, CheckInStatus)] {
        let me: CheckInStatus = app.checkedInAt.map { .home("Checked in at \($0.formatted(date: .omitted, time: .shortened))") }
            ?? .out("Kasernen Club")
        return [
            (SampleData.me, me),
            (SampleData.amara, .home("Home at 1:12 AM")),
            (SampleData.mateo, .home("Home at 1:31 AM")),
            (SampleData.lukas, .out("Kasernen Club")),
            (SampleData.priya, .notCheckedIn("Last seen 12:40 AM, Hinterhof 8")),
        ]
    }

    private var homeCount: Int {
        members.filter { if case .home = $0.1 { true } else { false } }.count
    }

    var body: some View {
        @Bindable var app = app
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Get home safe").font(.heading(34)).tracking(-0.85)
                    Text("\(Date.now.formatted(date: .omitted, time: .shortened)) · \(homeCount) of \(members.count) home")
                        .font(.body(15)).foregroundStyle(Theme.neutral500)
                }
                .padding(.horizontal, 20)

                VStack(spacing: 0) {
                    ForEach(Array(members.enumerated()), id: \.element.0.id) { index, entry in
                        memberRow(entry.0, status: entry.1)
                        if index < members.count - 1 { FadingDivider() }
                    }
                }
                .padding(.horizontal, 16).padding(.vertical, 4)
                .background(RoundedRectangle(cornerRadius: 20).fill(Theme.surface))
                .padding(.horizontal, 16)
                .padding(.top, 20)

                if app.showsBAC { bacCard } else {
                    Button("Show BAC estimate") { withAnimation { app.showsBAC = true } }
                        .buttonStyle(OutlinePillStyle(height: 44, fontSize: 14, fill: false))
                        .padding(.horizontal, 16).padding(.top, 16)
                }
            }
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background(Theme.bg.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) { homeButton }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func memberRow(_ person: Person, status: CheckInStatus) -> some View {
        HStack(spacing: 12) {
            Avatar(person: person, size: 40)
            VStack(alignment: .leading, spacing: 1) {
                Text(person.id == SampleData.me.id ? "You" : person.name).font(.body(16))
                Group {
                    switch status {
                    case .home(let sub), .out(let sub), .notCheckedIn(let sub): Text(sub)
                    }
                }
                .font(.body(13)).foregroundStyle(Theme.neutral500)
            }
            Spacer()
            switch status {
            case .home: Tag(text: "Home", systemImage: "checkmark")
            case .out: Tag(text: "Still out", style: .neutral)
            case .notCheckedIn:
                Button(app.nudged ? "Nudged" : "Nudge") {
                    app.nudged = true
                    app.show(toast: "\(person.name) got a nudge")
                }
                .font(.body(13, weight: .medium))
                .foregroundStyle(Theme.accent300)
                .padding(.horizontal, 12)
                .frame(minHeight: 36)
                .overlay(Capsule().strokeBorder(Theme.accent, style: StrokeStyle(lineWidth: 1, dash: [4, 3])))
                .disabled(app.nudged)
            }
        }
        .frame(minHeight: 64)
    }

    /// Opt-in, shown as a range, never shared with the crew.
    private var bacCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Kicker("Estimated BAC · only you see this")
                Spacer()
                Button("Hide") { withAnimation { app.showsBAC = false } }
                    .font(.body(13)).foregroundStyle(Theme.neutral400)
            }
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("≈ 0.05%").font(.heading(40)).tracking(-1.2)
                Text("range 0.03–0.07%").font(.body(14)).foregroundStyle(Theme.neutral500)
            }
            Text("Based on what you logged, your profile and the time. Likely near 0.00% around 5:30 AM.")
                .font(.body(14)).foregroundStyle(Theme.neutral400)
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "exclamationmark.circle").font(.system(size: 20))
                (Text("Estimate only. Not for driving decisions.").fontWeight(.semibold)
                    + Text(" Don't drive tonight. Take a tram or taxi, or walk with someone."))
                    .font(.body(14))
            }
            .foregroundStyle(Theme.accent200)
            .padding(12)
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.accent))
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20).fill(Theme.surface))
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }

    private var homeButton: some View {
        VStack(spacing: 8) {
            Button { app.checkIn() } label: {
                if let at = app.checkedInAt {
                    Label("Home · \(at.formatted(date: .omitted, time: .shortened))", systemImage: "checkmark.circle.fill")
                } else {
                    Label("I'm home", systemImage: "house")
                }
            }
            .buttonStyle(AccentPillStyle(height: 72, fontSize: 21))
            .sensoryFeedback(.success, trigger: app.checkedInAt)
            Text(app.checkedInAt == nil ? "Your crew gets a notification." : "Sleep well. Photos develop at 10:00.")
                .font(.body(13)).foregroundStyle(Theme.neutral500)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .background(LinearGradient(colors: [Theme.bg.opacity(0), Theme.bg], startPoint: .top, endPoint: .center).ignoresSafeArea())
    }
}

#Preview {
    NavigationStack { HomeSafeView() }
        .environment(AppState())
        .preferredColorScheme(.dark)
}
