//
//  AddUserViewController.swift
//  Donation
//
//  Created by Claude
//

import UIKit

protocol AddUserDelegate: AnyObject {
    func didAddUser(_ user: User)
}

class AddUserViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.backgroundColor = .systemGray5
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemGray3
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Photo", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var firstNameTextField = createTextField(placeholder: "First Name", keyboardType: .default)
    private lazy var lastNameTextField = createTextField(placeholder: "Last Name", keyboardType: .default)
    private lazy var emailTextField = createTextField(placeholder: "Email", keyboardType: .emailAddress)
    private lazy var phoneTextField = createTextField(placeholder: "Phone Number", keyboardType: .phonePad)
    private lazy var birthDateTextField = createTextField(placeholder: "Birth Date", keyboardType: .default)
    private lazy var passwordTextField = createTextField(placeholder: "Password", keyboardType: .default, isSecure: true)
    private lazy var confirmPasswordTextField = createTextField(placeholder: "Confirm Password", keyboardType: .default, isSecure: true)
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.maximumDate = Date()
        return picker
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "89AAC5")
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.layer.shadowColor = UIColor(hex: "89AAC5")?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 12
        button.layer.shadowOpacity = 0.3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    weak var delegate: AddUserDelegate?
    private var user: User?
    private var isEditMode: Bool = false
    private var selectedImage: UIImage?
    private var shouldUploadNewImage = false
    
    // MARK: - Initialization
    init(user: User? = nil) {
        self.user = user
        self.isEditMode = user != nil
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupDatePicker()
        setupKeyboardHandling()
        
        if let user = user {
            populateFields(with: user)
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(changePhotoButton)
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(birthDateTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(saveButton)
        
        changePhotoButton.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            changePhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            changePhotoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            firstNameTextField.topAnchor.constraint(equalTo: changePhotoButton.bottomAnchor, constant: 32),
            firstNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            firstNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 56),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            lastNameTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            lastNameTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 56),
            
            emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 56),
            
            phoneTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            phoneTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 56),
            
            birthDateTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 16),
            birthDateTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            birthDateTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            birthDateTextField.heightAnchor.constraint(equalToConstant: 56),
            
            passwordTextField.topAnchor.constraint(equalTo: birthDateTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 56),
            
            saveButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: firstNameTextField.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: firstNameTextField.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func setupNavigationBar() {
        title = isEditMode ? "Edit User" : "Add User"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func setupDatePicker() {
        birthDateTextField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(datePickerDone))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexSpace, doneButton]
        
        birthDateTextField.inputAccessoryView = toolbar
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func createTextField(placeholder: String, keyboardType: UIKeyboardType, isSecure: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.backgroundColor = .secondarySystemGroupedBackground
        textField.layer.cornerRadius = 12
        textField.font = .systemFont(ofSize: 16)
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.rightViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    private func populateFields(with user: User) {
        firstNameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        emailTextField.text = user.email
        phoneTextField.text = user.phoneNumber
        
        if let birthDate = user.birthDateAsDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            birthDateTextField.text = formatter.string(from: birthDate)
            datePicker.date = birthDate
        }
        
        // Load profile image
        if let imageURL = user.profileImageURL {
            loadImage(from: imageURL)
        }
        
        passwordTextField.placeholder = "Leave blank to keep current password"
        confirmPasswordTextField.placeholder = "Leave blank to keep current password"
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.profileImageView.image = image
            }
        }.resume()
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func changePhotoTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @objc private func datePickerDone() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        birthDateTextField.text = formatter.string(from: datePicker.date)
        birthDateTextField.resignFirstResponder()
    }
    
    @objc private func saveButtonTapped() {
        guard validateFields() else { return }
        
        // Show loading
        let loadingAlert = showLoadingAlert("Saving...")
        
        Task {
            do {
                var profileImageURL = user?.profileImageURL
                
                // Upload image if a new one was selected
                if shouldUploadNewImage, let image = selectedImage {
                    let userId = user?.id ?? UUID().uuidString
                    profileImageURL = try await SupabaseManager.shared.uploadProfileImage(image, userId: userId)
                }
                
                let firstName = firstNameTextField.text ?? ""
                let lastName = lastNameTextField.text ?? ""
                let email = emailTextField.text ?? ""
                let phone = phoneTextField.text
                let password = passwordTextField.text
                
                let newUser: User
                if let existingUser = user {
                    // Update existing user
                    newUser = User(
                        id: existingUser.id,
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        birthDate: datePicker.date,
                        phoneNumber: phone,
                        password: password?.isEmpty == false ? password : nil,
                        profileImageURL: profileImageURL,
                        isActive: existingUser.isActive,
                        createdAt: existingUser.createdAtAsDate
                    )
                    
                    let updatedUser = try await SupabaseManager.shared.updateUser(newUser)
                    
                    await MainActor.run {
                        loadingAlert.dismiss(animated: true) {
                            self.delegate?.didAddUser(updatedUser)
                            self.showSuccessAnimation()
                        }
                    }
                } else {
                    // Create new user
                    guard let password = password, !password.isEmpty else {
                        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Password is required"])
                    }
                    
                    newUser = User(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        birthDate: datePicker.date,
                        phoneNumber: phone,
                        password: password,
                        profileImageURL: profileImageURL
                    )
                    
                    let createdUser = try await SupabaseManager.shared.createUser(newUser)
                    
                    await MainActor.run {
                        loadingAlert.dismiss(animated: true) {
                            self.delegate?.didAddUser(createdUser)
                            self.showSuccessAnimation()
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    loadingAlert.dismiss(animated: true)
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func validateFields() -> Bool {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            showAlert(title: "Validation Error", message: "Please enter first name")
            return false
        }
        
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            showAlert(title: "Validation Error", message: "Please enter last name")
            return false
        }
        
        guard let email = emailTextField.text, !email.isEmpty, isValidEmail(email) else {
            showAlert(title: "Validation Error", message: "Please enter a valid email")
            return false
        }
        
        if !isEditMode {
            guard let password = passwordTextField.text, !password.isEmpty else {
                showAlert(title: "Validation Error", message: "Please enter a password")
                return false
            }
            
            guard let confirmPassword = confirmPasswordTextField.text, password == confirmPassword else {
                showAlert(title: "Validation Error", message: "Passwords do not match")
                return false
            }
            
            guard password.count >= 6 else {
                showAlert(title: "Validation Error", message: "Password must be at least 6 characters")
                return false
            }
        } else if let password = passwordTextField.text, !password.isEmpty {
            guard let confirmPassword = confirmPasswordTextField.text, password == confirmPassword else {
                showAlert(title: "Validation Error", message: "Passwords do not match")
                return false
            }
            
            guard password.count >= 6 else {
                showAlert(title: "Validation Error", message: "Password must be at least 6 characters")
                return false
            }
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showLoadingAlert(_ message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        loadingIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true
        loadingIndicator.startAnimating()
        present(alert, animated: true)
        return alert
    }
    
    private func showSuccessAnimation() {
        let checkmarkView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmarkView.tintColor = .systemGreen
        checkmarkView.contentMode = .scaleAspectFit
        checkmarkView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        checkmarkView.center = view.center
        checkmarkView.alpha = 0
        checkmarkView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        view.addSubview(checkmarkView)
        
        UIView.animate(withDuration: 0.3, animations: {
            checkmarkView.alpha = 1
            checkmarkView.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0.5, animations: {
                checkmarkView.alpha = 0
                checkmarkView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                checkmarkView.removeFromSuperview()
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
            selectedImage = editedImage
            shouldUploadNewImage = true
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageView.image = originalImage
            selectedImage = originalImage
            shouldUploadNewImage = true
        }
        
        dismiss(animated: true)
    }
}
