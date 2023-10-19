//
//  RepositryData.swift
//  AreebTechnology
//
//  Created by mac on 16/10/2023.
//

import UIKit

class RepositoriesViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var repositoriesTableView: UITableView!
    
    //MARK: - Variables
    let cellIdentifier = "RepositoryTVCell"
    var isLoading = false
    var repositoriesPerPages = 10
    var limit = 10
    var repos: [Repository] = []
    var paginationRepository: [Repository] = [] {
        didSet {
            Task {
                await MainActor.run {
                    self.repositoriesTableView.reloadData()
                    self.loader.stopAnimating()
                }
            }
        }
    }
    let loader = UIActivityIndicatorView(style: .large)

    let viewModel = RepositoriesViewModel()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repositories"
        initUI()
        setupLoader()
        Task {
            self.repos = await viewModel.getRepositories()
            self.limit = self.repos.count
            for i in 0..<10 {
                self.paginationRepository.append(self.repos[i])
            }
        }
    }
}

//MARK: - Repositories Functions
extension RepositoriesViewController{

    //Configuration TableView
    private func initUI(){
        repositoriesTableView.delegate = self
        repositoriesTableView.dataSource = self
        repositoriesTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    //Set Loader Function
    func setupLoader() {
        loader.color = .red

        let backgroundView = UIView(frame: self.repositoriesTableView.bounds)
        backgroundView.backgroundColor = UIColor.white
        backgroundView.addSubview(loader)

        loader.translatesAutoresizingMaskIntoConstraints = false

        let centerXConstraint = loader.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        let centerYConstraint = loader.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)

        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
        self.repositoriesTableView.backgroundView = backgroundView

        loader.startAnimating()
    }

    //Get Pagination Repositories
    func setPaginationRepositories(repositoriesPerPages: Int){
        if repositoriesPerPages >= limit {
            return
        }
        else if repositoriesPerPages >= limit - 10 {
            for i in repositoriesPerPages..<limit {
                paginationRepository.append(repos[i])
            }
            self.repositoriesPerPages += 10
        }
        else {
            for i in repositoriesPerPages..<repositoriesPerPages + 10 {
                paginationRepository.append(repos[i])
            }
            self.repositoriesPerPages += 10
        }
        Task {
            await MainActor.run {
                self.repositoriesTableView.reloadData()
            }
        }
    }
}

//MARK: - TableView Delegate Functions
extension RepositoriesViewController: UITableViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //Check if the scrolling view passed in this function is the same of my tableview
        if scrollView == repositoriesTableView {
            //check if i reached tableview end or not
            if (scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height) {
                setPaginationRepositories(repositoriesPerPages: repositoriesPerPages)
            }
        }
    }
}

//MARK: - TableView DataSource Functions
extension RepositoriesViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paginationRepository.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RepositoryTVCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: paginationRepository[indexPath.row])
        let dateString = cell.creationDateLbl.text
        cell.creationDateLbl.text = viewModel.formatDate(dateString ?? "Invalid Date")
        return cell
    }
}
