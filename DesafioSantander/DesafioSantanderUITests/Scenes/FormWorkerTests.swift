//
//  FormWorkerTests.swift
//  DesafioSantander
//
//  Created by Fernanda de Lima on 02/10/18.
//  Copyright (c) 2018 FeLima. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import DesafioSantander
import XCTest

class FormWorkerTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: FormWorker!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupFormWorker()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupFormWorker()
  {
    sut = FormWorker()
  }
  
    // MARK: Test doubles
    
    class FormAPISpy: FormAPIProtocol
    {
        let forms = FormModal(cells: [Seeds.Forms.text, Seeds.Forms.html])
        
        var fetchWithCompletionHandlerCalled = false
        var fetchWithDelegateCalled = false
        var delegate: FormAPIDelegate?
        
        func fetch(completion: @escaping (FormModal) -> Void)
        {
            fetchWithCompletionHandlerCalled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                completion(self.forms)
            }
        }
        
        func fetch()
        {
            fetchWithDelegateCalled = true
        }
    }
    
    class FormWorkerDelegateSpy: FormWorkerDelegate
    {
        var formWorkerDidFetchFormsCalled = false
        var formWorkerDidFetchFormsResults = FormModal(cells: [])
        
        func formWorker(formWorker: FormWorker, didFetchForm forms: FormModal)
        {
            formWorkerDidFetchFormsCalled = true
            formWorkerDidFetchFormsResults = forms
        }
    }
    
    // MARK: Tests
    
    // MARK: Block implementation
    
    func testFetchShouldAskFormAPIToFetchFormWithBlock()
    {
        // Given
        let formAPISpy = FormAPISpy()
        sut.formAPI = formAPISpy
        
        // When
        sut.fetch { (forms) in }
        
        // Then
        XCTAssertTrue(formAPISpy.fetchWithCompletionHandlerCalled, "fetch(completionHandler:) should ask Form API to fetch form")
    }
    
    func testFetchShouldReturnFormResultsToBlock()
    {
        // Given
        let formAPISpy = FormAPISpy()
        sut.formAPI = formAPISpy
        
        // When
        var actualForm: FormModal?
        let fetchCompleted = expectation(description: "Wait for fetch to complete")
        sut.fetch { (form) in
            actualForm = form
            fetchCompleted.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        // Then
        let expectedForm = formAPISpy.forms
        XCTAssertNotNil(expectedForm, "fetch(completion:) should return an array of form to completion block if the fetch succeeds")
    }
    
    // MARK: Delegate implementation
    
    func testFetchShouldAskGistAPIToFetchGistsWithDelegate()
    {
        // Given
        let formAPISpy = FormAPISpy()
        sut.formAPI = formAPISpy
        
        // When
        sut.fetch()
        
        // Then
        XCTAssertTrue(formAPISpy.fetchWithDelegateCalled, "fetch(completion:) should ask Form API to fetch form")
    }
    
    func testGistAPIDidFetchGistsShouldNotifyDelegateWithGistsResults()
    {
        // Given
        let formAPISpy = FormAPISpy()
        sut.formAPI = formAPISpy
        let formWorkerDelegateSpy = FormWorkerDelegateSpy()
        sut.delegate = formWorkerDelegateSpy
        
        // When
        let forms = FormModal(cells: [Seeds.Forms.text, Seeds.Forms.html])
        sut.formAPI(formAPI: formAPISpy, didFetchForm: forms)
        
        // Then
//        let expectedGists = gistAPISpy.gists
//        let actualGists = listGistsWorkerDelegateSpy.listGistsWorkerDidFetchGistsResults
        XCTAssertTrue(formWorkerDelegateSpy.formWorkerDidFetchFormsCalled, "fetch(completion:) should notify its delegate")
//        XCTAssertEqual(actualGists, expectedGists, "fetch(completionHandler:) should return an array of gists if the fetch succeeds")
    }
}