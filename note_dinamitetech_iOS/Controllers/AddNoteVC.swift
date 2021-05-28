//
//  NoteVC.swift
//
//  Created by Ranjana on 2021-05-24.
//

import UIKit
import AVFoundation

protocol addNote {
    func updateNote( title: String,descrption :String, recording:String ,currentDate :String, image : String )
}

class AddNoteVC: UIViewController , AVAudioRecorderDelegate {
    

    @IBOutlet weak var textFieldNoteTitle: UITextField!
    @IBOutlet weak var textFieldNoteDescription: UITextField!
    
    var imagePicker: ImagePicker!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imagePickerButton: UIButton!
    
    @IBOutlet weak var recordAudio: UIButton!
    var delegate : addNote? = nil

    var selectedNote: Note?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var player = AVAudioPlayer()
    
    var recorder = AudioRecorderHelper.shared
    
    // timer to update my scrubber
    var timer = Timer()
    // we need to access to the audio path
    
    var audioURL=""
    var path = Bundle.main.path(forResource: "documents", ofType: "recording.m4a")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    @IBAction func onUploadImageClick(_ sender: Any) {
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imagePicker.present(from: sender as! UIView)
        self.imagePickerButton.setImage(UIImage(named: ""), for: .normal)
    }
   
    @IBAction func onRecordClick(_ sender: UIButton) {
        
        if recorder.isRecording{
            sender.setImage(UIImage(named: "ic_add_audio.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            recorder.stopRecording()
        } else{
            
            sender.setImage(UIImage(named: "ic_stop.png")?.withRenderingMode(.alwaysOriginal), for: .normal)

            recorder.record()
           
        }
    }
    
    @IBAction func onDoneClick(_ sender: Any) {
        
        let noteTitle = textFieldNoteTitle.text ?? ""
        let noteDescription = textFieldNoteDescription.text ?? ""
     
        print(audioURL)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        print(result)

        var data = ""
        if imageView.image != nil {
            let imageData = imageView.image!.jpegData(compressionQuality: 0.5)
            var imageBase64String = imageData?.base64EncodedString()
            print(imageBase64String ?? "Could not encode image to Base64")
            imageBase64String = "" + imageBase64String!
            data = imageBase64String!
        } else {
        }
        
        
        if(noteTitle != "" || noteDescription != "" ){
            delegate?.updateNote(title: noteTitle, descrption: noteDescription, recording: audioURL, currentDate : result , image: data)
        }

        self.dismiss(animated: false, completion: nil)
        
    }
    
    
    @IBAction func onNotesClick(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
        
        
    }
    
    
    @IBAction func onPlayCLick(_ sender: Any) {
        
        let name = recorder.getRecordings[0]    // FileName
        recorder.play(name: name)
        audioURL=name
  
    }
}

extension AddNoteVC: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        self.imageView.image = image
    }
}
