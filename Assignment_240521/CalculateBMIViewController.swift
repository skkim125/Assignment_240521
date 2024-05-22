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
    
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var heightTextField: UITextField!
    
    
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var weightTextField: UITextField!
    
    @IBOutlet var randomButton: UIButton!
    @IBOutlet var calculateButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTopLabels()
        configureBMIUI(label: heightLabel, text: "키가 어떻게 되시나요?", textField: heightTextField, placeholder: "키: cm 기준, 140~230cm")
        configureBMIUI(label: weightLabel, text: "몸무게가 어떻게 되시나요?", textField: weightTextField, placeholder: "몸무게: kg 기준 30~130kg")
        
        configureRandomButton()
        configureCalculateButton()
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
        label.font = .systemFont(ofSize: 14)
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
    
    func configureRandomButton() {
        randomButton.setTitle("랜덤 BMI 입력하기", for: .normal)
        randomButton.setTitleColor(.purple, for: .normal)
        randomButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
    }
    
    func configureCalculateButton() {
        calculateButton.setTitle("결과 보기", for: .normal)
        calculateButton.backgroundColor = .gray
        calculateButton.isEnabled = false
        calculateButton.layer.cornerRadius = 10
        calculateButton.setTitleColor(.white, for: .normal)
        calculateButton.tintColor = .lightGray
    }
    
    // 결과보기 버튼 클릭시 알럿 표시 로직
    @IBAction func calculateBMIButtonTapped(_ sender: UIButton) {
        
        let bmi = calculateBMI(height: heightTextField.text, weight: weightTextField.text)
        let bmiStr = String(format: "%.2f", bmi)
        let result =  ResultOfCalculate(bmiString: bmiStr)
        
        let alert = UIAlertController(title: "\(result)입니다", message: "BMI 측정결과: \(bmiStr)", preferredStyle: .alert)
        
        let back = UIAlertAction(title: "다시 측정하기", style: .cancel)
        
        alert.addAction(back)
        present(alert, animated: true)
    }
    
    // bmi = kg * 100 / (m * m)
    func calculateBMI(height: String?, weight: String?) -> Double {
        let h = Double(height!) ?? 0
        let w = Double(weight!) ?? 0
        
        return w * 10000 / (h * h)
        
    }
    
    // 뷰 터치 시 키보드 내림
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // 숫자가 아닌 다른 것을 작성하였을 때
    @IBAction func notWrittenNum(_ sender: UITextField) {
        if let text = sender.text {
            print(text)
            disabledCalculateButton()
        }
    }
    
    // 숫자가 아닌 다른 것을 작성중일 때
    @IBAction func notWritingNum(_ sender: UITextField) {
        if let text = sender.text {
            print(text)
            disabledCalculateButton()
        }
    }
    
    // 결과보기 버튼 로직
    func disabledCalculateButton() {
        let height = heightTextField.text!
        let weight = weightTextField.text!
        let firstIf = height.isEmpty || weight.isEmpty
        let secondIf = Double(height) == nil || Double(weight) == nil
        
        guard !firstIf else { return disableButtonUI(text: "항목을 모두 채워주세요") }
        guard !secondIf else { return disableButtonUI(text: "숫자만 입력하세요") }
        
        if let h = Double(height), let w = Double(weight) {
            let heightRange = inRange(num: h, range: 140...230)
            let weightRange = inRange(num: w, range: 30...130)
            
            guard heightRange else { return disableButtonUI(text: "범위 내에서 입력해주세요") }
            guard weightRange else { return disableButtonUI(text: "범위 내에서 입력해주세요") }
            
            enableButtonUI(text: "결과 보기")
        }
        
        
//        if firstIf {
//            disableButtonUI(text: "항목을 모두 채워주세요")
//        } else {
//            if secondIf {
//                disableButtonUI(text: "숫자만 입력하세요")
//            } else {
//                if let h = Double(height), let w = Double(weight) {
//                    let heightRange = inRange(num: h, range: 140...230)
//                    let weightRange = inRange(num: w, range: 30...130)
//                    
//                    guard heightRange else { return disableButtonUI(text: "범위 내에서 입력해주세요") }
//                    guard weightRange else { return disableButtonUI(text: "범위 내에서 입력해주세요") }
//                    
//                    enableButtonUI(text: "결과 보기")
//                }
//            }
//        }
    }
    
    func disableButtonUI(text: String) {
        calculateButton.backgroundColor = .gray
        calculateButton.isEnabled = false
        calculateButton.setTitle(text, for: .normal)
        calculateButton.setTitleColor(.white, for: .normal)
    }
    
    func enableButtonUI(text: String) {
        calculateButton.setTitle(text, for: .normal)
        calculateButton.backgroundColor = .purple
        calculateButton.isEnabled = true
    }
    
    @IBAction func randomButtonTapped(_ sender: UIButton) {
        let height = Double.random(in: 140...190)
        let weight = Double.random(in: 30...130)
        
        heightTextField.text = String(format: "%.1f", height)
        weightTextField.text = String(format: "%.1f", weight)
    }
    
    // BMI 결과
    func ResultOfCalculate(bmiString: String) -> String {
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
    
    func inRange(num: Double, range: ClosedRange<Double>) -> Bool {
        return range ~= num
    }
}
