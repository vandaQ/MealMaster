import UIKit
import SnapKit

final class LoginViewController: UIViewController {
  private var nameTextField = UITextField()
  private var passTextField = UITextField()
  private var logInButton = UIButton(type: .system)
  private var signUpButton = UIButton(type: .system)
  private var helloLabel = UILabel()
  private var infoLabel = UILabel()
  
  var presenter: LoginViewPresenterProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyle = .light
    }
    
    view.backgroundColor = UIColor(red: 159/255, green: 174/255, blue: 173/255, alpha: 1)
    configureLabels()
    configureTextfields()
    configureButtons()
    hideKeyboard()
    moveKeyBoard()
  }
  
  //MARK: - View
  private func configureLabels() {
    helloLabel.text = "🎉Welcome🎉"
    helloLabel.textColor = UIColor(red: 239/255, green: 79/255, blue: 65/255, alpha: 1)
    helloLabel.font = UIFont.boldSystemFont(ofSize: 42)
    view.addSubview(helloLabel)
    helloLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(150)
      make.width.equalTo(300)
      make.height.equalTo(100)
    }
    
    infoLabel.numberOfLines = 0
    infoLabel.text = "Enjoy your favorite recipes with us"
    infoLabel.textColor = UIColor(red: 22/255, green: 16/255, blue: 34/255, alpha: 1)
    infoLabel.font = UIFont.systemFont(ofSize: 23)
    infoLabel.textAlignment = .center
    view.addSubview(infoLabel)
    infoLabel.snp.makeConstraints { make in
      make.top.equalTo(helloLabel).inset(80)
      make.centerX.equalToSuperview()
      make.width.equalTo(300)
      make.height.equalTo(100)
    }
  }
  
  private func configureTextfields() {
    setTextFieldDelegate()
    nameTextField.borderStyle = .roundedRect
    nameTextField.textAlignment = .left
    nameTextField.placeholder = "Enter login"
    nameTextField.returnKeyType = .done
    view.addSubview(nameTextField)
    nameTextField.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(infoLabel).inset(130)
      make.width.equalTo(280)
      make.height.equalTo(40)
    }
    
    
    passTextField.translatesAutoresizingMaskIntoConstraints = false
    passTextField.borderStyle = .roundedRect
    passTextField.textAlignment = .left
    passTextField.placeholder = "Enter password"
    passTextField.isSecureTextEntry.toggle()
    passTextField.keyboardType  = .numberPad
    view.addSubview(passTextField)
    passTextField.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(nameTextField).inset(55)
      make.width.equalTo(280)
      make.height.equalTo(40)
    }
  }
  
  private func configureButtons() {
    logInButton.translatesAutoresizingMaskIntoConstraints = false
    logInButton.backgroundColor  = UIColor(red: 239/255, green: 79/255, blue: 65/255, alpha: 1)
    logInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
    logInButton.setTitleColor(.white, for: .normal)
    logInButton.layer.cornerRadius = 20
    logInButton.setTitle("LogIn", for: .normal)
    
    logInButton.addTarget(self, action: #selector(lognIn), for: .touchUpInside)
    
    view.addSubview(logInButton)
    
    logInButton.snp.makeConstraints { make in
      make.top.equalTo(passTextField).inset(90)
      make.centerX.equalToSuperview()
      make.width.equalTo(260)
      make.height.equalTo(50)
    }
    
    signUpButton.translatesAutoresizingMaskIntoConstraints = false
    signUpButton.backgroundColor = .white
    signUpButton.layer.cornerRadius = 20
    signUpButton.layer.borderWidth = 1
    signUpButton.layer.borderColor = UIColor(red: 239/255, green: 79/255, blue: 65/255, alpha: 1).cgColor
    signUpButton.setTitle("SignUp", for: .normal)
    signUpButton.setTitleColor(UIColor(red: 239/255, green: 79/255, blue: 65/255, alpha: 1), for: .normal)
    signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    view.addSubview(signUpButton)
    signUpButton.snp.makeConstraints { make in
      make.top.equalTo(logInButton).inset(68)
      make.centerX.equalToSuperview()
      make.width.equalTo(260)
      make.height.equalTo(50)
    }
  }
  
  func setTextFieldDelegate() {
    nameTextField.delegate = self
    passTextField.delegate = self
  }
  
  //MARK: - Buttons
  @objc func lognIn(_ sender: UIButton) {
    let name = nameTextField.text ?? ""
    let pass = passTextField.text ?? ""
    
    presenter.login(username: name, password: pass)
  }
  
  @objc func signUp(_ sender: UIButton) {
    let name = nameTextField.text ?? ""
    let pass = passTextField.text ?? ""
      
    presenter.registration(username: name, password: pass)
  }
  
  
  //MARK: - reuseAlert
  func alert(title: String, massage: String, style: UIAlertController.Style) {
    let alert = UIAlertController(title: title, message: massage, preferredStyle: style)
    let action = UIAlertAction(title: "Ок", style: .default)
    alert.addAction(action)
    self.present(alert, animated: true)
  }
  
  func dismissAlert() {
    if let alert = presentedViewController as? UIAlertController {
      alert.dismiss(animated: true)
    }
  }
}


//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  
  func moveKeyBoard() {
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { nc in
      
      self.view.frame.origin.y = -100
    }
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: nil) { nc in
      self.view.frame.origin.y = 0
    }
  }
  
  //MARK: - hideKeyboard()
  func hideKeyboard() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

extension LoginViewController: LoginViewProtocol {
  func render(state: LoginState) {
    if let alertState = state.alert {
      alert(title: alertState.title, massage: alertState.message, style: .alert)
    } else {
      dismissAlert()
    }
  }
}
