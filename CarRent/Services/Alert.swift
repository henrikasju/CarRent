//
//  Alert.swift
//  CarRent
//
//  Created by Henrikas J on 18/01/2021.
//

import UIKit

struct Alert {

  typealias AlertActionHandler = (UIAlertAction) -> ()
  typealias AlertCompletionHandler = (() -> ())?

  static func showErrorAlert(on vc: UIViewController,
                                     title: String,
                                     message: String,
                                     buttonTitle: String,
                                     buttonHandler: AlertActionHandler?,
                                     completion: AlertCompletionHandler) {

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let buttonAction = UIAlertAction(title: buttonTitle, style: .cancel, handler: buttonHandler)

    alert.addAction(buttonAction)

    vc.present(alert, animated: true, completion: completion)
  }
}
