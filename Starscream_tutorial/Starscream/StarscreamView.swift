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
        button.setTitle("Connected", for: .normal)
        button.setTitle("DisConnected", for: .selected)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(tappedConnectButton), for: .touchUpInside)
        return button
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "내용을 입력해주세요."
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.391511023, green: 0.4367037416, blue: 0.4872434139, alpha: 1)
        return textField
    }()
    
    lazy var writeButton: UIButton = {
        let button = UIButton()
        button.setTitle("send", for: .normal)
        button.setTitleColor(.black , for: .normal)
        button.addTarget(self, action: #selector(tappedSendButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
                
    }

    private func setupUI() {
        
        self.view.addSubview(viewWrapper)
        self.view.addSubview(switchConnectButton)
        self.view.addSubview(textField)
        self.view.addSubview(writeButton)
        
        viewWrapper.snp.makeConstraints {
            $0.width.height.equalTo(300)
            $0.center.equalTo(self.view)
        }
        
        switchConnectButton.snp.makeConstraints {
            $0.top.equalTo(self.viewWrapper).inset(40)
            $0.centerX.equalTo(self.viewWrapper)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(self.switchConnectButton).offset(60)
            $0.centerX.equalTo(self.viewWrapper)
        }
        
        writeButton.snp.makeConstraints {
            $0.top.equalTo(self.textField).offset(80)
            $0.centerX.equalTo(self.viewWrapper)
        }
        
        

    }
    
    @objc func tappedConnectButton() {
        switchConnectButton.isSelected = !switchConnectButton.isSelected
        print("now connect status is \(switchConnectButton.isSelected)")
    }
    
    @objc func tappedSendButton() {
        guard let text = textField.text else { return }
        print("send \(text)")
        
        textField.text = ""
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

