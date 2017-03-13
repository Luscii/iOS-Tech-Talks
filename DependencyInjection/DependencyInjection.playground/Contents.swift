import Foundation

/*:
 # Dependency Injection in iOS / Swift
 */

/*:
 ## Base classes
 */

typealias CreditCard = Int

struct Pizza {
    let style: String
    let price: Int
}

protocol CreditCardProcessor {

    func charge(creditCard: CreditCard, with amount: Int) -> String

}

protocol BillingService {

    func order(pizza: Pizza, with creditCard: CreditCard) -> String
}

/*:
 ## 1. No dependency injection
 */

class PayPalCreditCardProcessor: CreditCardProcessor {

    func charge(creditCard: CreditCard, with amount: Int) -> String {
        // Imagine this method makes the necessary network calls to make a transaction to paypal
        return "Billing €\(amount) on card #\(creditCard) to PayPal"
    }
}

class BillingService1: BillingService {

    private let processor: CreditCardProcessor

    init() {
        processor = PayPalCreditCardProcessor() //or: PayPalCreditCardProcessor.sharedInstance...
    }

    func order(pizza: Pizza, with creditCard: CreditCard) -> String {
        return processor.charge(creditCard: creditCard, with: pizza.price)
    }
}

let billing1 = BillingService1()
print(billing1.order(pizza: Pizza(style: "Hawaii", price: 10), with: CreditCard(12345)))

/*:
 ## 2. Dependency injection
 */

class BillingService2: BillingService {

    private let processor: CreditCardProcessor

    init(processor: CreditCardProcessor) {
        self.processor = processor;
    }

    func order(pizza: Pizza, with creditCard: CreditCard) -> String {
        return processor.charge(creditCard: creditCard, with: pizza.price)
    }
}

let billing2 = BillingService2(processor: PayPalCreditCardProcessor())
print(billing2.order(pizza: Pizza(style: "Gorgonzola", price: 12), with: CreditCard(67890)))


/*:
 ## Forms of injection

 ### Dependency injection with initializers
 We just saw an example.
 */

/*:
 ### Dependency injection with properties
 */

class PropertyInitializedBillingService: BillingService {

    var processor: CreditCardProcessor?

    internal func order(pizza: Pizza, with creditCard: CreditCard) -> String {
        guard let processor = processor else {
            return "FATAL ERROR!!! Processor not set!"
        }
        return processor.charge(creditCard: creditCard, with: pizza.price)

    }
}

let propertyInitialized = PropertyInitializedBillingService()
propertyInitialized.order(pizza: Pizza(style: "Shoarma", price: 9), with: CreditCard(1111))

propertyInitialized.processor = PayPalCreditCardProcessor()
propertyInitialized.order(pizza: Pizza(style: "Shoarma", price: 9), with: CreditCard(1111))
/*:
 ## Pros and cons of DI
 - 👍 Testable code because dependencies are easily swappable
 - 👍 Classes not responsible for initializing dependencies (single responsibility paradigm)
 - 👍 Looser coupling between classes
 - 👍 Constructing dependencies becomes some other class's problem
 - 👎 Constructing dependencies becomes some other class's problem
 - 👎 Creating a sequence of dependencies (dependency tree) becomes unwieldy
 */

class SomethingThatDependsOnBillingService {

    private let billing: BillingService

    init(billing: BillingService) {
        self.billing = billing
    }
}

//: ![dependency tree](tree.pdf)

/*: 
 ### This constructor is getting really long...
 */
let something = SomethingThatDependsOnBillingService(billing:
    BillingService2(processor: PayPalCreditCardProcessor()))
/*:
 In real life scenarios, manual Dependency Injection becomes a big burden...
 */

/*:
 ### Dependency injection with a framework
 
 `Swinject` is the only option for Swift right now.
 
 First, we define a `container`, where we register protocols or (abstract) classes to concrete implementations
 */
import Swinject

let container = Swinject.Container()
container.register(CreditCardProcessor.self) { _ in PayPalCreditCardProcessor() }
container.register(BillingService.self) { r in BillingService2(processor:
                                                    r.resolve(CreditCardProcessor.self)!) }
/*:
 Then we can obtain concrete implementations by letting the container resolve the dependencies
 */
let billing3 = container.resolve(BillingService.self)!

billing3.order(pizza: Pizza(style: "Quattro Formaggi", price: 99), with: CreditCard(1337))
/*:
 Only first-level dependencies need to be resolved:
 */
container.register(SomethingThatDependsOnBillingService.self)
{ r in SomethingThatDependsOnBillingService(billing: r.resolve(BillingService.self)!) }

let something2 = container.resolve(SomethingThatDependsOnBillingService.self)!

/*:
 ### DI framework _and_ initializers?
 - Like Dwarves and Elves; they can work together, but in a perfect world they exist independently.
 */
