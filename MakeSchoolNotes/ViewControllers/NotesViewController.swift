//
//  ViewController.swift
//  MakeSchoolNotes
//
//  Created by Martin Walsh on 29/05/2015.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import UIKit
import RealmSwift

class NotesViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedNote:Note?
    
    enum State {
        case DefaultMode
        case SearchMode
    }
    var state:State = .DefaultMode {
    didSet {
        //updates the notes and search bar everytime the state changes
        switch(state) {
        case .DefaultMode:
            let realm = Realm()
            notes = realm.objects(Note).sorted("modificationDate", ascending: false) //whenever we return to default state our list is reset
            self.navigationController!.setNavigationBarHidden(false, animated: true) //shows the navigation bar again, since it was hidden in searchMode
            searchBar.resignFirstResponder() //removes the keyboard popup
            searchBar.text = ""
            searchBar.showsCancelButton = false
        case .SearchMode:
            let searchText = searchBar?.text ?? ""
            searchBar.setShowsCancelButton(true, animated: true) //animates in a cancel button
            notes = searchNotes(searchText) //performs a search on any text entered in the search bar
            self.navigationController!.setNavigationBarHidden(true, animated: true) //hides the navigation bar so that the search bar is in prominence in our view
        }
      }
    }
    
    var notes: Results<Note>! {
        didSet { //?
            // Whenever notes update, update the table view
            tableView?.reloadData()
        }
    }
    
    func searchNotes(searchString: String) -> Results<Note> {
        let realm = Realm()
        let searchPredicate = NSPredicate(format: "title CONTAINS[c] %@ OR content CONTAINS[c] %@", searchString, searchString)
        return realm.objects(Note).filter(searchPredicate)
        
        //if the text entered in the search bar is found in either the title or content of the note, then that note is included in as part of the result set
        //what is Results<Note>
    }
   

    override func viewDidLoad() {
        let realm = Realm() // 1

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView!.dataSource = self
        tableView!.delegate = self
        notes=realm.objects(Note).sorted("modificationDate", ascending:false)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let realm = Realm()
        notes = realm.objects(Note).sorted("modificationDate", ascending: false)
        state = .DefaultMode
        super.viewWillAppear(animated)
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) { //acts almost like a back button, navigating back to the last scene
        
        if let identifier = segue.identifier {
            
            println("Identifier \(identifier)")
            let realm = Realm()
            
             switch identifier {
                case "Save":
                        let source = segue.sourceViewController as! NewNoteViewController //the source is going to be the place that it came from
                    
                        realm.write() {
                            realm.add(source.newNote)
                        }
                case "Delete":
                    realm.write() {
                        realm.delete(self.selectedNote!)
                    }
                    let source = segue.sourceViewController as! NoteDisplayViewController //????
                    source.note = nil

                
                default:
                        println("No one loves \(identifier)")
             }
            notes = realm.objects(Note).sorted("modificationDate", ascending:false) //sorts the notes in order from most recent to less recent
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowExistingNote") {
            let noteViewController = segue.destinationViewController as! NoteDisplayViewController
            noteViewController.note = selectedNote
        }
    }
    
}

extension NotesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableViewCell //1
        
        let row = indexPath.row
        
        let note = notes[row] as Note
        cell.note = note
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(notes?.count ?? 0)
    }
}

extension NotesViewController: UITableViewDelegate { //extensions help to seperate some of the code,instead of adding functions directly inside of the class1
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedNote = notes[indexPath.row]      //1
        self.performSegueWithIdentifier("ShowExistingNote", sender: self)     //2
    }
    
    // 3
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // 4
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let note = notes[indexPath.row] as Object
            
            let realm = Realm()
            
            realm.write() {
                realm.delete(note)
            }
            
            notes = realm.objects(Note).sorted("modificationDate", ascending: false)//confused
        }
    }
    
}

extension NotesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        state = .DefaultMode
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        notes = searchNotes(searchText)
    }
    
}


