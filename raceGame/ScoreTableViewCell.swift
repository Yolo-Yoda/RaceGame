
import UIKit

class ScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.name.text = String()
        self.date.text = String()
        self.score.text = String()
    }
    
    func setupCell(_With user: ResultRace) {
        prepareForReuse()
        name.text = user.name
        score.text = "\(user.score)"
        date.text = user.getStringFromDate()
    }
}
