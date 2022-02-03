//
//  StarscreamView.swift
//  Starscream_tutorial
//
//  Created by BH on 2022/01/28.
//

import UIKit
import Starscream
import SnapKit

class StarscreamView: UIViewController {
    
    var socket: WebSocket!
    var isConnected = false
    
    lazy var viewWrapper: UIView = {
       let view = UIView()
        view.layer.borderColor = #colorLiteral(red: 0.391511023, green: 0.4367037416, blue: 0.4872434139, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var switchConnectButton: UIButton = {
        let button = UIButton()
        button.isSelected = false
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(tappedConnectButton), for: .touchUpInside)
        return button
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.addLeftPadding()
        textField.placeholder = "내용을 입력해주세요."
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.391511023, green: 0.4367037416, blue: 0.4872434139, alpha: 1)
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("send", for: .normal)
        button.setTitleColor(.white , for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.addTarget(self, action: #selector(tappedSendButton), for: .touchUpInside)
        return button
    }()

    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebSocket()
        setupUI()
    }
    
    private func setupWebSocket() {
        let url = URL(string: "ws://dev2.arasoft.kr:18080/okra-app-v1/ocrTest")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 3
        socket = WebSocket(request: request)
        socket.delegate = self
    }

    private func setupUI() {
        
        // MARK: addSubview
        self.view.addSubview(viewWrapper)
        self.view.addSubview(switchConnectButton)
        self.view.addSubview(textField)
        self.view.addSubview(sendButton)
        
        // MARK: setupLayout
        viewWrapper.snp.makeConstraints {
            $0.width.height.equalTo(300)
            $0.center.equalTo(self.view)
        }
        
        switchConnectButton.snp.makeConstraints {
            $0.top.equalTo(self.viewWrapper).inset(40)
            $0.centerX.equalTo(self.viewWrapper)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(self.switchConnectButton).offset(80)
            $0.height.equalTo(40)
            $0.width.equalTo(self.viewWrapper).inset(30)
            $0.centerX.equalTo(self.viewWrapper)
        }
        
        sendButton.snp.makeConstraints {
            $0.top.equalTo(self.textField).offset(80)
            $0.width.equalTo(80)
            $0.centerX.equalTo(self.viewWrapper)
        }
        
        

    }
    
    @objc func tappedConnectButton() {
        if isConnected {
            switchConnectButton.setTitle("Disconnect", for: .normal)
            socket.disconnect()
        } else {
            switchConnectButton.setTitle("Connect", for: .normal)
            socket.connect()
        }
//        switchConnectButton.isSelected = !switchConnectButton.isSelected
//        print("now connect status is \(switchConnectButton.isSelected)")
    }
    
    @objc func tappedSendButton() {
        guard let text = textField.text else { return }
        socket.write(string: text)
        
        textField.text = ""
    }
    

}

extension StarscreamView: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
            
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
            
        case .cancelled:
            isConnected = false
            print("웹소켓 취소됨")
            
        case .error(let err):
            isConnected = false
            handleError(err)
            
        case .binary(let data):
            print("binary data: \(data)")
            
        case .ping(let data):
            print("ping data: \(data)")
            
        case .pong(let data):
            print("pong data: \(data)")
            
        case .reconnectSuggested(let bool):
            print("reconnectSuggested: \(bool)")
            
        case .viabilityChanged(let bool):
            print("viabilityChanged: \(bool)")
            
        case .text(let str):
            print("text str: \(str)")
        }
    }
    
    func handleError(_ error: Error?) {
        if let error = error as? WSError {
            print("websocket encountered an error: \(error.message)")
        } else if let error = error {
            print("websocket encountered an error: \(error.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

// 전처리
#if DEBUG

import SwiftUI
@available(iOS 13.0, *)

// UIViewControllerRepresentable을 채택
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    // update
    // _ uiViewController: UIViewController로 지정
    func updateUIViewController(_ uiViewController: UIViewController , context: Context) {
        
    }
    // makeui
    func makeUIViewController(context: Context) -> UIViewController {
    // Preview를 보고자 하는 Viewcontroller 이름
    // e.g.)
        return StarscreamView()
    }
}

struct ViewController_Previews: PreviewProvider {
    
    @available(iOS 13.0, *)
    static var previews: some View {
        // UIViewControllerRepresentable에 지정된 이름.
        ViewControllerRepresentable()

// 테스트 해보고자 하는 기기
            .previewDevice("iPhone 11")
    }
}
#endif

