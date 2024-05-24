import SwiftUI

struct Home: View {
    
    var body: some View {
        TabView {
            MenuScreen()
                .tabItem { Label("Menu", systemImage: "menucard") }
            ProfileScreen()
                .tabItem { Label("Profile", systemImage: "person") }
        }
        .navigationBarBackButtonHidden()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
