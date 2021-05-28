//
//  NoteVC.swift
//
//  Created by Ranjana on 2021-05-24.
//

import UIKit

protocol addNote {
    func updateNote( title: String,descrption :String, category : String)
}

class AddNoteVC: UIViewController {
    

    @IBOutlet weak var textFieldNoteTitle: UITextField!
    
    @IBOutlet weak var textFieldNoteCategory: UITextField!
    
    @IBOutlet weak var textFieldNoteDescription: UITextField!
    
    var delegate : addNote? = nil
    
    var selectedNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func onUploadImageClick(_ sender: Any) {
    }
    @IBAction func onRecordVoiceClick(_ sender: Any) {
    }
    
    @IBAction func onDoneClick(_ sender: Any) {
        
        let noteTitle = textFieldNoteTitle.text ?? ""
        let noteDescription = textFieldNoteTitle.text ?? ""
        let noteCatgeory = textFieldNoteCategory.text ?? ""
        
        
        if(noteTitle != "" || noteDescription != "" || noteCatgeory != "" ){
            delegate?.updateNote(title: noteTitle, descrption: noteDescription, category: noteCatgeory)
        }

        self.dismiss(animated: false, completion: nil)
        
    }
    
    
    @IBAction func onNotesClick(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
        
    }
}
