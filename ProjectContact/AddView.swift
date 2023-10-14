import SwiftUI

struct AddView: View {
    @ObservedObject var contactManager: ContactManager
    @State private var newName: String = ""
    @State private var newPhone: String = ""
    @State private var newEmail: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var selectedImageData: Data? = nil
    @Environment(\.presentationMode) private var presentationMode
    @State private var isPhoneValid: Bool = true
    @State private var isEmailValid: Bool = true

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }
            
            Button(action: {
                showImagePicker.toggle()
            }) {
                Text("Choose Photo")
            }
            .padding()
            
            TextField("Name", text: $newName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Phone", text: $newPhone)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.phonePad)
                .onChange(of: newPhone, perform: { value in
                    isPhoneValid = isValidPhone(value)
                })
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isPhoneValid || newPhone.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                )
                .padding(.bottom, 5)
                .onAppear {
                    isPhoneValid = isValidPhone(newPhone)
                }
            
            TextField("Email", text: $newEmail)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .onChange(of: newEmail, perform: { value in
                    isEmailValid = isValidEmail(value)
                })
                .foregroundColor(isEmailValid ? .primary : .red)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isPhoneValid || newPhone.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                )
                .padding(.bottom, 20)
                .onAppear {
                    isEmailValid = isValidEmail(newEmail)
                }
            
            Spacer()
            
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Button(action: {
                    guard let image = selectedImage else { return }
                    guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
                    contactManager.addContact(imageData: imageData, name: newName, phone: newPhone, email: newEmail)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: self.$selectedImage)
        }
    }
    
    private func isValidPhone(_ phone: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "0123456789+")
        let disallowedCharacters = allowedCharacters.inverted
        return phone.rangeOfCharacter(from: disallowedCharacters) == nil
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return emailPredicate.evaluate(with: email)
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(contactManager: ContactManager())
    }
}


struct ImagePicker: UIViewControllerRepresentable { // Define uma estrutura chamada ImagePicker que representa um controlador de visualização
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker // Variável para armazenar a referência ao pai
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        // Função para lidar com a seleção de imagem
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage // Armazena a imagem selecionada
            }
            parent.presentationMode.wrappedValue.dismiss() // Sai do seletor de imagem
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    // Função para criar o controlador de visualização
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIViewController {
        let picker = UIImagePickerController() // Cria um seletor de imagem
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
}

