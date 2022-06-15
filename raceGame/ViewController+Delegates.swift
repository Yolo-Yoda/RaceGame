import UIKit

extension ViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as? ScoreTableViewCell else { return UITableViewCell() }
//        let numberOfRow = indexPath.row
//        if numberOfRow % 2 == 0 {
//            cell.backgroundColor = UIColor.white.withAlphaComponent(0.7)
//        }else{
//            cell.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
//        }
//        let user = dataArray[indexPath.row]
//        cell.setupCell(_With: user)
//        return cell
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        dataArray.count
//    }
//
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
