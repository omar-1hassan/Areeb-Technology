//
//  UIImageView + Extension.swift
//  AreebTechnology
//
//  Created by mac on 16/10/2023.
//

import UIKit

class RepositoryTVCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var repoImgView: UIImageView!
    @IBOutlet weak var repoOwnerNameLbl: UILabel!
    @IBOutlet weak var repoNameLbl: UILabel!
    @IBOutlet weak var creationDateLbl: UILabel!
    
    //MARK: - Configure Cell
    func configureCell(with repository: Repository) {
        repoNameLbl.text = repository.name
        guard let owner = repository.owner else { return }
        guard let imageURL = owner.avatar_url else { return }
        repoImgView.layer.cornerRadius = repoImgView.frame.size.width/2
        repoImgView.layer.masksToBounds = true
        repoImgView.load(urlString: imageURL)
        creationDateLbl.text = repository.created_at
        repoOwnerNameLbl.text = repository.owner?.login
    }
}
