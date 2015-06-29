//
//  NoteDisplayViewController.swift
//  MakeSchoolNotes
//
//  Created by Aarushi Shah on 6/25/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import ConvenienceKit


class NoteDisplayViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField?
    @IBOutlet weak var contentTextView: TextView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var toolbarBottomSpace: NSLayoutConstraint!
    
    var keyboardNotificationHandler: KeyboardNotificationHandler?
    
    var edit:Bool = false
    
    var note: Note? {
        didSet {
            displayNote(note)
        }
    }

    override func viewDidLoad() { // this method is called once when the view is initiallized
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) { //called everytime that the view is going to be displayed, to ensure that it is going to be refreshed
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        displayNote(self.note)
        titleTextField?.returnKeyType = .Next
        titleTextField?.delegate = self
        
        if edit {
            deleteButton!.enabled = false
        }
        
        keyboardNotificationHandler = KeyboardNotificationHandler()
        
        
        keyboardNotificationHandler!.keyboardWillBeHiddenHandler = { (height: CGFloat) in
            UIView.animateWithDuration(0.3){
                self.toolbarBottomSpace.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        
        keyboardNotificationHandler!.keyboardWillBeShownHandler = { (height: CGFloat) in
            UIView.animateWithDuration(0.3) {
                self.toolbarBottomSpace.constant = height
                self.view.layoutIfNeeded()
            }
        }
        
    }
    override func viewWillDisappear(animated: Bool) { //called when the view is dismissed, for example, when the back buton is pressed
        super.viewWillDisappear(animated)//call the supercalss
        saveNote()//call the method we have created, to save the note
    }
    func saveNote() {
        if let note = note { //if note is not nil
            let realm = Realm() //create an instance of the realm framework
            
            realm.write {
                if(note.title != self.titleTextField?.text || note.content != self.contentTextView.textValue) {//checking that something had been modified
                    note.title = self.titleTextField!.text
                    note.content = self.contentTextView!.textValue
                    note.modificationDate = NSDate()//a given method that finds the current date.
                    
                }
            }
            
        }
    }
  
    func displayNote(note:Note?) {
        if let note = note, titleTextField = titleTextField, contentTextView = contentTextView {
            titleTextField.text = note.title
            contentTextView.text = note.content
            
            if count(note.title)==0 && count(note.content)==0 { //checks the length of the note, and sees if there is no content
                titleTextField.becomeFirstResponder()//if there is no content, then assume that you are in edit mode
                //first responder will set the focus to be the titleTextField - prompts user with keyboard
            }
            //else if there is content in the strings, then the note will just be displayed as is.
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NoteDisplayViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == titleTextField) {  //checking if the text field that was delegated to this method is the titleTextField
            contentTextView.returnKeyType = .Done
            contentTextView.becomeFirstResponder() //sets the contentTextView to focus
        }
        
        return false
    }
}
