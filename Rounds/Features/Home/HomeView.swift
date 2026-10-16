import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No night yet",
                systemImage: "wineglass",
                description: Text("Start a Night with your crew to begin.")
            )
            .navigationTitle("Rounds")
        }
    }
}

#Preview {
    HomeView()
}
