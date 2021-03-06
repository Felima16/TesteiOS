//
//  FormInteractor.swift
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

protocol FormBusinessLogic{
  func fetchForm(request: Form.FecthForm.Request)
}

protocol FormDataStore{
  //var name: String { get set }
}

class FormInteractor: FormBusinessLogic, FormDataStore, FormWorkerDelegate{

    var presenter: FormPresentationLogic?
    var worker = FormWorker()
    
    enum AsyncOpKind {
        case block, delegate
    }
    var asyncOpKind = AsyncOpKind.block
  
  // MARK: Fetch forms
  
    func fetchForm(request: Form.FecthForm.Request) {
        
        switch asyncOpKind {
        case .block:
            // MARK: Block implementation
            worker.fetch { (form) in
                let response = Form.FecthForm.Response(formModal: form)
                self.presenter?.presentFetchedForms(response: response)
            }
            
        case .delegate:
            // MARK: Delegate method implementation
            worker.delegate = self
            worker.fetch()
        }
    }
    
    func formWorker(formWorker: FormWorker, didFetchForm form: FormModal) {
        let response = Form.FecthForm.Response(formModal: form)
        self.presenter?.presentFetchedForms(response: response)
    }
}
