import UIKit

extension KeyboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
                return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return candidates.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                guard let cell: WordsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordsCell", for: indexPath) as? WordsCollectionViewCell else {
                        return UICollectionViewCell()
                }
                cell.textLabel.text = candidates[indexPath.row].text
                
                // works, but don't know why
                cell.footnoteLabel.text = candidates[indexPath.row].text.first!.isLetter ? candidates[indexPath.row].footnote : nil
                
                let textColor: UIColor = isDarkAppearance ? .darkButtonText : .lightButtonText
                cell.textLabel.textColor = textColor
                cell.footnoteLabel.textColor = textColor
                return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let candidate: Candidate = candidates[indexPath.row]
                textDocumentProxy.insertText(candidate.text)
                currentInputText = String(currentInputText.dropFirst(candidate.input?.count ?? 0))
                if keyboardLayout == .wordsBoard {
                        keyboardLayout = .jyutping
                }
                DispatchQueue.global().async {
                        AudioFeedback.perform(audioFeedback: .modify)
                }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                let characterCount: Int = candidates[indexPath.row].count
                if self.keyboardLayout == .wordsBoard {
                        let fullWidth: CGFloat = collectionView.bounds.size.width
                        var itemCount: Int = 5
                        switch characterCount {
                        case 1:
                                itemCount = Int(fullWidth) / 55
                        case 2:
                                itemCount = Int(fullWidth) / 75
                        default:
                                itemCount = Int(fullWidth) / (characterCount * 30)
                        }
                        guard itemCount > 1 else {
                                return CGSize(width: fullWidth - 4, height: 55)
                        }
                        return CGSize(width: fullWidth / CGFloat(itemCount), height: 55)
                } else {
                        switch characterCount {
                        case 1:
                                return CGSize(width: 55, height: 55)
                        case 2:
                                return CGSize(width: 75, height: 55)
                        default:
                                return CGSize(width: characterCount * 30, height: 55)
                        }
                }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
}
