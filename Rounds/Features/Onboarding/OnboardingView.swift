import AuthenticationServices
import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void

    @State private var step = 0
    @State private var ageDenied = false

    private struct Slide { let kicker, title, body: String; var cta = "Continue" }

    private let slides = [
        Slide(kicker: "Crews", title: "Your people, in one place",
              body: "Make a crew for the friends you go out with. Everyone sees the same night as it happens."),
        Slide(kicker: "Nights", title: "Log the night as it happens",
              body: "Bars, rounds and photos land in one shared feed. One tap, then back to the conversation."),
        Slide(kicker: "The morning after", title: "Wake up to the recap",
              body: "At 10:00 the disposable photos develop and the night turns into a story you can keep.", cta: "Get started"),
        Slide(kicker: "Before we start", title: "One quick check",
              body: "Rounds is for people of legal drinking age. That's 18 in Switzerland and 21 in the US."),
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                if step < 3 {
                    Button("Skip") { withAnimation { step = 3 } }
                        .font(.body(16, weight: .medium))
                        .foregroundStyle(Theme.accent300)
                        .frame(minHeight: 44)
                }
            }
            .frame(height: 44)
            .padding(.horizontal, 20)

            art
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .id(step)
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .leading).combined(with: .opacity)))

            if step <= 3 {
                let slide = slides[step]
                VStack(alignment: .leading, spacing: 10) {
                    Kicker(slide.kicker)
                    Text(slide.title).font(.heading(32)).tracking(-0.8)
                    Text(slide.body).font(.body(17)).foregroundStyle(Theme.neutral400).lineSpacing(3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .id("text\(step)")
            }

            controls
                .padding(.horizontal, 24)
                .padding(.top, 26)
                .padding(.bottom, 12)
        }
        .foregroundStyle(Theme.text)
        .nocturneHeroBackground(height: 0.55)
        .gesture(DragGesture(minimumDistance: 30).onEnded { value in
            guard step < 3 else { return }
            withAnimation(.spring(duration: 0.35)) {
                if value.translation.width < -50 { step = min(step + 1, 3) }
                if value.translation.width > 50 { step = max(step - 1, 0) }
            }
        })
        .animation(.spring(duration: 0.35), value: step)
        .sensoryFeedback(.selection, trigger: step)
    }

    // MARK: Art

    @ViewBuilder private var art: some View {
        switch step {
        case 0: crewCluster
        case 1: feedPreview
        case 2: developingPolaroids
        case 3:
            Text("18+")
                .font(.heading(64)).tracking(-2.5)
                .foregroundStyle(Theme.accent200)
                .frame(width: 168, height: 168)
                .overlay(Circle().strokeBorder(Theme.accent, lineWidth: 1))
                .shadow(color: Theme.accent.opacity(0.3), radius: 25)
        default:
            VStack(alignment: .leading, spacing: 10) {
                Text("Rounds").font(.heading(64)).tracking(-2.9)
                Text("Nights out, kept.").font(.body(19)).foregroundStyle(Theme.neutral400)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28)
        }
    }

    private var crewCluster: some View {
        let layout: [(Person, CGFloat, CGFloat, CGFloat)] = [
            (SampleData.amara, 118, -6, 64), (SampleData.me, 104, 104, 92), (SampleData.lukas, 222, 92, 60),
            (SampleData.priya, 26, 170, 66), (SampleData.mateo, 208, 200, 56),
        ]
        return ZStack(alignment: .topLeading) {
            Circle().strokeBorder(Theme.divider).frame(width: 300, height: 300)
            Circle().strokeBorder(Theme.divider).frame(width: 200, height: 200).offset(x: 50, y: 50)
            ForEach(layout, id: \.0.id) { person, x, y, size in
                Avatar(person: person, size: size, ring: Theme.bg).offset(x: x, y: y)
            }
        }
        .frame(width: 300, height: 300)
        .overlay(alignment: .bottom) { Tag(text: "The Usual Suspects · 5").offset(y: 6) }
    }

    private var feedPreview: some View {
        VStack(spacing: 12) {
            previewCard(person: SampleData.priya, title: "logged a Cocktail", sub: "Hinterhof 8 · 11:38 PM", symbol: DrinkKind.cocktail.symbol)
                .rotationEffect(.degrees(-2))
            previewCard(person: SampleData.lukas, title: "took a photo", sub: "Develops at 10:00 AM", symbol: "lock.fill")
                .rotationEffect(.degrees(1.5))
                .padding(.leading, 24)
            Label("Crew arrived at Bar Limmatblick · 8:24 PM", systemImage: "mappin.and.ellipse")
                .font(.mono(12)).foregroundStyle(Theme.neutral500).padding(.top, 6)
        }
        .padding(.horizontal, 28)
    }

    private func previewCard(person: Person, title: String, sub: String, symbol: String) -> some View {
        HStack(spacing: 12) {
            Avatar(person: person, size: 36)
            VStack(alignment: .leading, spacing: 2) {
                (Text(person.name).fontWeight(.semibold) + Text(" \(title)")).font(.body(15))
                Text(sub).font(.body(12)).foregroundStyle(Theme.neutral500)
            }
            Spacer()
            Image(systemName: symbol).font(.system(size: 20)).foregroundStyle(Theme.accent)
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18).fill(Theme.surface))
        .shadow(color: .black.opacity(0.55), radius: 9, y: 6)
    }

    private var developingPolaroids: some View {
        ZStack(alignment: .topLeading) {
            Polaroid(bottom: 34, paper: Theme.neutral300, rotation: -9) {
                FilmPhoto().frame(width: 184, height: 184)
            }
            .offset(y: 20)
            Polaroid(bottom: 34, rotation: 5, caption: "1:15 AM · by Amara") {
                FilmPhoto(caption: nil, stamp: "10 15 '26").frame(width: 184, height: 184)
                    .overlay(alignment: .topLeading) {
                        Text("photo · Kasernen Club").font(.mono(10)).foregroundStyle(Theme.neutral400).padding(10)
                    }
            }
            .offset(x: 46, y: 6)
        }
        .frame(width: 250, height: 290, alignment: .topLeading)
        .overlay(alignment: .bottom) { Tag(text: "Develops at 10:00 AM", systemImage: "sunrise.fill") }
    }

    // MARK: Controls

    @ViewBuilder private var controls: some View {
        VStack(spacing: 12) {
            if step < 3 {
                HStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { index in
                        Capsule()
                            .fill(index == step ? Theme.accent : Theme.neutral700)
                            .frame(width: index == step ? 22 : 6, height: 6)
                    }
                    Spacer()
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 8)
                Button(slides[step].cta) { withAnimation { step += 1 } }
                    .buttonStyle(AccentPillStyle(height: 60, fontSize: 18))
            } else if step == 3 && !ageDenied {
                Button("I'm of legal drinking age") { withAnimation { step = 4 } }
                    .buttonStyle(AccentPillStyle(height: 60, fontSize: 18, glow: false))
                Button("I'm not") { withAnimation { ageDenied = true } }
                    .buttonStyle(OutlinePillStyle())
            } else if step == 3 {
                Text("Rounds is only for people of legal drinking age, so we can't set up an account for you yet.")
                    .font(.body(15)).foregroundStyle(Theme.neutral300)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 18).fill(Theme.surface))
                Button("Go back") { withAnimation { ageDenied = false; step = 0 } }
                    .buttonStyle(OutlinePillStyle())
            } else {
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName]
                } onCompletion: { _ in
                    // Prototype: continue either way until Supabase auth (signInWithIdToken) is wired up.
                    onFinish()
                }
                .signInWithAppleButtonStyle(.white)
                .frame(height: 56)
                .clipShape(Capsule())
                Text("We only ask for your name. Your email can stay private.\nTerms · Privacy")
                    .font(.body(12)).foregroundStyle(Theme.neutral500).multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    OnboardingView {}
        .environment(AppState())
        .preferredColorScheme(.dark)
}
