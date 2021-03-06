//
//  NoteDetailViewController.swift
//  note_dinamitetech_iOS
//
//  Created by one on 27/05/21.
//

import UIKit
import CoreData
import AVFoundation
import MapKit


class NoteDetailViewController: UIViewController,AVAudioPlayerDelegate ,CLLocationManagerDelegate{
    
    var selectedNote: Note?
    var delegate : addNote? = nil

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descpTxt: UILabel!
    @IBOutlet weak var categoryTxt: UILabel!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    private var audioPlayer : AVAudioPlayer = AVAudioPlayer()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Show data
 
        titleTxt.text = selectedNote?.noteTitle

        categoryTxt.text = selectedNote?.category?.catName
        
        descpTxt.text = selectedNote?.noteDescription
    
        
        if let image = selectedNote?.noteImage{
            imageView.image = UIImage(data: image)
        } else {
            imageView.isHidden=true
        }
        
        if(selectedNote?.noteRecording == nil){
            btnPlay.isHidden = true
        }
        
        mapView.delegate = self
                
        let t1 = Double(selectedNote!.noteLat)
        let t2 = (selectedNote?.noteLong)!
        
        displayLocation(latitude: t1, longitude: t2, title: "My location", subtitle: "fdgf")
        
        print(t1)

    }
    
    func displayLocation(latitude: CLLocationDegrees,
                         longitude: CLLocationDegrees,
                         title: String,
                         subtitle: String) {
        // 2nd step - define span
        let latDelta: CLLocationDegrees = 0.05
        let lngDelta: CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
        // 3rd step is to define the location
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        // 4th step is to define the region
        let region = MKCoordinateRegion(center: location, span: span)
        
        // 5th step is to set the region for the map
        mapView.setRegion(region, animated: true)
        
        // 6th step is to define annotation
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
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



extension NoteDetailViewController: MKMapViewDelegate {
    
        //MARK: - viewFor annotation method
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

            if annotation is MKUserLocation {
                return nil
            }

            switch annotation.title {
            case "My location":
                let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
                annotationView.markerTintColor = UIColor.blue
                return annotationView
            default:
                return nil
            }
        }

}
