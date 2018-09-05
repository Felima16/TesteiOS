//
//  FundPresenter.swift
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

protocol FundPresentationLogic
{
  func presentSomething(response: Fund.Something.Response)
}

class FundPresenter: FundPresentationLogic
{
  weak var viewController: FundDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Fund.Something.Response)
  {
    let viewModel = Fund.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}