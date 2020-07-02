//
//  TodoCell.swift
//  klear-1
//
//  Created by Yorwos Pallikaropoulos on 12/6/19.
//  Copyright © 2019 Yorwos Pallikaropoulos. All rights reserved.
//

import UIKit

protocol TodoCellDelegate: UIViewController {
    func todoCellWasModified(cell: TodoCell)
    func todoCellWillModify(cell: TodoCell)
    func todoCellWasSetToDone(cell:TodoCell)
    func todoCellWasSetToDeleted(cell:TodoCell)
    func todoCellPassedTheDoneThreshold(cell: TodoCell)
}


class TodoCell: UITableViewCell, UITextFieldDelegate  {
    
    //MARK: - to interact with controller
    
    var isAlreadyDone: Bool = false
    weak var delegate: TodoCellDelegate?
    
    //    MARK: - private properties
    
    private let bounceFactor = 0.1
    private let labelBaseAlpha:CGFloat = 0.1
    private let panThreshold: CGFloat = 60.0
    private let doneBackgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    
    private var isPanning = false{
        //       set the global isPanning to avoid other cells to pan as well
        didSet{
            if isPanning{
                TodoCell.isPanning = self.isPanning
            }
        }
    }
    
    
    
    private let panRatio = 0.5 //used to add resistance while panning
    private var initialBackgroundColor: UIColor? = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    //    TODO: - maybe change the isDone and isAlreadyDone properties (it is confusing)
    private var isDone = false
    private var isDeleted = false
    
    
    
    //   MARK: - gesture recognizers
    private var panGestureRecoginer: UIPanGestureRecognizer?
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    //    MARK: - vars for initial states
    private var initialLeftConstraintForCheckLabel = CGFloat()
    private var initialRightContsraintForDeleteLabel = CGFloat()
    private var initialLeftConstraint = CGFloat()
    private var initialRightConstraint = CGFloat()
    private var initialTextColor: UIColor? = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private var initialAtrributedString: NSAttributedString =  NSAttributedString()
    
    //    MARK: - global (static) vars for panning/editing
    private static var isPanning = false //use this to block other cell cell panning while this is editing
    static var shoudlBlockTextField = false //??
    private static var isTextFieldEditing = false // use this to block other cell interaction while this is editing
    
    //    MARK: - outlets
    @IBOutlet var checkLabel: UILabel!
    @IBOutlet var slidingView: UIView!
    @IBOutlet weak var checkLabelLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet var deleteLabelRightConstraint: NSLayoutConstraint!
    @IBOutlet var deleteLabel: UILabel!
    @IBOutlet var textField: UITextField!
    

    
    //  because the cell has different components (text field)
    //    use the getter/setter to treat background color uniformly

    func setBackground(color: UIColor){
        
        self.textField.backgroundColor = color
        self.slidingView.backgroundColor = color
    }
    
    func getBackGroundColor() -> UIColor{
        return slidingView.backgroundColor ?? UIColor()
    }
    
    

    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
       //block textfield editing. will use gesture recognizer instead.
        //(easier to control the interaction with other gestures)
        textField.isUserInteractionEnabled = false
        textField.delegate = self
//        setup the gesture recognizers
        panGestureRecoginer = UIPanGestureRecognizer(target: self, action:#selector(panTheCell))
        panGestureRecoginer?.maximumNumberOfTouches  = 2
        panGestureRecoginer?.delegate = self
        if panGestureRecoginer != nil{
            self.contentView.addGestureRecognizer(panGestureRecoginer!)
        }
        

        tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        tapGestureRecognizer?.delegate = self
//        tapGestureRecognizer?.delaysTouchesBegan = true
        if tapGestureRecognizer != nil{
            self.addGestureRecognizer(tapGestureRecognizer!)
        }
        initialBackgroundColor = getBackGroundColor()
    }
    

    func setText(_ text:String){
        textField.text = text
    }
    

    //    MARK: - TextField delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // return the control if user taps the return key
        textField.isUserInteractionEnabled = false
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
        delegate?.todoCellWasModified(cell: self) // used to inform the controller that text editing was done
        TodoCell.isTextFieldEditing = false
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        TodoCell.isTextFieldEditing = true
        delegate?.todoCellWillModify(cell: self) // used to inform the controller that text editing is about to begin
        

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.resetCell()
    }
    
    
  
    //    MARK: - gesture recognizer delegate methods
    

    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        // don't alllow gesture to begin if any cell is already in panning or editing state
        if TodoCell.isTextFieldEditing  || TodoCell.isPanning {
            return false
        }
        
        
        if gestureRecognizer == panGestureRecoginer{
            // only allow pan if the panning is (mainly) in the x-axis (i.e horizontaly)
            
            let velocity = panGestureRecoginer!.velocity(in: superview)
            return ( abs(velocity.x) > abs(velocity.y))
            
        }else{
            return true
        }
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == panGestureRecoginer{
            // if another instance is already panning block this one
            if TodoCell.isPanning {
                return true
            }else{
                return isPanning
            }
            // don't want to handle together taps from controller and the view
        }else if gestureRecognizer == tapGestureRecognizer{
            return true
        }
        return false
    }
    
    

    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return !TodoCell.isPanning && !TodoCell.isTextFieldEditing
    }
    
    
//    MARK: - gesture recognizers actions
    
    @objc func panTheCell(recognizer: UIPanGestureRecognizer){
        
        
        // TODO: - normally the following shouldn't be necessary, however if it is missing 2 cells can be swiped at the same time
        if TodoCell.isPanning, !self.isPanning{
            return
        }
        
        var delta: CGFloat = 0
        let currentPoint = recognizer.translation(in: self.contentView)
        var panStartPoint = CGPoint()
        //        var initialAtrributedString: NSAttributedString =  NSAttributedString(string: self.textField.text ?? "")
        let stringLength = initialAtrributedString.length
        
        delta = currentPoint.x - panStartPoint.x
        
        
        switch recognizer.state {
        case .began:

            // set panning to true (to block other interactions)
            isPanning = true
            // mark the initial pan point.
            panStartPoint = recognizer.translation(in: self.contentView)
            // the initial constraints
            initialLeftConstraint = leftConstraint.constant
            initialRightConstraint = rightConstraint.constant
            // initialLeftConstraintForButton = leftButtonConstraint.constant
            initialLeftConstraintForCheckLabel = checkLabelLeftConstraint.constant
            initialRightContsraintForDeleteLabel = deleteLabelRightConstraint.constant
            // the initial attributedString + text color
            initialAtrributedString = self.textField.attributedText ??  NSAttributedString(string: self.textField.text ?? "")
            initialTextColor = self.textField.textColor
            // and the initial backgroundColor
            initialBackgroundColor = getBackGroundColor()

        case .changed:
            // if an additional finger touches the cell,  then end panning
            if let numberOfTouches = panGestureRecoginer?.numberOfTouches  {
                if numberOfTouches > 1 {
                    panGestureRecoginer!.state = .ended
                }
            }
            
            let slidePercentageUntilThreshold = abs(delta/panThreshold)
            //  2 possible directions:
            //  1. Right (delta > 0) - revealing the check (done) action
            if delta > 0 {
                
                // 1. slide the view to the right and reset the right constarint
                rightConstraint.constant = initialRightConstraint
                //                 leftConstraint.constant =  initialLeftConstraint + delta * CGFloat(draggingRatio)
                
                self.slidingView.layoutIfNeeded()
                if delta < panThreshold{ // passing the threshold will invert the state of the item (done->not done or vice versa)
                    
                    //  * revealing the check (done) action *
                    leftConstraint.constant =  initialLeftConstraint + delta
                    // 1. reset isDone
                    isDone = false
                    // 2. reset backgroundColor to initial color
                    setBackground(color: initialBackgroundColor ?? .white)
                    
                    // 3. change  gradually the transparency of the check label
                    
                    let alpha = labelBaseAlpha + ((1-labelBaseAlpha) * slidePercentageUntilThreshold)
                    checkLabel.textColor = checkLabel.textColor.withAlphaComponent(alpha)
                    //  4. Strikethrough the letters as you go (in reverse order if already done)
                    //     when the threshold is reached, all letters should be strikethrough (or no strikethrough at all if it is already done)
                    let newAtrributedString = NSMutableAttributedString(attributedString: initialAtrributedString)
                    let strikeThroughPercentage = isAlreadyDone ? 1 - slidePercentageUntilThreshold : slidePercentageUntilThreshold
                    newAtrributedString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, stringLength))
                    let numberOfStrikethroughLetters = Int(round(Float(stringLength) * Float(strikeThroughPercentage)))
                    newAtrributedString.setAttributes([NSAttributedString.Key.strikethroughStyle: 2], range: NSMakeRange(0, numberOfStrikethroughLetters))
                    textField.attributedText = newAtrributedString
                    
                }else{
                    // * implementing the done action *
                    
                    // introduce resistance in panning (resistance definede by panRatio
                    
                    let addedDelta = (delta - panThreshold) *  CGFloat(panRatio) + panThreshold
                    
                    leftConstraint.constant =  initialLeftConstraint + addedDelta
                    
                    // 1. fix (freeze) the transparency of the check label
                    checkLabel.textColor = checkLabel.textColor.withAlphaComponent(1)
                    
                    // 2. fix (freeze) the strikethrough of the letters (if is already done remove the strikethrough and change the font color to white)
                    //   3. change the background to green (if not already done ) or to nextColor (if already done). the latter will be done by the deleagate (viewController)
                    
                    let newAtrributedString = NSMutableAttributedString(attributedString: initialAtrributedString)
                    
                    if isAlreadyDone{
                        newAtrributedString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, stringLength))
                        newAtrributedString.addAttributes([NSAttributedString.Key.foregroundColor:  UIColor.white ], range: NSMakeRange(0, stringLength))
                        delegate?.todoCellPassedTheDoneThreshold(cell: self)
                    }else{
                        newAtrributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, stringLength))
                        setBackground(color: doneBackgroundColor)
                    }
                    
                    textField.attributedText = newAtrributedString
                    //                   4. move the check label along
                    checkLabelLeftConstraint.constant = initialLeftConstraintForCheckLabel + (addedDelta - panThreshold)
                    checkLabel.layoutIfNeeded()

                    //                   5. set isDone to true
                    isDone = true
                    
                }
                
            }else //           2. left (delta < 0) - revealing the  delete action
            {
                //                reset the left constraint
                
                leftConstraint.constant =  initialLeftConstraint
                //                set the right contstraint
                rightConstraint.constant = initialRightConstraint - delta
                leftConstraint.constant =  initialLeftConstraint + delta
                self.slidingView.layoutIfNeeded()
                
                
                
                if -delta < panThreshold{
                    
                    // 1. reset isDeleted
                    isDeleted = false
                    // 2. set the alpha of the delete label
                    let alpha = labelBaseAlpha + ((1-labelBaseAlpha) * slidePercentageUntilThreshold)
                    deleteLabel.textColor = deleteLabel.textColor.withAlphaComponent(alpha)
                }else{
                    
                    // 1. move along the delete label
                    deleteLabelRightConstraint.constant = initialRightContsraintForDeleteLabel + (-delta - panThreshold)
                    deleteLabel.layoutIfNeeded()
                    //2. set isDeleted to true
                    isDeleted = true
                }
 
            }
            
            
        case .ended:

            // 1.  set panning to false (to unblock other interactions)
            isPanning = false
            // 2. reset position
            resetPosition(fromDelta: delta)
            // 3. switch the isAlreadyDone value if passed the threshold

            if delta > panThreshold {
                isAlreadyDone = !isAlreadyDone
                
            }else{ //if not reset the stikethrough and color
                textField.attributedText = initialAtrributedString
               
            }
    
        case .cancelled:
            
            // set panning to false (to unblock other interactions)
            isPanning = false
            TodoCell.isPanning = false
            isDone = false
            isDeleted = false
//        case .possible:
//            print ("possible")
//            return
        default:
            isPanning = false
            TodoCell.isPanning = false
            print("something else happened while recognizing pan")
        }
    }
    

//    this is used to trigger textField editing
    @objc func handleTap(sender: UITapGestureRecognizer) {
        switch sender.state {
        
        case .ended:
//            check of the textField is part of the active view hierarchy
//            (otherwise canBecomeFirstResponder has undefined results)
            if textField.window != nil && !isAlreadyDone{
                if textField.canBecomeFirstResponder{
                    textField.becomeFirstResponder()
                    textField.isUserInteractionEnabled = true
                    TodoCell.isTextFieldEditing = true
                }
            }

        default:
            return
        }
    }
    
    
    
    
// MARK: - helper functions
    
//    used by viewController when dequeing a cell to reset it initial position
//    not sure if it is actually needed
    func resetConstraints(){
        leftConstraint.constant = 0
        rightConstraint.constant = 0
        checkLabelLeftConstraint.constant = 0
        deleteLabelRightConstraint.constant = 0
        self.layoutIfNeeded()
    
    }
    
    func resetCell(){

        isDone = false
        isAlreadyDone = false
        isDeleted = false
        self.setBackground(color: .black)
        resetConstraints()
    }

    private func resetPosition(fromDelta delta:CGFloat = 0.0){

        let bounce = Double(delta) * bounceFactor
        if self.isDeleted{
             let distance = 1.5 * self.contentView.frame.size.width
//            animate the cell out of the view
            UIView.animate(withDuration: 0.1, animations: {
                self.leftConstraint.constant = -distance
                self.rightConstraint.constant = distance
                self.checkLabelLeftConstraint.constant = -distance
                self.deleteLabelRightConstraint.constant = distance
                self.layoutIfNeeded()
                
            }) { (ended) in
                //  inform the delegate
                self.delegate?.todoCellWasSetToDeleted(cell: self)
                self.isDeleted = false
                TodoCell.isPanning = false
                
            }
           
        }else{
            
//            animate the cell back to the intial position
//            TODO: - try with damping (may be more natural)
            
//            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
//                self.leftConstraint.constant = self.initialLeftConstraint
//                self.rightConstraint.constant = self.initialRightConstraint
//                self.checkLabelLeftConstraint.constant = self.initialLeftConstraintForCheckLabel
//                self.layoutIfNeeded()
//            }) { (done) in
//                TodoCell.isPanning = false
//                self.deleteLabel.isHidden = false
//
//                if self.isDone{
//                    // inform the delegate
//                    self.delegate?.todoCellWasSetToDone(cell: self)
//                    self.isDone = false
//
//                }else{
//                    // reset the strikethrough
//                    self.textField.attributedText = self.initialAtrributedString
//                }
//            }

            UIView.animate(withDuration: 0.2, animations: {
                self.leftConstraint.constant = self.initialLeftConstraint - CGFloat(bounce)
                self.rightConstraint.constant = self.initialRightConstraint + CGFloat(bounce)
                self.checkLabelLeftConstraint.constant = self.initialLeftConstraintForCheckLabel + CGFloat(bounce)
                self.layoutIfNeeded()
                
            })
            // temporarily hide the delete label to avoid being showed due to a big bounce
            deleteLabel.isHidden = true
            // add a little bounce
            UIView.animate(withDuration: 0.1, delay: 0.2, options: .beginFromCurrentState
                , animations: {
                    self.leftConstraint.constant = self.initialLeftConstraint
                    self.rightConstraint.constant = self.initialRightConstraint
                    self.checkLabelLeftConstraint.constant = self.initialLeftConstraintForCheckLabel
                    self.layoutIfNeeded()
                    
            }) { (done) in
                TodoCell.isPanning = false
                self.deleteLabel.isHidden = false

                if self.isDone{
                    // inform the delegate
                    self.delegate?.todoCellWasSetToDone(cell: self)
                    self.isDone = false

                }else{
                    // reset the strikethrough
                    self.textField.attributedText = self.initialAtrributedString
                }
            }
        }
    }
   
}



extension UITextField{
//    not sure if this is the correct way to do it.
    override open var canBecomeFirstResponder: Bool{
        return true

    }
}



