//
//  FormViewController.swift
//  DesafioSantander
//
//  Created by Fernanda de Lima on 03/09/2018.
//  Copyright (c) 2018 FeLima. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FormDisplayLogic: class{
  func displayFetchedForm(viewModel: Form.FecthForm.ViewModel)
}

class FormViewController: UIViewController, UITextFieldDelegate, FormDisplayLogic{
  var interactor: FormBusinessLogic?
  var router: (NSObjectProtocol & FormRoutingLogic & FormDataPassing)?
    
    var containerCell:[UIView] = []
    var activeField: UITextField?
    var messageAlert = ""

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder){
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup(){
    let viewController = self
    let interactor = FormInteractor()
    let presenter = FormPresenter()
    let router = FormRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
    // MARK: View lifecycle

    override func viewDidLoad(){
        super.viewDidLoad()
        fetchForm()
    }
    
    // MARK: - Fetch form
    
    var displayedForm: [Form.FecthForm.ViewModel.DisplayedCell] = []
    
    func fetchForm(){
        let request = Form.FecthForm.Request()
        interactor?.fetchForm(request: request)
    }
    
    func displayFetchedForm(viewModel: Form.FecthForm.ViewModel){
        displayedForm = viewModel.displayedForm
        createCells()
    }
    
    private func createCells(){
        let cellSorted = displayedForm.sorted(by: { $0.id < $1.id })
        
        for cell in cellSorted{
            switch cell.type{
            case 1: //textfield
                let textField = UITextField()
                textField.placeholder = cell.message
                
                if let typeField = cell.typefield{
                    if typeField as? String == "telnumber"{
                        textField.tag = 20
                    }
                    
                    if typeField as? Int == 3{
                        textField.tag = 25
                    }
                }
                
                textField.borderStyle = .roundedRect
                textField.isHidden = cell.hidden
                textField.delegate = self
                textField.tag = cell.id - 1
                containerCell.append(textField)
                
            case 2: //label
                let label = UILabel()
                label.text = cell.message
                label.numberOfLines = 0
                label.lineBreakMode = .byWordWrapping
                label.isHidden = cell.hidden
                label.textAlignment = .center
                containerCell.append(label)
                
            case 3: //image
                break
                
            case 4: //switch
                let check = UISwitch()
                check.tag = cell.show! - 1
                check.addTarget(self, action: #selector(self.switchIsOn(_:)), for: .valueChanged)
                check.onTintColor = .red
                containerCell.append(check)
                
            case 5: //button
                let button = UIButton()
                button.setTitle(cell.message, for: .normal)
                button.addTarget(self, action: #selector(self.validate(_:)), for: .touchUpInside)
                button.layer.cornerRadius = min(UIScreen.main.bounds.width * 0.8, UIScreen.main.bounds.height * 0.05)/2
                button.isHidden = cell.hidden
                button.backgroundColor = .red
                containerCell.append(button)
                
            default:
                break
            }
        }
        let width = UIScreen.main.bounds.width * 0.8
        let height = UIScreen.main.bounds.height * 0.05
        let x:CGFloat = 20
        var y:CGFloat = 0
        
        for i in 0..<containerCell.count{
            y += CGFloat((displayedForm[i].topSpacing))
            containerCell[i].frame = CGRect(x: x, y: y, width: width, height: height)
            
            if let _ = containerCell[i] as? UISwitch{
                let message = UILabel(frame: CGRect(x: x + 60, y: y, width: width, height: height))
                message.text = cellSorted[i].message
                message.adjustsFontSizeToFitWidth = true
                self.view.addSubview(message)
            }
            
            self.view.addSubview(containerCell[i])
            y += height
        }
        
        
    }
    
    @objc func switchIsOn(_ sender:UISwitch){
        containerCell[sender.tag].isHidden = !sender.isOn
    }
    
    @objc func validate(_ sender:UIButton){
        print("validate")
        messageAlert = ""
        
        var cellFilterText = containerCell.filter { $0 is UITextField } as! [UITextField]
        let cellFilterSwitch = containerCell.filter { $0 is UISwitch } as! [UISwitch]
        
        for check in cellFilterSwitch{
            let text = cellFilterText.filter { $0.tag == check.tag}
            if check.isOn{
                print("check")
                validateTextFielf(text.first!)
            }
            let index = cellFilterText.index(of: text.first!)
            cellFilterText.remove(at: index!)
        }
        
        for text in cellFilterText{
            validateTextFielf(text)
        }
        
        if messageAlert == ""{
            print("proxima tela")
            router?.routeToSucess(segue: nil)
            
        }else{
            let alert = UIAlertController(title: "Erro", message: "verificar campos \(messageAlert)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func validateTextFielf(_ text:UITextField){
        if text.tag == 25{
            if !validateEmail(enteredEmail: text.text!){
                messageAlert = "\(messageAlert)e-mail, "
            }
            return
        }

        if text.tag == 20{
            if !validatePhone(value: text.text!){
                messageAlert = "\(messageAlert)telefone, "
            }
            return
        }
        
        if (text.text?.isEmpty)!{
            messageAlert = "\(messageAlert)nome, "
        }
        
        return
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func validatePhone(value: String) -> Bool {
        let phone = "^\\d{2}-\\d{4}-\\d{4}$"
        let cellPhone = "^\\d{2}-\\d{5}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@ OR SELF MATCHES %@", phone,cellPhone)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    //MARK: - text field masking
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //MARK:- If Delete button click
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            textField.text!.removeLast()
            return false
        }

        if textField.tag == 5{
            
            if (textField.text?.count)! == 2{
                textField.text = "\(textField.text!)-"  //There we are ading -
            }
            else if (textField.text?.count)! == 8 {
                textField.text = "\(textField.text!)-" //there we are ading - in textfield
            }
            else if (textField.text?.count)! > 12{
                return false
            }
        }
        return true
    }

}
