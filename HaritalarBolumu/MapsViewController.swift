//
//  ViewController.swift
//  HaritalarBolumu
//
//  Created by SahilMehdiyev on 26.01.2023.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var isimTextField: UITextField!
    @IBOutlet weak var notTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var secilenLatitude = Double()
    var secilenLongitude = Double()
    
    var secilenIsim = ""
    var secilenId: UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(konumSec(gestureRecognizer:))) // Konum secmek icin uzun basili tutarak secebiliriz
        gestureRecognizer.minimumPressDuration = 3 // Minimum basma suresi
        mapView.addGestureRecognizer(gestureRecognizer)
        
        if secilenIsim != ""{
            //Core Data`dan verileri cek
            
            if let uuidString = secilenId?.uuidString{
                print(uuidString)
            }
        }else{
            //yeni veri eklemeye geldi
        }
        
        
    }
    
    @objc func konumSec(gestureRecognizer: UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == .began{
            let dokunulanNokta = gestureRecognizer.location(in: mapView)
            let dokunulanKordinat = mapView.convert(dokunulanNokta,toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = dokunulanKordinat
            annotation.title = isimTextField.text
            annotation.subtitle = notTextField.text
            mapView.addAnnotation(annotation)
            
        }
        
        
    }
    // locationManager her update oldugunda konum degisecek -- didUpdateLocations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations[0].coordinate.latitude)
        //print(locations[0].coordinate.longitude)
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude) // Konum olusturmak icin kullanilir.
        let span = MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9) // Kordinatin width ve hight degistirilebilir
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    

    @IBAction func kaydetTiklandi(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let yeniYer = NSEntityDescription.insertNewObject(forEntityName: "Yer", into: context)
       
        yeniYer.setValue(isimTextField.text, forKey: "isim")
        yeniYer.setValue(notTextField.text, forKey: "not")
        yeniYer.setValue(secilenLatitude, forKey: "latitude")
        yeniYer.setValue(secilenLongitude, forKey: "longitude")
        yeniYer.setValue(UUID(), forKey: "id")
        
        do{
            try context.save()
            print("Kayit edildi")
        }catch{
            print("Hata var")
        }
        
    }
    
}

