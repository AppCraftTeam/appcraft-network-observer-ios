//
//  ViewController.swift
//  ACNetworkObserverDemo
//
//  Created by Damian on 17.04.2023.
//

import UIKit
import ACNetworkObserver

final
class ViewController: UIViewController {
    
    // MARK: Components
    private var isExpansiveLabel = UILabel(text: "Undefined")
    private var isConnectedLabel = UILabel(text: "Undefined")
    private var interfaceTypeLabel = UILabel(text: "Undefined")
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            createHorizontalStack(title: "Expensive: ", valueLabel: isExpansiveLabel),
            createHorizontalStack(title: "Connected: ", valueLabel: isConnectedLabel),
            createHorizontalStack(title: "Interfacy type: ", valueLabel: interfaceTypeLabel)
        ])
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Services
    private let networkObserver: ACNetworkObserverInterface
    
    // MARK: - Initialization
    init(networkObserver: ACNetworkObserverInterface) {
        self.networkObserver = networkObserver
        
        super.init(nibName: nil, bundle: nil)
        self.networkObserver.subscribe(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupComponents()
        self.networkObserver.start()
    }
    
    // MARK: - Setup methods
    private func setupComponents() {
        self.view.backgroundColor = .white
        self.view.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Fabtication
    private func createHorizontalStack(title: String, valueLabel: UILabel) -> UIStackView {
        let leftLabel = UILabel(text: title)
        leftLabel.font = .boldSystemFont(ofSize: 16)
        leftLabel.setContentHuggingPriority(
            .required,
            for: .horizontal
        )
        return UIStackView(arrangedSubviews: [leftLabel, valueLabel])
    }
}

// MARK: - NetworkMonitorListener methods
extension ViewController: ACNetworkMonitorListener {
    func networkMonitor(didChangeExpensiveStatus isExpansive: Bool) {
        self.isExpansiveLabel.text = isExpansive.description
        self.isExpansiveLabel.textColor = isExpansive ? .red : .green
    }
    
    func networkMonitor(didChangeConnectionStatus isConnected: Bool) {
        self.isConnectedLabel.text = isConnected.description
        self.isConnectedLabel.textColor = isConnected ? .green : .red
    }
    
    func networkMonitor(didChangeInterfaceType interfaceType: ACNetworkInterfaceType) {
        self.interfaceTypeLabel.text = interfaceType.description
    }
}
