//
//  MovieTableViewCell.swift
//  Yaariyan
//
//  Created by Rahul Tomar on 15/06/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var imageLoadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var movieImage: UIImageView!
    
    var descriptionWindowTitle: String = ""
    var descriptionWindowDetails: String = ""
    var videoId: String = ""
    
    var onYoutubeButtonTapped : (() -> Void)? = nil
    var onReviewButtonTapped : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func showMovieDescription(sender: UIButton) {
        SweetAlert().showAlert(descriptionWindowTitle, subTitle: descriptionWindowDetails, style: AlertStyle.None, buttonColor: UIColor.color(89, green: 188, blue: 184, alpha: 1))
    }
    
    @IBAction func startYoutube(sender: UIButton) {
        if let onYoutubeButtonTapped = self.onYoutubeButtonTapped {
            onYoutubeButtonTapped()
        }
    }
    
    @IBAction func showMovieReview(sender: UIButton) {
        if let onReviewButtonTapped = self.onReviewButtonTapped {
            onReviewButtonTapped()
        }
    }
}