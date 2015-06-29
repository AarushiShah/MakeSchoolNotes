//
//  NewNoteViewController.swift
//  MakeSchoolNotes
//
//  Created by Aarushi Shah on 6/25/15.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController {
    
    var newNote = Note()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //newNote.title = "My First New Note"
        //newNote.content = "blah blah blah blah"
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "ShowNewNote") {
            //create a new note and hold onto it, to be able to save it for later
            newNote = Note() //create a variable instance of the note class
            let noteViewController = segue.destinationViewController as! NoteDisplayViewController //set the destination to notedisplayviewcontroller
            noteViewController.note = newNote //set the note of this viewcontroller as currentnote, so that you can access this current note from NoteDisplayViewController later on
            
            noteViewController.edit = true
        }
        
        
        
    }

}
