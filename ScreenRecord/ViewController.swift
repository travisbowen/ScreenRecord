//
//  ViewController.swift
//  ScreenRecord
//
//  Created by Travis Bowen on 5/6/19.
//  Copyright © 2019 Travis Bowen. All rights reserved.
//

import UIKit
import ReplayKit

class ViewController: UIViewController, RPPreviewViewControllerDelegate {
    
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var imageSegment: UISegmentedControl!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var microphoneToggle: UISwitch!
    @IBOutlet weak var recordButton: UIButton!
    var recorder = RPScreenRecorder.shared()
    var isRecording = false
    
    
    @IBAction func imageSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedImageView.image = UIImage(named: "skate")
            break
            
        case 1:
            selectedImageView.image = UIImage(named: "food")
            break
            
        case 2:
            selectedImageView.image = UIImage(named: "cat")
            break
            
        default:
            selectedImageView.image = UIImage(named: "nature")
            break
        }
    }
    
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        if !isRecording{
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    
    func startRecording(){
        guard recorder.isAvailable else {
            print("Recording is not available")
            return
        }
        
        if microphoneToggle.isOn {
            recorder.isMicrophoneEnabled = true
        } else {
            recorder.isMicrophoneEnabled = false
        }
        
        recorder.startRecording { (error) in
            guard error == nil else {
                print("There was an error starting the recording")
                return
            }
            DispatchQueue.main.async {
                self.viewRecording()
            }
        }
    }
    
    
    func stopRecording(){
        recorder.stopRecording { (preview, error) in
            guard preview != nil else {
                print("Preview controller is not available")
                return
            }
            
            let alert = UIAlertController(title: "Recording Finished", message: "Would you like to edit or delete your recording?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                self.recorder.discardRecording {
                    print("Recording deleted")
                }
            }
            
            let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
                preview?.previewControllerDelegate = self
                self.present(preview!, animated: true, completion: nil)
            }
            
            alert.addAction(deleteAction)
            alert.addAction(editAction)
            self.present(alert, animated: true, completion: nil)
            
            self.isRecording = false
            self.viewReset()
        }
    }
    
    
    func viewReset(){
        microphoneToggle.isEnabled = true
        statusLabel.text = "Ready to Record"
        statusLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        recordButton.setTitle("Record", for: .normal)
        recordButton.setTitleColor(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1), for: .normal)
    }
    
    
    func viewRecording(){
        self.microphoneToggle.isEnabled = false
        self.recordButton.setTitle("Stop", for: .normal)
        self.recordButton.setTitleColor(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), for: .normal)
        self.statusLabel.text = "Recording..."
        self.statusLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        self.isRecording = true
    }
    
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true, completion: nil)
    }
}

