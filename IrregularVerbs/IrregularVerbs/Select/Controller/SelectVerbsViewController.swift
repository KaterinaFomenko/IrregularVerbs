//
//  SelectVerbsViewController.swift
//  IrregularVerbs
//
//  Created by Katerina on 28/11/2023.
//

import UIKit

final class SelectVerbsViewController: UITableViewController {
    // MARK: - Properties
    private var dataSorce = IrregularVerbs.shared
    
    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select verbs".localized
        view.backgroundColor = .white
        
        tableView.register(SelectVerbsTableViewSell.self, forCellReuseIdentifier: "SelectVerbsTableViewSell")
    }
    
    private func isSelected(verb: Verb) -> Bool {
        dataSorce.selectedVerbs.contains(where: { $0.infinitive == verb.infinitive })
    }
}
// MARK: - UITableViewDataSource
extension SelectVerbsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSorce.verbs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectVerbsTableViewSell", for: indexPath) as? SelectVerbsTableViewSell else { return UITableViewCell() }
        
        let verb = dataSorce.verbs[indexPath.row]
        cell.configure(with: verb,
                       isSelected: isSelected(verb: verb))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SelectVerbsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let verb = dataSorce.verbs[indexPath.row]
        
        if isSelected(verb: verb) {
            dataSorce.selectedVerbs.removeAll(where: { $0.infinitive == verb.infinitive })
        } else {
            dataSorce.selectedVerbs.append(verb)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
