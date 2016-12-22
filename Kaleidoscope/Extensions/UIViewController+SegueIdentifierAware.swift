import UIKit

protocol SegueIdentifierAware
{
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueIdentifierAware where Self: UIViewController, SegueIdentifier.RawValue == String
{
    func performSegueWithIdentifier(_ segueIdentifier: SegueIdentifier, sender: AnyObject?)
    { performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender) }

    func segueIdentifierForSegue(_ segue: UIStoryboardSegue) -> SegueIdentifier
    {
        guard let
            identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier)
            else { fatalError("Invalid segue identifier: '\(segue.identifier)'") }
        return segueIdentifier
    }
}
