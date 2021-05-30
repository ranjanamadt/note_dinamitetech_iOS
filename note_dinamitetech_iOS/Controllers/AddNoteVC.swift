//
//  NoteVC.swift
//
//  Created by Ranjana on 2021-05-24.
//

import UIKit
import AVFoundation

protocol addNote {
    func updateNote( title: String,descrption :String, recording:Data? ,currentDate :String, image : String )
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
    

    var audioPlayer: AVAudioPlayer!
  
    
    // timer to update my scrubber
    var timer = Timer()
    // we need to access to the audio path
    var audioURL: URL? = nil
    
    var path = Bundle.main.path(forResource: "documents", ofType: "recording.m4a")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
    }
    @IBAction func onUploadImageClick(_ sender: Any) {
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imagePicker.present(from: sender as! UIView)
        self.imagePickerButton.setImage(UIImage(named: ""), for: .normal)
    }
   
   
    
    @IBAction func onDoneClick(_ sender: Any) {
        
        let noteTitle = textFieldNoteTitle.text ?? ""
        let noteDescription = textFieldNoteDescription.text ?? ""
     
       // print(audioURL)
        
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
      
        var audioData : Data? = nil
        if (audioURL != nil){
          audioData = try? Data(contentsOf: audioURL!)
        }
        
        if(noteTitle.isEmpty){
            alertMessage(message: "Enter Note Title")
        }else if (noteDescription.isEmpty){
            alertMessage(message: "Enter Note Description")
        }else{
        delegate?.updateNote(title: noteTitle, descrption: noteDescription, recording: audioData, currentDate: result, image: data)
            self.dismiss(animated: false, completion: nil)
        }
      
        
    }
    
    
    @IBAction func onNotesClick(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func alertMessage(message: String) {
        let alert = UIAlertController(title: "Note App", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
       
    }
    
    
    // MARK:- --------------Audio Handling------------------
    
    @IBAction func onRecordClick(_ sender: UIButton) {
    
        if audioRecorder == nil {
                startRecording()
            sender.setImage(UIImage(named: "ic_stop.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                finishRecording(success: true)
                sender.setImage(UIImage(named: "ic_add_audio.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
    }
    
    func startRecording() {
     
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            //recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("path for audio: \(paths[0])")
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioURL = audioRecorder?.url
           
        audioRecorder = nil
       
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    
}

// MARK:- ------------------Image Handling -----------------------
extension AddNoteVC: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        self.imageView.image = image
    }
}

extension AddNoteVC {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddNoteVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

