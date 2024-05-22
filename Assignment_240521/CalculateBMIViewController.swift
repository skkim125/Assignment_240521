//
//  CalculateBMIViewController.swift
//  Assignment_240521
//
//  Created by 김상규 on 5/21/24.
//

import UIKit

class CalculateBMIViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var charactorImage: UIImageView!
    
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var nicknameTextField: UITextField!
    
    
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var heightTextField: UITextField!
    
    
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var weightTextField: UITextField!
    
    @IBOutlet var randomButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var resultButton: UIButton!
    
    var nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
    var height = UserDefaults.standard.string(forKey: "height") ?? ""
    var weight = UserDefaults.standard.string(forKey: "weight") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInfo()
        
        configureTopLabels()
        configureBMIUI(label: nicknameLabel, text: "닉네임을 입력해주세요.", textField: nicknameTextField, placeholder: "닉네임: 2자 이상")
        configureBMIUI(label: heightLabel, text: "키가 어떻게 되시나요?", textField: heightTextField, placeholder: "키: cm 기준, 140~230cm")
        configureBMIUI(label: weightLabel, text: "몸무게가 어떻게 되시나요?", textField: weightTextField, placeholder: "몸무게: kg 기준 30~130kg")
        
        configureRandomButton()
        configureResetButton()
        configureResultButton()
    }
    
    // 위쪽 레이블 및 이미지 UI
    func configureTopLabels() {
        titleLabel.text = "BMI Calculator"
        titleLabel.font = .systemFont(ofSize: 23, weight: .black)
        
        subLabel.text = "당신의 BMI 지수를 알려드릴게요."
        subLabel.font = .systemFont(ofSize: 15)
        subLabel.numberOfLines = 2
        
        charactorImage.image = UIImage(named: "image")
        charactorImage.contentMode = .scaleToFill
    }
    
    // BMI 관련 UI
    func configureBMIUI(label: UILabel, text: String, textField: UITextField, placeholder: String) {
        label.text = text
        label.font = .systemFont(ofSize: 13)
        textField.keyboardType = .numbersAndPunctuation
        textField.returnKeyType = .done
        textField.borderStyle = .none
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.placeholder = placeholder
        
        // 텍스트필드 좌우 패딩 처리
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.rightViewMode = .always
    }
    
    // 랜덤 BMI 버튼 UI
    func configureRandomButton() {
        randomButton.setTitle("랜덤 BMI 입력하기", for: .normal)
        randomButton.setTitleColor(.purple, for: .normal)
        randomButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        randomButton.contentHorizontalAlignment = .trailing
    }
    
    // 결과 보기 버튼 UI
    func configureResultButton() {
        resultButton.setTitle("결과 보기", for: .normal)
        resultButton.backgroundColor = nickname.isEmpty ? .gray : .purple
        resultButton.isEnabled = false
        resultButton.layer.cornerRadius = 10
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.tintColor = .lightGray
        resultButton.titleLabel?.numberOfLines = 2
    }
    
    // 리셋버튼 UI
    func configureResetButton() {
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.red, for: .normal)
        resetButton.tintColor = .lightGray
        resetButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        resetButton.contentHorizontalAlignment = .leading
    }
    
    func loadInfo() {
        nicknameTextField.text = nickname
        heightTextField.text = height
        weightTextField.text = weight
    }
    
    // 결과 보기 버튼 클릭시 알럿 표시 로직
    @IBAction func resultButtonTapped(_ sender: UIButton) {
        
        let heightStr = heightTextField.text!
        let weightStr = weightTextField.text!
        let bmi = calculateBMI(height: heightTextField.text, weight: weightTextField.text)
        let bmiStr = String(format: "%.2f", bmi)
        let result =  result(bmiString: bmiStr)
        let nickname = nicknameTextField.text!
        
        let resultAlert = UIAlertController(title: "\(result)입니다", message: "\(nickname)님 BMI 측정결과: \(bmiStr)", preferredStyle: .alert)
        
        let save = UIAlertAction(title: "저장하기", style: .default) { _ in
            
            UserDefaults.standard.set(nickname, forKey: "nickname")
            UserDefaults.standard.set(heightStr, forKey: "height")
            UserDefaults.standard.set(weightStr, forKey: "weight")
        }
        
        let back = UIAlertAction(title: "다시 측정하기", style: .cancel)
        
        resultAlert.addAction(back)
        resultAlert.addAction(save)
        present(resultAlert, animated: true)
    }
    
    // 한글자 이하일 때
    @IBAction func underTwoWord(_ sender: UITextField) {
        if let count = sender.text?.count {
            print(count)
            disabledResultButton()
        }
    }
    
    // 숫자가 아닌 다른 것을 작성하였을 때
    @IBAction func notWrittenNum(_ sender: UITextField) {
        if let text = sender.text {
            print(text)
            disabledResultButton()
        }
    }
    
    // 숫자가 아닌 다른 것을 작성중일 때
    @IBAction func notWritingNum(_ sender: UITextField) {
        if let text = sender.text {
            print(text)
            disabledResultButton()
        }
    }
    
    // 결과 보기 버튼 로직
    func disabledResultButton() {
        let n = nicknameTextField.text!
        let h = heightTextField.text!
        let w = weightTextField.text!
        
        let firstIf = h.isEmpty || w.isEmpty
        let secondIf = Double(h) == nil || Double(w) == nil
        let nicknameNil = n.isEmpty
        let overOneWord = n.count <= 1
        
        guard !overOneWord else { return disableButtonUI(button: resultButton, text: "닉네임을 2자 이상 입력해주세요") }
        guard !firstIf else { return disableButtonUI(button: resultButton, text: "항목을 모두 입력해주세요") }
        guard !secondIf else { return disableButtonUI(button: resultButton, text: "숫자만 입력하세요") }
        guard !nicknameNil else { return disableButtonUI(button: resultButton, text: "닉네임을 입력해주세요")}
        
        if let h = Double(h), let w = Double(w) {
            let heightRange = inRange(num: h, range: 140...230)
            let weightRange = inRange(num: w, range: 30...130)
            
            guard heightRange || weightRange else { return disableButtonUI(button: resultButton, text: "키와 몸무게를 범위 내에서 입력해주세요") }
            guard heightRange else { return disableButtonUI(button: resultButton, text: "키 범위 내에서 입력해주세요") }
            guard weightRange else { return disableButtonUI(button: resultButton, text: "몸무게 범위 내에서 입력해주세요")}
            
            enableButtonUI(text: "결과 보기")
        }
    }
    
    // 비활성화 버튼 UI
    func disableButtonUI(button: UIButton, text: String) {
        button.backgroundColor = .gray
        button.isEnabled = false
        button.setTitle(text, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
    }
    
    // 활성화 버튼 UI
    func enableButtonUI(text: String) {
        resultButton.setTitle(text, for: .normal)
        resultButton.backgroundColor = .purple
        resultButton.isEnabled = true
    }
    
    // 랜덤 버튼 로직
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        let height = Double.random(in: 140...190)
        let weight = Double.random(in: 30...130)
        
        heightTextField.text = String(format: "%.1f", height)
        weightTextField.text = String(format: "%.1f", weight)
    }
    
    // 리셋버튼 로직
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        let resetAlert = UIAlertController(title: "저장된 정보를 초기화 하시겠습니까?", message: nil, preferredStyle: .alert)
        
        // 클로저가 외부 변수를 참조함으로 캡쳐리스트 사용
        let reset = UIAlertAction(title: "reset", style: .destructive) { [self] _ in
            
            UserDefaults.standard.removeObject(forKey: "nickname")
            UserDefaults.standard.removeObject(forKey: "height")
            UserDefaults.standard.removeObject(forKey: "weight")
            
            nicknameTextField.text = ""
            heightTextField.text = ""
            weightTextField.text = ""
        }
        
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        
        resetAlert.addAction(reset)
        resetAlert.addAction(cancel)
        
        present(resetAlert, animated: true)
    }
    
    // bmi = kg * 100 / (m * m)
    func calculateBMI(height: String?, weight: String?) -> Double {
        let h = Double(height!) ?? 0
        let w = Double(weight!) ?? 0
        
        return w * 10000 / (h * h)
        
    }
    
    // BMI 결과
    func result(bmiString: String) -> String {
        switch Double(bmiString)! {
        case ..<18.6:
            return "저체중"
        case 18.6..<23:
            return "정상"
        case 23..<25:
            return "과체중"
        default:
            return "비만"
        }
    }
    
    // 범위 로직
    func inRange(num: Double, range: ClosedRange<Double>) -> Bool {
        return range ~= num
    }
}
