import SwiftUI

struct MenuScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationStack {
            VStack {
                Header()
                Menu()
            }
        }
    }
}

#Preview {
    MenuScreen().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
