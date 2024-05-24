import SwiftUI
import CoreData

struct Menu: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selectedCategory: String = ""

    @State private var searchText = ""

    @State private var loaded = false

    @State private var isKeyboardVisible = false

    private var categories: [String] = ["Starters","Mains","Desserts","Drinks"]

    init() {
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if !isKeyboardVisible {
                        withAnimation() {
                            Hero()
                                .frame(maxHeight: 180)
                        }
                    }
                    TextField("Search menu", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                .background(Color.primaryColor1)
                
                Text("Order for Delivery")
                    .font(.sectionTitle())
                    .foregroundColor(.highlightColor2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.leading)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(categories, id: \.self) {category in
                            Text(category)
                                .font(.callout)
                                .frame(minWidth: 35)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 10)
                                .themeColors(isSelected: category == selectedCategory)
                                .cornerRadius(20)
                                .onTapGesture {
                                    if category == selectedCategory {
                                        selectedCategory = ""
                                    } else {
                                        selectedCategory = category
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                FetchedObjects(predicate: buildPredicate(),
                               sortDescriptors: buildSortDescriptors()) {
                    (dishes: [Dish]) in
                    List(dishes) { dish in
                        NavigationLink(destination: DetailItem(dish: dish)) {
                            FoodItem(dish: dish)
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .onAppear {
            if !loaded {
                MenuList.getMenuData(viewContext: viewContext)
                loaded = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            withAnimation {
                self.isKeyboardVisible = true
            }
            
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { notification in
            withAnimation {
                self.isKeyboardVisible = false
            }
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title",
                                  ascending: true,
                                  selector:
                                    #selector(NSString.localizedStandardCompare))]
    }
    
    func buildPredicate() -> NSCompoundPredicate {
        let predicate1 = (searchText.isEmpty ? NSPredicate(format: "TRUEPREDICATE") : NSPredicate(format: "title CONTAINS[cd] %@", searchText))
        let predicate2 = (selectedCategory.isEmpty ? NSPredicate(format: "TRUEPREDICATE") : NSPredicate(format: "category CONTAINS[cd] %@", selectedCategory))

        return NSCompoundPredicate(type: .and,
                                   subpredicates: [ predicate1, predicate2 ])
    }
}

extension View {
    func themeColors(isSelected: Bool) -> some View {
        return
        self
            .foregroundStyle(isSelected ? Color.highlightColor1 : Color.primaryColor1)
            .background(isSelected ? Color.primaryColor1 : Color.highlightColor1)
    }
}

#Preview {
    Menu().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
