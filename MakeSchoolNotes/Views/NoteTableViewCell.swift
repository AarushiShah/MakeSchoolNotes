//
//  NoteTableViewCell.swift
//  MakeSchoolNotes
//
//  Created by Martin Walsh on 29/05/2015.
//  Copyright (c) 2015 MakeSchool. All rights reserved.
//

import Foundation
import UIKit

class NoteTableViewCell: UITableViewCell {
    
    static var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
        }()

    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel:UILabel!
    
    var note: Note? { //confused
        didSet {
            if let note = note, titleLabel = titleLabel, dateLabel = dateLabel {
                self.titleLabel.text = note.title
                self.dateLabel.text = NoteTableViewCell.dateFormatter.stringFromDate(note.modificationDate)
            }
        }
    }
}
