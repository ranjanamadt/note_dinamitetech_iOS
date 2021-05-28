//
//  NoteDetailViewController.swift
//  note_dinamitetech_iOS
//
//  Created by one on 27/05/21.
//

import UIKit
import CoreData

class NoteDetailViewController: UIViewController {
    
    var selectedNote: Note?
    var delegate : addNote? = nil

    @IBOutlet weak var descpTxt: UILabel!
    @IBOutlet weak var categoryTxt: UILabel!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var recorder = AudioRecorderHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        titleTxt.text = selectedNote?.noteTitle
       
        categoryTxt.text = selectedNote?.category?.catName
        
        descpTxt.text = selectedNote?.noteDescription
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//
    
    @IBAction func cancel(_ sender: Any) {
        
        
        dismiss(animated: true, completion: nil)


    }
    
    @IBAction func onPlayClick(_ sender: UIButton) {
        recorder.play(name: (selectedNote?.noteRecording)!)
    }
}
