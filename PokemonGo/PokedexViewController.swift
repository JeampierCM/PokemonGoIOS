//
//  PokedexViewController.swift
//  PokemonGo
//
//  Created by jeampier on 11/30/22.
//  Copyright © 2022 miempresa. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pokemonsAtrapados:[Pokemon] = []
    var pokemonsNoAtrapados:[Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonsAtrapados = obtenerPokemonsAtrapados()
        pokemonsNoAtrapados = obtenerPokemonNoAtrapados()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Pokemones Atrapados"
        }else{
            return "Pokemones No Atrapados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return pokemonsAtrapados.count
        }else{
            return pokemonsNoAtrapados.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon:Pokemon
        if indexPath.section == 0{
            pokemon = pokemonsAtrapados[indexPath.row]
        }else{
            pokemon = pokemonsNoAtrapados[indexPath.row]
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = pokemon.nombre
        cell.imageView?.image = UIImage(named: pokemon.imagenNombre!)
        return cell
    }
    

}
