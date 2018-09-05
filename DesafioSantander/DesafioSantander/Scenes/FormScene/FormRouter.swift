//
//  FormRouter.swift
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

@objc protocol FormRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol FormDataPassing
{
  var dataStore: FormDataStore? { get }
}

class FormRouter: NSObject, FormRoutingLogic, FormDataPassing
{
  weak var viewController: FormViewController?
  var dataStore: FormDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: FormViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: FormDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}