//
//  MusicTrackSeachResultCell.swift
//  TestApp
//
//  Created by Иван Ерасов on 21/03/2019.
//

import UIKit

class MusicTrackSeachResultCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var albumArtView: UIImageView!
    @IBOutlet weak var titleTextlabel: UILabel!
    @IBOutlet weak var subtitleTextLabel: UILabel!
    @IBOutlet weak var additionaltextLabel: UILabel!
    
    var itemId: String?
    weak var eventHandler: MusicTrackSeachResultCellEventHandler?
    
    @IBAction func didTapOnIcon() {
        guard itemId != nil else { return }
        guard albumArtView.image != nil else { return }
        eventHandler?.didPressOnAlbumArtInItem(with: itemId!)
    }
    
    var albumArtFrameInWindow: CGRect {
        return contentView.convert(albumArtView.frame, to: nil)
    }
    
    //MARK: - ConfigurableView
    
    func configure(with object: Any) {
        
        guard let cellObject = object as? MusicTrackSeachResultCellObject else {
            return
        }
        
        albumArtView.loadAndDisplayImage(from: cellObject.albumArtUrl)
        
        titleTextlabel.text = cellObject.title
        subtitleTextLabel.text = cellObject.subtitle
        additionaltextLabel.text = cellObject.additionalInfo
        
        itemId = cellObject.itemId
        eventHandler = cellObject.eventHandler
    }
}
