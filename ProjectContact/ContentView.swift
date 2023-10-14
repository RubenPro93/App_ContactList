import SwiftUI

struct ContentView: View {
    @State private var isAddingContact = false
    @ObservedObject var contactManager = ContactManager()
    @State private var selectedContact: Contact?

    var body: some View {
        NavigationView {
            List(contactManager.contacts) { contact in
                NavigationLink(destination: DetailView(contact: contact, contactManager: self.contactManager)) {
                    ContactRow(contact: contact)
                }
            }
            .navigationBarTitle("Contacts")
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isAddingContact.toggle()
                        }) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 80)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .padding(.trailing, 20)
                        }
                    }
                }
            )
            .sheet(isPresented: $isAddingContact) {
                if let contact = selectedContact {
                    EditView(contact: contact, contactManager: contactManager)
                } else {
                    AddView(contactManager: self.contactManager)
                }
            }
        }
        .environment(\.colorScheme, .light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContactRow: View {
    let contact: Contact

    var body: some View {
        HStack {
            if let imageData = contact.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading) {
                Text(contact.name)
                    .font(.system(size: 21, weight: .medium, design: .default))
                Text(contact.phone)
            }
        }
    }
}
