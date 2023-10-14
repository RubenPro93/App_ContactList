import SwiftUI

struct EditView: View {
    var contact: Contact
    @ObservedObject var contactManager: ContactManager
    @State private var editedName: String
    @State private var editedPhone: String
    @State private var editedEmail: String
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var selectedImageData: Data? = nil
    @Environment(\.presentationMode) var presentationMode

    init(contact: Contact, contactManager: ContactManager) {
        self.contact = contact
        self._editedName = State(initialValue: contact.name)
        self._editedPhone = State(initialValue: contact.phone)
        self._editedEmail = State(initialValue: contact.email)
        self.contactManager = contactManager
    }

    var body: some View {
        NavigationView {
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                        .padding()
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                        .padding()
                }

                Button(action: {
                    showImagePicker.toggle()
                }) {
                    Text("Choose Photo")
                }
                .padding()

                TextField("Name", text: $editedName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Phone", text: $editedPhone)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)

                TextField("Email", text: $editedEmail)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)

                Spacer()

                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        guard !editedPhone.isEmpty else {
                            print("Phone is required")
                            return
                        }

                        contactManager.updateContact(contact, withName: editedName, phone: editedPhone, email: editedEmail)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .navigationBarTitle("Edit Contact", displayMode: .inline)
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: self.$selectedImage)
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(contact: Contact(imageName: "", imageData: nil, name: "", phone: "", email: ""), contactManager: ContactManager())
    }
}
