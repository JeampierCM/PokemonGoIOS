//
//  ViewController.swift
//  PokemonGo
//
//  Created by jeampier on 11/30/22.
//  Copyright © 2022 miempresa. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var ubicacion = CLLocationManager()
    var contActualizaciones = 0
    var pokemons:[Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ubicacion.delegate = self
        pokemons = obtenerPokemon()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            setup()
        }else{
            ubicacion.requestWhenInUseAuthorization()
        }
    }
    
    //punto 13
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if contActualizaciones<1{
            let region = MKCoordinateRegion.init(center: ubicacion.location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }else{
            ubicacion.stopUpdatingLocation()
        }
    }
    //punto 30
    
    @IBAction func centrarTapped(_ sender: Any) {
        if let coord = ubicacion.location?.coordinate{
            let region = MKCoordinateRegion.init(center: coord, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }
    }
    
    //punto 77
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            let pinview = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pinview.image = UIImage(named: "player")
            var frame = pinview.frame
            frame.size.height = 50
            frame.size.width = 50
            pinview.frame = frame
            return pinview
        }else{
            let pinview = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            //pinview.image = UIImage(named: "mew")
            let pokemon = (annotation as! PokePin).pokemon
            pinview.image = UIImage(named: pokemon.imagenNombre!)
            var frame = pinview.frame
            frame.size.height = 50
            frame.size.width = 50
            pinview.frame = frame
            return pinview
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if view.annotation is MKUserLocation{
            return
        }
        let region = MKCoordinateRegion.init(center:(view.annotation?.coordinate)!, latitudinalMeters: 200,longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false){ (Timer) in
            if let coord = self.ubicacion.location?.coordinate{
                let pokemon = (view.annotation as! PokePin).pokemon
                if mapView.visibleMapRect.contains(MKMapPoint(coord)){
                    print("Puede atrapar el pokemon")
                                        pokemon.atrapado = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    mapView.removeAnnotation(view.annotation!)
                    //punto 109
                    let AlertaVC = UIAlertController(title: "Felicidades!!!", message: "Atrapaste el pokemon(\(pokemon.nombre!)).", preferredStyle: .alert)
                    let pokedexAccion = UIAlertAction(title: "Ver Pokedex", style: .default, handler: {(action) in self.performSegue(withIdentifier: "pokedexSegue", sender: nil)})
                    AlertaVC.addAction(pokedexAccion)
                    let okAcction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    AlertaVC.addAction(okAcction)
                    self.present(AlertaVC, animated: true, completion: nil)
                }else{
                    print("No se puede atrapar el pokemon")
                    let alertaVC = UIAlertController(title: "Upss. Esta muy lejos", message: "No se puede atrapar el pokemon(\(pokemon.nombre!)).Acerquese mas.", preferredStyle: .alert)
                    let okAccion = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertaVC.addAction(okAccion)
                    self.present(alertaVC, animated: true, completion: nil)
                }
            }
        }
        //print("PIN presionado!")
    }
    
    func setup(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        ubicacion.startUpdatingLocation()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {(Timer) in
            if let coord = self.ubicacion.location?.coordinate{
                //let pin = MKPointAnnotation()
                //pin.coordinate = coord
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                let pin = PokePin(coord: coord, pokemon: pokemon)
                let randomLat = (Double(arc4random_uniform(200))-100.0)/5000.0
                let randomLon = (Double(arc4random_uniform(200))-100.0)/5000.0
                pin.coordinate.latitude += randomLat
                pin.coordinate.longitude += randomLon
                self.mapView.addAnnotation(pin)
                }
            })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            setup()
        }
    }

    
}

