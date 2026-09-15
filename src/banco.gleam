import gleam/result

pub type Account {
  Account(id: Int, owner: String, balance: Int)
}

pub type BankError {
  InvalidAmount
  InsufficientFunds
}

pub fn operations(account: Account) -> Result(Account, BankError) {
  use account <- result.try(deposit(account, 500))
  use account <- result.try(withdraw(account, 300))

  Ok(account)
}

pub fn deposit(account: Account, amount: Int) -> Result(Account, BankError) {
  case amount > 0 {
    True -> Ok(Account(..account, balance: account.balance + amount))
    False -> Error(InvalidAmount)
  }
}

pub fn withdraw(account: Account, amount: Int) -> Result(Account, BankError) {
  case amount {
    amount if amount <= 0 -> Error(InsufficientFunds)

    amount if amount > account.balance -> Error(InsufficientFunds)

    amount -> Ok(Account(..account, balance: account.balance - amount))
  }
}

pub fn main() {
  let account = Account(id: 1, owner: "Thomas", balance: 1000)

  echo operations(account)
}
