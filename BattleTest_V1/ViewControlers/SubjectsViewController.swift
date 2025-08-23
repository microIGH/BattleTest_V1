//
//  SubjectsViewController.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import UIKit

class SubjectsViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    private var subjects: [Subject] = []
    private var filteredSubjects: [Subject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupConstraints()
        loadSubjects()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "PrimaryBackground") ?? UIColor.systemBackground
        title = "Asignaturas"
        
        searchBar.placeholder = "Buscar asignatura..."
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "PrimaryBackground") ?? UIColor.systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SubjectCollectionViewCell.self, forCellWithReuseIdentifier: "SubjectCell")
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadSubjects() {
        subjects = QuizDataManager.shared.getAllSubjects()
        filteredSubjects = subjects
        collectionView.reloadData()
    }
    
    private func filterSubjects(with searchText: String) {
        if searchText.isEmpty {
            filteredSubjects = subjects
        } else {
            filteredSubjects = subjects.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension SubjectsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredSubjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCell", for: indexPath) as! SubjectCollectionViewCell
        let subject = filteredSubjects[indexPath.item]
        cell.configure(with: subject)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 56 // 20 + 16 + 20
        let availableWidth = view.frame.width - padding
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let subject = filteredSubjects[indexPath.item]
        let quizListVC = QuizListViewController(subject: subject)
        navigationController?.pushViewController(quizListVC, animated: true)
    }
}

// MARK: - UISearchBar Delegate
extension SubjectsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSubjects(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
