//
//  NoteDetailViewController.swift
//  note_dinamitetech_iOS
//
//  Created by one on 27/05/21.
//

import UIKit
import CoreData
import AVFoundation


class NoteDetailViewController: UIViewController,AVAudioPlayerDelegate {
    
    var selectedNote: Note?
    var delegate : addNote? = nil

    @IBOutlet weak var descpTxt: UILabel!
    @IBOutlet weak var categoryTxt: UILabel!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    private var audioPlayer : AVAudioPlayer = AVAudioPlayer()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        titleTxt.text = selectedNote?.noteTitle

        categoryTxt.text = selectedNote?.category?.catName
        
        descpTxt.text = selectedNote?.noteDescription
        
        let dataDecoded : Data = Data(base64Encoded: (selectedNote?.noteImage) ?? "", options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        imageView.image = decodedimage
        
        
        
        if(selectedNote?.noteRecording == nil){
            btnPlay.isHidden = true
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        if(audioPlayer.isPlaying){
            audioPlayer.pause()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPlayClick(_ sender: UIButton) {
      
        audioPlayer.prepareToPlay()
        do {
            audioPlayer = try AVAudioPlayer(data: (selectedNote?.noteRecording)!)
            audioPlayer.delegate = self
            audioPlayer.play()  /// play
            
        } catch {
            print("play(with name:), ",error.localizedDescription)
        }
    }
}
