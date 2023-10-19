//
//  RepositryData.swift
//  AreebTechnology
//
//  Created by mac on 16/10/2023.
//

import Foundation

class RepositoriesViewModel {

    init() {}

    //Get Repositories Data
     func getRepositories() async -> [Repository] {
        var reposDetails: [Repository] = []
        let result = await APISercive.shared.getRepositories()

        switch result {
        case .success(let repos):
            for repo in repos {
                if let repoDetails = await APISercive.shared.getCreationDate(for: repo.url) {
                    reposDetails.append(repoDetails)
                }
            }
        case .failure(let error):
            print(error)
        }

        return reposDetails
    }
    
    //Convert Date
    func formatDate(_ dateString: String) -> String {
        // Define a date formatter with ISO8601 format
        let iso8601DateFormatter = ISO8601DateFormatter()

        // Try to parse the date
        if let date = iso8601DateFormatter.date(from: dateString) {
            let currentDate = Date()
            let calendar = Calendar.current

            let dateDifference = calendar.dateComponents([.year, .month, .day], from: date, to: currentDate)

            if dateDifference.year! >= 2 {
                // If the date is more than 2 years ago, format as "2 years ago"
                let formattedDate = DateFormatter()
                formattedDate.dateFormat = "EEEE, MMM dd, yyyy"
                return formattedDate.string(from: date)

            } else if dateDifference.month! >= 6 {
                // If the date is more than 6 months ago, format as "Thursday, Oct 22, 2020"
                return "2 years ago"

            } else {
                // Calculate months and years ago
                let monthsAgo = dateDifference.year! * 12 + dateDifference.month!
                if monthsAgo >= 12 {
                    return "\(monthsAgo / 12) years ago"
                } else {
                    return "\(monthsAgo) months ago"
                }
            }
        } else {
            // Date parsing failed
            return "Invalid Date"
        }
    }
}
