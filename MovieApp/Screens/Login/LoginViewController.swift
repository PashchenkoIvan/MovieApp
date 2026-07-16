//
//  LoginViewController.swift
//  MovieApp
//
//  Created by Ivan P. on 08/07/2026.
//

import SnapKit
import UIKit

final class LoginViewController: BaseViewController<LoginViewModel> {
    private let titleLabel = UILabel()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let errorLabel = UILabel()

    override func setupUI() {
        view.backgroundColor = .systemBackground

        titleLabel.text = localized("login.title")
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center

        usernameTextField.placeholder = localized("login.field.username.placeholder")
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.textContentType = .username
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no

        passwordTextField.placeholder = localized("login.field.password.placeholder")
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true

        loginButton.setTitle(localized("login.primaryButton.title"), for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        errorLabel.textColor = .systemRed
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true

        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            usernameTextField,
            passwordTextField,
            loginButton,
            errorLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.setCustomSpacing(28, after: titleLabel)

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.centerY.equalToSuperview()
        }
    }

    override func render(_ state: LoginViewState) {
        switch state {
        case .idle:
            setControlsEnabled(true)
            errorLabel.isHidden = true
        case .loading:
            setControlsEnabled(false)
            errorLabel.isHidden = true
        case .authenticated:
            setControlsEnabled(true)
            errorLabel.isHidden = true
        case .failed(let messageKey):
            setControlsEnabled(true)
            errorLabel.text = localized(messageKey)
            errorLabel.isHidden = false
        }
    }
}

private extension LoginViewController {
    func setControlsEnabled(_ isEnabled: Bool) {
        usernameTextField.isEnabled = isEnabled
        passwordTextField.isEnabled = isEnabled
        loginButton.isEnabled = isEnabled
    }

    @objc func loginButtonTapped() {
        viewModel.login(
            username: usernameTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }
}
