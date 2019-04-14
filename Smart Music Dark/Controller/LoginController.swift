//
//  LoginController.swift
//  Smart Music Dark
//
//  Created by Lyheang IBell on 2/9/19.
//  Copyright © 2019 Kristoff IBell. All rights reserved.
//


import UIKit
import FirebaseAuth
import PKHUD

class LoginController: UIViewController {
    var datasource = [UITableViewCell]() { didSet { tableView.reloadData() }}
    let validation = Validator()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }

    func fillList(space: UIEdgeInsets = .zero) {
        view.addSubviews(views: tableView)
        tableView.fill(toView: view, space: space)
        setupKeyboardNotifcationListenerForScrollView(scrollView: tableView)
    }

    func setupView() {
        navigationController?.isNavigationBarHidden = true
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100


        let bgImageView = UIMaker.makeImageView(image: UIImage(named: "login_bg"), contentMode: .scaleAspectFill)
        let blackView = UIMaker.makeView(background: UIColor.black.withAlphaComponent(0.5))
        bgImageView.addFill(blackView)
        view.addSubview(bgImageView)
        bgImageView.fillSuperview()


        fillList()
        tableView.backgroundColor = .clear
        datasource = [ui.setupView()]

        ui.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        ui.signUpButton.addTarget(self, action: #selector(showSignup), for: .touchUpInside)
        ui.forgotButton.addTarget(self, action: #selector(showForgotPassword), for: .touchUpInside)
    }

    @objc func login() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.hideKeyboard()

        validation.email = ui.emailTextField.text
        validation.password = ui.passwordTextField.text
        if let message = validation.validate() {
            showError(message)
            return
        }

        HUD.show(.progress)
        Auth.auth().signIn(withEmail: validation.email!,
                           password: validation.password!) {
                            [weak self] (result, error) in
                            if error != nil {
                                self?.showError(error!.localizedDescription)
                                HUD.hide()
                                return
                            }

                            self?.didLoginSuccess()
        }
    }

    @objc func showSignup() {
        HUD.hide()
        let controller = RegisterController()
        navigationController?.setViewControllers([controller], animated: true)
    }

    @objc func showForgotPassword() {
        let controller = ForgotPasswordController()
        navigationController?.pushViewController(controller, animated: true)
    }

    func didLoginSuccess() {
        let helper = FirebaseHelper()
        helper.checkLoginStatus(completed: { [weak self] (didLogin) in
            if didLogin {
                let secondLoginErr = "You already logged in on other device. "
                try? Auth.auth().signOut()
                self?.showError(secondLoginErr)
                HUD.hide()
                return
            } else {
                HUD.hide()
                FirebaseHelper().saveLoginStatus(didLogin: true)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = CustomTabBarController()
            }
        })
    }

    func showError(_ message: String) {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        present(controller, animated: true)
    }

    lazy var tableView: UITableView = { [weak self] in
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        return tb
        }()

    let ui = UI()
}

extension LoginController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return datasource[indexPath.row] }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension }
}

extension LoginController {
    class UI {
        let padding: CGFloat = 24

        lazy var loginButton = makeMainButton()
        lazy var emailTextField = makeTextField(icon: UIImage(named: "email"),
                                           placeholder: "Email")
        lazy var passwordTextField = makeTextField(icon: UIImage(named: "password"),
                                              placeholder: "Password")
        let signUpButton = UIMaker.makeButton(title: "SIGN UP NOW", titleColor: .white,
                                              font: AppStateHelper.shared.defaultFontRegular(size: 15))
        let forgotButton = UIMaker.makeButton(title: "Forgot password", titleColor: .white,
                                              font: AppStateHelper.shared.defaultFontRegular(size: 15))

        func setupView() -> UITableViewCell {
            emailTextField.autocapitalizationType = .none
            emailTextField.autocorrectionType = .no

            passwordTextField.isSecureTextEntry = true

            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            cell.selectionStyle = .none

            let view = UIMaker.makeView()


            let font14 = AppStateHelper.shared.defaultFontRegular(size: 20)
            let appNameLabel = UIMaker.makeLabel(text: "8DWave",
                                                 font: font14,
                                                 color: .white)


            let boldFont = AppStateHelper.shared.defaultFontBold(size: 40)
            let loginLabel = UIMaker.makeLabel(text: "Login",
                                               font: boldFont,
                                               color: .white)


            let bar = UIMaker.makeHorizontalLine(color: .white, height: 5)


            view.addSubViewList(appNameLabel, loginLabel, bar, emailTextField, passwordTextField, loginButton, signUpButton, forgotButton)

            appNameLabel.left(toView: view, space: padding)

            loginLabel.left(toView: appNameLabel)
            loginLabel.verticalSpacing(toView: appNameLabel, space: padding)

            bar.left(toView: view, space: padding * 3)
            bar.width(150)
            bar.verticalSpacing(toView: loginLabel, space: padding * 2)
            bar.centerY(toView: view, space: -padding * 2)

            emailTextField.horizontal(toView: view, space: padding)
            emailTextField.verticalSpacing(toView: bar, space: padding * 3)

            passwordTextField.horizontal(toView: emailTextField)
            passwordTextField.verticalSpacing(toView: emailTextField, space: padding)

            loginButton.horizontal(toView: emailTextField)
            loginButton.verticalSpacing(toView: passwordTextField, space: padding * 2)


            signUpButton.verticalSpacing(toView: loginButton, space: padding * 3)
            signUpButton.bottom(toView: view, space: -padding * 2)
            signUpButton.left(toView: view, space: padding)

            forgotButton.right(toView: view, space: -padding)
            forgotButton.centerY(toView: signUpButton)

            cell.addSubview(view)
            view.fillSuperview()
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.height)
            return cell
        }

        func makeTextField(icon: UIImage?, placeholder: String) -> UITextField {
            let font = AppStateHelper.shared.defaultFontRegular(size: 18)
            let tf = UIMaker.makeTextField(placeholder: placeholder,
                                           font: font,
                                           color: .white)
            tf.setPlaceholderColor(.white)
            let view = tf.setView(.left, image: icon?.withRenderingMode(.alwaysTemplate))
            view.tintColor = .white
            tf.height(54)

            let line = UIMaker.makeHorizontalLine(color: .white)
            tf.addSubview(line)
            line.horizontal(toView: tf)
            line.bottom(toView: tf)
            return tf
        }

        func makeMainButton() -> UIButton {
            let barWidth: CGFloat = 3
            let bar = UIMaker.makeHorizontalLine(color: .white, height: barWidth)
            bar.isUserInteractionEnabled = false

            let font = AppStateHelper.shared.defaultFontBold(size: 20)
            let label = UIMaker.makeLabel(text: "LOGIN NOW",
                                          font: font,
                                          color: .white)
            let button = UIMaker.makeButton(background: .clear,
                                            borderWidth: barWidth,
                                            borderColor: .white)

            button.addSubview(bar)
            button.addSubview(label)


            button.addConstraints(withFormat: "H:|-16-[v0]-16-[v1]-16-|", views: bar, label)
            bar.centerY(toView: button)
            label.centerY(toView: button)

            button.height(66)
            return button
        }
    }

    class Validator {
        var email: String?
        var password: String?
        func validate() -> String? {
            if email == nil || email?.isEmpty == true { return "Email can't be blank" }
            if email!.isValidEmail() == false { return "Invalid email" }
            if password == nil || password?.isEmpty == true { return "Password can't be blank" }
            return nil
        }
    }
}

