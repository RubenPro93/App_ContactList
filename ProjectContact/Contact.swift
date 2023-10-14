import Foundation

class Contact: Identifiable {
    let id = UUID()
    var imageName: String
    var imageData: Data?
    var name: String
    var phone: String
    var email: String

    init(imageName: String, imageData: Data?, name: String, phone: String, email: String) {
        self.imageName = imageName
        self.imageData = imageData
        self.name = name
        self.phone = phone
        self.email = email
    }
}

class ContactManager: ObservableObject {
    @Published var contacts: [Contact] = []

    init() {
        loadPredefinedContacts()
    }

    private func loadPredefinedContacts() {
        let contact1 = Contact(imageName: "defaultImage", imageData: nil, name: "Ruben Alves", phone: "987654321", email: "ruben@atec.com")
        let contact2 = Contact(imageName: "defaultImage", imageData: nil, name: "João Alves", phone: "987654321", email: "joao_alves@atec.com")

        contacts.append(contentsOf: [contact1, contact2])
    }

    func addContact(imageData: Data?, name: String, phone: String, email: String) {
        let imageName = UUID().uuidString
        let contact = Contact(imageName: imageName, imageData: imageData, name: name, phone: phone, email: email)
        contacts.append(contact)
    }

    func updateContact(_ contact: Contact, withName name: String, phone: String, email: String) {
        guard let index = contacts.firstIndex(where: { $0.id == contact.id }) else { return }
        let updatedContact = Contact(imageName: contact.imageName, imageData: contact.imageData, name: name, phone: phone, email: email)
        contacts[index] = updatedContact
    }
}
