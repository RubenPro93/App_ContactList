import SwiftUI

struct DetailView: View {
    @State private var isEditing: Bool = false
    @State private var editedContact: Contact

    var contact: Contact
    @ObservedObject var contactManager: ContactManager

    init(contact: Contact, contactManager: ContactManager) {
        self.contact = contact
        self.contactManager = contactManager
        _editedContact = State(initialValue: contact)
    }

    var body: some View {
        VStack {
            if let imageData = contact.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }

            Text(contact.name)
                .font(.title)
                .fontWeight(.medium)

            Form {
                Section {
                    HStack {
                        Text("Phone")
                        Spacer()
                        Text(contact.phone)
                            .foregroundStyle(.gray)
                            .font(.callout)
                            .frame(alignment: .leading)
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(contact.email)
                            .foregroundStyle(.gray)
                            .font(.callout)
                            .frame(alignment: .leading)
                    }
                }
            }

            HStack {
                Button(action: {
                    isEditing.toggle()
                }) {
                    Image(systemName: "pencil")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 60)

                Button(action: {
                    contactManager.contacts.removeAll { $0.id == contact.id }
                }) {
                    Image(systemName: "trash")
                        .imageScale(.large)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .environment(\.colorScheme, .light)
        .sheet(isPresented: $isEditing) {
            EditView(contact: editedContact, contactManager: contactManager)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let contactManager = ContactManager()
        contactManager.contacts = [Contact(imageName: "", imageData: nil, name: "", phone: "", email: "")]
        return DetailView(contact: contactManager.contacts[0], contactManager: contactManager)
    }
}
