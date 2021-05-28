//
//  NoteVC.swift
//
//  Created by Ranjana on 2021-05-24.
//

import UIKit
import AVFoundation

protocol addNote {
    func updateNote( title: String,descrption :String, recording:String)
}

class AddNoteVC: UIViewController , AVAudioRecorderDelegate {
    

    @IBOutlet weak var textFieldNoteTitle: UITextField!
    @IBOutlet weak var textFieldNoteDescription: UITextField!
    
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
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
    }
    @IBAction func onUploadImageClick(_ sender: Any) {
    }
   
    @IBAction func onRecordClick(_ sender: UIButton) {
        
        if recorder.isRecording{
            
            recorder.stopRecording()
           
        } else{
           //sender.image = UIImage(systemName: "pause.fill")
            recorder.record()
           
        }
    }
    
    @IBAction func onDoneClick(_ sender: Any) {
        
        let noteTitle = textFieldNoteTitle.text ?? ""
        let noteDescription = textFieldNoteDescription.text ?? ""
     
        print(audioURL)
        
        if(noteTitle != "" || noteDescription != "" ){
            delegate?.updateNote(title: noteTitle, descrption: noteDescription, recording: audioURL)
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
        
        
//        if player.isPlaying {
//            //playBtn.cc
//            player.pause()
//    //            isPlaying = false
//            timer.invalidate()
//
//        } else {
//          //  playBtn.image = UIImage(systemName: "pause.fill")
//            player.play()
//    //            isPlaying = true
//            //timer  = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScrubber), userInfo: nil, repeats: true)
//        }
    
    }
    
 
    func loadRecordingUI() {
        recordAudio.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
    
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        audioURL=audioFilename.absoluteString

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

            recordAudio.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

//        if success {
//            recordAudio.setTitle("Tap to Re-record", for: .normal)
//        } else {
//            recordAudio.setTitle("Tap to Record", for: .normal)
//            // recording failed :(
//        }
    }
    
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    
    
}
